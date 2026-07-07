// backend/src/controllers/productController.js
const productModel = require('../models/productModel');

// GET /api/products
// Query params: categoryId, search, sort, limit, offset
const getProducts = async (req, res) => {
  try {
    const { categoryId, search, sort, limit, offset } = req.query;
    const products = await productModel.getProducts({
      categoryId,
      search,
      sort,
      limit: limit ? parseInt(limit) : 20,
      offset: offset ? parseInt(offset) : 0,
    });
    res.json({ success: true, products });
  } catch (err) {
    console.error('getProducts error:', err.message);
    res.status(500).json({ success: false, error: 'Server error' });
  }
};

// GET /api/products/:id
const getProductById = async (req, res) => {
  try {
    const product = await productModel.getProductById(req.params.id);
    if (!product) {
      return res.status(404).json({ success: false, error: 'Product not found' });
    }
    // Fire-and-forget view increment — don't await, don't fail the request if it errors
    productModel.incrementViewCount(req.params.id).catch(() => {});
    res.json({ success: true, product });
  } catch (err) {
    console.error('getProductById error:', err.message);
    res.status(500).json({ success: false, error: 'Server error' });
  }
};

// GET /api/products/artisan/:artisanId
const getProductsByArtisan = async (req, res) => {
  try {
    const products = await productModel.getProductsByArtisan(req.params.artisanId);
    res.json({ success: true, products });
  } catch (err) {
    console.error('getProductsByArtisan error:', err.message);
    res.status(500).json({ success: false, error: 'Server error' });
  }
};

module.exports = { getProducts, getProductById, getProductsByArtisan };