const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const examSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          questions: [String],
          grades: [{String: String}]
    },
    {
        timestamps: true,
        collection: "exams",
    }
);

module.exports = mongoose.model("Exam", examSchema);