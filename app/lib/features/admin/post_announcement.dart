import 'package:app/core/components/button.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/announcement_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/admin.dart';
import 'package:flutter/material.dart';

class PostAnnouncement extends StatelessWidget {
  const PostAnnouncement({ 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              PostAnnouncementForm()
            ],
          ),
        ),
      )
    );
  }
}

class PostAnnouncementForm extends StatefulWidget {

  const PostAnnouncementForm({super.key});

  @override
  State<PostAnnouncementForm> createState() => _PostAnnouncementFormState();
}
class _PostAnnouncementFormState extends State<PostAnnouncementForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  String? _targetAudience;

  List<String> audiences = ['All', 'Job Seeker', 'Employer'];

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final titleVal = _title.text.trim();
      final contentVal = _content.text.trim();
      final targetAudienceVal = _targetAudience;
      final Map<String, dynamic> announcement = {
        "title": titleVal,
        "content": contentVal,
        "audience": targetAudienceVal!.toLowerCase().replaceAll(' ', '_')
      };
      try {
        final res = await AnnouncementService.createAnnouncement(announcement);

        if (res.isNotEmpty) {
          if (!mounted) return;
          AppSnackbar.show(
            context, 
            message: 'Announcement uploaded successfully',
            backgroundColor: AppColor.success
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
          );
        }
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.show(
          context, 
          message: '$e',
          backgroundColor: AppColor.danger
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text('📢 Post New Announcement', style: AppText.textXl.merge(AppText.fontSemibold)),
          ),
          AppTextField(
            controller: _title, 
            label: 'Title',
          ),
          const SizedBox(height: 10),
          AppTextField(
            controller: _content, 
            label: 'Content',
            maxLine: 5,
          ),
          const SizedBox(height: 10),
          AppDropdownSelect(
            items: audiences, 
            label: 'Target Audience', 
            initialValue: _targetAudience, 
            placeholder: 'Select Audience', 
            onChanged: (value) { 
              setState(() { 
                _targetAudience = value; 
              }); 
            }
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              AppButton(
                label: 'Post', 
                onPressed: () => _submitForm(),
                visualDensityY: -2,
                backgroundColor: AppColor.success,
              ),
              const SizedBox(width: 5),
              AppButton(
                label: 'Back',
                onPressed: () => Navigator.pop(context),
                visualDensityY: -2,
                backgroundColor: AppColor.secondary,
              )
            ],
          )
        ],
      )
    );
  }
}