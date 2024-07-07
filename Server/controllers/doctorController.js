const doctorService = require("../services/doctorService");

const getAllDoctors = async (req, res) => {
  try {
    const doctors = await doctorService.getAllDoctors();
    res.status(200).json(doctors);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getDoctorById = async (req, res) => {
  try {
    const doctor = await doctorService.getDoctorById(req.params.id);
    if (!doctor) {
      return res.status(404).json({ message: "Doctor not found" });
    }
    res.status(200).json(doctor);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createDoctor = async (req, res) => {
  try {
    const newDoctor = await doctorService.createDoctor(req.body);
    res.status(201).json(newDoctor);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateDoctor = async (req, res) => {
  try {
    const doctor = await doctorService.updateDoctor(req.params.id, req.body);
    if (!doctor) {
      return res.status(404).json({ message: "Doctor not found" });
    }
    res.status(200).json(doctor);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteDoctor = async (req, res) => {
  try {
    const doctor = await doctorService.deleteDoctor(req.params.id);
    if (!doctor) {
      return res.status(404).json({ message: "Doctor not found" });
    }
    res.status(200).json({ message: "Doctor deleted" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getAllDoctors,
  getDoctorById,
  createDoctor,
  updateDoctor,
  deleteDoctor,
};
