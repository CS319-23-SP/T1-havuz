const mongoose = require('mongoose')

const questionSchema = new mongoose.Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    courses: {
        type: [String],
        required: true,
    },
    header: {
        type: String,
    },
    text: {
        type: String,
        required: true,
    },
    topics: {
        type: [String], 
        required: true,
    },
    toughness: {
        type: Number,
    },
    pastExams: {
        type: [String], 
    },
    creatorId: {
        type: Number,
        required: true,
    },
})

module.exports = mongoose.model('question', questionSchema)