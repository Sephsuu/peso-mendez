import 'package:app/core/components/button.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
          final data = await UserService.getUserTechVocTrainings(claims['id']);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                child: Text(
                  'TechVoc and Other Trainings',
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
