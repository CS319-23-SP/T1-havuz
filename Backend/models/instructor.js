const mongoose = require('mongoose')

const instructorSchema = new mongoose.Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    firstName: {
        type: String,
        required: true,
    },
    middleName: {
        type: String,
    },
    lastName: {
        type: String, 
        required: true,
    },
    department: {
        type: String,
        required: true,
    },
    coursesGiven: {
        type: [String], 
        required: true,
    },
    advisedStudents: {
        type: [String]
    }
})

module.exports = mongoose.model('Instructor', instructorSchema)