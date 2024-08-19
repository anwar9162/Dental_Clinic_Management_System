const Appointment = require("../models/Appointment");

const getAllAppointments = async () => {
  return await Appointment.find().populate('patient').populate('doctor');
};

const getAppointmentById = async (id) => {
  return await Appointment.findById(id);
};

const createAppointment = async (appointmentData) => {
  const newAppointment = new Appointment(appointmentData);
  const savedAppointment = await newAppointment.save();

  const populatedAppointment = await Appointment.findById(savedAppointment._id)
    .populate('patient') // Ensure 'patient' is a valid reference
    .populate('doctor');  // Ensure 'doctor' is a valid reference

  console.log('Populated Appointment:', populatedAppointment); // Debug line

  return populatedAppointment; // Return the populated appointment
};

const updateAppointment = async (id, appointmentData) => {
  return await Appointment.findByIdAndUpdate(id, appointmentData, {
    new: true,
  });
};

const deleteAppointment = async (id) => {
  return await Appointment.findByIdAndDelete(id);
};


const getTodaysAppointments = async () => {

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);
console.log(today);
  return await Appointment.find({
    date: { $gte: today, $lt: tomorrow },
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
 
  getVisitHistory,

};
