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
final List<String> educationLevels = [
  "No grade completed",
  "Elementary Level",
  "Elementary Graduate",
  "Junior High School Level",
  "Junior High School Graduate",
  "Senior High School Level",
  "Senior High School Graduate",
  "High School Level (Non K-12)",
  "High School Graduate (Non K-12)",
  "Alternative Learning System",
  "Vocational Level",
  "College Level",
  "College Graduate",
  "Some Masteral Units",
  "Master's Degree Holder",
  "Some Doctorate Units",
];

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
  bool _isSubmitting = false;
  int? employerId;

  final TextEditingController _jobTitle = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _citmun = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String? _requiredEduc;
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
    if (_isSubmitting) return; // ⛔ prevent double tap

    setState(() {
      _isSubmitting = true;
    });

    loadUser();

    if (_formKey.currentState!.validate()) {
      try {
        final res = await JobService.createJob({
          "title": _jobTitle.text.trim(),
          "company": _company.text.trim(),
          "location": _location.text.trim(),
          "salary": _salary.text.trim(),
          "type": _jobType,
          "description": _description.text.trim(),
          "employerId": employerId,
          "citmun": _citmun.text.trim(),
          "required_education": _requiredEduc,
        });

        if (res.isNotEmpty) {
          await JobService.createJobSkill(res['id'], selectedSkills);

          if (!mounted) return;
          AppSnackbar.show(
            context,
            message: 'Job ${_jobTitle.text} created successfully!',
            backgroundColor: AppColor.success,
          );

          navigateTo(context, const EmployerDashboard());
        }
      } catch (e) {
        if (!mounted) return;
        AppSnackbar.show(context, message: '$e');
      }
    }

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
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
          const Text('Required Education'),
          const SizedBox(height: 5),
          AppSelect<String>(
            items: educationLevels,
            value: _requiredEduc,
            getLabel: (item) => item,
            borderColor: AppColor.muted,
            visualDensityY: 0,
            onChanged: (value) {
              setState(() {
                _requiredEduc = value;
              });
            },
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
                isDisabled: _isSubmitting,
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

