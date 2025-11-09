import 'package:app/core/components/badge.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/forms/other_skills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OtherSkills extends HookWidget {
  final Map<String, dynamic> claims;
  final bool open;
  final VoidCallback setOpen;

  const OtherSkills({
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
        final res = await UserService.updateUserCredential({
        
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
          final data = await UserService.getUserOtherSkills(claims['id']);
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
                'No other skills found.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please fill out your other skills to continue.',
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
                onPressed: () => navigateTo(context, OtherSkillsForm(userId: claims['id'])), // opens modal form
              ),
            ],
          ),
        ),
      );
    }

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
                  'Other Skills',
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
              Text('My Skills:', style: AppText.fontBold),
              const SizedBox(height: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < user.value.length; i += 2)
                    Row(
                      children: [
                        for (int j = i; j < i + 2 && j < user.value.length; j++)
                          Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 8),
                            child: AppBadge(
                              text: user.value[j]['skill'],
                              color: AppColor.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
