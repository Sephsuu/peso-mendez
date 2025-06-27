import pool from "../../db.js";

export async function addApplication(jobId, userId) {
    const checkQuery = `
        SELECT 1 FROM applications WHERE job_id = ? AND job_seeker_id = ? LIMIT 1
    `;
    const [rows] = await pool.query(checkQuery, [jobId, userId]);

    if (rows.length > 0) {
        throw new Error('Already applied for the job');
    }

    const insertQuery = `
        INSERT INTO applications 
        (job_id, job_seeker_id)
        VALUES (?, ?)
    `;

    const [result] = await pool.query(insertQuery, [jobId, userId]);

    return result;
} 

export async function getApplicationByJobAndUser(jobId, userId) {
    const [rows] = await pool.query(
      "SELECT * FROM applications WHERE job_id = ? AND job_seeker_id = ?",
      [jobId, userId]
    )

    return rows[0];
}

export async function getApplicationsByEmployer(employerId) {
    const [rows] = await pool.query(
        "SELECT * FROM applications a JOIN jobs j ON a.job_id = j.id WHERE j.employer_id = ?",
        [employerId]
    )
    return rows;
}