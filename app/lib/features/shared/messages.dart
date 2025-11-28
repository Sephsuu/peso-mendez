import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/services/message_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Messages extends HookWidget {
  final Map<String, dynamic> user;
  final int otherUserId;

  const Messages({
    super.key,
    required this.user,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    final messages = useState<List<Map<String, dynamic>>>([]);
    final reload = useState(false);
    final otherUser = useState<Map<String, dynamic>>({});

    useEffect(() {
      void fetchData() async {
        try {
          final res = await UserService.getUserById(otherUserId);
          otherUser.value = res;
        } catch (e) {
          if (!context.mounted) return;
          showDialog(
            context: context, 
            builder: (context) {
              return AppModal(
                title: '$e'
              );
            }
          );
        }
      } fetchData(); return null;
    }, [otherUserId]);

    useEffect(() {
      void fetchData() async {
        try {
          final res = await MessageService.getMessages(user['id'], otherUserId);
          messages.value = res;
        } catch (e) {
          if (!context.mounted) return;
          showDialog(
            context: context, 
            builder: (context) {
              return AppModal(
                title: '$e'
              );
            }
          );
        }
      } fetchData(); return null;
    }, [otherUserId, reload.value]);

    final controller = useTextEditingController();

    void sendMessage() async {
      try {
        final text = controller.text.trim();
        if (text.isEmpty) return;

        await MessageService.createMessage({
          "userId": user['id'],
          "otherId": otherUserId,
          "message": text
        });
        reload.value = !reload.value;
        controller.clear();
      } catch (e) {
        if (!context.mounted) return;
        showDialog(
          context: context, 
          builder: (context) {
            return AppModal(
              title: '$e'
            );
          }
        );
      }
    }

    if (otherUser.value.isEmpty) return const Loader();
    return Scaffold(
      appBar: AppBar(
        title: Text(otherUser.value['full_name'], style: AppText.textMd.merge(AppText.fontSemibold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.value.length,
              itemBuilder: (context, index) {
                final msg = messages.value[index];
                final isMe = msg['sender_id'] == user['id'];

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppColor.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isMe
                            ? const Radius.circular(12)
                            : const Radius.circular(0),
                        bottomRight: isMe
                            ? const Radius.circular(0)
                            : const Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      msg['message_text'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: AppColor.primary,
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}