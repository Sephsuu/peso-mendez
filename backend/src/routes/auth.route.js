import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { getUserByEmailOrUsername, getUserById, updateUserPassword } from '../queries/user.query.js';
import { authenticateToken } from '../middlewares/authToken.js';
import { registerUser } from '../queries/user.query.js';
import * as tokenQuery from '../queries/token.query.js';
import * as helper from '../utils/helper.js'
import * as notificationQuery from "../queries/notifications.query.js";
import admin from '../middlewares/firebase.js'

const router = express.Router();

router.post('/login', async (req, res) => {
    const { emailOrUsername, password } = req.body;

    const user = await getUserByEmailOrUsername(emailOrUsername);

    if (!user) {
        return res.status(404).json({ message: 'Invalid credentials!' });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
        return res.status(401).json({ message: 'Password do not matched.' });
    }

    const payload = { id: user.id, full_name: user.full_name, role: user.role };

    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '3d' })
  
    res.json({
      token,
      message: `Welcome ${user.full_name}`,
      status: user.status,
      user: {
        id: user.id,
        full_name: user.full_name,
        role: user.role
      }
    });
});

router.post('/register', async (req, res) => {
  try {
    const { fullName, email, contactNumber, username, password, role } = req.body;

    if (!fullName || !email || !username || !password || !role) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const userId = await registerUser(fullName, email, contactNumber, username, password, role);

    const userIds = await helper.getUserIdsByRole("admin");
    const tokens = await tokenQuery.getTokensByRole("admin");
    for (const id of userIds) {
        await notificationQuery.createNotification({
            recipient_id: id,
            recipient_role: "admin",
            sender_id: null,
            type: "ACCOUNT",
            content: `A new ${role == "job_seeker" ? "Job Seeker" : "Employer"} registered an account.`,
        })
    }

    if (tokens.length === 0) {
        return res.json({
            success: true,
            message: "No FCM tokens found.",
            announcement: query
        });
    }

    const payload = {
        tokens: tokens,
        notification: {
            title: "A new account has been created.",
            body: `Email ${email} has been registered to PESO Mendez.`,
        },
        data: {
            screen: "account",
        }
    };

    const response = await admin.messaging().sendEachForMulticast(payload);
    console.log("FCM RESPONSE:", JSON.stringify(response, null, 2));
    console.log("FCM ERROR DETAILS:", response.responses[0].error);

    res.status(201).json({ message: 'User registered successfully', userId, username, role });
  } catch (err) {
    if (err.message.includes('exists')) {
      return res.status(400).json({ error: err.message });
    }
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/get-claims', authenticateToken, (req, res) => {
  res.json(req.user);
});

router.post('/update-password', async (req, res) => {
  try {
    const { userId, old_password, new_password } = req.body;

    if (!old_password || !new_password) {
      return res.status(400).json({ message: "Both old and new password are required" });
    }

    const user = await getUserById(userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const isMatch = await bcrypt.compare(old_password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Old password is incorrect" });
    }

    const hashedPassword = await bcrypt.hash(new_password, 10);
    console.log('Line 125');
    

    await updateUserPassword(userId, hashedPassword);

    res.json({ message: "Password updated successfully" });

  } catch (err) {
    console.error("UPDATE PASSWORD ERROR:", err);
    res.status(500).json({ message: "Internal server error" });
  }
});


export default router;