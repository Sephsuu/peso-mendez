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

export async function createJob(title, company, location, salary, type, description, employerId, visibility) {
    const insertQuery = `
        INSERT INTO jobs
        (title, company, location, salary, type, description, employer_id, visibility)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const [result] =  await pool.query(insertQuery, [
        title, company, location, salary, type, description, employerId, visibility
    ]);

    return result;
}

export async function getJobsByEmployer(employerId) {
    const [rows] = await pool.query(
        "SELECT * FROM jobs WHERE employer_id = ?",
        [employerId]
    );
    return rows;
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
        "DELETE FROM jobs WHERE id = ?",
        [jobId]
    );

    return rows[0];
}