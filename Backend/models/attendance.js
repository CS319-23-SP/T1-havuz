const mongoose = require("mongoose");

const attendanceSchema = new mongoose.Schema(
  {
    studentID: {
      type: String,
      required: true,
    },
    sectionID: {
      type: String,
      required: true,
    },
    date: {
      type: Date,
      required: true,
    },
    hour: {
      type: Number,
      default: 0,
    },
    totalHour: {
      type: Number,
      default: 0,
    },
    term: {
      type: String,
      default: 0,
    },
  },
  {
    timestamps: true,
    collection: "attendance",
  }
);

module.exports = mongoose.model("Attendance", attendanceSchema);
