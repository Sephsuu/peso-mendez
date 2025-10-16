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

// Optional secret
const secret = 'your-static-development-secret-key-here';

const app = express();
const PORT = 3005;

// --- Resolve __dirname (ES module compatible) ---
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ✅ Serve uploaded files publicly
// This lets you open: http://localhost:3005/uploads/employer-documents/file.pdf
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/uploads', express.static(path.join(__dirname, '../uploads'))); 
// ^ one of these will catch depending on where uploads is located; the second covers your case

// ✅ Middleware setup
app.use(cors({
  origin: function (origin, callback) {
    if (!origin) return callback(null, true); // Allow Postman, mobile apps, etc.
    return callback(null, true); // Allow all origins - adjust for production
  },
  credentials: false,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ✅ Register all routes
app.use('/auth', authRouter);
app.use('/users', userRouter);
app.use('/jobs', jobRouter);
app.use('/applications', applicationRouter);
app.use('/announcements', announcementRouter);
app.use('/verifications', verificationRouter);
app.use('/uploads', uploadRoute); // make sure Flutter hits /api/upload

// ✅ Start server
app.listen(PORT, () => {
  console.log(`✅ Server running on port ${PORT}`);
  console.log(`📂 Serving uploads from: ${path.join(__dirname, '../uploads')}`);
});
