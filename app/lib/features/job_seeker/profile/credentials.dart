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
import 'package:app/features/job_seeker/profile/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:io';
import 'package:app/core/components/navigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as path;

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
              titleStyle: AppText.fontBold.merge(AppText.textLg),
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
                        visualDensityY: 0,
                        textSize: 16,
                      ),
                      const SizedBox(height: 12),
                      AppInputField(
                        label: 'Full Name',
                        initialValue: credentials.value['full_name'],
                        visualDensityY: 0,
                        textSize: 16,
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
                        visualDensityY: 0,
                        textSize: 16,
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
                        visualDensityY: 0,
                        textSize: 16,
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
                        visualDensityY: 0,
                        textSize: 16,
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
                  if (claims["role"] != "employer") // 👈 Hide if role == "employer"
                    AppButton(
                      label: 'Edit',
                      onPressed: () => setOpen(),
                      backgroundColor: AppColor.light,
                      foregroundColor: AppColor.dark,
                      visualDensityY: -4,
                    ),
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
              ResumeCard(user: credentials.value, claims: claims),
              const SizedBox(height: 20),
              Text('Account Created:', style: AppText.fontBold),
              Text(formatDateTime(credentials.value['created_at'])),
              const SizedBox(height: 100),
              if (claims["role"] == "job_seeker")
                Center(
                  child: AppButton(
                    label: "Change Password", 
                    onPressed: () => navigateTo(context, ChangePassword(userId: claims['id']))
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    );
  }
}

class ResumeCard extends HookWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> claims;

  const ResumeCard({
    super.key,
    required this.user,
    required this.claims,
  });

  @override
  Widget build(BuildContext context) {
    final pickedFile = useState<File?>(null);
    final isUploading = useState(false);

    final filename = useState(
      (user["document_path"] != null && user["document_path"].toString().isNotEmpty)
          ? path.basename(user["document_path"])
          : "No resume uploaded",
    );

    Future<void> pickFile() async {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'rtf', 'txt'],
        );

        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          pickedFile.value = file;
          filename.value = path.basename(file.path);
        } else {
          if (!context.mounted) return;
          AppSnackbar.show(context, message: "No file selected", backgroundColor: AppColor.danger);
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(context, message: "Error selecting file: $e", backgroundColor: AppColor.danger);
      }
    }


    void openDocument(String? url) {
      if (url == null || url.isEmpty) {
        AppSnackbar.show(context, message: "No resume uploaded yet.", backgroundColor: AppColor.danger);
        return;
      }

      final ext = url.split('.').last.toLowerCase();
      String finalUrl = url;

      // Convert relative to absolute
      if (!url.startsWith("http")) {
        finalUrl = "$BASE_URL/$url";
      }

      // Google Docs Viewer (PDF, DOCX, PPTX, etc.)
      if (['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx']
          .contains(ext)) {
        finalUrl = "https://docs.google.com/viewer?url=$finalUrl&embedded=true";
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text("View Document")),
            body: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(finalUrl)),
            ),
          ),
        ),
      );
    }

    Future<void> uploadResume() async {
      if (pickedFile.value == null) {
        AppSnackbar.show(context,
          message: "Please select a file first.",
          backgroundColor: AppColor.danger,
        );
        return;
      }

      try {
        isUploading.value = true;

        final uploaded = await VerificationService.uploadDocuments(pickedFile.value!);
        await UserService.updateUserCredential({
          ...user,
          "document_path": uploaded["filePath"],
        });
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: "Resume uploaded successfully!",
          backgroundColor: AppColor.success,
        ); 
        if (!context.mounted) return;
        navigateTo(context, const JobSeekerDashboard());
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: "Upload error: $e",
          backgroundColor: AppColor.danger,
        );
      } finally {
        isUploading.value = false;         
      }
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // File Row
            Row(
              children: [
                const Icon(Icons.insert_drive_file, color: Colors.blueGrey, size: 22),
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

            const SizedBox(height: 8),
            const Text(
              "Accepted file types: PDF, DOC, DOCX, RTF, TXT",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: "View",
                  onPressed: () => openDocument(user["document_path"]),
                  backgroundColor: AppColor.primary,
                  foregroundColor: AppColor.light,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  visualDensityY: -2,
                ),
                const SizedBox(width: 10),

                if (claims["role"] != "employer")
                  AppButton(
                    label: isUploading.value ? "Uploading..." : "Upload",
                    backgroundColor: isUploading.value ? Colors.grey : AppColor.success,
                    foregroundColor: AppColor.light,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    visualDensityY: -2,
                    onPressed: isUploading.value
                        ? null
                        : () async {
                            await pickFile();
                            if (pickedFile.value != null) {
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                builder: (_) => AppModal(
                                  title: "Upload selected resume?",
                                  onConfirm: () async {
                                    await uploadResume();
                                  },
                                  confirmBackground: AppColor.success,
                                  confirmForeground: AppColor.light,
                                ),
                              );
                            }
                          },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
