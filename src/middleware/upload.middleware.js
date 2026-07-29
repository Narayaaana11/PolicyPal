const multer = require('multer');
const path = require('path');

// Use memory storage — we process the buffer directly without saving to disk
const storage = multer.memoryStorage();

// File filter: only allow PDF files
const fileFilter = (req, file, cb) => {
  const allowedMimeTypes = ['application/pdf'];
  const allowedExtensions = ['.pdf'];
  const ext = path.extname(file.originalname).toLowerCase();

  if (allowedMimeTypes.includes(file.mimetype) && allowedExtensions.includes(ext)) {
    cb(null, true);
  } else {
    cb(new Error('Only PDF files are allowed. Please upload a valid .pdf document.'), false);
  }
};

// Configure multer for single PDF upload
const uploadPDF = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 10 * 1024 * 1024, // 10 MB max
    files: 1,
  },
});

module.exports = { uploadPDF };
