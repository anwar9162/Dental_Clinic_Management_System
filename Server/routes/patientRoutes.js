const express = require("express");
const upload = require("../helpers/uploadHelper"); // Import the upload helper
const {
  getAllPatients,
  getPatientsBasicInfo,
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
  addVisitRecord,
  updateCardStatus,
  addPastDentalHistory,
  addPastMedicalHistory,
  getTodaysPatient,
  updateVisitRecord,
} = require("../controllers/patientController");

const router = express.Router();

// Basic patient routes
router.get("/", getAllPatients);
router.get("/basicpatientinfo", getPatientsBasicInfo);
router.get("/:id", getPatientById);
router.get("/phone-number/:phoneNumber", getPatientByPhone);
router.post("/", createPatient);
router.put("/:id", updatePatient);
router.delete("/:id", deletePatient);

// Dental chart routes
router.post("/:id/dental-chart", addDentalChartEntry);
router.get("/:id/dental-chart", getDentalChart);
router.delete(
  "/:id/dental-chart/:toothNumber/:entryId",
  deleteDentalChartEntry
);
router.put("/:id/dental-chart/:toothNumber/:entryId", updateDentalChartEntry);

// Payment routes
router.post("/:id/payments", addPayment);
router.put("/:id/payments/:paymentId", updatePayment);

// File upload routes
router.post(
  "/:id/progress-images",
  upload.array("progressImages"),
  addProgressImages
);
router.post("/:id/xray-images", upload.array("xrayImages"), addXrayImages);

// New routes
router.post("/:id/visit-records", addVisitRecord);

router.put("/:id/visit-records/:visitId", updateVisitRecord); // Updated route

router.put("/:id/card-status", updateCardStatus);

// Add past dental/medical history
router.post("/:id/past-medical-history", addPastMedicalHistory);
router.post("/:id/past-dental-history", addPastDentalHistory);

router.get("/today/patients", getTodaysPatient);

module.exports = router;
