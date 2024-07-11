// controllers/patientController.js

const Patient = require("../models/Patient");

// Get all patients
const getAllPatients = async (req, res) => {
  try {
    const patients = await Patient.find();
    res.status(200).json(patients);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get patient by ID
const getPatientById = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }
    res.status(200).json(patient);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Create new patient
const createPatient = async (req, res) => {
  try {
    console.log(req.body); // Log the request body
    const newPatient = new Patient(req.body);
    await newPatient.save();
    res.status(201).json(newPatient);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update patient
const updatePatient = async (req, res) => {
  try {
    const updatedPatient = await Patient.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedPatient) {
      return res.status(404).json({ message: "Patient not found" });
    }
    res.status(200).json(updatedPatient);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete patient
const deletePatient = async (req, res) => {
  try {
    const deletedPatient = await Patient.findByIdAndDelete(req.params.id);
    if (!deletedPatient) {
      return res.status(404).json({ message: "Patient not found" });
    }
    res.status(200).json({ message: "Patient deleted" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Add a dental chart entry
const addDentalChartEntry = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    const { toothNumber, condition, treatment, date } = req.body;
    const toothEntry = patient.dentalChart.find(entry => entry.toothNumber === toothNumber);

    if (toothEntry) {
      toothEntry.notes.push({ condition, treatment, date });
    } else {
      patient.dentalChart.push({
        toothNumber,
        notes: [{ condition, treatment, date }]
      });
    }

    await patient.save();
    res.status(201).json({ message: 'Dental chart entry added', patient });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get dental chart for a patient
const getDentalChart = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    res.status(200).json(patient.dentalChart);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete dental chart entry
const deleteDentalChartEntry = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    const toothEntry = patient.dentalChart.find(entry => entry.toothNumber === req.params.toothNumber);
    if (!toothEntry) {
      return res.status(404).json({ message: 'Tooth entry not found' });
    }

    const noteIndex = toothEntry.notes.findIndex(note => note._id.toString() === req.params.entryId);
    if (noteIndex === -1) {
      return res.status(404).json({ message: 'Note not found' });
    }

    toothEntry.notes.splice(noteIndex, 1);

    // If the tooth entry has no more notes, remove the entire tooth entry
    if (toothEntry.notes.length === 0) {
      patient.dentalChart = patient.dentalChart.filter(entry => entry.toothNumber !== req.params.toothNumber);
    }

    await patient.save();
    res.status(200).json({ message: 'Dental chart entry deleted', patient });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update dental chart entry
const updateDentalChartEntry = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    const toothEntry = patient.dentalChart.find(entry => entry.toothNumber === req.params.toothNumber);
    if (!toothEntry) {
      return res.status(404).json({ message: 'Tooth entry not found' });
    }

    const note = toothEntry.notes.id(req.params.entryId);
    if (!note) {
      return res.status(404).json({ message: 'Note not found' });
    }

    // Update the note with the new data from the request body
    note.condition = req.body.condition || note.condition;
    note.treatment = req.body.treatment || note.treatment;
    note.date = req.body.date || note.date;

    await patient.save();
    res.status(200).json({ message: 'Dental chart entry updated', patient });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

module.exports = {
  getAllPatients,
  getPatientById,
  createPatient,
  updatePatient,
  deletePatient,
  addDentalChartEntry,
  deleteDentalChartEntry,
  getDentalChart,
  updateDentalChartEntry,
};
