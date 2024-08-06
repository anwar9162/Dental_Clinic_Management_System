const multer = require("multer");
const path = require("path");

// Define the MIME type to file extension mapping
const mimeToExt = {
  "image/jpeg": "jpg",
  "image/png": "png",
  "image/gif": "gif",
  // Add more MIME types if needed
};

const storage = multer.diskStorage({
  destination: function (_req, _file, cb) {
    console.log('Setting upload destination to "Images" folder.');
    cb(null, "Images"); // Folder where images will be saved
  },
  filename: function (_req, file, cb) {
    // Determine the file extension based on the MIME type
    const ext = mimeToExt[file.mimetype] || "jpg"; // Default to 'jpg' if type is not mapped
    // Generate a unique file name
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    // Create the file name with extension
    const fileName = `${uniqueSuffix}.${ext}`;

    console.log("Generated File Name:", fileName);
    console.log("File Extension:", ext);

    cb(null, fileName);
  },
});

const fileFilter = (req, file, cb) => {
  if (mimeToExt[file.mimetype]) {
    console.log("File type is valid:", file.mimetype);
    cb(null, true);
  } else {
    console.log("Invalid file type:", file.mimetype);
    cb(new Error("Invalid file type. Only images are allowed."));
  }
};

const upload = multer({
  storage: storage,
  fileFilter: fileFilter, // Add fileFilter to multer configuration
});

module.exports = upload;
