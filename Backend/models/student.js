const mongoose = require('mongoose')

const studentSchema = new mongoose.Schema({
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
    coursesTaken: {
        type: [String], 
        required: true,
    },
})

module.exports = mongoose.model('Student', studentSchema)