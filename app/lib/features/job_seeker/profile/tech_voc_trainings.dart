import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/techvoc_training.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final fields = {
  'course': 'Course',
  'hours_training': 'Hrs. of Training',
  'institution': 'Institution',
  'skills_acquired': 'Skills Acquired',
  'cert_received': 'Certificate Received',
};

class TechVocTrainings extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const TechVocTrainings({
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
        for (final training in user.value) {
          await UserService.updateUserTechVocTraining(training);
        }
        if (!context.mounted) return;
        AppSnackbar.show(
          context, 
          message: 'Credential updated successfully!',
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
          final data = await UserService.getUserTechVocTrainings(claims['id']);
          user.value = data;
        } catch (e) {
          AppModal(title: ('$e'));
        } finally { loading.value = false; }

      } fetchData();
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
                'No techvoc and trainings found.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              if (claims["role"] == "job_seeker")
                const Text(
                  'Please fill out your techvoc and trainings to continue.',
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
                  onPressed: () => navigateTo(context, TechVocForm(userId: claims['id'], fromProfile: true)), // opens modal form
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
              titleStyle: AppText.fontBold.merge(AppText.textXl),
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
                                    visualDensityY: 0,
                                    textSize: 16,
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
                  'TechVoc and Other Trainings',
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
              ...user.value.map((item) {
                return (
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TechVoc/Training 1:', style: AppText.fontBold),
                      Text('Course: ${item['course'] ?? 'N/A'}'),
                      Text('Hrs. Training: ${item['hours_training'] ?? 'N/A'}'),
                      Text('Institution: ${item['institution'] ?? 'N/A'}'),
                      Text('Skills Acquired: ${item['skills_acquired'] ?? 'N/A'}'),
                      Text('Certificate Received: ${item['cert_received'] ?? 'N/A'}'),
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
