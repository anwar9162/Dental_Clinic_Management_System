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

// Get patient by phone
const getPatientByPhone = async (req, res) => {
  try {
    const patient = await Patient.findOne({
      phoneNumber: req.params.phoneNumber,
    });
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
    const { phoneNumber } = req.body;

    // Check if a patient with the same phone number already exists
    const existingPatient = await Patient.findOne({ phoneNumber });
    if (existingPatient) {
      return res
        .status(400)
        .json({ message: "Patient with this phone number already exists" });
    }

    // Create and save the new patient
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
      return res.status(404).json({ message: "Patient not found" });
    }

    const { toothNumber, condition, treatment, date } = req.body;
    const toothEntry = patient.dentalChart.find(
      (entry) => entry.toothNumber === toothNumber
    );

    if (toothEntry) {
      toothEntry.notes.push({ condition, treatment, date });
    } else {
      patient.dentalChart.push({
        toothNumber,
        notes: [{ condition, treatment, date }],
      });
    }

    await patient.save();
    res.status(201).json({ message: "Dental chart entry added", patient });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get dental chart for a patient
const getDentalChart = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
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
      return res.status(404).json({ message: "Patient not found" });
    }

    const toothEntry = patient.dentalChart.find(
      (entry) => entry.toothNumber === req.params.toothNumber
    );
    if (!toothEntry) {
      return res.status(404).json({ message: "Tooth entry not found" });
    }

    const noteIndex = toothEntry.notes.findIndex(
      (note) => note._id.toString() === req.params.entryId
    );
    if (noteIndex === -1) {
      return res.status(404).json({ message: "Note not found" });
    }

    toothEntry.notes.splice(noteIndex, 1);

    // If the tooth entry has no more notes, remove the entire tooth entry
    if (toothEntry.notes.length === 0) {
      patient.dentalChart = patient.dentalChart.filter(
        (entry) => entry.toothNumber !== req.params.toothNumber
      );
    }

    await patient.save();
    res.status(200).json({ message: "Dental chart entry deleted", patient });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update dental chart entry
const updateDentalChartEntry = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    const toothEntry = patient.dentalChart.find(
      (entry) => entry.toothNumber === req.params.toothNumber
    );
    if (!toothEntry) {
      return res.status(404).json({ message: "Tooth entry not found" });
    }

    const note = toothEntry.notes.id(req.params.entryId);
    if (!note) {
      return res.status(404).json({ message: "Note not found" });
    }

    // Update the note with the new data from the request body
    note.condition = req.body.condition || note.condition;
    note.treatment = req.body.treatment || note.treatment;
    note.date = req.body.date || note.date;

    await patient.save();
    res.status(200).json({ message: "Dental chart entry updated", patient });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Add a payment to a patient's record
const addPayment = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    const { amount, date, status, reason } = req.body;
    patient.payments.push({ amount, date, status, reason });

    await patient.save();
    res.status(201).json({ message: "Payment added", patient });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update the status and reason of a payment
const updatePayment = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    const payment = patient.payments.id(req.params.paymentId);
    if (!payment) {
      return res.status(404).json({ message: "Payment not found" });
    }

    if (req.body.status) {
      payment.status = req.body.status;
    }
    if (req.body.reason) {
      payment.reason = req.body.reason;
    }

    await patient.save();
    res.status(200).json({ message: "Payment updated", patient });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const addProgressImages = async (req, res) => {
  console.log("Received request to add progress images.");

  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      console.log("Patient not found.");
      return res.status(404).json({ message: "Patient not found" });
    }

    console.log("Patient found:", patient._id);

    // Extract dateCaptured from the request body
    const { dateCaptured } = req.body;

    // Validate dateCaptured
    if (!dateCaptured || isNaN(new Date(dateCaptured).getTime())) {
      console.log("Invalid dateCaptured format:", dateCaptured);
      return res.status(400).json({ message: "Invalid dateCaptured format" });
    }

    console.log("Valid dateCaptured:", dateCaptured);

    // Map uploaded files to include dateCaptured and only filename
    const images = req.files.map((file) => {
      console.log("Processing file:", file.originalname);
      return {
        dateCaptured: new Date(dateCaptured),
        assetPath: file.filename, // Store only the filename
        type: file.mimetype, // MIME type of the uploaded file
      };
    });

    patient.progressImages.push(...images);
    await patient.save();

    console.log("Progress images added successfully.");
    res.status(201).json({ message: "Progress images added", patient });
  } catch (error) {
    console.error("Error adding progress images:", error);
    res.status(500).json({ error: error.message });
  }
};

const addXrayImages = async (req, res) => {
  console.log("Received request to add x-ray images.");

  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      console.log("Patient not found.");
      return res.status(404).json({ message: "Patient not found" });
    }

    console.log("Patient found:", patient._id);

    // Extract dateCaptured from the request body
    const { dateCaptured } = req.body;

    // Validate dateCaptured
    if (!dateCaptured || isNaN(new Date(dateCaptured).getTime())) {
      console.log("Invalid dateCaptured format:", dateCaptured);
      return res.status(400).json({ message: "Invalid dateCaptured format" });
    }

    console.log("Valid dateCaptured:", dateCaptured);

    // Map uploaded files to include dateCaptured and only filename
    const images = req.files.map((file) => {
      console.log("Processing file:", file.originalname);
      return {
        dateCaptured: new Date(dateCaptured),
        assetPath: file.filename, // Store only the filename
        type: file.mimetype, // MIME type of the uploaded file
      };
    });

    patient.xrayImages.push(...images);
    await patient.save();

    console.log("X-ray images added successfully.");
    res.status(201).json({ message: "X-ray images added", patient });
  } catch (error) {
    console.error("Error adding x-ray images:", error);
    res.status(500).json({ error: error.message });
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
  getPatientByPhone,
  addPayment,
  updatePayment,
  addProgressImages,
  addXrayImages,
};
