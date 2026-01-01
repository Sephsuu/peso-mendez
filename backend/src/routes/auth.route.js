import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { getUserByEmailOrUsername, getUserById, updateUserPassword } from '../queries/user.query.js';
import { authenticateToken } from '../middlewares/authToken.js';
import { registerUser } from '../queries/user.query.js';
import { findByVerificationToken } from '../queries/user.query.js';
import { verifyUser } from '../queries/user.query.js';
import * as tokenQuery from '../queries/token.query.js';
import * as helper from '../utils/helper.js'
import * as notificationQuery from "../queries/notifications.query.js";
import admin from '../middlewares/firebase.js'
import { sendVerificationEmail } from '../utils/mailer.js';
import crypto from "crypto";

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

    if (!user.is_verified) {
        return res.status(403).json({
        message: "Please verify your email before logging in.",
      });
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

router.post("/register", async (req, res) => {
    try {
        const { fullName, email, contactNumber, username, password, role } = req.body;

        if (!fullName || !email || !username || !password || !role) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        // 🔐 Generate verification token
        const verificationToken = crypto.randomBytes(32).toString("hex");
        const tokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours

        // 👤 Register user (NOT verified yet)
        const userId = await registerUser(
            fullName,
            email,
            contactNumber,
            username,
            password,
            role,
            verificationToken,
            tokenExpiry
        );

        // 📧 Send verification email
        await sendVerificationEmail(email, verificationToken);

        /* ===== YOUR EXISTING ADMIN NOTIFICATIONS (UNCHANGED) ===== */

        const userIds = await helper.getUserIdsByRole("admin");
        const tokens = await tokenQuery.getTokensByRole("admin");

        for (const id of userIds) {
            await notificationQuery.createNotification({
                recipient_id: id,
                recipient_role: "admin",
                sender_id: null,
                type: "ACCOUNT",
                content: `A new ${role === "job_seeker" ? "Job Seeker" : "Employer"} registered an account.`,
            });
        }

        if (tokens.length > 0) {
            const payload = {
                tokens,
                notification: {
                    title: "A new account has been created.",
                    body: `Email ${email} has been registered to PESO Mendez.`,
                },
                data: { screen: "account" },
            };

            await admin.messaging().sendEachForMulticast(payload);
        }

        res.status(201).json({
            message: "Registration successful. Please verify your email.",
            userId,
        });
    } catch (err) {
        if (err.message.includes("exists")) {
            return res.status(400).json({ error: err.message });
        }
        console.error(err);
        res.status(500).json({ error: "Internal server error" });
    }
});

router.get("/verify-email", async (req, res) => {
    try {
        const { token } = req.query;

        if (!token) {
            return res.redirect("peso-mendez://verify-failed");
        }

        const user = await findByVerificationToken(token);

        if (!user) {
            return res.redirect("peso-mendez://verify-failed");
        }

        if (new Date(user.verification_token_expires) < new Date()) {
            return res.redirect("peso-mendez://verify-expired");
        }

        await verifyUser(user.id);

        // ✅ Redirect to Flutter app
        return res.redirect("peso-mendez://verified-success");

    } catch (err) {
        console.error(err);
        return res.redirect("peso-mendez://verify-failed");
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

router.get("/test-email", async (req, res) => {
    try {
        await sendVerificationEmail(
            "josephemanuel.bataller@cvsu.edu.ph",
            "test123"
        );
        res.json({ message: "Email sent successfully" });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: err.message });
    }
});



export default router;