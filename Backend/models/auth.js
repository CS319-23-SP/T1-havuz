const mongoose = require('mongoose')

const authSchema = new mongoose.Schema({
    id: {
        type: Number,
        required: true,
    },
    password: {
        type: String,
        required: true,
    },
    role: {
        type: String, 
        required: true,
    },
})

module.exports = mongoose.model('auth', authSchema)