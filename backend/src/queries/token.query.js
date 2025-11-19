import pool from '../../db.js'

export async function getAllTokens() {
    const [rows]  = await pool.query(
        `SELECT * FROM fcm_tokens`
    )

    return rows ?? [];
}