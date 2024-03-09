const mongoose = require('mongoose')

const adminSchema = new mongoose.Schema({
    id: {
        type: Number,
        required: true,
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
    title: {
        type: String,
        required: true,
    },
})

module.exports = mongoose.model('admin', adminSchema)