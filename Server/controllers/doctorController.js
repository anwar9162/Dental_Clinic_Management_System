const doctorService = require('../services/doctorService');

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
      return res.status(404).json({ message: 'Doctor not found' });
    }
    res.status(200).json(doctor);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createDoctor = async (req, res) => {
  try {
    const { name, specialty, contactInfo, username, password } = req.body;

    // Ensure all required fields are provided
    if (!name || !specialty || !contactInfo || !username || !password) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    // Create a new doctor
    const newDoctor = await doctorService.createDoctor({
      name,
      specialty,
      contactInfo,
      username,
      password
    });

    res.status(201).json(newDoctor);
  } catch (error) {
    // Handle duplicate username error
    if (error.message === 'Username already exists') {
      return res.status(400).json({ error: 'Username already exists' });
    }
    res.status(500).json({ error: error.message });
  }
};

const updateDoctor = async (req, res) => {
  try {
    const { name, specialty, contactInfo, username, password } = req.body;

    // Ensure at least one field is provided for update
    if (!name && !specialty && !contactInfo && !username && !password) {
      return res.status(400).json({ error: 'At least one field is required for update' });
    }

    // Update doctor
    const updatedDoctor = await doctorService.updateDoctor(req.params.id, {
      name,
      specialty,
      contactInfo,
      username,
      password
    });

    if (!updatedDoctor) {
      return res.status(404).json({ message: 'Doctor not found' });
    }
    res.status(200).json(updatedDoctor);
  } catch (error) {
    // Handle duplicate username error
    if (error.message === 'Username already exists') {
      return res.status(400).json({ error: 'Username already exists' });
    }
    res.status(500).json({ error: error.message });
  }
};

const deleteDoctor = async (req, res) => {
  try {
    const doctor = await doctorService.deleteDoctor(req.params.id);
    if (!doctor) {
      return res.status(404).json({ message: 'Doctor not found' });
    }
    res.status(200).json({ message: 'Doctor deleted' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const loginDoctor = async (req, res) => {
  try {
    const { username, password } = req.body;
    const token = await doctorService.loginDoctor(username, password);
    res.status(200).json({ token });
  } catch (error) {
    res.status(401).json({ error: error.message });
  }
};

module.exports = {
  getAllDoctors,
  getDoctorById,
  createDoctor,
  updateDoctor,
  deleteDoctor,
  loginDoctor
};
