import express from "express";
import multer from "multer";
import path from "path";
import fs from "fs";
import { fileURLToPath } from "url";

const router = express.Router();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 🔹 Base uploads directory
const baseUploadDir = path.join(__dirname, "../../uploads");

// 🔹 Ensure base directory exists
if (!fs.existsSync(baseUploadDir)) {
  fs.mkdirSync(baseUploadDir, { recursive: true });
}

// 🔹 Function to dynamically create upload folder
function ensureFolderExists(folderPath) {
  if (!fs.existsSync(folderPath)) {
    fs.mkdirSync(folderPath, { recursive: true });
  }
}

// 🔹 Common Multer storage configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    let folder = "misc";
    const type = req.params.type; // "employer" or "job-seeker"

    if (type === "employer") folder = "employer-documents";
    if (type === "job-seeker") folder = "job-seeker-documents";

    const uploadDir = path.join(baseUploadDir, folder);
    ensureFolderExists(uploadDir);

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

// 🔹 File filter – only allow documents
const fileFilter = (req, file, cb) => {
  const allowed = [".pdf", ".doc", ".docx", ".rtf", ".txt"];
  const ext = path.extname(file.originalname).toLowerCase();
  if (allowed.includes(ext)) cb(null, true);
  else cb(new Error("Unsupported file type"), false);
};

// 🔹 Create Multer upload instance
const upload = multer({ storage, fileFilter });

/**
 * POST /api/upload/:type
 * 
 * Examples:
 *  - /api/upload/employer
 *  - /api/upload/job-seeker
 */
router.post("/:type", upload.single("file"), (req, res) => {
  try {
    const { type } = req.params;

    if (!["employer", "job-seeker"].includes(type)) {
      return res.status(400).json({ error: "Invalid upload type" });
    }

    if (!req.file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    // Generate relative path for DB storage
    const folder = type === "employer" ? "employer-documents" : "job-seeker-documents";
    const relativePath = `uploads/${folder}/${req.file.filename}`;

    // Return clean JSON for Flutter
    res.status(200).json({
      message: `${type} document uploaded successfully`,
      filePath: relativePath,
    });
  } catch (err) {
    console.error("Upload error:", err);
    res.status(500).json({ error: "File upload failed" });
  }
});

export default router;
