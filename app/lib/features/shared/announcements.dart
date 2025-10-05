import 'package:app/core/components/button.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/announcement_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Announcements extends HookWidget {
  const Announcements({super.key});
  @override
  Widget build(BuildContext context) {
    final announcements = useState<List<Map<String, dynamic>>>([]);

    useEffect(() { 
      void fetchData() async {
        try { 
          final data = await AnnouncementService.getAllAnnouncements();
          announcements.value = data;
        } catch (e) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context, 
            message: '$e',
            backgroundColor: AppColor.danger
          );
        }
      } fetchData();
      return;
    }, []);

    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Announcements', style: AppText.textLg.merge(AppText.fontBold)),
              ...announcements.value.map((item) {
                return SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'] ?? 'N/A', style: AppText.fontBold),
                          const SizedBox(height: 10),
                          Text(item['content'] ?? 'N/A'),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatAnnouncementDate(item['posted_on']), style: AppText.textXs),
                              AppButton(
                                label: 'View More', 
                                textSize: 10,
                                onPressed: () {},
                                visualDensityY: -4,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      )
    );
  }
}