import 'package:app/core/components/button.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/announcement_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Announcements extends HookWidget {
  const Announcements({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final announcements = useState<List<Map<String, dynamic>>>([]);

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
                'Announcements',
                style: AppText.textLg.merge(AppText.fontSemibold)
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
                                Text(
                                  item['title'] ?? 'Untitled',
                                  style: AppText.textSm
                                      .merge(AppText.fontSemibold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['content'] ?? 'No content available.',
                                  style: AppText.textXs,
                                ),
                                const SizedBox(height: 10),
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
                                      onPressed: () {},
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
