import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Notifications extends HookWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final notifications = useState<List<Map<String, dynamic>>>([]);

    useEffect(() {
      if (claims.isEmpty) return null;
      void fetchData() async {
        try {
          final res = await NotificationService.getNotificationsByRole({
            "role": claims['role'],
            "userId": claims['id']
          });
          notifications.value = res;
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
    }, [claims]);

    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) {
          Scaffold.of(context).openDrawer();
        },
      ),
      endDrawer: const OffcanvasNavigation(),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧭 Page header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Notifications',
                style: AppText.textLg.merge(AppText.fontSemibold),
              ),
            ),

            const Divider(thickness: 1, height: 16),

            // 🗒️ Notification list
            Expanded(
              child: ListView.builder(
                itemCount: notifications.value.length,
                itemBuilder: (context, index) {
                  final notif = notifications.value[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications_active_outlined,
                        color: AppColor.primary,
                      ),
                      title: Text(
                        notif['type'],
                        style:
                            AppText.textXs.merge(AppText.fontSemibold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            notif['content'],
                            style: AppText.textXs,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatDateTime(notif['created_at']),
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
