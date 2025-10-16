import pool from "../../db.js";

export async function getVerifications(role) {
    let rows;
    if (role == 'employer') {
        rows = await pool.query(
            `SELECT 
            v.id, v.employer_id, v.status, v.documents,
            u.full_name, u.email, u.username, u.contact, u.created_at
            FROM employer_verification v
            JOIN users u ON u.id = v.employer_id`
        )
    } else {
        rows = await pool.query(
            `SELECT 
            v.id, v.employer_id, v.status, v.documents,
            u.full_name, u.email, u.username, u.contact, u.created_at
            FROM employer_verification v
            JOIN users u ON u.id = v.employer_id
            WHERE v.status = ?`,
            ['pending']
        )
    }
    
    return rows[0] ?? [];
}

export async function getVerificationByUser(id) {
    const [rows] = await pool.query(
        `SELECT * FROM employer_verification WHERE employer_id = ?`,
        [id]
    )

    return rows[0] ?? {}
}

export async function createVerification(verification) {
    const [rows] = await pool.query(
        `INSERT INTO employer_verification(employer_id, documents, status)
        VALUES (?, ?, ?)`,
        [verification.employerId, verification.documents, verification.status]
    )

    return rows;
}

export async function updateStatus(id, updatedStatus) {
    const [rows] = await pool.query(
        `UPDATE employer_verification 
        SET status = ?
        WHERE id = ?`,
        [updatedStatus, id]
    );

    const [result] = await pool.query(
        `SELECT * FROM employer_verification WHERE id = ?`,
        [id]
    )

    return result[0] ?? {};
}