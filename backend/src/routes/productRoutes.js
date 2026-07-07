// backend/src/routes/productRoutes.js
const express = require('express');
const { getProducts, getProductById, getProductsByArtisan } = require('../controllers/productController');
const router = express.Router();

// All product routes are public — no auth needed to browse
router.get('/',                         getProducts);
router.get('/artisan/:artisanId',       getProductsByArtisan);
router.get('/:id',                      getProductById);

module.exports = router;