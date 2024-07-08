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
} = require("../controllers/patientController");

const router = express.Router();

router.get("/", getAllPatients);
router.get("/:id", getPatientById);
router.post("/", createPatient);
router.put("/:id", updatePatient);
router.delete("/:id", deletePatient);

router.post('/:id/dental-chart', addDentalChartEntry);
router.get('/:id/dental-chart', getDentalChart);
router.delete('/:id/dental-chart/:entryId', deleteDentalChartEntry);

module.exports = router;
