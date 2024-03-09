const express = require('express')
const router = express.Router()
const Student = require('../models/student')


router.get('/student', async (req, res) => {
    try {
        const students = await Student.find().sort({id: 1}).toArray();
        res.json(students);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


router.get("/student/:id", async (req, res) => {
    const id = parseInt(req.params.id);
    if (!isNaN(id) && Number.isInteger(id)) {
        try {
            const student = await Student.findOne({ id: id });
            if (student) {
                res.status(200).json(student);
            } else {
                res.status(404).json({ error: 'Student with id :${id} not found' });
            }
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    } else {
        res.status(400).json({ error: '${req.params.id} Not a valid id (bad id)' });
    }
});


router.post('/student', async (req, res) => {
    const student = new Student({
        firstName: req.body.firstName,
        middleName: req.body.middleName,
        lastName: req.body.lastName,
        department: req.body.department,
        coursesTaken: req.body.coursesTaken, 
    });

    try {
        const existingStudent = await Student.findOne({ id: student.id });
        if (existingStudent) {
            return res.status(400).json({ error: "Student with the id :${id} exists" });
        }
        
        const result = await Student.insertOne(student);
        res.status(201).json(result);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.delete('/student/:id', async (req, res) => {
    const id = parseInt(req.params.id);
    
    if (!isNaN(id) && Number.isInteger(id)) {
        try {
            const existingStudent = await Student.findOneAndDelete({ id: id });
            
            if (existingStudent) {
                res.status(200).json(existingStudent);
            } else {
                res.status(404).json({ error: "Student with id :${id} doesn't exist" });
            }
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    } else {
        res.status(400).json({ error: '${req.params.id} Not a valid id' });
    }
});


router.patch('/student/:id', async (req, res) => {
    const studentId = parseInt(req.params.id);
    const studentUpdates = new Student({
        firstName: req.body.firstName,
        middleName: req.body.middleName,
        lastName: req.body.lastName,
        department: req.body.department,
        coursesTaken: req.body.coursesTaken, 
    });
    try {
        const existingStudent = await Student.findOne({ id: studentId });

        if (existingStudent) {
            const updatedStudent = await Student.findOneAndUpdate(
                { id: studentId },
                { $set: studentUpdates },
                { new: true } 
            );

            res.status(200).json(updatedStudent);
        } else {
            res.status(404).json({ error: "Student with the id:${id} doesn't exist" });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


module.exports = router