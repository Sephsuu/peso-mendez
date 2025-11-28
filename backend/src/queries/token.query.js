import pool from '../../db.js'

export async function getAllTokens() {
    const [rows]  = await pool.query(
        `SELECT * FROM fcm_tokens`
    )

    return rows.map((row) => row.token);
}

export async function getTokensByRole(role) {
    const [rows] = await pool.query(`
        SELECT f.token
        FROM fcm_tokens f
        INNER JOIN users u ON u.id = f.user_id
        WHERE u.role = ? AND u.status = 'active'`,
        [role]
    );

    return rows.map((row) => row.token);
}


export async function getTokensByUserIds(userIds) {
    if (!Array.isArray(userIds) || userIds.length === 0) {
        return [];
    }

    const placeholders = userIds.map(() => "?").join(", ");

    const [rows] = await pool.query(
        `
        SELECT token
        FROM fcm_tokens
        WHERE user_id IN (${placeholders})
        `,
        userIds
    );

    return rows.map(r => r.token);
}

