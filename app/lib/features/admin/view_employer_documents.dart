import 'dart:convert';
import 'dart:io';

import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/hooks/utils.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

class ViewEmployerDocuments extends StatefulWidget {
  final Map<String, dynamic> claims;
  final int employerId;

  const ViewEmployerDocuments({
    super.key,
    required this.claims,
    this.employerId = 0,
  });

  @override
  State<ViewEmployerDocuments> createState() => _ViewEmployerDocumentsState();
}

class _ViewEmployerDocumentsState extends State<ViewEmployerDocuments> {
  Map<String, dynamic>? verification;
  bool loading = true;

  bool approving = false;
  bool rejecting = false;

  // ✅ employer edit/upload state
  bool editing = false;
  bool isUploading = false;
  final Map<String, File?> pickedFiles = {};
  final Map<String, String> filenames = {};

  // same endpoint from your upload page
  static const String backendUploadUrl = "$BASE_URL/uploads/employer/formdata";

  // Document mappings (label -> DB field)
  final Map<String, String> documentMap = {
    "Letter of Intent": "letter_of_intent",
    "Company Profile": "company_profile",
    "Business Permit": "business_permit",
    "Mayor's Permit": "mayors_permit",
    "SEC Registration": "sec_registration",
    "POEA/DMW Registration": "poea_dmw_registration",
    "Approved Job Order": "approved_job_order",
    "Job Vacancies": "job_vacancies",
    "PhilJobNet Accreditation": "philjobnet_accreditation",
    "DOLE No Pending Case Certificate": "dole_no_pending_case_certificate",
  };

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    try {
      final data = await VerificationService.getVerificationByUser(widget.employerId == 0 ? widget.claims["id"] : widget.employerId);
      if (!mounted) return;

      setState(() {
        verification = (data.isEmpty) ? null : data;
        loading = false;

        // if employer has no verification yet, allow editing immediately
        if (widget.claims["role"] == "employer" && verification == null) {
          editing = true;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      AppSnackbar.show(
        context,
        message: "Failed to load verification: $e",
        backgroundColor: AppColor.danger,
      );
    }
  }

  // -----------------------------
  // VIEW + DOWNLOAD DOCUMENT
  // -----------------------------
  void openDocument(String? url) {
    if (url == null || url.isEmpty) return;

    final ext = url.split('.').last.toLowerCase();
    String viewerUrl = url;

    if (ext == "pdf" ||
        ['doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'].contains(ext)) {
      viewerUrl = "https://docs.google.com/viewer?url=$url&embedded=true";
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("View Document"),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'Download',
                onPressed: () async {
                  final uri = Uri.parse(url);

                  final canLaunchIt = await canLaunchUrl(uri);
                  if (!canLaunchIt) {
                    if (!context.mounted) return;
                    AppSnackbar.show(
                      context,
                      message: 'Unable to download file',
                      backgroundColor: AppColor.danger,
                    );
                    return;
                  }

                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),
          body: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(viewerUrl)),
          ),
        ),
      ),
    );
  }

  // -----------------------------
  // STATUS BADGE
  // -----------------------------
  Widget buildStatusBadge(String status) {
    Color bg = Colors.grey.shade300;
    Color text = Colors.black;

    if (status == "approved") {
      bg = Colors.green.shade100;
      text = Colors.green.shade800;
    } else if (status == "pending") {
      bg = Colors.orange.shade100;
      text = Colors.orange.shade800;
    } else if (status == "rejected") {
      bg = Colors.red.shade100;
      text = Colors.red.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // -----------------------------
  // ADMIN: APPROVE / REJECT
  // -----------------------------
  Future<void> approveDocument(int id) async {
    showDialog(
      context: context,
      builder: (_) => AppModal(
        title: "Approve Documents",
        message: "Are you sure you want to approve this employer’s documents?",
        confirmLabel: "Approve",
        confirmBackground: AppColor.success,
        confirmForeground: AppColor.light,
        onConfirm: () async {
          Navigator.pop(context);
          setState(() => approving = true);

          try {
            final data = await VerificationService.updateVerificationStatus(
              id,
              "approved",
              verification?["note"] ?? "",
            );

            if (!context.mounted) return;
            if (data.isNotEmpty) {
              AppSnackbar.show(
                context,
                message: "Employer verification approved successfully!",
                backgroundColor: AppColor.success,
              );
            } else {
              AppSnackbar.show(
                context,
                message: "Something went wrong. Please try again.",
                backgroundColor: AppColor.danger,
              );
            }
          } catch (e) {
            if (!mounted) return;
            AppSnackbar.show(
              context,
              message: "Error approving verification: $e",
              backgroundColor: AppColor.danger,
            );
          } finally {
            if (!mounted) return;
            setState(() => approving = false);
            await loadDocuments();
          }
        },
      ),
    );
  }

  Future<void> rejectDocument(int id) async {
    showDialog(
      context: context,
      builder: (_) => AppModal(
        title: "Reject Documents",
        message: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please state the reason why employer accreditation was rejected.',
              ),
              const SizedBox(height: 12),
              AppInputField(
                label: 'Reason',
                initialValue: verification?['note'] ?? '',
                visualDensityY: 0,
                textSize: 16,
                onChanged: (val) {
                  setState(() {
                    verification = {
                      ...(verification ?? {}),
                      'note': val,
                    };
                  });
                },
              ),
            ],
          ),
        ),
        confirmLabel: "Reject",
        confirmBackground: AppColor.danger,
        confirmForeground: AppColor.light,
        onConfirm: () async {
          Navigator.pop(context);
          setState(() => rejecting = true);

          try {
            final data = await VerificationService.updateVerificationStatus(
              id,
              "rejected",
              verification?["note"],
            );

            if (!mounted) return;

            if (data.isNotEmpty) {
              AppSnackbar.show(
                context,
                message: "Employer verification rejected successfully!",
                backgroundColor: AppColor.danger,
              );
            } else {
              AppSnackbar.show(
                context,
                message: "Something went wrong. Please try again.",
                backgroundColor: AppColor.danger,
              );
            }
          } catch (e) {
            if (!mounted) return;
            AppSnackbar.show(
              context,
              message: "Error rejecting verification: $e",
              backgroundColor: AppColor.danger,
            );
          } finally {
            if (!mounted) return;
            setState(() => rejecting = false);
            await loadDocuments();
          }
        },
      ),
    );
  }

  // -----------------------------
  // EMPLOYER: PICK FILE
  // -----------------------------
  Future<void> pickFile(String label) async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        setState(() {
          pickedFiles[label] = file;
          filenames[label] = path.basename(file.path);
        });
      } else {
        if (!mounted) return;
        AppSnackbar.show(
          context,
          message: "No file selected",
          backgroundColor: AppColor.danger,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(
        context,
        message: "Error picking file: $e",
        backgroundColor: AppColor.danger,
      );
    }
  }

  // label -> backend field name (same logic as your upload page)
  String convertLabelToField(String label) {
    return label
        .toLowerCase()
        .replaceAll(" ", "_")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("/", "_")
        .replaceAll("'", "");
  }

  // -----------------------------
  // EMPLOYER: SUBMIT EDIT/UPLOAD
  // -----------------------------
  Future<void> submitEmployerDocuments() async {
    if (pickedFiles.isEmpty) {
      AppSnackbar.show(
        context,
        message: "Upload at least one document.",
        backgroundColor: AppColor.danger,
      );
      return;
    }

    setState(() => isUploading = true);

    try {
      final request = http.MultipartRequest("POST", Uri.parse(backendUploadUrl));

      request.fields["employerId"] = widget.claims["id"].toString();

      for (final entry in pickedFiles.entries) {
        final label = entry.key;
        final file = entry.value;
        if (file == null) continue;

        final fieldName = convertLabelToField(label);

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

      final Map<String, dynamic> res = Map<String, dynamic>.from(jsonDecode(respBody));

      final payload = <String, dynamic>{
        "status": "pending",
        "employerId": widget.claims["id"],

        "letter_of_intent": res["data"]["letter_of_intent"] ?? (verification?["letter_of_intent"] ?? ""),
        "company_profile": res["data"]["company_profile"] ?? (verification?["company_profile"] ?? ""),
        "business_permit": res["data"]["business_permit"] ?? (verification?["business_permit"] ?? ""),
        "mayors_permit": res["data"]["mayors_permit"] ?? (verification?["mayors_permit"] ?? ""),
        "sec_registration": res["data"]["sec_registration"] ?? (verification?["sec_registration"] ?? ""),
        "poea_dmw_registration": res["data"]["poea_dmw_registration"] ?? (verification?["poea_dmw_registration"] ?? ""),
        "approved_job_order": res["data"]["approved_job_order"] ?? (verification?["approved_job_order"] ?? ""),
        "job_vacancies": res["data"]["job_vacancies"] ?? (verification?["job_vacancies"] ?? ""),
        "philjobnet_accreditation": res["data"]["philjobnet_accreditation"] ?? (verification?["philjobnet_accreditation"] ?? ""),
        "dole_no_pending_case_certificate":
            res["data"]["dole_no_pending_case_certificate"] ?? (verification?["dole_no_pending_case_certificate"] ?? ""),
      };

      Map<String, dynamic> saved = {};

      // ✅ If verification already exists, try update; otherwise create
      if (verification != null && verification!["id"] != null) {
        // If you don't have this endpoint, comment this and keep create only.
        try {
          saved = await VerificationService.updateVerification(verification!["id"], payload);
        } catch (_) {
          // fallback: create again if update doesn't exist
          saved = await VerificationService.createVerification(payload);
        }
      } else {
        saved = await VerificationService.createVerification(payload);
      }

      if (!mounted) return;

      if (saved.isNotEmpty) {
        AppSnackbar.show(
          context,
          message: "Documents submitted successfully!",
          backgroundColor: AppColor.success,
        );
        setState(() {
          editing = false;
          pickedFiles.clear();
          filenames.clear();
        });
        await loadDocuments();
      } else {
        AppSnackbar.show(
          context,
          message: "Something went wrong. Please try again.",
          backgroundColor: AppColor.danger,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(
        context,
        message: "Upload failed: $e",
        backgroundColor: AppColor.danger,
      );
    } finally {
      if (!mounted) return;
      setState(() => isUploading = false);
    }
  }

  // -----------------------------
  // DOCUMENT TILE
  // -----------------------------
  Widget buildDocumentTile(String label, String? url) {
    final hasFile = url != null && url.isNotEmpty && !url.endsWith("/null");

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          Icon(
            Icons.description,
            size: 28,
            color: hasFile ? AppColor.success : AppColor.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.fontBold.merge(AppText.textMd)),
                const SizedBox(height: 4),
                Text(
                  hasFile ? "Tap to view document" : "No document uploaded",
                  style: AppText.textMuted.merge(AppText.textSm),
                ),
              ],
            ),
          ),
          if (hasFile)
            IconButton(
              icon: const Icon(Icons.open_in_new, color: Colors.blue),
              onPressed: () => openDocument(url),
            ),
        ],
      ),
    );
  }

  // -----------------------------
  // EMPLOYER EDIT UI
  // -----------------------------
  Widget buildEmployerEditSection() {
    final labels = documentMap.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Edit / Upload Documents", style: AppText.fontBold.merge(AppText.textLg)),
        const SizedBox(height: 10),

        ...labels.map((label) {
          final name = filenames[label] ?? "Tap to upload $label";
          final hasPicked = pickedFiles[label] != null;

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
                      color: hasPicked ? AppColor.success : AppColor.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(label, style: AppText.fontBold.merge(AppText.textMd)),
                          const SizedBox(height: 4),
                          Text(
                            name,
                            style: AppText.textMuted.merge(AppText.textSm),
                            softWrap: true,
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Accepted: PDF, DOCX, RTF, TXT",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
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

        AppButton(
          label: isUploading ? "Submitting..." : "Submit Documents",
          isDisabled: ((verification?["status"] as String?) ?? "pending") != "pending",
          onPressed: isUploading
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (_) => AppModal(
                      title: "Submit employer documents?",
                      confirmBackground: AppColor.primary,
                      confirmForeground: AppColor.light,
                      onConfirm: () async {
                        Navigator.pop(context);
                        await submitEmployerDocuments();
                      },
                    ),
                  );
                },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.claims["role"];
    final status = verification?["status"] ?? "pending";

    return Scaffold(
      appBar: AppNavigationBar(
        title: "Employer Submitted Documents",
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
      ),
      endDrawer: const OffcanvasNavigation(),
      body: loading
          ? const Center(child: Loader())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // EMPLOYER NAME
                  if (verification?["full_name"] != null)
                    Text(
                      "Employer: ${verification!["full_name"]}",
                      style: AppText.fontBold.merge(AppText.textLg),
                    ),

                  const SizedBox(height: 8),

                  // DATE SUBMITTED
                  if (verification?["created_at"] != null)
                    Text(
                      "Submitted: ${formatDateOnly(verification!["created_at"])}",
                      style: AppText.textMuted.merge(AppText.textSm),
                    ),

                  const SizedBox(height: 12),

                  // STATUS BADGE
                  buildStatusBadge(status),

                  const SizedBox(height: 10),

                  // rejected reason
                  if (status == "rejected") ...[
                    Text("Reason:", style: AppText.fontSemibold),
                    Text(verification?["note"] ?? "Reason not specified."),
                    const SizedBox(height: 10),
                  ],

                  // -------------------------
                  // EMPLOYER ACTIONS
                  // -------------------------
                  if (role == "employer") ...[
                    const SizedBox(height: 10),
                    // toggle editing
                    AppButton(
                      label: editing ? "Cancel Editing" : "Edit / Upload Documents",
                      backgroundColor: editing ? AppColor.warning : AppColor.primary,
                      foregroundColor: editing ? AppColor.dark : AppColor.light,
                      visualDensityY: -2,
                      onPressed: () {
                        setState(() => editing = !editing);
                      },
                    ),
                    const SizedBox(height: 16),

                    if (editing) buildEmployerEditSection(),

                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 20),

                  // DOCUMENT LIST (always show existing list)
                  Text("Uploaded Documents", style: AppText.fontBold.merge(AppText.textLg)),
                  const SizedBox(height: 12),

                  ...documentMap.entries.map((entry) {
                    final label = entry.key;
                    final field = entry.value;

                    // If no verification yet, show empty
                    if (verification == null) {
                      return buildDocumentTile(label, null);
                    }

                    final rawPath = verification?[field];
                    final url = (rawPath == null || rawPath.toString().isEmpty)
                        ? null
                        : '$BASE_URL/$rawPath';

                    return buildDocumentTile(label, url);
                  }),

                  const SizedBox(height: 30),

                  // -------------------------
                  // ADMIN ACTIONS (pending only)
                  // -------------------------
                  if (widget.claims["role"] == "admin" && status == "pending" && verification != null) ...[
                    AppButton(
                      label: approving ? "Approving..." : "Approve",
                      backgroundColor: AppColor.success,
                      onPressed: approving ? null : () => approveDocument(verification!['id']),
                      visualDensityY: -2,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: rejecting ? "Rejecting..." : "Reject",
                      backgroundColor: AppColor.danger,
                      onPressed: rejecting ? null : () => rejectDocument(verification!['id']),
                      visualDensityY: -2,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
