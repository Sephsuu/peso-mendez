import 'package:app/core/components/button.dart';
import 'package:app/core/components/checkbox.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LanguageProfeciency extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const LanguageProfeciency({
    super.key,
    required this.claims,
    required this.open,
    required this.setOpen,
  });
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final user = useState<List<Map<String, dynamic>>>([]);
    final tempUser = useState<List<Map<String, dynamic>>>([]);


    void handleSubmit() async {
      try {
        final res = await UserService.updateUserCredential({
          // 'id': user.value['id'],
          // 'fullName': user.value['full_name'],
          // 'username': user.value['username'],
          // 'contact': user.value['contact']
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
          backgroundColor: const Color.fromARGB(255, 28, 4, 6)
        );
      }
    }

    useEffect(() {
      if (claims['id'] == null) return null;
      void fetchData() async {
        try {
          final data = await UserService.getUserLanguageProfeciency(claims['id']);
          user.value = data;
        } catch (e) {
          AppModal(title: ('$e'));
        } finally { loading.value = false; }

      } fetchData();
      return null;
    }, [claims['id']]);


    if (loading.value) return const Loader();

    useEffect(() {
      if (open) {
        tempUser.value = user.value.map((item) => Map<String, dynamic>.from(item)).toList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AppModal(
              title: 'Edit Language Proficiency',
              titleStyle: AppText.fontBold,
              confirmBackground: AppColor.success,
              confirmForeground: AppColor.light,
              onConfirm: () {
                // Only apply changes when Confirm is pressed
                user.value = tempUser.value;
                handleSubmit();
              },
              message: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...tempUser.value.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item['language']} Language', style: AppText.fontBold.merge(AppText.textMd)),
                            const SizedBox(height: 12),
                            AppCheckbox(
                              label: 'Read',
                              state: item['read'] == 1,
                              onChanged: (bool? newValue) {
                                final updated = [...tempUser.value];
                                updated[index]['read'] = newValue == true ? 1 : 0;
                                tempUser.value = updated;
                              },
                            ),
                            AppCheckbox(
                              label: 'Write',
                              state: item['write'] == 1,
                              onChanged: (bool? newValue) {
                                final updated = [...tempUser.value];
                                updated[index]['write'] = newValue == true ? 1 : 0;
                                tempUser.value = updated;
                              },
                            ),
                            AppCheckbox(
                              label: 'Speak',
                              state: item['speak'] == 1,
                              onChanged: (bool? newValue) {
                                final updated = [...tempUser.value];
                                updated[index]['speak'] = newValue == true ? 1 : 0;
                                tempUser.value = updated;
                              },
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ).then((_) => setOpen());
        });
      }
      return null;
    }, [open]);

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                child: Text(
                  'Language Profeciency',
                  style: AppText.textXl.merge(AppText.fontBold).merge(AppText.textLight)),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: 'Edit', 
                onPressed: () => setOpen(),
                backgroundColor: AppColor.light,
                foregroundColor: AppColor.dark,
                visualDensityY: -4,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...user.value.map((item) {
                return (
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item['language']} Language:', style: AppText.fontBold),
                      AppCheckbox(
                        label: 'Read', 
                        state: item['read'] == 1,
                        onChanged: (bool? newValue) {
                          item['read'] == 1;
                        },
                      ),
                      AppCheckbox(
                        label: 'Write', 
                        state: item['write'] == 1,
                        onChanged: (bool? newValue) {
                          item['write'] == 1;
                        },
                      ),
                      AppCheckbox(
                        label: 'Speak', 
                        state: item['speak'] == 1,
                        onChanged: (bool? newValue) {
                          item['speak'] == 1;
                        },
                      ),
                      AppCheckbox(
                        label: 'Understand', 
                        state: item['understand'] == 1,
                        onChanged: (bool? newValue) {
                          item['understand'] == 1;
                        },
                      ),
                    ]
                  )
                );
              }),
            ],
          ),
        )
    

      ],
    );
  }
}
