const express = require('express');
const router = express.Router();
const Auth = require('../models/auth'); 

router.post('/login', async (req, res) => {
    const { id, password, role } = req.body;

    try {
        const auth = await Auth.findOne({ id: id});
        const role = auth.role;


        if (auth) {
            if (password === auth.password) {
                return res.status(200).json({ message: `Successful ${role} login`, role: role});
            } else {
                return res.status(400).json({ error: `Incorrect password for with id: ${id}` });
            }
        } else {
            return res.status(404).json({ error: "Account not found" });
        }
    } catch (error) {
        return res.status(500).json({ error: "Something went wrong while trying to authenticate" });
    }
});



router.patch('/changepassword', async (req, res) => {
    const { id, newPassword } = req.body;

    try {
        const auth = await Auth.findOne({ id: id });

        if (auth) {
            await Auth.updateOne({ id: id }, { $set: { password: newPassword } });
            return res.status(200).json({ message: "Password updated successfully" });
        } else {
            return res.status(404).json({ error: "Account not found" });
        }
    } catch (error) {
        return res.status(500).json({ error: "Something went wrong while trying to update password" });
    }
});



module.exports = router

