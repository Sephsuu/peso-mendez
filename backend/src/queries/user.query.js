import pool from "../../db.js";
import bcrypt from 'bcryptjs';

export async function getUsers() {
    const [rows] = await pool.query('SELECT * FROM users');
    return rows;
}

export async function getUserById(id) {
    const [rows] = await pool.query(
        'SELECT * FROM users WHERE id = ?',
        [id]
    )
    return rows[0];
}

export async function getUserByRole(role) {
    const [rows] = await pool.query(
        'SELECT * FROM users WHERE role = ?',
        [role]
    );
    return rows;
}

export async function getUserByEmailOrUsername(emailOrUsername) {
    const [rows] = await pool.query(
        'SELECT * FROM users WHERE email = ? OR username = ? LIMIT 1',
        [emailOrUsername, emailOrUsername]
    );
    return rows[0]; 
}

export async function getUserProfileStrength(id) {
    const tables = ["personal_informations", "job_references", "language_profeciencies", "educational_backgrounds", "tech_voc_trainings", "eligibilities", "professional_licenses", "work_experiences", "other_skills"];
    let strength = 0;

    for (const table of tables) {
        const [rows] = await pool.query(
            `SELECT COUNT(*) AS count FROM \`${table}\` WHERE user_id = ?`,
            [id]
        );

        if (rows[0].count > 0) {
            strength++;
        }
    }

    return strength / tables.length;
}

export async function getUserCredentials(id) {
    const [rows] = await pool.query(
        `SELECT * FROM users WHERE id = ?`,
        [id]
    );
    return rows[0];
} 

export async function getUserPersonalInformation(id) {
    const [rows] = await pool.query(
        `SELECT * FROM personal_informations WHERE user_id = ?`,
        [id]
    );
    return rows[0];
} 

export async function getUserJobReference(id) {
    const [rows] = await pool.query(
        `SELECT * FROM job_references WHERE user_id = ?`,
        [id]
    );
    return rows[0];
} 

export async function getUserLanguageProcefiency(id) {
    const [rows] = await pool.query(
        `SELECT * FROM language_profeciencies WHERE user_id = ?`,
        [id]
    );
    return rows;
} 

export async function getUserEducationalBackground(id) {
    const [rows] = await pool.query(
        `SELECT * FROM educational_backgrounds WHERE user_id = ?`,
        [id]
    );
    return rows[0];
} 

export async function getUserTechVocTrainings(id) {
    const [rows] = await pool.query(
        `SELECT * FROM tech_voc_trainings WHERE user_id = ?`,
        [id]
    );
    return rows;
} 

export async function getUserEligibility(id) {
    const [rows] = await pool.query(
        `SELECT * FROM eligibilities WHERE user_id = ?`,
        [id]
    );
    return rows;
} 

export async function getUserProfessionalLicense(id) {
    const [rows] = await pool.query(
        `SELECT * FROM professional_licenses WHERE user_id = ?`,
        [id]
    );
    return rows;
} 

export async function getUserWorkExperience(id) {
    const [rows] = await pool.query(
        `SELECT * FROM work_experiences WHERE user_id = ?`,
        [id]
    );
    return rows;
} 

export async function getUserOtherSkills(id) {
    const [rows] = await pool.query(
        `SELECT * FROM other_skills WHERE user_id = ?`,
        [id]
    );
    return rows;
} 

