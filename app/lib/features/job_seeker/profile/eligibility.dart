import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/eligipility_prc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final fieldsE = {
  'eligibility': 'Eligibility',
  'date_taken': 'Date Taken',
};

final fieldsL = {
  'license': 'License',
  'valid_until': 'Valid Until'
};

class Eligibility extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const Eligibility({
    super.key,
    required this.claims,
    required this.open,
    required this.setOpen,
  });
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final userE = useState<List<Map<String, dynamic>>>([]);
    final userL = useState<List<Map<String, dynamic>>>([]);

    void handleSubmit() async {
      try {
        for (final userInfo in userE.value) {
          await UserService.updateUserEligibility(userInfo);
        }
        for (final userInfo in userL.value) {
          await UserService.updateUserProfessionalLicense(userInfo);
        }
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: 'Eligibility updated successfully!',
          backgroundColor: AppColor.success
        );
      
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
          final eData = await UserService.getUserEligibility(claims['id']);
          final lData = await UserService.getUserProfLicense(claims['id']);
          userE.value = eData;
          userL.value = lData;

        } catch (e) {
          AppModal(title: ('$e'));
        } finally { loading.value = false; }

      } fetchData();
      return null;
    }, [claims['id']]);

    if (loading.value) return const Loader();

    if (userE.value.isEmpty || userL.value.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 60, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'No eligibilities found.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please fill out your eligibilities to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Fill Out Information',
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.light,
                onPressed: () => navigateTo(context, EligibilityPRCForm(userId: claims['id'], fromProfile: true)), // opens modal form
              ),
            ],
          ),
        ),
      );
    }

    useEffect(() {
      if (open) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => AppModal(
              title: 'Edit Language Profeciency',
              titleStyle: AppText.fontBold,
              confirmBackground: AppColor.success,
              confirmForeground: AppColor.light,
              onConfirm: () => handleSubmit(),
              message: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...userE.value.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return HookBuilder(
                          builder: (context) {
                            final controllers = {
                              for (final key in fieldsE.keys)
                                key: useTextEditingController(text: item[key] ?? ''),
                            };

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TechVoc and Other Trainings ${index + 1}', style: AppText.fontBold),
                                const SizedBox(height: 12),
                                for (final entry in fieldsE.entries) ...[
                                  AppInputField(
                                    label: entry.value,
                                    controller: controllers[entry.key]!,
                                    onChanged: (value) {
                                      final updated = [...userE.value];
                                      updated[index] = {...updated[index], entry.key: value};
                                      userE.value = updated;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            );
                          },
                        );
                      }),
                      ...userL.value.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return HookBuilder(
                          builder: (context) {
                            final controllers = {
                              for (final key in fieldsL.keys)
                                key: useTextEditingController(text: item[key] ?? ''),
                            };

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('License ${index + 1}', style: AppText.fontBold),
                                const SizedBox(height: 12),
                                for (final entry in fieldsL.entries) ...[
                                  AppInputField(
                                    label: entry.value,
                                    controller: controllers[entry.key]!,
                                    onChanged: (value) {
                                      final updated = [...userL.value];
                                      updated[index] = {...updated[index], entry.key: value};
                                      userL.value = updated;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ],
                            );
                          },
                        );
                      }),
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
                alignment: Alignment.center,
                child: Text(
                  'Eligibility and Professional License',
                  style: AppText.textXl.merge(AppText.fontBold).merge(AppText.textLight)),
              ),
              const SizedBox(height: 10),
              if (claims["role"] != "employer") // 👈 Hide if role == "employer"
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
              ...userE.value.map((item) {
                return (
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Eligibility 1:', style: AppText.fontBold),
                      Text('Eligibility: ${item['eligibility'] ?? 'N/A'}'),
                      Text('Date Taken: ${formatDateTime(item['date_taken'])}'),
                      const SizedBox(height: 10)
                    ]
                  )
                );
              }),
              ...userL.value.map((item) {
                return (
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Professional License 1:', style: AppText.fontBold),
                      Text('PRC License/Registered License: ${item['license'] ?? 'N/A'}'),
                      Text('Valid Until: ${formatDateTime(item['valid_until'])}'),
                      const SizedBox(height: 10)
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
