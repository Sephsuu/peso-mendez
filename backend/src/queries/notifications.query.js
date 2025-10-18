import pool from "../../db.js";

export async function createNotification(notfication) {
    const [rows] = await pool.query(
        `INSERT INTO notifications (user_id, type, content)
        VALUES (?, ?, ?)`,
        [notfication.userId, notfication.type, notfication.content]
    );
    
    return rows ?? {};
}
