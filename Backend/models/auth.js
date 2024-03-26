const mongoose = require('mongoose')

const authSchema = new mongoose.Schema({
    id: {
        type: Number,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true,
    },
    role: {
        type: String, 
        required: true,
        enum: ['student', 'admin', 'TA', 'instructor']
    },
})

module.exports = mongoose.model('auth', authSchema)