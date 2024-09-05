const Patient = require("../models/Patient");
const Appointment = require("../models/Appointment");
const patientService = require("../services/patientService");

// Get all patients
const getAllPatients = async (req, res) => {
  try {
    const patients = await Patient.find();
    res.status(200).json(patients);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
// Get all patients with basic information
const getPatientsBasicInfo = async (req, res) => {
  try {
    const patients = await Patient.find({}, "firstName lastName phoneNumber"); // Project only required fields
    res.status(200).json(patients);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get patient by ID
const getPatientById = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id).populate(
      "visitHistory"
    );
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

    // Calculate expiration date (6 months from now)
    const sixMonthsFromNow = new Date();
    sixMonthsFromNow.setMonth(sixMonthsFromNow.getMonth() + 6);

    // Create and save the new patient with expiration date
    const newPatient = new Patient({
      ...req.body,
      cardStatus: {
        isActive: true,
        expirationDate: sixMonthsFromNow,
        notes: null,
      },
    });
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

// Add progress images
const addProgressImages = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    const { dateCaptured } = req.body;
    if (!dateCaptured || isNaN(new Date(dateCaptured).getTime())) {
      return res.status(400).json({ message: "Invalid dateCaptured format" });
    }

    const images = req.files.map((file) => ({
      dateCaptured: new Date(dateCaptured),
      assetPath: file.filename,
      type: file.mimetype,
    }));

    patient.progressImages.push(...images);
    await patient.save();

    res.status(201).json({ message: "Progress images added", patient });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Add x-ray images
const addXrayImages = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    const { dateCaptured } = req.body;
    if (!dateCaptured || isNaN(new Date(dateCaptured).getTime())) {
      return res.status(400).json({ message: "Invalid dateCaptured format" });
    }

    const images = req.files.map((file) => ({
      dateCaptured: new Date(dateCaptured),
      assetPath: file.filename,
      type: file.mimetype,
    }));

    patient.xrayImages.push(...images);
    await patient.save();

    res.status(201).json({ message: "X-ray images added", patient });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const addVisitRecord = async (req, res) => {
  try {
    const { id } = req.params;
    const visitData = req.body;

    // Log the request body
    console.log("Received visit data:", visitData);

    // Find the patient by ID
    const patient = await Patient.findById(id);
    if (!patient) {
      console.log(`Patient with ID ${id} not found`);
      const errorResponse = { message: "Patient not found" };
      console.log("Response:", errorResponse);
      return res.status(404).json(errorResponse);
    }

    // Add the new visit record to the visitHistory
    patient.visitHistory.push(visitData);
    const updatedPatient = await patient.save();

    // Log the successful response
    console.log("Response:", updatedPatient);
    res.status(201).json(updatedPatient);
  } catch (error) {
    // Log the error message
    console.error("Error adding visit record:", error.message);

    // Log the error response
    const errorResponse = { error: error.message };
    console.log("Response:", errorResponse);
    res.status(500).json(errorResponse);
  }
};

const updateVisitRecord = async (req, res) => {
  try {
    const { id, visitId } = req.params;
    const { progressNote, treatmentPlan, treatmentDone } = req.body;

    const patient = await Patient.findOne({
      _id: id,
      "visitHistory._id": visitId,
    });
    if (!patient) return res.status(404).send("Visit record not found.");

    const visit = patient.visitHistory.id(visitId);

    // Update progress notes
    if (progressNote) {
      visit.progressNotes.push({ note: progressNote });
    }

    // Update treatment plan
    if (treatmentPlan) {
      if (Array.isArray(treatmentPlan)) {
        visit.treatmentPlan.plannedTreatments = [
          ...new Set([
            ...visit.treatmentPlan.plannedTreatments,
            ...treatmentPlan,
          ]),
        ];
      } else {
        return res.status(400).send("Invalid treatmentPlan format.");
      }
    }

    // Update treatment done
    if (treatmentDone) {
      if (Array.isArray(treatmentDone.treatments)) {
        visit.treatmentDone.treatments = [
          ...new Set([
            ...visit.treatmentDone.treatments,
            ...treatmentDone.treatments,
          ]),
        ];
      } else {
        return res.status(400).send("Invalid treatmentDone.treatments format.");
      }
      if (treatmentDone.completionDate) {
        visit.treatmentDone.completionDate = treatmentDone.completionDate;
      }
    }

    await patient.save();
    res.status(200).send(visit);
  } catch (error) {
    res.status(500).send(error.message);
  }
};
const updateCardStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const cardStatusUpdates = req.body;

    // Find the patient by ID
    const patient = await Patient.findById(id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    // Update only the provided fields in the cardStatus
    if (cardStatusUpdates) {
      Object.assign(patient.cardStatus, cardStatusUpdates);
    }

    await patient.save();

    res.status(200).json(patient);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const addPastMedicalHistory = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    const entries = req.body;
    if (
      !Array.isArray(entries) ||
      entries.some((entry) => !entry.fieldName || !entry.fieldValue)
    ) {
      return res
        .status(400)
        .json({ message: "Field name and value are required for each entry" });
    }

    entries.forEach((entry) => {
      if (entry.fieldName && entry.fieldValue) {
        patient.pastMedicalHistory.push(entry);
      }
    });

    await patient.save();
    res.status(201).json({ message: "Past medical history added", patient });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const addPastDentalHistory = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }

    const entries = req.body;
    if (
      !Array.isArray(entries) ||
      entries.some((entry) => !entry.fieldName || !entry.fieldValue)
    ) {
      return res
        .status(400)
        .json({ message: "Field name and value are required for each entry" });
    }

    entries.forEach((entry) => {
      if (entry.fieldName && entry.fieldValue) {
        patient.pastDentalHistory.push(entry);
      }
    });

    await patient.save();
    res.status(201).json({ message: "Past dental history added", patient });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
const getTodaysPatient = async (req, res) => {
  try {
    const patient = await patientService.getTodaysPatient();
    res.status(200).json(patient);
  } catch (error) {
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
  addVisitRecord,
  updateCardStatus,
  addPastMedicalHistory,
  addPastDentalHistory,
  getTodaysPatient,
  updateVisitRecord,
  getPatientsBasicInfo,
};
