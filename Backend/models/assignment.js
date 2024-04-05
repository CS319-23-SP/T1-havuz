const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const Question = require('../models/question');

const assignmentSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          questions: [Question],
          grades: [{String: String}],
          deadline: String,
          solutionKey: String
    },
    {
        timestamps: true,
        collection: "assignments",
    }
);

module.exports = mongoose.model("Assignment", assignmentSchema);