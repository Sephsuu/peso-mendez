import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

import authRouter from './src/routes/auth.route.js';
import userRouter from './src/routes/user.route.js';
import jobRouter from './src/routes/job.route.js';
import applicationRouter from './src/routes/application.route.js';
import announcementRouter from './src/routes/announcement.route.js';
import verificationRouter from './src/routes/verification.route.js';
import uploadRoute from './src/routes/upload.route.js';
import notificationRoute from './src/routes/notifications.route.js';
import messageRoute from './src/routes/message.route.js';
import tokenRoute from './src/routes/token.route.js'
import reportRoute from './src/routes/report.route.js'

// Optional secret
const secret = 'your-static-development-secret-key-here';

const app = express();
const PORT = process.env.PORT || 3005;

// --- Resolve __dirname (ES module compatible) ---
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/uploads', express.static(path.join(__dirname, '../uploads'))); 

app.use(cors({
  origin: function (origin, callback) {
    if (!origin) return callback(null, true); // Allow Postman, mobile apps, etc.
    return callback(null, true); // Allow all origins - adjust for production
  },
  credentials: false,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/auth', authRouter);
app.use('/users', userRouter);
app.use('/jobs', jobRouter);
app.use('/applications', applicationRouter);
app.use('/announcements', announcementRouter);
app.use('/verifications', verificationRouter);
app.use('/uploads', uploadRoute); 
app.use('/notifications', notificationRoute); 
app.use('/messages', messageRoute);
app.use('/tokens', tokenRoute);
app.use('/reports', reportRoute);

app.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ Server running on port ${PORT}`);
  console.log(`📂 Serving uploads from: ${path.join(__dirname, '../uploads')}`);
});
