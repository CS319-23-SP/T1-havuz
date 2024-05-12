const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const questionSchema = new mongoose.Schema(
    {
        _id: {
            type: String,
            default: () => uuidv4().replace(/\-/g, ""),
          },
          id: String,
          courses: [String],
          header: String,
          text: String,
          topics: [String],
          toughness: String,
          history: [{
            studentID: String,
            grade: Number,
            term: String
          }],
          pastExams: [String], // Exam ID + Course ID + Term
          creatorID: String,
    },
    {
        timestamps: true,
        collection: "questions",
    }
);

questionSchema.statics.createQuestion = async function (courses, header, text, topics, toughness, creatorID) {
    try {
        const lastQuestion = await this.findOne().sort({ id: -1});
        let id;

        if (lastQuestion) {
            const lastSequentialNumber = parseInt(lastQuestion.id.substring(2));
            id = `${(new Date().getFullYear() % 100).toString().padStart(2, '0')}${(lastSequentialNumber + 1).toString().padStart(8, '0')}`;
        } else {
            id = `${(new Date().getFullYear() % 100).toString().padStart(2, '0')}00000001`;
        }

        const question = await this.create({id, courses, header, text, topics, toughness, creatorID});
        return question;
    } catch (error) {
        throw error;
    }
}

questionSchema.statics.getQuestionByID = async function (id) {
    try {
        const question = await this.findOne({ id: id});
        if(!question) throw ({error: 'No question with this id found' });
        return question;
    } catch (error) {
        throw error;
    }
}

questionSchema.statics.getQuestions = async function () {
    try {
      const questions = await this.find();
      return questions;
    } catch (error) {
      throw error;
    }
}

questionSchema.statics.deleteQuestionByID = async function (id) {
    try {
      const question = await this.deleteOne({ id: id });
      return question;
    } catch (error) {
      throw error;
    }
}

questionSchema.statics.editQuestionByID = async function (id, courses, header, text, topics, toughness, pastExams, creatorID) {
    
    try {
      const question = await this.findOne({id: id});
        var updatedPastExams = question.pastExams;
        
        if (question && question.pastExams && Array.isArray(pastExams) && pastExams && Array.isArray(question.pastExams)) {
          pastExams.forEach(exam => {
            updatedPastExams.push(exam);
          });
        } 

        const questionUpdates = {
          courses: courses,
          header: header,
          text: text,
          topics: topics,
          toughness: toughness,
          pastExams: updatedPastExams,
          creatorID: creatorID,
      };

      const updatedQuestion = await this.findOneAndUpdate(
        { id: id },
        { $set: questionUpdates },
        { new: true } 
      );
      return updatedQuestion;
    } catch (error) {
      throw error;
    }
}

module.exports = mongoose.model("Question", questionSchema);