import 'package:app/core/components/badge.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Credentials extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const Credentials({
    super.key,
    required this.claims,
    required this.open,
    required this.setOpen,
  });
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final credentials = useState<Map<String, dynamic>>({});

    void handleSubmit() async {
      try {
        final res = await UserService.updateUserCredential({
          'id': credentials.value['id'],
          'fullName': credentials.value['full_name'],
          'username': credentials.value['username'],
          'contact': credentials.value['contact']
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
          final data = await UserService.getUserCredential(claims['id']);
          credentials.value = data;
        } catch (e) {
          AppModal(title: ('$e'));
        } finally { loading.value = false; }

      } fetchData();
      return null;
    }, [claims['id']]);

    useEffect(() {
      if (open) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AppModal(
              title: 'Edit Profile',
              titleStyle: AppText.fontBold,
              confirmBackground: AppColor.success,
              confirmForeground: AppColor.light,
              onConfirm: () => handleSubmit(),
              message: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppInputField(
                        label: 'Email',
                        initialValue: credentials.value['email'],
                        isEnabled: false,
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Full Name',
                        initialValue: credentials.value['full_name'],
                        onChanged: (value) {
                          credentials.value = {
                            ...credentials.value,
                            'full_name': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Username',
                        initialValue: credentials.value['username'],
                        onChanged: (value) {
                          credentials.value = {
                            ...credentials.value,
                            'username': value
                          };
                        },
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Contact Number',
                        initialValue: credentials.value['contact'],
                        onChanged: (value) {
                          credentials.value = {
                            ...credentials.value,
                            'contact': value
                          };
                        },
                      ),
                      const  SizedBox(height: 12),
                      AppInputField(
                        label: 'Account Created',
                        initialValue: formatDateTime(credentials.value['created_at']),
                        isEnabled: false,
                      ),
                    ],
                  ),
                ),
              )
            ),
          ).then((_) => setOpen()); // close after dialog dismissed
        });
      }
      return null;
    }, [open]);

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
                  credentials.value['full_name'],
                  style: AppText.textXl.merge(AppText.fontBold).merge(AppText.textLight)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.alternate_email, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Text(credentials.value
                  ['username'], style: AppText.textLight.merge(AppText.fontSemibold))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.email, 
                    size: 15, 
                    color: AppColor.light
                  ),
                  const SizedBox(width: 5),
                  Text(credentials.value
                  ['email'], style: AppText.textLight.merge(AppText.fontSemibold))
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
              Text('Contact Number:', style: AppText.fontBold),
              Text(credentials.value['contact']),
              const SizedBox(height: 5),
              Text('Role:', style: AppText.fontBold),
              const AppBadge(
                text: 'Job Seeker', 
                color: AppColor.primary,
                isCenter: false,
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              ),
              const SizedBox(height: 5),
              Text('Status:', style: AppText.fontBold),
              Text(credentials.value['status']),
              const SizedBox(height: 5),
              Text('Account Created:', style: AppText.fontBold),
              Text(formatDateTime(credentials.value['created_at'])),
            ],
          ),
        )
    

      ],
    );
  }
}
