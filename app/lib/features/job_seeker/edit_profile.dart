import 'package:app/core/components/button.dart';
import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/hooks/use_claims.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/features/job_seeker/profile/credentials.dart';
import 'package:app/features/job_seeker/profile/educational_background.dart';
import 'package:app/features/job_seeker/profile/eligibility.dart';
import 'package:app/features/job_seeker/profile/job_reference.dart';
import 'package:app/features/job_seeker/profile/language_profeciency.dart';
import 'package:app/features/job_seeker/profile/other_skills.dart';
import 'package:app/features/job_seeker/profile/personal_information.dart';
import 'package:app/features/job_seeker/profile/tech_voc_trainings.dart';
import 'package:app/features/job_seeker/profile/work_experience.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const profileSections = [
  'Credentials',
  'Personal Information',
  'Job Reference',
  'Language Profeciency',
  'Educational Background',
  'TechVoc and Other Trainings',
  'Eligibility',
  'Work Experience',
  'Other Skills'
];

class EditProfile extends HookWidget {
  final Map<String, dynamic>? employerClaim;

  const EditProfile({
    super.key,
    this.employerClaim,
  });

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final activeClaim = employerClaim ?? claims; 

    final open = useState(false);
    final section = useState('Credentials');

    void setOpen() {
      open.value = !open.value;
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
        child: Column(
          children: [
            // ✅ Horizontal buttons for each section
            Scrollbar(
              thumbVisibility: true, // Makes scrollbar always visible
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: profileSections.map((item) {
                    return AppButton(
                      label: item,
                      onPressed: () => section.value = item,
                      backgroundColor: section.value == item
                          ? AppColor.primary
                          : const Color.fromARGB(255, 197, 216, 252),
                      foregroundColor: section.value == item
                          ? AppColor.light
                          : AppColor.secondary,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      visualDensityY: -2,
                      borderRadius: 0,
                    );
                  }).toList(),
                ),
              ),
            ),

            // ✅ Conditional sections
            if (section.value == 'Credentials')
              Credentials(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              )
            else if (section.value == 'Personal Information')
              PersonalInformation(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              )
            else if (section.value == 'Job Reference')
              JobReference(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              )
            else if (section.value == 'Language Profeciency')
              LanguageProfeciency(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              )
            else if (section.value == 'Educational Background')
              EducationalBackround(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              )
            else if (section.value == 'TechVoc and Other Trainings')
              TechVocTrainings(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              )
            else if (section.value == 'Eligibility')
              Eligibility(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              )
            else if (section.value == 'Work Experience')
              WorkExperience(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              )
            else
              OtherSkills(
                claims: activeClaim,
                open: open.value,
                setOpen: setOpen,
              ),
          ],
        ),
      ),
    );
  }
}
