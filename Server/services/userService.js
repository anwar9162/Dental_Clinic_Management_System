const User = require("../models/User");
const jwt = require("jsonwebtoken");

const getAllUsers = async () => {
  return await User.find();
};

const getUserById = async (id) => {
  return await User.findById(id);
};

const createUser = async (userData) => {
  const newUser = new User(userData);
  return await newUser.save();
};

const updateUser = async (id, userData) => {
  return await User.findByIdAndUpdate(id, userData, { new: true });
};

const deleteUser = async (id) => {
  return await User.findByIdAndDelete(id);
};

const loginUser = async (username, password) => {
  const user = await User.findOne({ username });
  if (!user || !(await user.comparePassword(password))) {
    throw new Error("Invalid credentials");
  }
  const token = jwt.sign({ id: user._id, role: user.role }, "your_jwt_secret", {
    expiresIn: "1h",
  });
  return token;
};

const changePassword = async (id, oldPassword, newPassword) => {
  const user = await User.findById(id);
  if (!user) {
    throw new Error("User not found");
  }
  if (!(await user.comparePassword(oldPassword))) {
    throw new Error("Old password is incorrect");
  }
  user.password = newPassword;
  await user.save();
  return { message: "Password changed successfully" };
};

module.exports = {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  loginUser,
  changePassword,
};
