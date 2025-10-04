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

class JobReference extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const JobReference({
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
          final data = await UserService.getUserJobReference(claims['id']);
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
                  'Job Reference',
                  style: AppText.textXl.merge(AppText.fontBold).merge(AppText.textLight)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.fact_check, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Text(
                    user.value['occupation_type'] ?? 'N/A',
                    style: AppText.textLight.merge(AppText.fontSemibold)
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.location_on, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Text(
                    user.value['location_type'] ?? 'N/A', 
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
              Text('Occupation 1:', style: AppText.fontBold),
              Text(user.value['occupation1']),
              const SizedBox(height: 5),
              Text('Location 1:', style: AppText.fontBold),
              Text(user.value['location1']),
              const SizedBox(height: 5),
              Text('Occupation 2:', style: AppText.fontBold),
              Text(user.value['occupation2']),
              const SizedBox(height: 5),
              Text('Location 2:', style: AppText.fontBold),
              Text(user.value['location2']),
              const SizedBox(height: 5),
              Text('Occupation 3:', style: AppText.fontBold),
              Text(user.value['occupation3']),
              const SizedBox(height: 5),
              Text('Location 3:', style: AppText.fontBold),
              Text(user.value['location3']),
              const SizedBox(height: 5),
              Text('Fill up date:', style: AppText.fontBold),
              Text(formatDateTime(user.value['created_at'])),
              const SizedBox(height: 5),

            ],
          ),
        )
    

      ],
    );
  }
}
