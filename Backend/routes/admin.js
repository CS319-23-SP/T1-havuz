const express = require('express')
const router = express.Router()
const Admin = require('../models/admin')


router.post('/admin', (req, res) => {
    const id = req.body.id;
    const enteredPassword = req.body.password;
    db.collection('admin')
        .findOne({id: id})
        .then(existingAdmin => {
            if(enteredPassword == existingAdmin.password)
                res.status(200).json("succesful adminim");
            else
                res.status(500).json("wrong password madmin");
        })
        .catch(error => {
            db.collection('student')
                .findOne({id: id})
                .then(existingStudent => {
                    if(enteredPassword == existingStudent.password)
                        res.status(201).json("succesfual studo");
                    else
                        res.status(501).json("bari şifreni unutma aw");
                })
                .catch(error => {
                    res.status(503).json({ error: "something went wrong trying to looking for account" });
                });
        });
});

module.exports = router