const express = require('express')
const mongoose = require('mongoose')
const router = express.Router()
const Student = require('../models/student')
const Instructor = require('../models/instructor')
const Auth = require('../models/auth')

router.get('/', async (req, res) => {
    try {
        const instructors = await Instructor.find().sort({ id: 1 });
        res.status(200).json(instructors);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.get("/:id", async (req, res) => {
    const id = parseInt(req.params.id);
    if (!isNaN(id) && Number.isInteger(id)) {
        try {
            const instructor = await Instructor.findOne({ id: id });
            if (instructor) {
                res.status(200).json(instructor);
            } else {
                res.status(404).json({ error: 'Instructor with id :${id} not found' });
            }
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    } else {
        res.status(400).json({ error: '${req.params.id} Not a valid id (bad id)' });
    }
});

router.post('/', async (req, res) => {
    const instructor = new Instructor({
        id: req.body.id,
        firstName: req.body.firstName,
        middleName: req.body.middleName,
        lastName: req.body.lastName,
        department: req.body.department,
        coursesGiven: req.body.coursesGiven,
    });
    const auth = new Auth({
        id: req.body.id,
        password: req.body.password ? req.body.password : "default",
        role: "instructor"
    })

    try {
        if(await Auth.findOne({ id: instructor.id})){
            return res.status(400).json({ error: `User with the id ${instructor.id} exists` });    
        }

        const instructorResult = await instructor.save();
        const authResult = await auth.save();

        res.status(201).json(instructorResult);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.delete('/:id', async (req, res) => {
    const id = parseInt(req.params.id);
    
    if (!isNaN(id) && Number.isInteger(id)) {
        try {
            const existingInstructor = await Instructor.findOneAndDelete({ id: id });
            
            if (existingInstructor) {
                await Auth.findOneAndDelete({ id: id });

                res.status(200).json(existingInstructor);
            } else {
                res.status(404).json({ error: "Instructor with id :${id} doesn't exist" });
            }
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    } else {
        res.status(400).json({ error: '${req.params.id} Not a valid id' });
    }
});

router.patch('/:id', async (req, res) => {
    const instructorId = parseInt(req.params.id);
    const instructorUpdates = {
        id: req.body.id,
        firstName: req.body.firstName,
        middleName: req.body.middleName,
        lastName: req.body.lastName,
        department: req.body.department,
        coursesGiven: req.body.coursesGiven,
        advisedStudents: req.body.advisedStudents
    };
    try {
        const existingInstructor = await Instructor.findOne({ id: instructorId });

        if (existingInstructor) {
            const updatedInstructor = await Instructor.findOneAndUpdate(
                { id: instructorId },
                { $set: instructorUpdates },
                { new: true } 
            );

            res.status(200).json(updatedInstructor);
        } else {
            res.status(404).json({ error: `Instructor with the id: ${studentId} doesn't exist` });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router