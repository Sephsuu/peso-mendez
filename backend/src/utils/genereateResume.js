import fs from "fs";
import path from "path";
import PDFDocument from "pdfkit";

export function generateResumePDF(resume, userId, res,  photoPath = null) {
    const outputDir = path.join(
        process.cwd(),
        "uploads",
        "job-seeker-resume"
    );

    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    const filePath = path.join(outputDir, `${userId}_resume.pdf`);
    const doc = new PDFDocument({ 
        margin: 40,
        size: 'A4'
    });

    res.setHeader("Content-Type", "application/pdf");
    res.setHeader(
        "Content-Disposition",
        `attachment; filename="${resume.credentials.full_name}_Resume.pdf"`
    );

    const fileStream = fs.createWriteStream(filePath);
    doc.pipe(fileStream);
    doc.pipe(res);

    const LEFT_COL = 40;
    const RIGHT_COL = 320;
    const COL_WIDTH = 240;
    const PAGE_WIDTH = 595;

    const pi = resume.personal_information || {};
    const cred = resume.credentials || {};
    
    const fullName = `${pi.first_name || ''} ${pi.middle_name || ''} ${pi.surname || ''}`.trim() || 
                     cred.full_name || 'Name Not Provided';
    
    if (photoPath && fs.existsSync(photoPath)) {
        try {
            doc.image(photoPath, PAGE_WIDTH - 140, 40, {
                width: 100,
                height: 100,
                fit: [100, 100],
                align: 'center'
            });
        } catch (error) {
            console.error('Error adding photo:', error);
        }
    }
    
    doc
        .fontSize(24)
        .font("Helvetica-Bold")
        .fillColor("#1a1a1a")
        .text(fullName.toUpperCase(), LEFT_COL, 50, { 
            align: "left",
            width: 350 
        });

    doc.moveDown(0.3);

    const contactInfo = [];
    if (cred.email) contactInfo.push(cred.email);
    if (cred.contact) contactInfo.push(cred.contact);
    if (pi.present_address) contactInfo.push(pi.present_address);
    
    doc
        .fontSize(10)
        .font("Helvetica")
        .fillColor("#333333")
        .text(contactInfo.join(" | ") || "Contact information not provided", LEFT_COL, doc.y, { 
            width: 350 
        });

    doc.moveDown(1.5);

    doc
        .moveTo(LEFT_COL, doc.y)
        .lineTo(PAGE_WIDTH - 40, doc.y)
        .lineWidth(2)
        .strokeColor("#808080")
        .stroke();

    doc.moveDown(1);

    let leftY = doc.y;
    let rightY = doc.y;

    doc.y = leftY;
    sectionTitle(doc, "PERSONAL INFORMATION", LEFT_COL, COL_WIDTH);
    
    addLeftItem(doc, "Date of Birth", formatDate(pi.date_of_birth) || "Not specified", LEFT_COL);
    addLeftItem(doc, "Sex", pi.sex || "Not specified", LEFT_COL);
    addLeftItem(doc, "Civil Status", pi.civil_status || "Not specified", LEFT_COL);
    addLeftItem(doc, "Religion", pi.religion || "Not specified", LEFT_COL);
    addLeftItem(doc, "TIN", pi.tin || "Not specified", LEFT_COL);
    if (pi.disability) addLeftItem(doc, "PWD", pi.disability, LEFT_COL);
    
    doc.moveDown(0.5);

    sectionTitle(doc, "EMPLOYMENT STATUS", LEFT_COL, COL_WIDTH);
    addLeftItem(doc, "Current Status", pi.employment_status || "Not specified", LEFT_COL);
    addLeftItem(doc, "Type", pi.employment_type || "Not specified", LEFT_COL);
    if (pi.clientele) addLeftItem(doc, "Clientele", pi.clientele, LEFT_COL);
    addLeftItem(doc, "OFW", pi.is_ofw || "No", LEFT_COL);
    addLeftItem(doc, "Former OFW", pi.is_former_ofw || "No", LEFT_COL);

    doc.moveDown(0.5);

    sectionTitle(doc, "LANGUAGE PROFICIENCY", LEFT_COL, COL_WIDTH);
    
    const languages = resume.language_proficiency || [];
    if (languages.length > 0) {
        languages.forEach(lang => {
            const skills = [];
            if (lang.read) skills.push("Read");
            if (lang.write) skills.push("Write");
            if (lang.speak) skills.push("Speak");
            if (lang.understand) skills.push("Understand");
            
            doc
                .fontSize(10)
                .font("Helvetica-Bold")
                .fillColor("#2c3e50")
                .text(`${lang.language}`, LEFT_COL, doc.y, { width: COL_WIDTH });
            
            doc
                .fontSize(9)
                .font("Helvetica")
                .fillColor("#555555")
                .text(skills.length > 0 ? skills.join(", ") : "Basic knowledge", LEFT_COL, doc.y, { width: COL_WIDTH });
            
            doc.moveDown(0.3);
        });
    } else {
        doc.fontSize(9).font("Helvetica").text("Not specified", LEFT_COL);
    }

    doc.moveDown(0.5);

    sectionTitle(doc, "OTHER SKILLS", LEFT_COL, COL_WIDTH);
    
    const skills = resume.other_skills || [];
    if (skills.length > 0 && skills.some(s => s.skill)) {
        skills.forEach(s => {
            if (s.skill) {
                bulletPoint(doc, s.skill, LEFT_COL, COL_WIDTH);
            }
        });
    } else {
        doc.fontSize(9).font("Helvetica").text("Not specified", LEFT_COL);
    }

    doc.moveDown(0.5);

    const eligibility = resume.eligibility || [];
    if (eligibility.some(e => e.eligibility)) {
        sectionTitle(doc, "ELIGIBILITY", LEFT_COL, COL_WIDTH);
        eligibility.forEach(e => {
            if (e.eligibility) {
                bulletPoint(doc, `${e.eligibility} (${formatDate(e.date_taken) || 'Date not specified'})`, LEFT_COL, COL_WIDTH);
            }
        });
        doc.moveDown(0.5);
    }

    const licenses = resume.professional_license || [];
    if (licenses.some(l => l.license)) {
        sectionTitle(doc, "PROFESSIONAL LICENSES", LEFT_COL, COL_WIDTH);
        licenses.forEach(l => {
            if (l.license) {
                bulletPoint(doc, `${l.license} (Valid until: ${formatDate(l.valid_until) || 'Not specified'})`, LEFT_COL, COL_WIDTH);
            }
        });
    }

    leftY = doc.y;

    /* ================= RIGHT COLUMN ================= */

    doc.y = rightY;

    const jobRef = resume.job_reference || {};
    sectionTitle(doc, "JOB PREFERENCE", RIGHT_COL, COL_WIDTH);
    
    addRightItem(doc, "Occupation Type", jobRef.occupation_type || "Not specified", RIGHT_COL);
    
    doc.moveDown(0.2);
    doc.fontSize(9).font("Helvetica-Bold").fillColor("#2c3e50").text("Preferred Occupations:", RIGHT_COL);
    const occupations = [jobRef.occupation1, jobRef.occupation2, jobRef.occupation3].filter(Boolean);
    if (occupations.length > 0) {
        occupations.forEach(occ => bulletPoint(doc, occ, RIGHT_COL, COL_WIDTH));
    } else {
        doc.fontSize(9).font("Helvetica").text("Not specified", RIGHT_COL);
    }

    doc.moveDown(0.2);
    doc.fontSize(9).font("Helvetica-Bold").fillColor("#2c3e50").text("Preferred Locations:", RIGHT_COL);
    addRightItem(doc, "Location Type", jobRef.location_type || "Not specified", RIGHT_COL);
    const locations = [jobRef.location1, jobRef.location2, jobRef.location3].filter(Boolean);
    if (locations.length > 0) {
        locations.forEach(loc => bulletPoint(doc, loc, RIGHT_COL, COL_WIDTH));
    } else {
        doc.fontSize(9).font("Helvetica").text("Not specified", RIGHT_COL);
    }

    doc.moveDown(0.5);

    const edu = resume.educational_background || {};
    sectionTitle(doc, "EDUCATIONAL BACKGROUND", RIGHT_COL, COL_WIDTH);
    
    addRightItem(doc, "Highest Education", edu.highest_education || "Not specified", RIGHT_COL);
    doc.moveDown(0.2);

    if (edu.elem_year_grad || edu.elem_level_reached) {
        doc.fontSize(9).font("Helvetica-Bold").fillColor("#2c3e50").text("Elementary", RIGHT_COL);
        if (edu.elem_year_grad) {
            doc.fontSize(9).font("Helvetica").text(`Graduated: ${edu.elem_year_grad}`, RIGHT_COL);
        } else if (edu.elem_level_reached) {
            doc.fontSize(9).font("Helvetica").text(`Level Reached: Grade ${edu.elem_level_reached}`, RIGHT_COL);
        }
        doc.moveDown(0.2);
    }

    if (edu.seco_year_grad || edu.seco_level_reached) {
        doc.fontSize(9).font("Helvetica-Bold").fillColor("#2c3e50").text("Secondary", RIGHT_COL);
        if (edu.shs_strand) doc.fontSize(9).font("Helvetica").text(`Strand: ${edu.shs_strand}`, RIGHT_COL);
        if (edu.seco_year_grad) {
            doc.fontSize(9).font("Helvetica").text(`Graduated: ${edu.seco_year_grad}`, RIGHT_COL);
        } else if (edu.seco_level_reached) {
            doc.fontSize(9).font("Helvetica").text(`Level Reached: Grade ${edu.seco_level_reached}`, RIGHT_COL);
        }
        doc.moveDown(0.2);
    }

    if (edu.ter_course || edu.ter_year_grad) {
        doc.fontSize(9).font("Helvetica-Bold").fillColor("#2c3e50").text("Tertiary", RIGHT_COL);
        if (edu.ter_course) doc.fontSize(9).font("Helvetica").text(edu.ter_course, RIGHT_COL);
        if (edu.ter_year_grad) {
            doc.fontSize(9).font("Helvetica").text(`Graduated: ${edu.ter_year_grad}`, RIGHT_COL);
        } else if (edu.ter_level_reached) {
            doc.fontSize(9).font("Helvetica").text(`Level Reached: ${edu.ter_level_reached}`, RIGHT_COL);
        }
        doc.moveDown(0.2);
    }

    if (edu.gs_course || edu.gs_year_grad) {
        doc.fontSize(9).font("Helvetica-Bold").fillColor("#2c3e50").text("Graduate Studies", RIGHT_COL);
        if (edu.gs_course) doc.fontSize(9).font("Helvetica").text(edu.gs_course, RIGHT_COL);
        if (edu.gs_year_grad) doc.fontSize(9).font("Helvetica").text(`Graduated: ${edu.gs_year_grad}`, RIGHT_COL);
    }

    doc.moveDown(0.5);

    const techVoc = resume.tech_voc || [];
    sectionTitle(doc, "TECHNICAL/VOCATIONAL TRAINING", RIGHT_COL, COL_WIDTH);
    
    if (techVoc.length > 0 && techVoc.some(t => t.course)) {
        techVoc.forEach(t => {
            if (t.course && t.course !== 'TechVoc Trainings Sample') {
                doc.fontSize(9).font("Helvetica-Bold").fillColor("#2c3e50").text(t.course, RIGHT_COL);
                if (t.institution) doc.fontSize(8).font("Helvetica").text(`Institution: ${t.institution}`, RIGHT_COL);
                if (t.hours_training) doc.fontSize(8).font("Helvetica").text(`Duration: ${t.hours_training}`, RIGHT_COL);
                if (t.skills_acquired) doc.fontSize(8).font("Helvetica").text(`Skills: ${t.skills_acquired}`, RIGHT_COL);
                if (t.cert_received) doc.fontSize(8).font("Helvetica").text(`Certificate: ${t.cert_received}`, RIGHT_COL);
                doc.moveDown(0.3);
            }
        });
    } else {
        doc.fontSize(9).font("Helvetica").text("No formal training specified", RIGHT_COL);
    }

    doc.moveDown(0.5);

    const workExp = resume.work_experience || [];
    sectionTitle(doc, "WORK EXPERIENCE", RIGHT_COL, COL_WIDTH);
    
    if (workExp.length > 0 && workExp.some(w => w.company_name)) {
        workExp.forEach(w => {
            if (w.company_name) {
                doc.fontSize(10).font("Helvetica-Bold").fillColor("#2c3e50").text(w.position || "Position not specified", RIGHT_COL);
                doc.fontSize(9).font("Helvetica-Oblique").fillColor("#555555").text(w.company_name, RIGHT_COL);
                if (w.address) doc.fontSize(8).font("Helvetica").text(w.address, RIGHT_COL);
                
                const duration = w.no_of_month ? `${w.no_of_month} month${w.no_of_month > 1 ? 's' : ''}` : 'Duration not specified';
                const status = w.status ? ` | Status: ${w.status}` : '';
                doc.fontSize(8).font("Helvetica").text(duration + status, RIGHT_COL);
                doc.moveDown(0.4);
            }
        });
    } else {
        doc.fontSize(9).font("Helvetica").text("No work experience specified", RIGHT_COL);
    }

    rightY = doc.y;

    const finalY = Math.max(leftY, rightY) + 20;
    doc.y = finalY;

    doc
        .moveTo(LEFT_COL, doc.y)
        .lineTo(PAGE_WIDTH - 40, doc.y)
        .lineWidth(1)
        .strokeColor("#808080")
        .stroke();

    doc.moveDown(0.5);

    doc
        .fontSize(8)
        .font("Helvetica-Oblique")
        .fillColor("#666666")
        .text(
            "I hereby certify that the above information is true and correct to the best of my knowledge.",
            { align: "center" }
        );

    doc.end();
}

