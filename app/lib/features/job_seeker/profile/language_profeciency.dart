import 'package:app/core/components/button.dart';
import 'package:app/core/components/checkbox.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/language_profeciency.dart';
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
        for (var item in user.value) {
          await UserService.updateUserLanguageProficiency(item);
        } 


        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: 'Credential updated successfully!',
          backgroundColor: AppColor.success,
        );
        
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: '$e',
          backgroundColor: const Color.fromARGB(255, 28, 4, 6),
        );
      }
    }

    useEffect(() {
      if (claims['id'] == null) return null;
      void fetchData() async {
        try {
          final data =
              await UserService.getUserLanguageProfeciency(claims['id']);
          user.value = data;
        } catch (e) {
          AppModal(title: ('$e'));
        } finally {
          loading.value = false;
        }
      }

      fetchData();
      return null;
    }, [claims['id']]);

    if (loading.value) return const Loader();

    if (user.value.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'No language profeciencies found.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (claims["role"] == "job_seeker")
                const Text(
                  'Please fill out your language profeciencies to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              const SizedBox(height: 24),
              if (claims["role"] == "job_seeker")
                AppButton(
                  label: 'Fill Out Information',
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.light,
                  onPressed: () => navigateTo(context, LanguageProfeciencyForm(userId: claims['id'], fromProfile: true,)), // opens modal form
                ),
            ],
          ),
        ),
      );
    }

    useEffect(() {
      if (open) {
        // Create editable copy
        tempUser.value =
            user.value.map((item) => Map<String, dynamic>.from(item)).toList();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AppModal(
              title: 'Edit Language Proficiency',
              titleStyle: AppText.fontBold,
              confirmBackground: AppColor.success,
              confirmForeground: AppColor.light,
              onConfirm: () {
                // Apply temp changes to user state
                user.value = tempUser.value;
                handleSubmit();
              },
              message: StatefulBuilder(
                builder: (context, modalSetState) {
                  return SizedBox(
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
                                Text(
                                  '${item['language']} Language',
                                  style: AppText.fontBold.merge(AppText.textMd),
                                ),
                                const SizedBox(height: 12),

                                AppCheckbox(
                                  label: 'Read',
                                  state: item['read'] == 1,
                                  onChanged: (bool? newValue) {
                                    modalSetState(() {
                                      tempUser.value[index]['read'] =
                                          newValue == true ? 1 : 0;
                                    });
                                  },
                                ),

                                AppCheckbox(
                                  label: 'Write',
                                  state: item['write'] == 1,
                                  onChanged: (bool? newValue) {
                                    modalSetState(() {
                                      tempUser.value[index]['write'] =
                                          newValue == true ? 1 : 0;
                                    });
                                  },
                                ),

                                AppCheckbox(
                                  label: 'Speak',
                                  state: item['speak'] == 1,
                                  onChanged: (bool? newValue) {
                                    modalSetState(() {
                                      tempUser.value[index]['speak'] =
                                          newValue == true ? 1 : 0;
                                    });
                                  },
                                ),

                                AppCheckbox(
                                  label: 'Understand',
                                  state: item['understand'] == 1,
                                  onChanged: (bool? newValue) {
                                    modalSetState(() {
                                      tempUser.value[index]['understand'] =
                                          newValue == true ? 1 : 0;
                                    });
                                  },
                                ),

                                const Divider(height: 16),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
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
          width: double.infinity,
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
                  'Language Proficiency',
                  style: AppText.textXl
                      .merge(AppText.fontBold)
                      .merge(AppText.textLight),
                ),
              ),
              const SizedBox(height: 10),
              if (claims["role"] == "job_seeker")
                AppButton(
                  label: 'Edit',
                  onPressed: () => setOpen(),
                  backgroundColor: AppColor.light,
                  foregroundColor: AppColor.dark,
                  visualDensityY: -4,
                ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...user.value.asMap().entries.map((entry) {
                final item = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item['language']} Language:',
                        style: AppText.fontBold),
                    AppCheckbox(
                      label: 'Read',
                      state: item['read'] == 1,
                      onChanged: null
                    ),
                    AppCheckbox(
                      label: 'Write',
                      state: item['write'] == 1,
                      onChanged: null
                    ),
                    AppCheckbox(
                      label: 'Speak',
                      state: item['speak'] == 1,
                      onChanged: null
                    ),
                    AppCheckbox(
                      label: 'Understand',
                      state: item['understand'] == 1,
                      onChanged: null
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
