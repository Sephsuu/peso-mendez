import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
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
    final loading = useState(true);
    final claims = useClaimsHook(context);
    final notifications = useState<List<Map<String, dynamic>>>([]);
    final snackError = useState<String?>(null);

    // Fetch data (NO dialog/snackbar here)
    useEffect(() {
      if (claims.isEmpty) return null;

      () async {
        try {
          final res = await NotificationService.getNotificationsByUser(
            claims["id"],
          );
          notifications.value = res;
          loading.value = false;
        } catch (e) {
          snackError.value = '$e'; // Store error instead of showing snackbar
        }
      }();

      return null;
    }, [claims["id"]]);

    // Show snackbar safely AFTER build
    useEffect(() {
      if (snackError.value == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        AppSnackbar.show(
          context, 
          message: snackError.value!
        );
        snackError.value = null;
      });

      return null;
    }, [snackError.value]);

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Notifications',
                style: AppText.textLg.merge(AppText.fontSemibold),
              ),
            ),
            const Divider(thickness: 1, height: 16),
            Expanded(
              child: notifications.value.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.notifications_none,
                              size: 60,
                              color: AppColor.muted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No notifications yet',
                              style: AppText.textMd.merge(AppText.fontSemibold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'You will see updates here once they arrive.',
                              style: AppText.textSm.copyWith(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    )
                  : ListView.builder(
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
                              style: AppText.textXs.merge(AppText.fontSemibold),
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
      )
    );
  }
}
