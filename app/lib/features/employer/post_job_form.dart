import 'package:app/core/components/badge.dart';
import 'package:app/core/components/button.dart';
import 'package:app/core/components/footer.dart';
import 'package:app/core/components/input.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/components/select.dart';
import 'package:app/core/components/snackbar.dart';
import 'package:app/core/services/auth_service.dart';
import 'package:app/core/services/job_service.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:app/features/dashboard/employer.dart';
import 'package:flutter/material.dart';

const caviteLocations = ["Alfonso","Amadeo","Bacoor City","Carmona","Cavite City","Cavite Province","City of General Trias","Dasmariñas City","General Emilio Aguinaldo","General Mariano Alvarez","Imus City","Indang","Kawit","Magallanes","Maragondon","Mendez","Naic","Noveleta","Rosario","Silang","Tagaytay City","Tanza","Ternate","Trece Martires City"];

class PostNewJob extends StatelessWidget {
  const PostNewJob({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: PostNewJobForm(),
            ),
            Footer()
          ],
        ),
      ),
    );
  }
}

class PostNewJobForm extends StatefulWidget {
  const PostNewJobForm({super.key});

  @override
  State<PostNewJobForm> createState() => _PostNewJobFormState();
}

class _PostNewJobFormState extends State<PostNewJobForm>  {
  final _formKey = GlobalKey<FormState>();
  int? employerId;

  final TextEditingController _jobTitle = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _citmun = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  String? _jobType;
  String? _selectedCitmun;

  List<String> types = ['Full-Time', 'Part-Time'];
  List<String> skills = [
    'Auto Mechnanic', 'Beautician', 'Carpentry Work',  'Computer Literate', 'Domestic Chores', 'Driver',
    'Electrician', 'Embroidery', 'Gardening', 'Masonry', 'Painter/Artist', 'Painting Jobs',
    'Photography', 'Plumbing', 'Sewing Dresses', 'Stenography', 'Tailoring'
  ];
  List<String> selectedSkills = [];

  @override
  void initState() {
    super.initState();
    loadUser();

    _selectedCitmun = "Mendez";
    _citmun.text = "Mendez";
  }

  void loadUser() async {
    final data = await AuthService.getClaims();
    setState(() {
      employerId = data['id'];
    });
  }

  @override
  void dispose() {
    _jobTitle.dispose();
    _company.dispose();
    _location.dispose();
    _salary.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    loadUser();
    if (_formKey.currentState!.validate()) {
      final jobTitleValue = _jobTitle.text.trim();
      final companyValue = _company.text.trim();
      final locationValue = _location.text.trim();
      final descriptionValue = _description.text.trim();
      final salaryValue = _salary.text.trim();
      final jobTypeValue = _jobType;
      final citmunValue = _citmun.text.trim();

      try {
        final res = await JobService.createJob({
          "title": jobTitleValue,
          "company": companyValue,
          "location": locationValue,
          "salary": salaryValue,
          "type": jobTypeValue,
          "description": descriptionValue,
          "employerId": employerId,
          "citmun": citmunValue,
        });

        if (res.isNotEmpty) {
          await JobService.createJobSkill(res['id'], selectedSkills);
          
          if (!mounted) return;
          AppSnackbar.show(
            context,
            message: 'Job $jobTitleValue created successfully!',
            backgroundColor: AppColor.success
          );
          navigateTo(context, const EmployerDashboard());
        }
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.show(
          context, 
          message: '$e'
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
          Text(
            'Publish a Job',
            style: AppText.textXl.merge(AppText.fontSemibold),
          ),
          const Divider(thickness: 1, height: 16),
          const SizedBox(height: 10),
          const Text('Job Title'),
          const SizedBox(height: 5),
          AppInputField(
            label: '',
            controller: _jobTitle,
            required: true,  
            textSize: 16,
            visualDensityY: 0,
            validatorMessage: "Please enter title of the job",
          ),
          const SizedBox(height: 10),
          const Text('Company'),
          const SizedBox(height: 5),
          AppInputField(
            label: '',
            controller: _company,
            required: true,  
            textSize: 16,
            visualDensityY: 0,
            validatorMessage: "This field is required.",
          ),
          const SizedBox(height: 10),
          const Text('Job Location'),
          const SizedBox(height: 5),
          AppInputField(
            label: '',
            controller: _location,
            required: true,  
            textSize: 16,
            visualDensityY: 0,
            validatorMessage: "This field is required.",
          ),
          const SizedBox(height: 10),
          Text('City/Municipality', textAlign: TextAlign.start, style: AppText.textSm),
          const SizedBox(height: 5.0),
          AppSelect<String>(
            items: caviteLocations,
            value: _selectedCitmun,
            getLabel: (item) => item,
            visualDensityY: 2,
            textSize: 16,
            required: true,
            borderColor: AppColor.muted,
            onChanged: (value) {
              setState(() {
                _selectedCitmun = value;
                _citmun.text = value ?? "";
              });
            },
          ),
          const SizedBox(height: 10),
          Text('Job Type', textAlign: TextAlign.start, style: AppText.textSm),
          const SizedBox(height: 5.0),
          AppSelect<String>(
            items: types,
            value: _jobType,
            getLabel: (item) => item,
            visualDensityY: 2,
            textSize: 16,
            borderColor: AppColor.muted,
            required: true,
            onChanged: (value) {
              setState(() {
                _jobType = value;
              });
            },
          ),
          const SizedBox(height: 10),
          const Text('Salary/Compensation'),
          const SizedBox(height: 5),
          AppInputField(
            label: 'specify in Philippine Peso',
            controller: _salary,
            required: true,  
            textSize: 16,
            visualDensityY: 0,
            numericOnly: true,
            validatorMessage: "This field is required.",
          ),
          const SizedBox(height: 10),
          const Text('Job Description'),
          const SizedBox(height: 5),
          AppInputField(
            label: '',
            controller: _description,
            textSize: 16,
            visualDensityY: 0,
            maxLine: 4,
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Required Skills for the Job:'),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedSkills.isEmpty)
                    Center(
                      child: Text(
                        "No selected skill for the job.",
                        style: AppText.textMuted,
                      ),
                    ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final double itemWidth = (constraints.maxWidth - 8) / 2;

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(selectedSkills.length, (index) {
                          final skill = selectedSkills[index];

                          return SizedBox(
                            width: itemWidth,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSkills.removeAt(index);
                                });
                              },
                              child: AppBadge(
                                text: skill,
                                backgroundColor: AppColor.primary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                isCenter: true,
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppSelect(
            placeholder: "Select a skill",
            items: skills,
            visualDensityY: 1,
            textSize: 16,
            borderColor: AppColor.muted,
            onChanged: (value) {
              if (value != null && !selectedSkills.contains(value)) {
                setState(() {
                  selectedSkills.add(value);

                });
              }
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              AppButton(
                label: '🚀 Post Job', 
                onPressed: () => _submitForm(),
                backgroundColor: AppColor.success,
                visualDensityY: -2,
              ),
              const SizedBox(width: 15),
              AppButton(
                label: 'Cancel', 
                onPressed: () => {
                  Navigator.of(context).pop()
                },
                backgroundColor: AppColor.secondary,
                visualDensityY: -2,
              ),
            ],
          )
        ],
      ),
    );
  }
}

