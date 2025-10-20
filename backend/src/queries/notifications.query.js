import pool from "../../db.js";

export async function getNotificationsByRole(role, userId) {
    let query = '';

    switch (role) {
      case 'employer':
        query = `

        `;
        break;

      case 'job_seeker':
        query = `
            SELECT n.id,
                n.type,
                n.content,
                n.created_at
            FROM notifications n
            LEFT JOIN notifications_reads nr
            ON nr.notification_id = n.id
            AND nr.user_id = ?              
            WHERE n.type IN ('JOB SEEKER ANNOUNCEMENT', 'FOR ALL ANNOUNCEMENT')
            OR n.user_id = ?
            ORDER BY n.created_at DESC;

        `;
        break;

      case 'admin':
        query = `

        `;
        break;

      default:
        throw new Error('Invalid role provided');
    }

    const [rows] = await pool.query(query, [userId, userId]);
    return rows ?? [];
}

export async function createNotification(notfication) {
    const [rows] = await pool.query(
        `INSERT INTO notifications (user_id, type, content)
        VALUES (?, ?, ?)`,
        [notfication.userId, notfication.type, notfication.content]
    );
    
    return rows ?? {};
}
