import pool from "../../db.js";

export async function getMessages(userId, otherId) {
  const [rows] = await pool.query(
    `
    SELECT * FROM messages 
    WHERE 
      (sender_id = ? AND receiver_id = ?)
      OR
      (sender_id = ? AND receiver_id = ?)
    ORDER BY timestamp ASC
    `,
    [userId, otherId, otherId, userId]
  );

  return rows;
}

export async function createMessage(userId, otherId, message) {
    const [result] = await pool.query(
        `INSERT INTO messages (sender_id, receiver_id, message_text)
        VALUES (?, ?, ?)`,
        [userId, otherId, message]
    );

    return result;
}

