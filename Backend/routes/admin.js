const express = require('express');
const mongoose = require('mongoose')
const router = express.Router();
const Admin = require('../models/admin');
const Auth = require('../models/auth')


router.post('/', async (req, res) => {
    const admin = new Admin({
        id: req.body.id,
        firstName: req.body.firstName,
        middleName: req.body.middleName,
        lastName: req.body.lastName,
        title: req.body.title,
    });
    const auth = new Auth({
        id: req.body.id,
        password: req.body.password ? req.body.password : "amdin",
        role: "admin"
    });

    try {
        const existingAdmin = await Admin.findOne({ id: admin.id });
        if (existingAdmin) {
            return res.status(400).json({ error: `Admin with the id ${admin.id} exists` });
        }
        
        const adminResult = await admin.save();
        const authResult = await auth.save();

        res.status(201).json(adminResult);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});



module.exports = router