/* ================= HELPER FUNCTIONS ================= */

function sectionTitle(doc, title, x, width) {
    doc
        .fontSize(11)
        .font("Helvetica-Bold")
        .fillColor("#2c3e50")
        .text(title.toUpperCase(), x, doc.y, { width: width });
    
    doc
        .moveDown(0.2)
        .moveTo(x, doc.y)
        .lineTo(x + width, doc.y)
        .lineWidth(1.5)
        .strokeColor("#808080")
        .stroke();
    
    doc.moveDown(0.4);
}

function addLeftItem(doc, label, value, x) {
    doc
        .fontSize(9)
        .font("Helvetica-Bold")
        .fillColor("#2c3e50")
        .text(`${label}: `, x, doc.y, { continued: true, width: 240 })
        .font("Helvetica")
        .fillColor("#555555")
        .text(value || "Not specified");
    doc.moveDown(0.2);
}

function addRightItem(doc, label, value, x) {
    doc
        .fontSize(9)
        .font("Helvetica-Bold")
        .fillColor("#2c3e50")
        .text(`${label}: `, x, doc.y, { continued: true, width: 240 })
        .font("Helvetica")
        .fillColor("#555555")
        .text(value || "Not specified");
    doc.moveDown(0.2);
}

function bulletPoint(doc, text, x, width) {
    doc
        .fontSize(9)
        .font("Helvetica")
        .fillColor("#555555")
        .text(`• ${text}`, x, doc.y, { width: width });
    doc.moveDown(0.15);
}

function formatDate(date) {
    if (!date) return null;
    const d = new Date(date);
    if (d.getFullYear() < 1900) return null;
    return d.toLocaleDateString("en-US", {
        year: "numeric",
        month: "long",
        day: "numeric",
    });
}