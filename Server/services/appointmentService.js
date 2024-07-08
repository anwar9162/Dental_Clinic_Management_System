const Appointment = require('../models/appointment');
const Patient = require('../models/Patient');

const getTodaysAppointments = async () => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);

  return await Appointment.find({
    date: { $gte: today, $lt: tomorrow },
  }).populate('patient').populate('doctor');
};

const getArrivedPatients = async () => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);

  return await Appointment.find({
    date: { $gte: today, $lt: tomorrow },
    status: 'Arrived',
  }).populate('patient').populate('doctor');
};

const getVisitHistory = async (patientId) => {
  return await Appointment.find({
    patient: patientId,
  }).populate('doctor').sort({ date: -1 });
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
};
