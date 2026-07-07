const express = require('express');
const cors = require('cors');
require('dotenv').config();
const authRoutes = require('./routes/authRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const productRoutes  = require('./routes/productRoutes');


// Import database connection
const pool = require('./config/db');

const app = express();
const port = process.env.PORT || 5000;

// --- Middleware ---
app.use(cors()); // Allow your Flutter app to make requests
app.use(express.json()); // Parse JSON request bodies
app.use('/api/auth', authRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/products',   productRoutes);
// --- Basic Test Route ---
app.get('/', (req, res) => {
    res.send('CraftGo API is running!');
});

// --- Test Database Route ---
app.get('/api/test-db', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.json({ success: true, time: result.rows[0] });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ success: false, error: 'Database connection failed' });
    }
});

// --- Start the Server ---
app.listen(port, () => {
    console.log(`🚀 CraftGo backend is running on http://localhost:${port}`);
});