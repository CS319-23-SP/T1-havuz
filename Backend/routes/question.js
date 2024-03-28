const express = require('express');
const mongoose = require('mongoose')
const router = express.Router();
const Question = require('../models/question');
const Admin = require('../models/admin');
const Auth = require('../models/auth');

router.get('/', async (req, res) => {
    try {
        const questions = await Question.find().sort({ id: 1 });
        res.status(200).json(questions);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post('/search', async (req, res) => {
    var id = req.body.id;
    var pastExams = req.body.pastExams;
    var courses = req.body.courses;
    var topics = req.body.topics;

    var filter = {};

    if (id)
        filter.id = { $regex: id, $options: 'i' };
    if (pastExams)
        filter.pastExams = { $in: pastExams };
    if (courses)
        filter.courses = { $in: courses };
    if (topics)
        filter.topics = { $in: topics };

    try {
        const questions = await Question.find(filter).sort({ id: 1 });
        if(questions){
            res.status(200).json(questions);
        } else {
            res.status(404).json({ error: 'No question found' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.get("/:id", async (req, res) => {
    const id = parseInt(req.params.id);
    if (!isNaN(id) && Number.isInteger(id)) {
        try {
            const question = await Question.findOne({ id: id });
            if (question) {
                res.status(200).json(question);
            } else {
                res.status(404).json({ error: 'Question with id :${id} not found' });
            }
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    } else {
        res.status(400).json({ error: '${req.params.id} Not a valid id (bad id)' });
    }
});

router.post('/', async (req, res) => {
    if (!req.body.header || !req.body.text || !req.body.creatorId || req.body.courses.length === 0 || req.body.topics.length === 0) {
        return res.status(400).json({ message: "Required fields are missing or empty." });
    }

    var randomId = Math.floor(Math.random() * 10000000000);
    while(await Question.findOne({ id: randomId })){
        randomId = Math.floor(Math.random() * 10000000000);
    }

    const question = new Question({
        id:randomId.toString(),
        courses:req.body.courses,
        header:req.body.header,
        text:req.body.text,
        topics:req.body.topics,
        creatorId:req.body.creatorId
    });

    try {
        const questionResult = await question.save();

        res.status(201).json(questionResult);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.delete('/:id', async (req, res) => {
    const id = parseInt(req.params.id);
    
    if (!isNaN(id) && Number.isInteger(id)) {
        try {
            const existingQuestion = await Question.findOneAndDelete({ id: id });
            
            if (existingQuestion) {
                res.status(200).json(existingQuestion);
            } else {
                res.status(404).json({ error: "Question with id :${id} doesn't exist" });
            }
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    } else {
        res.status(400).json({ error: '${req.params.id} Not a valid id' });
    }
});

router.patch('/:id', async (req, res) => {
    const questionId = req.params.id;
    const questionUpdates = {
        toughness:req.body.toughness,
        pastExams:req.body.pastExams,
        courses:req.body.courses,
        header:req.body.header,
        text:req.body.text,
        topics:req.body.topics,
        creatorId:req.body.creatorId
    };
    try {
        const updatedQuestion = await Question.findOneAndUpdate(
            { id: questionId },
            { $set: questionUpdates },
            { new: true } 
        );

        if(updatedQuestion){
            res.status(200).json(updatedQuestion);
        } else {
            res.status(404).json({ error: `Question with the id: ${questionId} doesn't exist` });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router