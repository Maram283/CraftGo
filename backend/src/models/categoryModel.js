const pool = require('../config/db');

// Get all active categories
const getAllCategories = async () => {
  const result = await pool.query(`
    SELECT id, name, name_ar, description, icon_url
    FROM categories
    WHERE is_active = true
    ORDER BY display_order, name
  `);
  return result.rows;
};

// Get one category by id
const getCategoryById = async (id) => {
  const result = await pool.query(
    'SELECT * FROM categories WHERE id = $1 AND is_active = true',
    [id]
  );
  return result.rows[0];
};

module.exports = { getAllCategories, getCategoryById };