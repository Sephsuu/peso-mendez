import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { getUserByEmailOrUsername, getUserById } from '../queries/user.query.js';
import { authenticateToken } from '../middlewares/authToken.js';
import { registerUser } from '../queries/user.query.js';

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

    const token = jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '2400s' })
  
    res.json({
      token,
      message: `Welcome ${user.full_name}`,
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

    res.status(201).json({ message: 'User registered successfully', userId });
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

export default router;