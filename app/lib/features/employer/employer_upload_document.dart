import 'dart:convert';
import 'dart:io';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class EmployerUploadAllDocuments extends HookWidget {
  const EmployerUploadAllDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);

    // Dummy backend URL
    const backendUrl = "$BASE_URL/uploads/employer/formdata";

    final documentFields = [
      "Letter of Intent",
      "Company Profile",
      "Business Permit",
      "Mayors Permit",
      "SEC Registration",
      "POEA DMW Registration",
      "Approved Job Order",
      "Job Vacancies",
      "PhilJobNet Accreditation",
      "DOLE Certificate of No Pending Case",
    ];

    final pickedFiles = useState<Map<String, File?>>({});
    final filenames = useState<Map<String, String>>({});
    final isUploading = useState(false);

    // Pick file by label
    Future<void> pickFile(String label) async {
      try {
        final result = await FilePicker.platform.pickFiles();

        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);

          pickedFiles.value = {...pickedFiles.value, label: file};
          filenames.value = {
            ...filenames.value,
            label: path.basename(file.path),
          };
        } else {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "No file selected",
            backgroundColor: AppColor.danger,
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        AppSnackbar.show(
          context,
          message: "Error picking file: $e",
          backgroundColor: AppColor.danger,
        );
      }
    }

    // Convert label → backend field name
    String convertLabel(String label) {
      return label
          .toLowerCase()
          .replaceAll(" ", "_")
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll("/", "_");
    }

    // Submit all files in ONE FormData request
    Future<void> submitAll() async {
      if (pickedFiles.value.isEmpty) {
        AppSnackbar.show(
          context,
          message: "Upload at least one document.",
          backgroundColor: AppColor.danger,
        );
        return;
      }

      try {
        isUploading.value = true;

        var request = http.MultipartRequest("POST", Uri.parse(backendUrl));

        // Add employerId
        request.fields["employerId"] = claims["id"].toString();

        // Attach files
        for (final entry in pickedFiles.value.entries) {
          final label = entry.key;
          final file = entry.value;

          if (file == null) continue;

          final fieldName = convertLabel(label);

          request.files.add(
            await http.MultipartFile.fromPath(
              fieldName,
              file.path,
            ),
          );
        }

        request.headers.addAll({
          "Accept": "*/*",
          "Content-Type": "multipart/form-data",
        });

        final response = await request.send();
        final respBody = await response.stream.bytesToString();

        if (response.statusCode != 200) {
          throw Exception("Server error: $respBody");
        }

        // -------------------------
        // ⭐ PARSE UPLOADED PATHS
        // -------------------------
        final Map<String, dynamic> res = Map<String, dynamic>.from(
          jsonDecode(respBody),
        );

        // Build final payload for DB
        final Map<String, dynamic> payload = {
          "status": "pending",
          "employerId": claims["id"],
          "letter_of_intent": res["data"]["letter_of_intent"] ?? "",
          "company_profile": res["data"]["company_profile"] ?? "",
          "business_permit": res["data"]["business_permit"] ?? "",
          "mayors_permit": res["data"]["mayors_permit"] ?? "",
          "sec_registration": res["data"]["sec_registration"] ?? "",
          "poea_dmw_registration": res["data"]["poea_dmw_registration"] ?? "",
          "approved_job_order": res["data"]["approved_job_order"] ?? "",
          "job_vacancies": res["data"]["job_vacancies"] ?? "",
          "philjobnet_accreditation": res["data"]["philjobnet_accreditation"] ?? "",
          "dole_no_pending_case_certificate":
              res["data"]["dole_no_pending_case_certificate"] ?? "",
        };

        final data = await VerificationService.createVerification(payload); 

        if (data.isNotEmpty) {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "Documents uploaded successfully!",
            backgroundColor: AppColor.success,
          );
          navigateTo(context, const EmployerDashboard());
        } else {
          if (!context.mounted) return;
          AppSnackbar.show(
            context,
            message: "Something went wrong!",
            backgroundColor: AppColor.danger,
          );
        }

      } catch (e) {
        AppSnackbar.show(
          context,
          message: "Upload failed: $e",
          backgroundColor: AppColor.danger,
        );
      } finally {
        isUploading.value = false;
      }
    }


    return Scaffold(
      appBar: AppNavigationBar(
        title: "Employer Documents Upload",
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
      ),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...documentFields.map((label) {
              final fileName = filenames.value[label] ?? "Tap to upload $label";
              final hasFile = pickedFiles.value[label] != null;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => pickFile(label),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 26,
                          color: hasFile ? AppColor.success : AppColor.primary,   // ⭐ change color
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: AppText.fontBold.merge(AppText.textMd),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fileName,
                                style: AppText.textMuted.merge(AppText.textSm),
                                softWrap: true,
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Accepted: PDF, DOCX, RTF, TXT",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            AppButton(
              label: isUploading.value ? "Uploading..." : "Submit Documents",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AppModal(
                    title: "Submit all employer documents?",
                    confirmBackground: AppColor.primary,
                    confirmForeground: AppColor.light,
                    onConfirm: () async {
                      await submitAll();
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