export async function registerUser(fullName, email, contactNumber, username, password, role) {
    const checkQuery = `
        SELECT 1 FROM users WHERE email = ? OR username = ? LIMIT 1
    `;
    const [rows] = await pool.query(checkQuery, [email, username]);

    if (rows.length > 0) {
        throw new Error('Email or username already exists');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const now = new Date();

    const insertQuery = `
        INSERT INTO users
        (full_name, email, contact, username, password, role, created_at, is_active, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const [result] = await pool.query(insertQuery, [
        fullName,
        email,
        contactNumber,
        username,
        hashedPassword,
        role,
        now,
        1,         
        'active',   
    ]);

    return result.insertId;
}

export async function createPersonalinformation(personalInfo) {
    const [result] = await pool.query(
        `INSERT INTO personal_informations (
            user_id, surname, first_name, middle_name, date_of_birth, suffix,
            religion, present_address, tin, sex, civil_status,
            disability, employment_status, employment_type, is_ofw, is_former_ofw
        )
        VALUES (
            ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?
        )`,
        [
            personalInfo.userId, personalInfo.surname, personalInfo.firstName, 
            personalInfo.middleName, personalInfo.dateOfBirth, personalInfo.suffix, personalInfo.religion,
            personalInfo.presentAddress, personalInfo.tin, personalInfo.sex,
            personalInfo.civilStatus, personalInfo.disability, personalInfo.employmentStatus,
            personalInfo.employmentType, personalInfo.isOfw, personalInfo.isFormerOfw
        ]
    );
    return result;
}

export async function createJobReference(jobRef) {
    console.log(jobRef);
    
    const [result] = await pool.query(
        `INSERT INTO job_references (
            user_id, occupation_type, occupation1, occupation2, occupation3,
            location_type, location1, location2, location3
        )
        VALUES (
            ?, ?, ?, ?, ?,
            ?, ?, ?, ?
        )`,
        [
            jobRef.userId, jobRef.occupationType, jobRef.occupation1,
            jobRef.occupation2, jobRef.occupation3, jobRef.locationType,
            jobRef.location1, jobRef.location2, jobRef.location3
        ]
    );
    return result;
}

export async function createLanguageProfeciency(languageProf) {
    console.log(languageProf);
    
    const [result] = await pool.query(
        `INSERT INTO language_profeciencies (
            user_id, language, \`read\`, \`write\`, speak, understand
        )
        VALUES (?, ?, ?, ?, ?, ?)`,
        [
            languageProf.userId, languageProf.language, languageProf.read,
            languageProf.write, languageProf.speak, languageProf.understand,
        ]
    );
    return result;
}

export async function createEducationalBackground(educBg) {
    const [result] = await pool.query(
        `INSERT INTO educational_backgrounds (
            user_id, elem_year_grad, elem_level_reached, elem_year_last_attended,
            seco_year_grad, seco_level_reached, seco_year_last_attended, ter_course,
            ter_year_grad, ter_level_reached, ter_year_last_attended, gs_course,
            gs_year_grad, gs_level_reached, gs_year_last_attended, is_kto12, shs_strand  
        )
        VALUES (
            ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?
        )`,
        [
            educBg.userId, educBg.elemYearGrad, educBg.elemLevelReached, educBg.elemYearLastAttended,
            educBg.secoYearGrad, educBg.secoLevelReached, educBg.secoYearLastAttended, educBg.terCourse,
            educBg.terYearGrad, educBg.terLevelReached, educBg.terYearLastAttended, educBg.gsCourse,
            educBg.gsYearGrad, educBg.gsLevelReached, educBg.gsYearLastAttended, educBg.isKto12, educBg.shsStrand
        ]
    );
    return result;
}


export async function createTechVocTraining(techVoc) {
    const [result] = await pool.query(
        `INSERT INTO tech_voc_trainings (
            user_id, course, hours_training, institution,
            skills_acquired, cert_received
        )
        VALUES (?, ?, ?, ?, ?, ?)`,
        [
            techVoc.userId, techVoc.course, techVoc.hoursTraining,
            techVoc.institution, techVoc.skillsAcquired, techVoc.certReceived
        ]
    );
    return result;
}

export async function createEligibility(eligibility) {
    const [result] = await pool.query(
        `INSERT INTO eligibilities (
            user_id, eligibility, date_taken
        )
        VALUES (?, ?, ?)`,
        [eligibility.userId, eligibility.eligibility, eligibility.dateTaken]
    );
    return result;
}

export async function createProfessionalLicense(prc) {
    const [result] = await pool.query(
        `INSERT INTO professional_licenses (
            user_id, license, valid_until
        )
        VALUES (?, ?, ?)`,
        [prc.userId, prc.license, prc.validUntil]
    );
    return result;
}

export async function createWorkExperience(workExp) {
    const [result] = await pool.query(
        `INSERT INTO work_experiences (
            user_id, company_name, address,
            position, no_of_month, status 
        )
        VALUES (?, ?, ?, ?, ?, ?)`,
        [
            workExp.userId, workExp.companyName, workExp.address,
            workExp.position, workExp.noOfMonth, workExp.status
        ]
    );
    return result;
}

export async function createOtherSkill(otherSkill) {
    const [result] = await pool.query(
        `INSERT INTO other_skills (
            user_id, skill
        )
        VALUES (?, ?)`,
        [otherSkill.userId, otherSkill.skill]
    );
    return result;
}

export async function updateUserCredential(user) {
    const [result] = await  pool.query(
        `UPDATE users 
        SET full_name = ?, username = ?, contact = ?, document_path = ?
        WHERE id = ?`,
        [user.full_name, user.username, user.contact, user.document_path, user.id]
    ) ;
    return result;
}

export async function updatePersonalInformation(personalInfo) {
  const [result] = await pool.query(
    `UPDATE personal_informations
     SET
       surname = ?, first_name = ?, middle_name = ?, date_of_birth = ?,
       suffix = ?, religion = ?, present_address = ?, tin = ?,
       sex = ?, civil_status = ?, disability = ?, employment_status = ?,
       employment_type = ?, is_ofw = ?, is_former_ofw = ?, updated_at = NOW()
     WHERE user_id = ?`,
    [
      personalInfo.surname, personalInfo.firstName, personalInfo.middleName, personalInfo.dateOfBirth,
      personalInfo.suffix, personalInfo.religion, personalInfo.presentAddress,  personalInfo.tin,
      personalInfo.sex, personalInfo.civilStatus, personalInfo.disability, personalInfo.employmentStatus,
      personalInfo.employmentType, personalInfo.isOfw, personalInfo.isFormerOfw, personalInfo.userId, // WHERE condition
    ]
  );

  return result;
}

export async function updateJobReference(jobRef) {
    console.log(jobRef);
    
    const [result] = await pool.query(
        `UPDATE job_references
        SET
            occupation_type = ?, occupation1 = ?, occupation2 = ?,
            occupation3 = ?, location_type = ?, location1 = ?,
            location2 = ?, location3 = ?, updated_at = NOW()
        WHERE
            user_id = ?`,
        [
            jobRef.occupation_type, jobRef.occupation1, jobRef.occupation2,
            jobRef.occupation3, jobRef.location_type, jobRef.location1,
            jobRef.location2, jobRef.location3, jobRef.user_id
        ]
    );
    return result;
}

export async function updateTechVocTraining(techVoc) {
  const [result] = await pool.query(
    `UPDATE tech_voc_trainings 
     SET 
        course = ?, hours_training = ?, institution = ?, 
        skills_acquired = ?, cert_received = ?, updated_at = NOW()
     WHERE id = ?`,
    [
      techVoc.course, techVoc.hours_training, techVoc.institution, 
      techVoc.skills_acquired, techVoc.cert_received, techVoc.id
    ]
  );

  return result;
}

export async function updateEligibility(eligibility) {
  const [result] = await pool.query(
    `UPDATE eligibilities
     SET 
        eligibility = ?, date_taken = ?, updated_at = NOW()
     WHERE id = ?`,
    [eligibility.eligibility, eligibility.date_taken, eligibility.id]
  );
  return result;
}

export async function updateProfessionalLicense(prc) {
  const [result] = await pool.query(
    `UPDATE professional_licenses 
     SET 
        license = ?, valid_until = ?, updated_at = NOW()
     WHERE id = ?`,
    [prc.license, prc.valid_until, prc.id]
  );
  return result;
}

export async function updateWorkExperience(workExp) {
  const [result] = await pool.query(
    `UPDATE work_experiences
     SET 
        company_name = ?, address = ?, position = ?, 
        no_of_month = ?, status = ?, updated_at = NOW()
     WHERE id = ?`,
    [
      workExp.company_name, workExp.address, workExp.position, 
      workExp.no_of_month, workExp.status,workExp.id
    ]
  );
  return result;
}


export async function deactivateUser(id) {
    await pool.query(
        `UPDATE users SET status = "inactive" WHERE id = ?`,
        [id]
    );
    const [rows] = await pool.query(
        `SELECT * FROM users WHERE id = ?`,
        [id]
    );

    return rows.length ? rows[0] : null;
}