// routes/arrivalRoutes.js
const express = require("express");
const Arrival = require("../models/Arrival");
const Patient = require("../models/Patient");

const router = express.Router();

// Route to create a new arrival
router.post("/", async (req, res) => {
  try {
    const { patientId, arrivalTime, notes, arrivalType } = req.body;

    // Check if the patient exists
    const patient = await Patient.findById(patientId);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    // Create a new arrival record
    const arrival = new Arrival({
      patientId,
      arrivalTime,
      notes,
      arrivalType,
    });

    await arrival.save();
    res.status(201).json({ message: "Arrival marked successfully", arrival });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
});

// Route to get all arrivals for today
router.get("/today", async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);

    const arrivals = await Arrival.find({
      arrivalTime: { $gte: today, $lt: tomorrow },
     
    }).populate("patientId", "firstName lastName phoneNumber");

    res.status(200).json(arrivals);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
});

// Route to delete an arrival by ID
router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;

    // Find and delete the arrival
    const arrival = await Arrival.findByIdAndDelete(id);

    if (!arrival) {
      return res.status(404).json({ message: "Arrival not found" });
    }

    res.status(200).json({ message: "Arrival deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
});

module.exports = router;
