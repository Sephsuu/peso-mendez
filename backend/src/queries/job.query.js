import pool from "../../db.js";

export async function getJobs() {
    const [rows] = await pool.query(`
        SELECT * FROM jobs 
        WHERE status = "active" 
        ORDER BY posted_on DESC`
    );
    return rows;
}

export async function getRecommendedJobs(userId) {
    const [rows] = await pool.query(
        `SELECT DISTINCT j.*
        FROM jobs j
        JOIN job_skills js ON j.id = js.job_id
        JOIN other_skills os ON js.skill = os.skill
        WHERE os.user_id = ? AND j.status = ?;`,
        [userId, 'active']
    )

    return rows ?? [];
}

export async function getJobById(id) {
    const [rows] = await pool.query(
        `SELECT *, j.id as id FROM jobs j 
        JOIN users u ON j.employer_id = u.id
        WHERE j.id = ?`,
        [id]
    )
    return rows[0];
}

export async function getJobSkills(id) {
    const [rows] = await pool.query(
        `SELECT skill FROM job_skills WHERE job_id = ?`,
        [id]
    );

    return rows;
}

export async function getJobsByEmployer(employerId) {
    const [rows] = await pool.query(
        "SELECT * FROM jobs WHERE employer_id = ?",
        [employerId]
    );
    return rows;
}

export async function getAllSavedJobsByUser(userId) {
    const [rows] = await pool.query(
        `SELECT *, j.id as id FROM
        jobs j JOIN saved_jobs s ON j.id = s.job_id
        WHERE s.user_id = ?`,
        [userId]
    );

    return rows ?? {};
}

export async function getSavedJobByUserJob(userId, jobId) {
    const [rows] = await pool.query(
        `SELECT * FROM saved_jobs WHERE user_id = ? AND job_id = ?`,
        [userId, jobId]
    );

    return rows[0] ?? {};
}

export async function createJob(job) {
    const insertQuery = `
        INSERT INTO jobs
        (title, company, location, salary, type, description, employer_id, visibility)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const [result] = await pool.query(insertQuery, [
        job.title, job.company, job.location,
        job.salary, job.type, job.description,
        job.employerId, job.visibility
    ]);

    return { id: result.insertId, ...job };
}

export async function createJobSkill(jobSkill) {
    const [rows] = await pool.query(
        `INSERT INTO job_skills (job_id, skill) VALUES (?, ?)`,
        [jobSkill.jobId, jobSkill.skill]
    )

    return rows;
} 

export async function saveJob(userid, jobId) {
    const [result] = await pool.query(
        `INSERT INTO saved_jobs (user_id, job_id) VALUES (?, ?)`,
        [userid, jobId]
    );
    
    return result;
}

export async function updateJob(jobId, title, company, location, type, salary, visibility, description) {
    const [rows] = await pool.query(
        "UPDATE jobs SET title = ?, company = ?, location = ?, type = ?, salary = ?, visibility = ?, description = ? WHERE id = ?",
        [title, company, location, type, salary, visibility, description, jobId]
    );
    return rows[0];
}

export async function deleteJob(jobId) {
    const [rows] = await pool.query(
        `SELECT * FROM jobs WHERE id = ?`,
        [jobId]
    );
    await pool.query(
        "DELETE FROM jobs WHERE id = ?",
        [jobId]
    );

    return rows[0];
}

export async function unsaveJob(userId, jobId) {
    
}