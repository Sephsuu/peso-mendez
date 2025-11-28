import 'package:app/core/components/navigation.dart';
import 'package:app/core/components/offcanvas.dart';
import 'package:app/core/theme/colors.dart';
import 'package:app/core/theme/typography.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavigationBar(
        title: 'About PESO',
        onMenuPressed: (context) => Scaffold.of(context).openDrawer(),
      ),
      endDrawer: const OffcanvasNavigation(),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            _SectionHeader(title: "About Mendez PESO"),
            SizedBox(height: 15),
            AboutPESOSection(),
            SizedBox(height: 30),
            VisionSection(),
            SizedBox(height: 10),
            MissionSection(),
            SizedBox(height: 40),
            ObjectivesSection(),
            SizedBox(height: 40),
            CoreServicesSection(),
            SizedBox(height: 40),
            OrgStructureSection(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'About PESO Mendez',
              style: AppText.textLg.merge(AppText.fontSemibold),
            ),
          ),
          const Divider(thickness: 1, height: 16),
        ],
      ),
    );
  }
}

// =============================
//   ABOUT PESO SECTION
// =============================
class AboutPESOSection extends StatelessWidget {
  const AboutPESOSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("What is PESO?",
              style: AppText.textLg.merge(AppText.fontSemibold)),
          const SizedBox(height: 10),
          const Text(
            "Public Employment Service Office (PESO) is a non-fee charging multi-employment service facility or entity established in LGUs in coordination with the Department of Labor and Employment (DOLE) pursuant to RA 8759 or the PESO Act of 1999 as amended by RA 10691.",
            textAlign: TextAlign.justify,
            style: TextStyle(height: 1.6),
          ),
        ],
      ),
    );
  }
}

// =============================
//   VISION SECTION (with gradient)
// =============================
class VisionSection extends StatelessWidget {
  const VisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4169E1), // Royal Blue
              Color(0xFF0B1D51), // Deep Navy
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vision",
              style: AppText.textLg.merge(AppText.fontBold).merge(AppText.textLight)
            ),
            const SizedBox(height: 10),
            const Text(
              "For PESO to be a service-oriented multi-service facility that ensures reliable and sustainable employment facilitation, leading to higher labor market outcomes and socio-economic development.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                height: 1.6,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================
//   MISSION SECTION (with gradient)
// =============================
class MissionSection extends StatelessWidget {
  const MissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4169E1), // Royal Blue
              Color(0xFF0B1D51), // Deep Navy
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mission",
              style: AppText.textLg.merge(AppText.fontBold).merge(AppText.textLight),
            ),
            const SizedBox(height: 10),
            const Text(
              "To facilitate employment by providing efficient and timely services that address skills, employment, and labor market concerns.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                height: 1.6,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================
//   OBJECTIVES SECTION
// =============================
class ObjectivesSection extends StatelessWidget {
  const ObjectivesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Objectives",
              style: AppText.textLg.merge(AppText.fontSemibold),
            ),
            const SizedBox(height: 12),
            const _ObjectiveItem(
              icon: Icons.people_alt_rounded,
              title: "01",
              description:
                  "Ensure prompt and efficient delivery of employment facilitation services.",
            ),
            const SizedBox(height: 16),
            const _ObjectiveItem(
              icon: Icons.school_rounded,
              title: "02",
              description:
                  "Provide timely information on labor market and DOLE programs",
            ),
          ],
        ),
      ),
    );
  }
}

// =============================
//   OBJECTIVE ITEM (helper widget)
// =============================
class _ObjectiveItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ObjectiveItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4169E1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF4169E1), size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  )),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================
//   CORE SERVICES SECTION
// =============================
class CoreServicesSection extends StatelessWidget {
  const CoreServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4169E1), // Royal Blue
              Color(0xFF1E2A78), // Darker Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Core Services",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            const _ServiceItem(
              icon: Icons.work_rounded,
              title: "Labor Market Information",
              // description:
              //     "Connecting job seekers with employers through efficient employment facilitation and referrals.",
            ),
            const SizedBox(height: 16),
            const _ServiceItem(
              icon: Icons.school_rounded,
              title: "Referral and Placement",
              // description:
              //     "Providing information and counseling to help individuals make informed career and training decisions.",
            ),
            const SizedBox(height: 16),
            const _ServiceItem(
              icon: Icons.business_center_rounded,
              title: "Employment Coaching and Counseling",
              // description:
              //     "Assisting in entrepreneurship and livelihood programs to promote self-sufficiency and employment generation.",
            ),
          ],
        ),
      ),
    );
  }
}

// =============================
//   SERVICE ITEM (helper widget)
// =============================
class _ServiceItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ServiceItem({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================
//   ORGANIZATIONAL STRUCTURE SECTION
// =============================
class OrgStructureSection extends StatelessWidget {
  const OrgStructureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Organizational Structure",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4169E1), // Royal Blue
                  Color(0xFF1E2A78), // Dark Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Icon(Icons.account_circle_rounded,
                    color: Colors.white, size: 60),
                SizedBox(height: 8),
                Text(
                  "Noren A. Perola",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Labor and Employment Officer",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "↓ Staff ↓",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const[
                BoxShadow(
                  blurRadius: 1,
                  offset: Offset(0, 1),
                  color: AppColor.muted
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Color(0xFF4169E1), size: 30),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Janice Quinonece",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Administration Aide IV",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================
//   CONTACT INFORMATION SECTION
// =============================
 