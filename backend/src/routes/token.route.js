import express from 'express';
import pool from "../../db.js";

const router = express.Router();

// Save or Update FCM Token
router.post("/save-fcm-token", async (req, res) => {
  const { userId, token } = req.body;

  if (!userId || !token) {
    return res.status(400).json({ message: "Missing fields" });
  }

  try {
    // Check if user already has token saved
    const [existing] = await pool.query(
      "SELECT * FROM fcm_tokens WHERE user_id = ?",
      [userId]
    );

    if (existing.length > 0) {
      // Update existing token
      await pool.query(
        "UPDATE fcm_tokens SET token = ? WHERE user_id = ?",
        [token, userId]
      );
    } else {
      // Insert new token
      await pool.query(
        "INSERT INTO fcm_tokens (user_id, token) VALUES (?, ?)",
        [userId, token]
      );
    }

    return res.json({ success: true, message: "Token saved" });
  } catch (err) {
    console.log(err);
    return res.status(500).json({ message: "Database error" });
  }
});

export default router;