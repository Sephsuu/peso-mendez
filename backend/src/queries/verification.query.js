import pool from "../../db.js";
const TABLE = "employer_verification"; // ✅ change to your actual table name

const ALLOWED_FIELDS = [
  "status",
  "note",
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
];

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
        `SELECT ev.*, u.full_name FROM employer_verification ev
        JOIN users u ON ev.employer_id = u.id
        WHERE employer_id = ?`,
        [id]
    )

    return rows[0] ?? {}
}

export async function createOrUpdateVerification(verification) {
    const [existing] = await pool.query(
        `SELECT id FROM employer_verification WHERE employer_id = ? LIMIT 1`,
        [verification.employerId]
    );

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

    const updates = fields.map(f => `${f} = ?`).join(", ");
    const values = fields.map(f => verification[f] || null);

    let verificationId;

    if (existing.length > 0) {
        verificationId = existing[0].id;

        await pool.query(
            `UPDATE employer_verification 
             SET ${updates} 
             WHERE id = ?`,
            [...values, verificationId]
        );
    } else {
        const [result] = await pool.query(
            `INSERT INTO employer_verification (
                employer_id,
                ${fields.join(", ")}
            ) VALUES (
                ?,
                ${fields.map(() => "?").join(", ")}
            )`,
            [verification.employerId, ...values]
        );

        verificationId = result.insertId;
    }

    const [rows] = await pool.query(
        `SELECT ev.*, u.full_name
         FROM employer_verification ev
         JOIN users u ON ev.employer_id = u.id
         WHERE ev.id = ?`,
        [verificationId]
    );

    return {
        type: existing.length > 0 ? "updated" : "created",
        ...rows[0]   // <-- spreads fields including full_name
    };
}


export async function updateStatus(id, updatedStatus, note) {
    const [rows] = await pool.query(
        `UPDATE employer_verification 
        SET status = ?, note = ?
        WHERE id = ?`,
        [updatedStatus, note, id]
    );

    const [result] = await pool.query(
        `SELECT * FROM employer_verification WHERE id = ?`,
        [id]
    )

    return result[0] ?? { message: "Something went wrong" };
}

function buildUpdate(payload) {
    const keys = Object.keys(payload).filter((k) => {
        if (!ALLOWED_FIELDS.includes(k)) return false;
        if (payload[k] === undefined) return false;
        if (payload[k] === null) return false;
        return true;
    });

    if (keys.length === 0) return null;

    const setClause = keys.map((k) => `${k} = ?`).join(", ");
    const values = keys.map((k) => payload[k]);

    return { setClause, values };
}

export async function updateVerificationById(id, payload) {
    const built = buildUpdate(payload);
    if (!built) return null;

    const { setClause, values } = built;

    await pool.query(
        `UPDATE ${TABLE} SET ${setClause}, updated_at = NOW() WHERE id = ?`,
        [...values, id]
    );

    const [rows] = await pool.query(`SELECT * FROM ${TABLE} WHERE id = ? LIMIT 1`, [id]);
    return rows?.[0] || null;
}

export async function updateVerificationByEmployerId(employerId, payload) {
    const built = buildUpdate(payload);
    if (!built) return null;

    const { setClause, values } = built;

    await pool.query(
        `UPDATE ${TABLE} SET ${setClause}, updated_at = NOW() WHERE ${EMPLOYER_ID_COL} = ?`,
        [...values, employerId]
    );

    // return the latest row for that employer
    const [rows] = await pool.query(
        `SELECT * FROM ${TABLE} WHERE ${EMPLOYER_ID_COL} = ? ORDER BY id DESC LIMIT 1`,
        [employerId]
    );
    return rows?.[0] || null;
}

export async function getEmployersWithVerification() {
    const [rows] = await pool.query(
        `SELECT DISTINCT
            u.*, 
            ev.status AS verification_status,
            ei.employer_type,
            ei.sex,
            ei.highest_education,
            ei.citmun
            FROM users u
            LEFT JOIN employer_verification ev 
                ON ev.employer_id = u.id
            LEFT JOIN employer_information ei
                ON ei.employer_id = u.id
            WHERE u.role = ? 
            AND u.status = ?`,
        ["employer", "active"]
    );

    return rows;
}