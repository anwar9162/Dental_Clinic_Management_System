const express = require("express");
const upload = require("../helpers/uploadHelper"); // Import the upload helper
const {
  getAllPatients,
  getPatientById,
  createPatient,
  updatePatient,
  deletePatient,
  addDentalChartEntry,
  getDentalChart,
  deleteDentalChartEntry,
  updateDentalChartEntry,
  getPatientByPhone,
  addPayment,
  updatePayment,
  addProgressImages,
  addXrayImages,
} = require("../controllers/patientController");

const router = express.Router();

router.get("/", getAllPatients);
router.get("/:id", getPatientById);
router.get("/phone-number/:phoneNumber", getPatientByPhone);
router.post("/", createPatient);
router.put("/:id", updatePatient);
router.delete("/:id", deletePatient);

router.post("/:id/dental-chart", addDentalChartEntry);
router.get("/:id/dental-chart", getDentalChart);
router.delete(
  "/:id/dental-chart/:toothNumber/:entryId",
  deleteDentalChartEntry
);
router.put("/:id/dental-chart/:toothNumber/:entryId", updateDentalChartEntry);

router.post("/:id/payments", addPayment);
router.put("/:id/payments/:paymentId", updatePayment);

// Use multer middleware for file uploads and include dateCaptured in request body
router.post(
  "/:id/progress-images",
  upload.array("progressImages"),
  addProgressImages
);
router.post("/:id/xray-images", upload.array("xrayImages"), addXrayImages);

module.exports = router;
