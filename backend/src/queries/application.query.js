import pool from "../../db.js";

export async function createApplication(jobId, userId) {
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
    console.log(jobId, userId);
    
    const [result] = await pool.query(insertQuery, [jobId, userId]);

    return result;
} 

export async function getApplicationsByUser(userId) {
    const [rows] = await pool.query(
        `SELECT a.id, a.status AS applicationStatus, a.applied_on,
        j.id as job_id, j.title, j.company, j.location, j.salary, j.type, j.description, j.visibility, j.posted_on, j.status, j.employer_id,
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
      `SELECT a.id, a.status AS applicationStatus, a.applied_on,
        j.id as job_id, j.title, j.company, j.location, j.salary, j.type, j.description, j.visibility, j.posted_on, j.status, j.employer_id,
        u.full_name, u.email, u.contact FROM applications a
        JOIN jobs j ON a.job_id = j.id
        JOIN users u ON j.employer_id = u.id
        WHERE a.job_id = ? AND a.job_seeker_id`,
      [jobId, userId]
    )

    return rows[0] ?? {};
}

export async function getApplicationsByEmployer(employerId) {
    const [rows] = await pool.query(
        `SELECT a.*, j.title, j.location, u.full_name, u.document_path
        FROM applications a
        JOIN jobs j ON a.job_id = j.id
        JOIN users u ON a.job_seeker_id = u.id
        WHERE j.employer_id = ?`,
        [employerId]
    )
    return rows;
}

export async function updateApplicationStatus(applicationId, status) {
    await pool.query(
        "UPDATE applications SET status = ? WHERE id = ?",
        [status, applicationId]
    );

    if (status === "Hired") {
        await pool.query(
            `UPDATE jobs 
             SET status = 'inactive' 
             WHERE id = (SELECT job_id FROM applications WHERE id = ?)`,
            [applicationId]
        );
    }

    return { message: "Status updated successfully" };
}

export async function updateApplicationPlacement(applicationId, placement) {
    await pool.query(
        "UPDATE applications SET placement = ? WHERE id = ?",
        [placement, applicationId]
    );

    return { message: "Status updated successfully" };
}


export async function deleteApplicationByJobAndUser(jobId, userId) {
    const result = await pool.query(
        `DELETE FROM applications WHERE job_seeker_id = ? AND job_id = ?`, 
        [userId, jobId],
    )

    return result[0];
}