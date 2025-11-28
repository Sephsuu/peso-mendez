import 'package:app/core/components/button.dart';
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
    final announcements = useState<List<Map<String, dynamic>>>([]);

    // 🎨 Badge color based on audience
    Color getAudienceColor(String audience) {
      switch (audience.toLowerCase()) {
        case "all":
          return Colors.blue;
        case "job_seeker":
          return Colors.green;
        case "employer":
          return Colors.purple;
        case "admin":
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    // 🔤 Format audience → ALL, JOB SEEKER, etc.
    String formatAudience(String value) {
      return value.replaceAll("_", " ").toUpperCase();
    }

    // 🔄 Fetch announcements on load
    useEffect(() {
      void fetchData() async {
        try {
          List<Map<String, dynamic>> data = [];

          if (claims['role'] == 'admin') {
            data = await AnnouncementService.getAllAnnouncements();
          } else {
            data = await AnnouncementService.getAnnouncementsByRole(claims['role']);
          }

          announcements.value = data;
        } catch (e) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: '$e',
            backgroundColor: AppColor.danger,
          );
        }
      }

      fetchData();
      return null;
    }, [claims['role']]);

    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
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
                'Announcements',
                style: AppText.textLg.merge(AppText.fontSemibold),
              ),
            ),
            const Divider(thickness: 1, height: 16),

            // 🗒️ Announcements list
            Expanded(
              child: announcements.value.isEmpty
                  ? const Center(
                      child: Text(
                        'No announcements found.',
                        style: TextStyle(color: Colors.grey),
                      ),
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
                                      text: formatAudience(item['target_audience'] ?? ""),
                                      color: getAudienceColor(item['target_audience'] ?? ""),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      fontSize: 10,
                                      borderRadius: 8,
                                      isCenter: false,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // 📄 Content (ellipsis after 2 lines)
                                Text(
                                  item['content'] ?? 'No content available.',
                                  style: AppText.textXs,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 10),

                                // 📅 Footer row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatAnnouncementDate(item['posted_on']),
                                      style: AppText.textXs.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    AppButton(
                                      label: 'View More',
                                      textSize: 10,
                                      onPressed: () => navigateTo(
                                        context,
                                        ViewAnnouncement(announcement: item),
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
