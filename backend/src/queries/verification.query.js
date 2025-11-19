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

export async function createOrUpdateVerification(verification) {
    // 1️⃣ Check if employer already has a record
    const [existing] = await pool.query(
        `SELECT id FROM employer_verification WHERE employer_id = ? LIMIT 1`,
        [verification.employerId]
    );

    // 🟦 Fields we expect from Flutter
    const fields = [
        "documents",
        "letter_of_intent",
        "company_profile",
        "business_permit",
        "mayors_permit",
        "sec_registration",
        "poea_dmw_registration",
        "approved_job_order",
        "job_vacancies",
        "philjobnet_accreditation",
        "dole_no_pending_case_certificate",
        "status"
    ];

    // Build dynamic SET part for SQL
    const updates = fields.map(f => `${f} = ?`).join(", ");
    const values = fields.map(f => verification[f] || null);

    if (existing.length > 0) {
        // 2️⃣ UPDATE existing row
        const verificationId = existing[0].id;

        await pool.query(
            `UPDATE employer_verification SET ${updates} WHERE id = ?`,
            [...values, verificationId]
        );

        return {
            type: "updated",
            id: verificationId
        };
    }

    // 3️⃣ INSERT new record  
    await pool.query(
        `INSERT INTO employer_verification (
            employer_id,
            ${fields.join(", ")}
        ) VALUES (
            ?,
            ${fields.map(() => "?").join(", ")}
        )`,
        [
            verification.employerId,
            ...values
        ]
    );

    return {
        type: "created"
    };
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