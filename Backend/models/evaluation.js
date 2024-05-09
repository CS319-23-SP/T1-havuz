const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const evaluationSchema = new mongoose.Schema(
  {    
    _id: {
    type: String,
    default: () => uuidv4().replace(/\-/g, ""),
  },
    sectionId: {
      type: String,
      required: true,
    },
    courseMessage: {
      type: String,
    },
    instructorMessage: {
      type: String,
    },
  },
  {
    timestamps: true,
    collection: "evaluations",
  }
);

evaluationSchema.statics.createEvaluation = async function (sectionId, courseMessage, instructorMessage) {
  try {
    const evaluation = await this.create({
      sectionId,
      courseMessage, instructorMessage,
    });

    return evaluation;
  } catch (error) {
    throw error;
  }
};

evaluationSchema.statics.getAllEvaluationsBySectionId = async function (sectionId) {
  try {
    const evaluations = await this.find({ sectionId });
    return evaluations;
  } catch (error) {
    throw error;
  }
};


module.exports = mongoose.model("evaluation", evaluationSchema);
