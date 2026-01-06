import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/services/message_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/shared/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class Conversations extends HookWidget {
  const Conversations({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final userId = claims['id'];

    final loading = useState(true);
    final conversations = useState<List<Map<String, dynamic>>>([]);

    /* ---------------- FETCH CONVERSATIONS ---------------- */
    useEffect(() {
      if (userId == null) return null;

      () async {
        loading.value = true;
        try {
          conversations.value =
              await MessageService.getConversations(userId);
        } catch (e) {
          if (!context.mounted) return;
          showDialog(
            context: context,
            builder: (_) => AppModal(title: e.toString()),
          );
        } finally {
          loading.value = false;
        }
      }();

      return null;
    }, [userId]);

    String formatShortDate(String isoString) {
      final date = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        return DateFormat('h:mm a').format(date);
      } else if (diff.inDays == 1) {
        return "Yesterday";
      } else if (diff.inDays < 7) {
        return DateFormat('EEE').format(date);
      } else {
        return DateFormat('MMM d').format(date);
      }
    }

    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) {
          Scaffold.of(context).openDrawer();
        },
      ),
      endDrawer: const OffcanvasNavigation(),

      body: loading.value 
        ? const Loader()
        : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧭 Page Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Messages',
                style: AppText.textLg.merge(AppText.fontSemibold)
              ),
            ),
            const Divider(thickness: 1, height: 16),

            // 💬 Conversation List
            Expanded(
              child: ListView.builder(
                itemCount: conversations.value.length,
                itemBuilder: (context, index) {
                  final conv = conversations.value[index];

                  // Determine who the "other person" is
                  final isUserA = conv['user_a_id'] == claims['id'];
                  final otherName = isUserA
                      ? conv['user_b_name']
                      : conv['user_a_name'];

                  final latestMessage = conv['latest_message'] ?? '';
                  final formattedDate =
                      formatShortDate(conv['updated_at'] ?? conv['created_at']);

                  return InkWell(
                    onTap: () => navigateTo(
                      context, 
                      Messages(user: claims, otherUserId: conv['user_a_id'] == claims['id'] ? conv['user_b_id'] : conv['user_a_id'])
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          // Profile avatar (placeholder)
                          const CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColor.primary,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),

                          // Name + message preview
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  otherName,
                                  style: AppText.textSm
                                      .merge(AppText.fontSemibold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  latestMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.textXs.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Date label (right-aligned)
                          Text(
                            formattedDate,
                            style: AppText.textXs.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
