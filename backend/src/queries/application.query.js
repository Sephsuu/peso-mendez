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

export async function getApplicationsByUser(userId) {
    const [rows] = await pool.query(
        `SELECT a.id, a.status AS applicationStatus,
        j.title, j.company, j.location, j.salary, j.type, j.description, j.visibility, j.posted_on, j.status,
        u.full_name, u.email, u.contact FROM applications a
        JOIN jobs j ON a.job_id = j.id
        JOIN users u ON j.employer_id = u.id
        WHERE a.job_seeker_id = ?`,
        [userId]
    );
    
    return rows;
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
        `SELECT a.*, j.title, j.location, u.full_name
        FROM applications a
        JOIN jobs j ON a.job_id = j.id
        JOIN users u ON a.job_seeker_id = u.id
        WHERE j.employer_id = ?`,
        [employerId]
    )
    return rows;
}

export async function updateApplicationStatus(applicationId, status) {
    const rows = pool.query(
        "UPDATE applications SET status = ? WHERE id = ?",
        [status, applicationId]
    );
    return rows;
}