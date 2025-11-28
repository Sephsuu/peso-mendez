import pool from "../../db.js";

async function verifyConversation(userId, otherId, message) {
    const [rows] = await pool.query(
      `SELECT *
      FROM conversations
      WHERE (user_a = ? AND user_b = ?) OR (user_a = ? AND user_b = ?)
      ORDER BY created_at DESC
      LIMIT 1`,
      [userId, otherId, otherId, userId]
    );

    console.log(rows);
    

    if (rows.length > 0) {
      const updateConvo = await pool.query(
        `UPDATE conversations SET latest_message = ? WHERE id = ?`,
        [message, rows[0].id]
      )
      return
    }

    return await pool.query(
      `INSERT INTO conversations (user_a, user_b, latest_message)
      VALUES (?, ?, ?)`,
      [userId, otherId, message]
    );
}

export async function getConversationsByUser(userId) {
  const [rows] = await pool.query(
    `SELECT 
      c.id,
      c.latest_message,
      c.created_at,
      c.updated_at,
      u1.id AS user_a_id,
      u1.full_name AS user_a_name,
      u2.id AS user_b_id,
      u2.full_name AS user_b_name
    FROM conversations c
    JOIN users u1 ON c.user_a = u1.id
    JOIN users u2 ON c.user_b = u2.id
    WHERE c.user_a = ? OR c.user_b = ?
    ORDER BY c.updated_at DESC`,
    [userId, userId]
  );

  return rows;
}

export async function getMessages(userId, otherId) {
  const [rows] = await pool.query(
    `
    SELECT * FROM messages 
    WHERE 
      (sender_id = ? AND receiver_id = ?)
      OR
      (sender_id = ? AND receiver_id = ?)
    ORDER BY created_at ASC
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

    verifyConversation(userId, otherId, message)

    return result;
}

