import fs from "fs";
import path from "path";
import PDFDocument from "pdfkit";

export function generateResumePDF(resume, userId, res) {
    const outputDir = path.join(
        process.cwd(),
        "uploads",
        "job-seeker-resume"
    );

    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    const filePath = path.join(
        outputDir,
        `${userId}_resume.pdf`
    );

    const doc = new PDFDocument({ margin: 50 });

    /* ================= HEADERS ================= */
    res.setHeader("Content-Type", "application/pdf");
    res.setHeader(
        "Content-Disposition",
        `attachment; filename="${resume.credentials.full_name}_Resume.pdf"`
    );

    /* ================= STREAMS ================= */
    const fileStream = fs.createWriteStream(filePath);

    doc.pipe(fileStream); // ✅ SAVE TO FILE
    doc.pipe(res);        // ✅ STREAM TO CLIENT

    /* ================= HEADER ================= */
    doc
        .fontSize(22)
        .font("Helvetica-Bold")
        .text(`${resume.personal_information.first_name} ${resume.personal_information.middle_name} ${resume.personal_information.surname}`, { align: "center" });

    doc
        .moveDown(0.5)
        .fontSize(11)
        .font("Helvetica")
        .text(
            `${resume.credentials.email} | ${resume.credentials.contact}`,
            { align: "center" }
        );

    doc
        .fontSize(10)
        .text(resume.personal_information.present_address, { align: "center" });

    doc.moveDown(1.5);

    /* ================= PERSONAL INFORMATION ================= */
    sectionTitle(doc, "PERSONAL INFORMATION");

    keyValue(doc, "Date of Birth", formatDate(resume.personal_information.date_of_birth));
    keyValue(doc, "Sex", resume.personal_information.sex);
    keyValue(doc, "Civil Status", resume.personal_information.civil_status);
    keyValue(doc, "Employment Status", resume.personal_information.employment_status);

    doc.moveDown();

    /* ================= JOB PREFERENCE ================= */
    sectionTitle(doc, "JOB PREFERENCE");

    bullet(doc, resume.job_reference.occupation1);
    bullet(doc, resume.job_reference.occupation2);
    bullet(doc, resume.job_reference.occupation3);

    doc.moveDown(0.5);
    doc.font("Helvetica-Bold").text("Preferred Locations:");
    doc.font("Helvetica");
    bullet(doc, resume.job_reference.location1);
    bullet(doc, resume.job_reference.location2);
    bullet(doc, resume.job_reference.location3);

    doc.moveDown();

    /* ================= EDUCATION ================= */
    sectionTitle(doc, "EDUCATIONAL BACKGROUND");

    doc.text(
        `Highest Education Attained: ${resume.educational_background.highest_education}`
    );

    doc.moveDown();

    /* ================= TRAININGS ================= */
    sectionTitle(doc, "TECHNICAL / VOCATIONAL TRAINING");

    resume.tech_voc.forEach(t => {
        if (t.course) bullet(doc, t.course);
    });

    if (resume.tech_voc.every(t => !t.course)) {
        doc.text("— None —");
    }

    doc.moveDown();

    /* ================= WORK EXPERIENCE ================= */
    sectionTitle(doc, "WORK EXPERIENCE");

    if (resume.work_experience.some(w => w.company_name)) {
        resume.work_experience.forEach(w => {
            if (!w.company_name) return;

            doc.font("Helvetica-Bold").text(w.company_name);
            doc.font("Helvetica").text(`${w.position} | ${w.no_of_month} months`);
            doc.moveDown(0.5);
        });
    } else {
        doc.text("— No work experience —");
    }

    doc.moveDown();

    /* ================= SKILLS ================= */
    sectionTitle(doc, "SKILLS");

    resume.other_skills.forEach(s => bullet(doc, s.skill));

    doc.moveDown();

    /* ================= LANGUAGES ================= */
    sectionTitle(doc, "LANGUAGE PROFICIENCY");

    resume.language_proficiency.forEach(lang => {
        doc.text(`• ${lang.language}`);
    });

    doc.moveDown();

    /* ================= FOOTER ================= */
    doc
        .fontSize(9)
        .fillColor("gray")
        .text(
            "I hereby certify that the above information is true and correct.",
            { align: "center" }
        );

    doc.end(); // ✅ FINALIZE PDF
}

/* ================= HELPER FUNCTIONS ================= */

function sectionTitle(doc, title) {
    doc
        .fontSize(13)
        .font("Helvetica-Bold")
        .text(title);
    doc
        .moveDown(0.3)
        .moveTo(50, doc.y)
        .lineTo(550, doc.y)
        .stroke();
    doc.moveDown(0.5);
}

function keyValue(doc, key, value) {
    if (!value) return;
    doc.font("Helvetica-Bold").text(`${key}: `, { continued: true });
    doc.font("Helvetica").text(value);
}

function bullet(doc, text) {
    if (!text) return;
    doc.text(`• ${text}`);
}

function formatDate(date) {
    if (!date) return "";
    return new Date(date).toLocaleDateString("en-PH", {
        year: "numeric",
        month: "long",
        day: "numeric",
    });
}
