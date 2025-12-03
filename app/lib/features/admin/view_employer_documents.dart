import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/loader.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/modal.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/_endpoint.dart';
import 'package:app/core/services/verification_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ViewEmployerDocuments extends StatefulWidget {
  final int employerId;

  const ViewEmployerDocuments({
    super.key,
    required this.employerId,
  });

  @override
  State<ViewEmployerDocuments> createState() =>
      _ViewEmployerDocumentsState();
}

class _ViewEmployerDocumentsState extends State<ViewEmployerDocuments> {
  Map<String, dynamic>? verification;
  bool loading = true;
  bool approving = false;
  bool rejecting = false;

  // Document mappings
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
    final data = await VerificationService.getVerificationByUser(widget.employerId);

    if (mounted) {
      setState(() {
        verification = data;
        loading = false;
      });
    }
  }

  void openDocument(String? url) {
    if (url == null || url.isEmpty) return;

    final ext = url.split('.').last.toLowerCase();

    String finalUrl = url;
    if (ext == "pdf") {
      finalUrl = "https://docs.google.com/viewer?url=$url&embedded=true";
    }

    // Use Google Docs Viewer for office files
    if (['doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'].contains(ext)) {
      finalUrl = "https://docs.google.com/viewer?url=$url&embedded=true";
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


  // STATUS BADGE
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
          Navigator.pop(context); // Close modal
          setState(() => approving = true);

          try {
            final data = await VerificationService.updateVerificationStatus(
              id,
              "approved",
            );

            // ✔ SUCCESS
            if (data.isNotEmpty) {
              if (!mounted) return;
              AppSnackbar.show(
                context,
                message: "Employer verification approved successfully!",
                backgroundColor: AppColor.success,
              );
            } 
            // ❌ FAIL (backend returned no success)
            else {
              if (!mounted) return;
              AppSnackbar.show(
                context,
                message: "Something went wrong. Please try again.",
                backgroundColor: AppColor.danger,
              );
            }
          } catch (e) {
            // ❌ EXCEPTION / ERROR
            if (!mounted) return;
            AppSnackbar.show(
              context,
              message: "Error approving verification: $e",
              backgroundColor: AppColor.danger,
            );
          } finally {
            setState(() => approving = false);
            if (mounted) await loadDocuments();
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
        message: "Are you sure you want to reject this employer’s documents?",
        confirmLabel: "Reject",
        confirmBackground: AppColor.danger,
        confirmForeground: AppColor.light,
        onConfirm: () async {
          Navigator.pop(context); // Close modal
          setState(() => rejecting = true);

          try {
            final data = await VerificationService.updateVerificationStatus(
              id,
              "rejected",
            );

            // ✔ SUCCESS
            if (data.isNotEmpty) {
              if (!mounted) return;
              AppSnackbar.show(
                context,
                message: "Employer verification rejected successfully!",
                backgroundColor: AppColor.danger,
              );
            } 
            // ❌ FAIL BACKEND RESPONSE
            else {
              if (!mounted) return;
              AppSnackbar.show(
                context,
                message: "Something went wrong. Please try again.",
                backgroundColor: AppColor.danger,
              );
            }
          } catch (e) {
            // ❌ ERROR / EXCEPTION
            if (!mounted) return;
            AppSnackbar.show(
              context,
              message: "Error rejecting verification: $e",
              backgroundColor: AppColor.danger,
            );
          } finally {
            setState(() => rejecting = false);
            if (mounted) await loadDocuments();
          }
        },
      ),
    );
  }

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
            color: hasFile ? AppColor.success : AppColor.secondary,   // ⭐ dynamic color
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.fontBold.merge(AppText.textMd)),
                const SizedBox(height: 4),
                Text(
                  hasFile
                      ? "Tap to view document"
                      : "No document uploaded",
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

  
  @override
  Widget build(BuildContext context) {
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
                      "Submitted: ${verification!["created_at"]}",
                      style: AppText.textMuted.merge(AppText.textSm),
                    ),

                  const SizedBox(height: 12),

                  // STATUS BADGE
                  buildStatusBadge(verification?["status"] ?? "pending"),

                  const SizedBox(height: 20),

                  // DOCUMENT LIST
                  ...documentMap.entries.map((entry) {
                    final label = entry.key;
                    final field = entry.value;
                    final url = '$BASE_URL/${verification?[field]}';
                    return buildDocumentTile(label, url);
                  }),

                  const SizedBox(height: 30),

                  // ACTION BUTTONS
                  if (verification?["status"] == "pending") ...[
                    AppButton(
                      label: approving ? "Approving..." : "Approve",
                      backgroundColor: AppColor.success,
                      onPressed: approving || verification == null
                        ? null
                        : () => approveDocument(verification!['id']),
                      visualDensityY: -2,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: rejecting ? "Rejecting..." : "Reject",
                      backgroundColor: AppColor.danger,
                      onPressed: rejecting || verification == null
                        ? null
                        : () => rejectDocument(verification!['id']),
                      visualDensityY: -2,
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
