// backend/src/controllers/categoryController.js
const categoryModel = require('../models/categoryModel');

const getCategories = async (req, res) => {
  try {
    const categories = await categoryModel.getAllCategories();
    res.json({ success: true, categories });
  } catch (err) {
    console.error('getCategories error:', err.message);
    res.status(500).json({ success: false, error: 'Server error' });
  }
};

module.exports = { getCategories };