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
        `SELECT a.*, j.title, j.location, u.full_name
        FROM applications a
        JOIN jobs j ON a.job_id = j.id
        JOIN users u ON a.job_seeker_id = u.id
        WHERE j.employer_id = ?`,
        [employerId]
    )
    return rows;
}

export async function getApplicationsByEmployerFilter(employerId, title, location, applicationStatus) {
    console.log({ employerId, title, location, applicationStatus });
    let sql = `
        SELECT a.*, j.title, j.location, u.full_name
        FROM applications a
        JOIN jobs j ON a.job_id = j.id
        JOIN users u ON a.job_seeker_id = u.id
        WHERE j.employer_id = ?
    `;
    const params = [employerId];

    if (title !== "A") {
        sql += " AND j.title = ?";
        params.push(title);
    }
    if (location !== "A") {
        sql += " AND j.location = ?";
        params.push(location);
    }
    if (applicationStatus !== "A") {
        sql += " AND a.status = ?";
        params.push(applicationStatus);
    }

    const [rows] = await pool.query(sql, params);
    return rows;
}