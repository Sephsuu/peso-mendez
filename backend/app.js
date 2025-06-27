import express from 'express';
import cors from 'cors';
import authRouter from './src/routes/auth.route.js';
import userRouter from './src/routes/user.route.js';
import jobRouter from './src/routes/job.route.js';
import applicationRouter from './src/routes/application.route.js';

const secret = 'your-static-development-secret-key-here';

const app = express();

app.use(cors({
  origin: function (origin, callback) {
    if (!origin) return callback(null, true); // Allow Postman, mobile apps, etc.
    return callback(null, true); // Allow all origins - adjust for production
  },
  credentials: false, // JWT does not require credentials: true
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'], // Include Authorization header
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const PORT = 3005;

app.use('/auth', authRouter);
app.use('/users', userRouter);
app.use('/jobs', jobRouter);
app.use('/applications', applicationRouter);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});