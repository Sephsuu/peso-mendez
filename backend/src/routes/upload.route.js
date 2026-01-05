import express from "express";
import multer from "multer";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

const router = express.Router();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const uploadDir = path.join(__dirname, "../../uploads/employer-documents");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

const jobSeekerDir = path.join(__dirname, "../../uploads/job-seeker-documents");
if (!fs.existsSync(jobSeekerDir)) fs.mkdirSync(jobSeekerDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, uploadDir),
  filename: (req, file, cb) => {
    const unique = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, unique + path.extname(file.originalname));
  },
});

const jobSeeekerStorage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, jobSeekerDir),
  filename: (req, file, cb) => {
    const unique = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, unique + path.extname(file.originalname));
  },
});

const upload = multer({ storage });

const documentFields = [
  "letter_of_intent",
  "company_profile",
  "business_permit",
  "mayors_permit",
  "sec_registration",
  "poea_dmw_registration",
  "approved_job_order",
  "job_vacancies",
  "philjobnet_accreditation",
  "dole_certificate_of_no_pending_case"
];

router.post(
  "/employer/formdata",
  upload.fields(documentFields.map(f => ({ name: f }))),
  async (req, res) => {
    try {
      const { employerId } = req.body;
      if (!employerId) {
        return res.status(400).json({ error: "Missing employerId" });
      }

      const payload = { employerId };
      for (const field of documentFields) {
        payload[field] = req.files[field]
          ? `uploads/employer-documents/${req.files[field][0].filename}`
          : null;
      }

      res.json({
        success: true,
        message: "Documents uploaded!",
        data: payload,
      });

    } catch (err) {
      console.error("FormData Error:", err);
      res.status(500).json({ error: "Upload failed" });
    }
  }
);

const jobSeekerUpload = multer({ storage: jobSeeekerStorage }); // job seeker

router.post(
  "/job-seeker/resume",
  jobSeekerUpload.single("document"),
  async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "No file uploaded" });
      }

      const filePath = `uploads/job-seeker-documents/${req.file.filename}`;

      res.json({
        success: true,
        message: "Resume uploaded successfully!",
        filePath
      });

    } catch (err) {
      console.error("Resume Upload Error:", err);
      res.status(500).json({ error: "Upload failed" });
    }
  }
);


export default router;
