import express from "express";
import multer from "multer";
import path from "path";
import { fileURLToPath } from "url";

const router = express.Router();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 🔹 Directory to store uploaded employer documents
const uploadDir = path.join(__dirname, "../../uploads/employer-documents");

// 🔹 Ensure directory exists
import fs from "fs";
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// 🔹 Configure Multer storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const timestamp = Date.now();
    const random = Math.round(Math.random() * 1e9);
    const ext = path.extname(file.originalname);
    const base = path.basename(file.originalname, ext);
    const uniqueFileName = `${base}_${timestamp}_${random}${ext}`;
    cb(null, uniqueFileName);
  },
});

// 🔹 File filter (optional – for PDF/DOCX only)
const fileFilter = (req, file, cb) => {
  const allowed = [
    ".pdf",
    ".doc",
    ".docx",
    ".rtf",
    ".txt",
  ];
  const ext = path.extname(file.originalname).toLowerCase();
  if (allowed.includes(ext)) cb(null, true);
  else cb(new Error("Unsupported file type"), false);
};

// 🔹 Create Multer upload instance
const upload = multer({ storage, fileFilter });

// 🔹 POST /api/upload
router.post("/employer-docs", upload.single("file"), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    // Relative path (to be stored in DB)
    const relativePath = `uploads/employer-documents/${req.file.filename}`;

    // Return clean JSON to Flutter
    res.status(200).json({ filePath: relativePath });
  } catch (err) {
    console.error("Upload error:", err);
    res.status(500).json({ error: "File upload failed" });
  }
});

export default router;