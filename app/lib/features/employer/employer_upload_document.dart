import 'dart:io';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart' as path;

class EmpployerUploadDocument extends HookWidget {
  const EmpployerUploadDocument({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final filename = useState('Upload your documents');
    final pickedFile = useState<File?>(null);
    final isUploading = useState(false);

    Future<void> pickFile(BuildContext context) async {
      try {
        final result = await FilePicker.platform.pickFiles();

        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          pickedFile.value = file;
          filename.value = path.basename(file.path);
        } else {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: 'No file selected',
            backgroundColor: AppColor.danger,
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: 'Error picking file: $e',
          backgroundColor: AppColor.danger,
        );
      }
    }

    Future<void> submitVerification(BuildContext context) async {
      if (pickedFile.value == null) {
        AppSnackbar.show(
          context,
          message: 'Please select a file first.',
          backgroundColor: AppColor.danger,
        );
        return;
      }

      try {
        isUploading.value = true;

        final uploadedPath = await VerificationService.uploadDocuments(pickedFile.value!, 'employer');
        if (!context.mounted) return;        

        await VerificationService.createVerification({
          "employerId": claims['id'],
          "documents": uploadedPath['filePath'], // ✅ backend file path
          "status": "pending",
        });

        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message:
              'Documents uploaded successfully. Please wait for admin approval.',
          backgroundColor: AppColor.success,
        );

        navigateTo(context, const EmployerDashboard());
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: 'Error uploading: $e',
          backgroundColor: AppColor.danger,
        );
      } finally {
        isUploading.value = false;
      }
    }

    return Scaffold(
      appBar: AppNavigationBar(
        title: 'Mendez PESO Job Portal',
        onMenuPressed: (context) {
          Scaffold.of(context).openDrawer();
        },
      ),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await pickFile(context);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.insert_drive_file,
                                color: Colors.blueGrey, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                filename.value,
                                style: AppText.fontBold.merge(AppText.textMd),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Accepted file types are PDF (recommended), DOCX, RTF, and TXT',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: isUploading.value ? 'Uploading...' : 'Continue',
                  visualDensityY: -2,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AppModal(
                          title: 'Upload selected document?',
                          confirmBackground: AppColor.primary,
                          confirmForeground: AppColor.light,
                          onConfirm: () async {
                            Navigator.pop(context);
                            await submitVerification(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
