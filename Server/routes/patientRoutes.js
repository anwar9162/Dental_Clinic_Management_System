const express = require("express");
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

router.post('/:id/dental-chart', addDentalChartEntry);
router.get('/:id/dental-chart', getDentalChart);
router.delete('/:id/dental-chart/:toothNumber/:entryId', deleteDentalChartEntry);
router.put('/:id/dental-chart/:toothNumber/:entryId', updateDentalChartEntry);

router.post('/:id/payments', addPayment); // Route to add payment
router.put('/:id/payments/:paymentId', updatePayment); // Route to update payment

router.post('/:id/progress-images', addProgressImages); // Route to add progress images
router.post('/:id/xray-images', addXrayImages); // Route to add xray images


module.exports = router;
