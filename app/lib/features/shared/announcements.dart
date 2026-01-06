import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/announcement_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/shared/view_announcement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:app/core/components/badge.dart'; // ensure AppBadge is imported

class Announcements extends HookWidget {
  const Announcements({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final role = claims['role'];

    final loading = useState(true);
    final announcements = useState<List<Map<String, dynamic>>>([]);

    String formatAudience(String value) {
      return value.replaceAll("_", " ").toUpperCase();
    }

    /* ---------------- FETCH ANNOUNCEMENTS ---------------- */
    useEffect(() {
      if (role == null) return null;

      () async {
        loading.value = true;
        try {
          if (role == 'admin') {
            announcements.value =
                await AnnouncementService.getAllAnnouncements();
          } else {
            announcements.value =
                await AnnouncementService.getAnnouncementsByRole(role);
          }
        } catch (e) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: e.toString(),
            backgroundColor: AppColor.danger,
          );
        } finally {
          loading.value = false;
        }
      }();

      return null;
    }, [role]);

    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
      ),
      endDrawer: const OffcanvasNavigation(),
      body: loading.value
        ? const Loader()
        : Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🧭 Page header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Announcements',
                style: AppText.textLg.merge(AppText.fontSemibold),
              ),
            ),
            const Divider(thickness: 1, height: 16),

            // 🗒️ Announcements list
            Expanded(
              child: announcements.value.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.campaign_outlined,
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
                      itemCount: announcements.value.length,
                      itemBuilder: (context, index) {
                        final item = announcements.value[index];

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🏷 Title + Audience Badge
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['title'] ?? 'Untitled',
                                        style: AppText.textSm.merge(AppText.fontSemibold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AppBadge(
                                      text: formatAudience(
                                          item['target_audience'] ?? ''),
                                      backgroundColor: AppColor.light,
                                      foregroundColor: AppColor.primary,
                                      borderColor: AppColor.primary,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      fontSize: 10,
                                      borderRadius: 8,
                                      isCenter: false,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // 📄 Content preview
                                Text(
                                  item['content'] ??
                                      'No content available.',
                                  style: AppText.textXs,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),

                                // 📅 Footer
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatAnnouncementDate(
                                          item['posted_on']),
                                      style: AppText.textXs.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    AppButton(
                                      label: 'View More',
                                      textSize: 10,
                                      backgroundColor:
                                          AppColor.primary,
                                      onPressed: () => navigateTo(
                                        context,
                                        ViewAnnouncement(
                                            announcement: item),
                                      ),
                                      visualDensityY: -4,
                                    ),
                                  ],
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
