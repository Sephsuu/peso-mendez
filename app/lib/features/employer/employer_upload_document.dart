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
import 'package:path_provider/path_provider.dart';

class EmpployerUploadDocument extends HookWidget {
  const EmpployerUploadDocument({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final filename = useState('Upload your documents');
    final pickedFile = useState<File?>(null);

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

    Future<File?> saveFile(BuildContext context, File file) async {
      try {
        final originalName = path.basename(file.path);
        final extension = path.extension(originalName);
        final baseName = path.basenameWithoutExtension(originalName);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final uniqueFileName = '${baseName}_$timestamp$extension';

        final dir = await getApplicationDocumentsDirectory();
        final savePath = path.join(dir.path, 'employer-documents');
        await Directory(savePath).create(recursive: true);

        final savedFile = await file.copy(path.join(savePath, uniqueFileName));
        await VerificationService.createVerification({
          "employerId": claims['id'],
          "documents": savedFile.path,
          "status": 'pending'
        });

        if (!context.mounted) return null;
        AppSnackbar.show(
          context,
          message: 'Documents submitted successfully. Please wait for admin approval',
          backgroundColor: AppColor.success,
        );
        navigateTo(context, const EmployerDashboard());
        return savedFile;
      } catch (e) {
        if (!context.mounted) return null;
        AppSnackbar.show(
          context,
          message: 'Error saving file: $e',
          backgroundColor: AppColor.danger,
        );
        return null;
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
                  await pickFile(context); // pick file first
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
                                style:
                                    AppText.fontBold.merge(AppText.textMd),
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
                  label: 'Continue',
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
                            if (pickedFile.value == null) {
                              AppSnackbar.show(
                                context,
                                message: 'Please select a document first.',
                                backgroundColor: AppColor.danger,
                              );
                              return;
                            }
                            await saveFile(context, pickedFile.value!);
                          },
                        );
                      }
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
