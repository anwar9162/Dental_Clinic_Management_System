const appointmentService = require("../services/appointmentService");
const Appointment = require("../models/Appointment");
const Patient = require("../models/Patient");

const getAllAppointments = async (req, res) => {
  try {
    const appointments = await appointmentService.getAllAppointments();
    res.status(200).json(appointments);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getAppointmentById = async (req, res) => {
  try {
    const appointment = await appointmentService.getAppointmentById(
      req.params.id
    );
    if (!appointment) {
      return res.status(404).json({ message: "Appointment not found" });
    }
    res.status(200).json(appointment);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createAppointment = async (req, res) => {
  try {
    console.log("Creating appointment");
    console.log(`Body: ${JSON.stringify(req.body)}`);
    const newAppointment = await appointmentService.createAppointment(req.body);
    res.status(201).json(newAppointment);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateAppointment = async (req, res) => {
  const { id } = req.params;
  const { status, newNotes } = req.body; // Assume newNotes is an array of note objects

  try {
    const appointment = await Appointment.findById(id);
    if (!appointment) {
      return res.status(404).json({ message: "Appointment not found" });
    }

    // Update the status
    if (status) {
      appointment.status = status;

      // If status is changed to 'Completed', update patient visit history
      if (status === "Completed") {
        const patientRecord = await Patient.findById(appointment.patient);
        if (patientRecord) {
          patientRecord.visitHistory.push(appointment._id);
          await patientRecord.save();
        }
      }
    }

    // Add new notes
    if (newNotes && Array.isArray(newNotes)) {
      appointment.notes.push(
        ...newNotes.map((note) => ({
          content: note.content,
          createdAt: note.createdAt || Date.now(), // Use provided createdAt or default to now
        }))
      );
    }

    // Save the updated appointment
    await appointment.save();

    res.status(200).json(appointment);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal server error" });
  }
};

const deleteAppointment = async (req, res) => {
  try {
    const appointment = await appointmentService.deleteAppointment(
      req.params.id
    );
    if (!appointment) {
      return res.status(404).json({ message: "Appointment not found" });
    }
    res.status(200).json({ message: "Appointment deleted" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getTodaysAppointments = async (req, res) => {
  try {
    const appointments = await appointmentService.getTodaysAppointments();
    res.status(200).json(appointments);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getVisitHistory = async (req, res) => {
  const { patientId } = req.params;
  try {
    const patient = await Patient.findById(patientId).populate("visitHistory");
    if (!patient) {
      return res.status(404).json({ message: "Patient not found" });
    }
    res.status(200).json(patient.visitHistory);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

module.exports = {
  getAllAppointments,
  getAppointmentById,
  createAppointment,
  updateAppointment,
  deleteAppointment,
  getTodaysAppointments,
  getVisitHistory,
};
