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

const profileSections = ['Credentials', 'Personal Information', 'Job Reference', 'Language Profeciency', 'Educational Background', 'TechVoc and Other Trainings', 'Eligibility', 'Work Experience', 'Other Skills'];

class EditProfile extends HookWidget {

  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final claims = useClaimsHook(context);
    final open = useState(false);
    final section = useState('Credentials');

    void setOpen() {
      open.value = !open.value;
    }
    
    return Scaffold(
      appBar: AppNavigationBar(title: 'Mendez PESO Job Portal', onMenuPressed: (context) { Scaffold.of(context).openDrawer(); }),
      endDrawer: const OffcanvasNavigation(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: profileSections.map((item) {
                  return AppButton(
                    label: item, 
                    onPressed: () { section.value = item; },
                    backgroundColor: section.value == item ? AppColor.primary : const Color.fromARGB(255, 197, 216, 252),
                    foregroundColor: section.value == item ? AppColor.light : AppColor.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    visualDensityY: -2,
                    borderRadius: 0,
                  );
                }).toList(),
              ),
            ),
            section.value == 'Credentials'
              ? Credentials(
                claims: claims,
                open: open.value,
                setOpen: setOpen,
              ) :
            section.value == 'Personal Information'
              ? PersonalInformation(
                claims: claims, 
                open: open.value, 
                setOpen: setOpen
              ) :
            section.value == 'Job Reference' 
              ? JobReference(
                claims: claims, 
                open: open.value, 
                setOpen: setOpen
              ) :
            section.value == 'Language Profeciency' 
              ? LanguageProfeciency(
                claims: claims, 
                open: open.value, 
                setOpen: setOpen
              )  : 
            section.value == 'Educational Background' 
              ? EducationalBackround(
                claims: claims, 
                open: open.value, 
                setOpen: setOpen
              ) :
            section.value == 'TechVoc and Other Trainings' 
              ? TechVocTrainings(
                claims: claims, 
                open: open.value, 
                setOpen: setOpen
              ) : 
            section.value == 'Work Experience' 
              ? WorkExperience(
                claims: claims, 
                open: open.value, 
                setOpen: setOpen
              ) : 
            section.value == 'Eligibility' 
              ? Eligibility(
                claims: claims, 
                open: open.value, 
                setOpen: setOpen
              ) : OtherSkills(
                claims: claims, 
                open: open.value, 
                setOpen: setOpen
              )

          ],
        ),
      ),
    );
  }
}

