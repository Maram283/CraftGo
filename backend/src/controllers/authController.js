const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const userModel = require('../models/userModel');
require('dotenv').config();

// ─── REGISTER ─────────────────────────────────────────────────────────────────
const register = async (req, res) => {
    const { email, password, full_name, phone, role } = req.body;

    // Basic validation
    if (!email || !password || !full_name) {
        return res.status(400).json({ success: false, error: 'email, password and full_name are required' });
    }

    try {
        const existingUser = await userModel.findUserByEmail(email);
        if (existingUser) {
            return res.status(400).json({ success: false, error: 'User already exists' });
        }

        const salt = await bcrypt.genSalt(10);
        const passwordHash = await bcrypt.hash(password, salt);

        const newUser = await userModel.createUser(email, passwordHash, full_name, phone, role);

        const token = jwt.sign(
            { userId: newUser.id, email: newUser.email, role: newUser.role },
            process.env.JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.status(201).json({ success: true, user: newUser, token });
    } catch (error) {
        console.error('Register error:', error.message);
        res.status(500).json({ success: false, error: 'Server error' });
    }
};

// ─── LOGIN ────────────────────────────────────────────────────────────────────
const login = async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ success: false, error: 'email and password are required' });
    }

    try {
        const user = await userModel.findUserByEmail(email);
        if (!user) {
            return res.status(401).json({ success: false, error: 'Invalid credentials' });
        }

        const valid = await bcrypt.compare(password, user.password_hash);
        if (!valid) {
            return res.status(401).json({ success: false, error: 'Invalid credentials' });
        }

        const token = jwt.sign(
            { userId: user.id, email: user.email, role: user.role },
            process.env.JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.json({
            success: true,
            user: {
                id: user.id,
                email: user.email,
                full_name: user.full_name,
                role: user.role,
            },
            token,
        });
    } catch (error) {
        console.error('Login error:', error.message);
        res.status(500).json({ success: false, error: 'Server error' });
    }
};

// ─── EXPORTS ──────────────────────────────────────────────────────────────────
// FIX: login was defined but not exported in the original file
module.exports = { register, login };