import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EducationalBackround extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const EducationalBackround({
    super.key,
    required this.claims,
    required this.open,
    required this.setOpen,
  });
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final user = useState<Map<String, dynamic>>({});

    void handleSubmit() async {
      try {
        final res = await UserService.updateUserCredential({
          'id': user.value['id'],
          'fullName': user.value['full_name'],
          'username': user.value['username'],
          'contact': user.value['contact']
        });
        if (res.isNotEmpty) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context, 
            message: 'Credential updated successfully!',
            backgroundColor: AppColor.success
          );
        }
      } catch (e) { 
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: '$e',
          backgroundColor: AppColor.danger
        );
      }
    }

    useEffect(() {
      if (claims['id'] == null) return null;
      void fetchData() async {
        try {
          final data = await UserService.getUserEducationalBackground(claims['id']);
          user.value = data;
        } catch (e) {
          AppModal(title: ('$e'));
        } finally { loading.value = false; }

      } fetchData();
      return null;
    }, [claims['id']]);


    if (loading.value) return const Loader();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          width: double.infinity,  // full width
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight,  
              colors: [
                Color.fromARGB(255, 32, 64, 192),            
                Color.fromARGB(255, 104, 129, 255),             
              ],
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Educational Background',
                  style: AppText.textXl.merge(AppText.fontBold).merge(AppText.textLight)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.school, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      user.value['ter_course'] ?? 'N/A',
                      style: AppText.textLight.merge(AppText.fontSemibold)
                    )
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.date_range, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Text(
                    user.value['ter_year_grad'] ?? 'N/A', 
                    style: AppText.textLight.merge(AppText.fontSemibold)
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AppButton(
                    label: 'Edit', 
                    onPressed: () => setOpen(),
                    backgroundColor: AppColor.light,
                    foregroundColor: AppColor.dark,
                    visualDensityY: -4,
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Elementary Year Graduated:', style: AppText.fontBold),
              Text(user.value['elem_year_grad'] ?? 'N/A'),
              const SizedBox(height: 5),
              Text('Elementary Level Reached:', style: AppText.fontBold),
              Text(user.value['elem_year_grad'].isNotEmpty ? 'Grade Six' : user.value['elem_level_reached']),
              const SizedBox(height: 5),
              Text('Elementary Last Year Attended:', style: AppText.fontBold),
              Text(user.value['elem_year_grad'].isNotEmpty ? user.value['elem_year_grad'] : user.value['elem_year_last_attended']),
              const SizedBox(height: 20),

              Text('High School Year Graduated:', style: AppText.fontBold),
              Text(user.value['seco_year_grad'] ?? 'N/A'),
              const SizedBox(height: 5),
              Text('High School Level Reached:', style: AppText.fontBold),
              Text(user.value['seco_year_grad'].isNotEmpty ? 'Fourth Year' : user.value['seco_level_reached']),
              const SizedBox(height: 5),
              Text('High School Last Year Attended:', style: AppText.fontBold),
              Text(user.value['seco_year_grad'].isNotEmpty ? user.value['seco_year_grad'] : user.value['seco_year_last_attended']),
              const SizedBox(height: 20),

              Text('Senior High School Strand (Kto12):', style: AppText.fontBold),
              Text(user.value['shs_strand'] ?? 'N/A'),
              const SizedBox(height: 20),

              Text('Tertiary Level Reached:', style: AppText.fontBold),
              Text(user.value['ter_level_reached'].isEmpty ? 'N/A' : user.value['ter_level_reached']),
              const SizedBox(height: 5),
              Text('Tertiary Level Last Year Attended:', style: AppText.fontBold),
              Text(user.value['ter_year_last_attended'].isEmpty ? 'N/A' : user.value['ter_year_last_attended']),
              const SizedBox(height: 20),

              Text('General Studies Course/Program:', style: AppText.fontBold),
              Text(user.value['gs_course'].isEmpty ? 'N/A' : user.value['gs_course']),
              const SizedBox(height: 5),
              Text('General Studies Year Graduated:', style: AppText.fontBold),
              Text(user.value['gs_year_grad'].isEmpty ? 'N/A' : user.value['gs_year_grad']),
              const SizedBox(height: 5),
              Text('General Studies Reached:', style: AppText.fontBold),
              Text(user.value['gs_level_reached'].isEmpty ? 'N/A' : user.value['gs_level_reached']),
              const SizedBox(height: 5),
              Text('General Studies Last Year Attended:', style: AppText.fontBold),
              Text(user.value['gs_year_last_attended'].isEmpty ? 'N/A' : user.value['gs_year_last_attended']),
              const SizedBox(height: 20),

              Text('Fill up date:', style: AppText.fontBold),
              Text(user.value['created_at'].isEmpty ? 'N/A' : formatDateTime(user.value['created_at'])),
              const SizedBox(height: 20),
            ],
          ),
        )
    

      ],
    );
  }
}
