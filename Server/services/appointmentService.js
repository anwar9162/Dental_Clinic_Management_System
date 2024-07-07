const Appointment = require("../models/Appointment");

const getAllAppointments = async () => {
  return await Appointment.find();
};

const getAppointmentById = async (id) => {
  return await Appointment.findById(id);
};

const createAppointment = async (appointmentData) => {
  const newAppointment = new Appointment(appointmentData);
  return await newAppointment.save();
};

const updateAppointment = async (id, appointmentData) => {
  return await Appointment.findByIdAndUpdate(id, appointmentData, {
    new: true,
  });
};

const deleteAppointment = async (id) => {
  return await Appointment.findByIdAndDelete(id);
};

module.exports = {
  getAllAppointments,
  getAppointmentById,
  createAppointment,
  updateAppointment,
  deleteAppointment,
};
