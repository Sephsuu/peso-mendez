import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:flutter/material.dart';

class ViewAnnouncement extends StatelessWidget {
  final Map<String, dynamic> announcement;

  const ViewAnnouncement({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) {
          Scaffold.of(context).openDrawer();
        },
      ),
      endDrawer: const OffcanvasNavigation(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏷 Title header
            Text(
              announcement['title'] ?? 'Untitled Announcement',
              style: AppText.textLg.merge(AppText.fontBold),
            ),
            const SizedBox(height: 8),

            // 📅 Date
            Text(
              formatAnnouncementDate(announcement['posted_on']),
              style: AppText.textXs.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            const Divider(thickness: 1, height: 20),

            // 📄 Full content
            Text(
              announcement['content'] ?? 'No content available.',
              style: AppText.textSm.copyWith(height: 1.5),
            ),
            const SizedBox(height: 24),

            // 📎 Attachments section (optional)
            if (announcement['files'] != null &&
                (announcement['files'] as List).isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attachments',
                    style: AppText.textSm.merge(AppText.fontSemibold),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(
                    (announcement['files'] as List).length,
                    (index) {
                      final file = announcement['files'][index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: InkWell(
                          onTap: () {
                            // TODO: Open file link if available
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.attach_file,
                                  size: 16, color: AppColor.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  file.toString(),
                                  style: AppText.textXs.copyWith(
                                    color: AppColor.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
