const express = require('express');
const router = express.Router();
const Admin = require('../models/admin');


router.post('/', async (req, res) => {
    const admin = new Admin({
        id: req.body.id,
        firstName: req.body.firstName,
        middleName: req.body.middleName,
        lastName: req.body.lastName,
        title: req.body.title,
    });

    try {
        const existingAdmin = await Admin.findOne({ id: admin.id });
        if (existingAdmin) {
            return res.status(400).json({ error: `Admin with the id ${admin.id} exists` });
        }
        
        const result = await admin.save();
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});



module.exports = router