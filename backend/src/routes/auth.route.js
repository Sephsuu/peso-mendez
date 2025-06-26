import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { getUserByEmailOrUsername, getUserById } from '../queries/user.query.js';
import { authenticateToken } from '../middlewares/authToken.js';

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

    const payload = { id: user.id, full_name: user.full_name };

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

router.get('/dashboard', authenticateToken, (req, res) => {
  res.json({
    message: `Welcome ${req.user.full_name}`,
    user: req.user,
  });
});

export default router;