import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final fields = {
  'company_name': 'Company Name',
  'address': 'Address',
  'position': 'Position',
  'no_of_month': 'No. of months',
  'status': 'Status'
};


class WorkExperience extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const WorkExperience({
    super.key,
    required this.claims,
    required this.open,
    required this.setOpen,
  });
  @override
  Widget build(BuildContext context) {
    final loading = useState(true);
    final user = useState<List<Map<String, dynamic>>>([]);

    void handleSubmit() async {
      try {
        for (final userInfo in user.value) {
          await UserService.updateUserWorkExperience(userInfo);
        }
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: 'Work Experience updated successfully!',
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
          final data = await UserService.getUserWorkExperience(claims['id']);
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
                      ...user.value.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return HookBuilder(
                          builder: (context) {
                            final controllers = {
                              for (final key in fields.keys)
                                key: useTextEditingController(text: item[key] ?? ''),
                            };

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TechVoc and Other Trainings ${index + 1}', style: AppText.fontBold),
                                const SizedBox(height: 12),
                                for (final entry in fields.entries) ...[
                                  AppInputField(
                                    label: entry.value,
                                    controller: controllers[entry.key]!,
                                    onChanged: (value) {
                                      final updated = [...user.value];
                                      updated[index] = {...updated[index], entry.key: value};
                                      user.value = updated;
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

    useEffect(() {
      print(user.value);
    }, [user.value]);

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
                  'Work Experience',
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
                      Text('Work Experience 1:', style: AppText.fontBold),
                      Text('Company Name: ${item['company_name'] ?? 'N/A'}'),
                      Text('Address: ${item['address'] ?? 'N/A'}'),
                      Text('Position/Designation: ${item['position'] ?? 'N/A'}'),
                      Text('No. of month: ${item['no_of_month'] ?? 'N/A'}'),
                      Text('Status: ${item['status'] ?? 'N/A'}'),
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
