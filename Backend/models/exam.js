const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const course = require("./course");

const examSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          term: String,
          courseID: String,
          questions: [String],
          grades: [{String: String}]
    },
    {
        timestamps: true,
        collection: "exams",
    }
);

examSchema.statics.createExam = async function (term, courseID, questions) {
    try {
        const lastExam = await this.findOne({term: term, courseID: courseID}).sort({ id: -1});
        let id;

        if (lastExam) {
            const lastSequentialNumber = parseInt(lastExam.id);
            id = `${(lastSequentialNumber + 1).toString().padStart(2, '0')}`;
        } else {
            id = `01`;
        }

        const exam = await this.create({id, term, courseID, questions});
        return exam;
    } catch (error) {
        throw error;
    }
}

examSchema.statics.getExam = async function (id, term, courseID) {
    try {
        const exam = await this.find({ id: id, term: term, courseID: courseID});
        if(!exam) throw ({error: 'No exam with this id, term, or course ID found' });
        return exam;
    } catch (error) {
        throw error;
    }
}

examSchema.statics.getExams = async function () {
    try {
        const exams = await this.find();
        return exams;
      } catch (error) {
        throw error;
      }
}

examSchema.statics.deleteExam = async function (id, term, courseID) {
    try {
      const result = await this.deleteOne({ id: id, term: term, courseID: courseID});
      return result;
    } catch (error) {
      throw error;
    }
}

examSchema.statics.editExam = async function (id, term, courseID, questions, grades) {
    try {
        const examUpdates = {
            questions: questions,
            grades: grades
        };

        const examUpdated = await this.findOneAndUpdate(
            { id: id, term: term, courseID: courseID},
            { $set: examUpdates },
            { new: true } 
        );

        console.log("ah");
        return examUpdated;
    } catch (error) {
        throw error;
    }
}

module.exports = mongoose.model("Exam", examSchema);