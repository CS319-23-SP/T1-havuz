const express = require('express');
const router = express.Router();
const Admin = require('../models/admin');


router.post('/login', async (req, res) => {
    const id = req.body.id;
    const enteredPassword = req.body.password;

    try {
        const existingAdmin = await Admin.findOne({ id: id });

        if (existingAdmin) {
            if (enteredPassword === existingAdmin.password) {
                return res.status(200).json("Successful admin login");
            } else {
                return res.status(400).json("Admin Login Error: id:${id} has different password than ${enteredPassword}");
            }
        } else {
            const existingStudent = await Student.findOne({ id: id });

            if (existingStudent) {
                if (enteredPassword === existingStudent.password) {
                    return res.status(201).json("Successful student login");
                } else {
                    return res.status(400).json("Student Login Error: id:${id} has different password than ${enteredPassword}");
                }
            } else {
                return res.status(404).json({ error: "Account not found" });
            }
        }
    } catch (error) {
        return res.status(500).json({ error: "Something went wrong while trying to authenticate" });
    }
});




app.patch('/changepassword', async (req, res) => {
    const id = req.body.id;
    const newPassword = req.body.password;

    try {
        const existingAdmin = await Admin.findOne({ id: id });

        if (existingAdmin) {
            await Admin.updateOne({ id: id }, { $set: { password: newPassword } });
            return res.status(200).json("Password of admin updated");
        } else {
            const existingStudent = await Student.findOne({ id: id });

            if (existingStudent) {
                await Student.updateOne({ id: id }, { $set: { password: newPassword } });
                return res.status(200).json("Password of student updated");
            } else {
                return res.status(404).json({ error: "Account not found" });
            }
        }
    } catch (error) {
        return res.status(500).json({ error: "Something went wrong while trying to update password" });
    }
});



module.exports = router

