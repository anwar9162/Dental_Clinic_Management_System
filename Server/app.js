const express = require("express");
const connectDB = require("./config/db");
const path = require("path"); // Add this line
const cors = require("cors");
const patientRoutes = require("./routes/patientRoutes");
const doctorRoutes = require("./routes/doctorRoutes");
const appointmentRoutes = require("./routes/appointmentRoutes");
const userRoutes = require("./routes/userRoutes");
const arrivalRoutes = require("./routes/arrivalRoutes");
require("dotenv").config();

const app = express();

app.use(cors()); // Allows all origins
// Connect to database
connectDB();

// Middleware
app.use(express.json());

// Serve static files from the 'public' directory
app.use("/images", express.static(path.join(__dirname, "Images")));

// Routes
app.use("/api/patients", patientRoutes);
app.use("/api/doctors", doctorRoutes);
app.use("/api/appointments", appointmentRoutes);
app.use("/api/users", userRoutes);
app.use("/api/arrivals", arrivalRoutes); // Use arrival routes

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
