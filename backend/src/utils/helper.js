import pool from "../../db.js"
import fs from "fs";
import path from "path";

export async function getAllUserIds() {
    const [rows]  = await pool.query(
        `SELECT id FROM users`
    )

    return rows.map(r => r.id);
}

export async function getUserIdsByRole(role) {
    const [rows]  = await pool.query(
        `SELECT id FROM users WHERE role= ? AND status="active"`,
        [role]
    )

    return rows.map(r => r.id);
}

export async function getMatchedUsersAndSkill(skills) {
    if (!Array.isArray(skills) || skills.length === 0) {
        return [];
    }

    // Dynamically create placeholders (?, ?, ?, ...)
    const placeholders = skills.map(() => "?").join(", ");

    const [rows] = await pool.query(
        `
        SELECT DISTINCT user_id 
        FROM other_skills
        WHERE skill IN (${placeholders})
        `,
        skills
    );

    // rows = [ { user_id: 1 }, { user_id: 5 }, ... ]
    return rows.map(r => r.user_id);
}

export async function getUserByApplication(id) {
    const [rows] = await pool.query(
        `SELECT job_seeker_id 
         FROM applications 
         WHERE id = ? 
         LIMIT 1`,
        [id]
    );

    return rows.length > 0 ? [rows[0].job_seeker_id] : null;
}

export async function getUserByJob(id) {
    const [rows] = await pool.query(
        `SELECT employer_id 
         FROM jobs 
         WHERE id = ? 
         LIMIT 1`,
        [id]
    );

    return rows.length > 0 ? [rows[0].employer_id] : null;
}

export async function getUserByVerification(id) {
    const [rows] = await pool.query(
        `SELECT employer_id 
         FROM employer_verification 
         WHERE id = ? 
         LIMIT 1`,
        [id]
    );

    return rows.length > 0 ? [rows[0].employer_id] : null;
}

export function findResumeFile(userId) {
    const resumePath = path.join(
        process.cwd(),
        "uploads",
        "job-seeker-resume",
        `${userId}_resume.pdf`
    );

    if (!fs.existsSync(resumePath)) {
        return null;
    }

    return resumePath;
}
