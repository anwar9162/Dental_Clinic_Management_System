const appointmentService = require('../services/appointmentService');
const Appointment = require('../models/Appointment');
const Patient = require('../models/Patient');
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
    const appointment = await appointmentService.getAppointmentById(req.params.id);
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }
    res.status(200).json(appointment);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createAppointment = async (req, res) => {
  try {
    const newAppointment = await appointmentService.createAppointment(req.body);
    res.status(201).json(newAppointment);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateAppointment = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const appointment = await Appointment.findById(id);
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    appointment.status = status;

    await appointment.save();

    if (status === 'Completed') {
      const patientRecord = await Patient.findById(appointment.patient);
      if (patientRecord) {
        patientRecord.visitHistory.push(appointment._id);
        await patientRecord.save();
      }
    }

    res.status(200).json(appointment);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

const deleteAppointment = async (req, res) => {
  try {
    const appointment = await appointmentService.deleteAppointment(req.params.id);
    if (!appointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }
    res.status(200).json({ message: 'Appointment deleted' });
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

const getArrivedPatients = async (req, res) => {
  try {
    const patients = await appointmentService.getArrivedPatients();
    res.status(200).json(patients);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getVisitHistory = async (req, res) => {
  const { patientId } = req.params;
  try {
    const patient = await Patient.findById(patientId).populate('visitHistory');
    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }
    res.status(200).json(patient.visitHistory);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};


const addDentalChartEntry = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    patient.dentalChart.push(req.body);
    await patient.save();
    res.status(201).json({ message: 'Dental chart entry added', patient });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

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

const deleteDentalChartEntry = async (req, res) => {
  try {
    const patient = await Patient.findById(req.params.id);
    if (!patient) {
      return res.status(404).json({ message: 'Patient not found' });
    }

    patient.dentalChart.id(req.params.entryId).remove();
    await patient.save();
    res.status(200).json({ message: 'Dental chart entry deleted', patient });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};



module.exports = {
  getAllAppointments,
  getAppointmentById,
  createAppointment,
  updateAppointment,
  deleteAppointment,
  getTodaysAppointments,
  getArrivedPatients,
  getVisitHistory,
  addDentalChartEntry,
  deleteDentalChartEntry,
  getDentalChart,
};
