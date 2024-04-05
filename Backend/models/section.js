const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const Assignment = require('../models/assignment');

const sectionSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          quota: String,
          students: [String],
          assignments: [Assignment],
          instructorID: String,
          material: [String]
    },
    {
        timestamps: true,
        collection: "sections",
    }
);

module.exports = mongoose.model("Section", sectionSchema);