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
          SELECT * FROM notifications WHERE user_id = ?
        `;
        break;

      default:
        throw new Error('Invalid role provided');
    }

    const [rows] = await pool.query(query, [userId, userId]);
    return rows ?? [];
}

export async function getNotificationsByUser(id) {
  const [rows] = await pool.query(
    `SELECT * FROM notifications WHERE recipient_id = ? ORDER BY created_at DESC`,
    [id]
  )

  return rows ?? [];
}

export async function getRecentNotifications(id) {
  const [rows] = await pool.query(
    `SELECT * FROM notifications WHERE recipient_id = ? ORDER BY created_at DESC LIMIT 5`,
    [id]
  )

  return rows ?? [];
}

export async function createNotification(notfication) {
    const [rows] = await pool.query(
        `INSERT INTO notifications (recipient_id, recipient_role, sender_id, content, type)
        VALUES (?, ?, ?, ?, ?)`,
        [notfication.recipient_id, notfication.recipient_role, notfication.sender_id, notfication.content, notfication.type]
    );
    
    return rows ?? {};
}
