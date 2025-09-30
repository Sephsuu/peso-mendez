import pool from "../../db.js";

export async function getJobs() {
    const [rows] = await pool.query('SELECT * FROM jobs ORDER BY posted_on DESC');
    return rows;
}

export async function getJobById(id) {
    const [rows] = await pool.query(
        'SELECT * FROM jobs WHERE id = ?',
        [id]
    )
    return rows[0];
}

export async function getJobsByEmployer(employerId) {
    const [rows] = await pool.query(
        "SELECT * FROM jobs WHERE employer_id = ?",
        [employerId]
    );
    return rows;
}

export async function getAllSavedJobsByUserJob(userId) {
    const [rows] = await pool.query(
        `SELECT j.title, j.status 
        FROM saved_jobs s 
        JOIN jobs j ON j.id = s.job_id
        `,
        [userId]
    );

    return rows[0] ?? {};
}

export async function getSavedJobByUserJob(userId, jobId) {
    const [rows] = await pool.query(
        `SELECT * FROM saved_jobs WHERE user_id = ? AND job_id = ?`,
        [userId, jobId]
    );

    return rows[0] ?? {};
}

export async function createJob(job) {
    console.log(job);
    
    const insertQuery = `
        INSERT INTO jobs
        (title, company, location, salary, type, description, employer_id, visibility)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const [result] =  await pool.query(insertQuery, [
        job.title, job.company, job.location, 
        job.salary, job.type, job.description, 
        job.employerId, job.visibility
    ]);

    return result;
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