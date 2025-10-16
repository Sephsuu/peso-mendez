import 'package:app/core/components/badge.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/services/user_service.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/job_seeker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:io';
import 'package:app/core/components/navigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

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
        final res = await UserService.updateUserCredential(credentials.value);
        if (res.isNotEmpty) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context, 
            message: 'Credential updated successfully! Please re-login.',
            backgroundColor: AppColor.success
          );
          await AuthService.logout(context);
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

    if (loading.value) return const Loader();

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
              ResumeCard(user: credentials.value),
              const SizedBox(height: 20),
              Text('Account Created:', style: AppText.fontBold),
              Text(formatDateTime(credentials.value['created_at'])),
            ],
          ),
        )
      ],
    );
  }
}

class ResumeCard extends HookWidget {
  final Map<String, dynamic> user;

  const ResumeCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final filename = useState('My Resume');
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

        final uploadedPath = await VerificationService.uploadDocuments(pickedFile.value!, 'job-seeker');
        if (!context.mounted) return;        

        await UserService.updateUserCredential({
          ...user,
          "document_path": uploadedPath['filePath']
        });

        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message:
              'Resume uploaded successfully..',
          backgroundColor: AppColor.success,
        );

        navigateTo(context, const JobSeekerDashboard());
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

    return Column(
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
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final String filePath = user["document_path"];
                          final String fullUrl = filePath.startsWith("http")
                              ? filePath
                              : "$BASE_URL/$filePath";

                          final Uri uri = Uri.parse(fullUrl);

                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication, // opens in browser or PDF viewer
                            );
                          } else {
                            if (context.mounted) {
                              AppSnackbar.show(
                                context,
                                message: "Cannot open document",
                                backgroundColor: AppColor.danger
                              );
                            }
                          }
                        },
                        child: Text('View', style: AppText.textPrimary),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AppModal(
                                title: 'Upload selected document?',
                                confirmBackground: AppColor.success,
                                confirmForeground: AppColor.light,
                                onConfirm: () async {
                                  Navigator.pop(context);
                                  await submitVerification(context);
                                },
                              );
                            },
                          );
                        },
                        child: Text('Update', style: AppText.textSuccess),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
} 
