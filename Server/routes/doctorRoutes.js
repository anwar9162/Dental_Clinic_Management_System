const express = require("express");
const {
  getAllDoctors,
  getDoctorById,
  createDoctor,
  updateDoctor,
  deleteDoctor,
  loginDoctor,
} = require("../controllers/doctorController");

const router = express.Router();

router.get("/", getAllDoctors);
router.get("/:id", getDoctorById);
router.post("/", createDoctor);
router.put("/:id", updateDoctor);
router.delete("/:id", deleteDoctor);

// New route for doctor login
router.post('/login', loginDoctor);

module.exports = router;
