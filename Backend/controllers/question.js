const makeValidation = require('@withvoid/make-validation');
const questionModel = require('../models/question');

const onCreateQuestion = async (req, res) => {
  try {
    const validation = makeValidation(types => ({
      payload: req.body,
      checks: {
        courses: { type: types.array },
        header: { type: types.string },
        text: { type: types.string },
        topics: { type: types.array },
        toughness: { type: types.string },
        creatorID: { type: types.string },
      }
    }));
    if (!validation.success) return res.status(400).json(validation);

    const { courses, header, text, topics, toughness, creatorID} = req.body;
    const question = await questionModel.createQuestion(courses, header, text, topics, toughness, creatorID);
    return res.status(200).json({ success: true, question });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
};

const onSearchQuestion = async (req, res) => {
    var id = req.body.id;
    var pastExams = req.body.pastExams;
    var courses = req.body.courses;
    var topics = req.body.topics;

    var filter = {};

    if (id)
        filter.id = { $regex: id, $options: 'i' };
    if (pastExams)
        filter.pastExams = { $in: pastExams };
    if (courses)
        filter.courses = { $in: courses };
    if (topics)
        filter.topics = { $in: topics };

    try {
        const questions = await questionModel.find(filter).sort({ id: 1 });
        if(questions){
            return res.status(200).json({ success: true, questions });
        } else {
            return res.status(500).json({ success: false, error: error });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

const onEditQuestionByID = async (req, res) => {
    try {
        const validation = makeValidation(types => ({
        payload: req.params,
        checks: {
            id: {type: types.string},
        }
        }));
        if (!validation.success) return res.status(400).json(validation);

        const {id} = req.params;
        const { courses, header, text, topics, toughness, pastExams, creatorID} = req.body;
        const question = await questionModel.editQuestionByID( id, courses, header, text, topics, toughness, pastExams, creatorID);
        return res.status(200).json({ success: true, question });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onDeleteQuestionByID = async (req, res) => {
    try {
        const question = await questionModel.deleteQuestionByID(req.params.id);
        if(question.deletedCount !== 0){
            return res.status(200).json({ 
                success: true, 
                message: `Deleted a question with ID ${req.params.id}.` 
            });
        } else {
            res.status(404).json({ error: "Question with id ${id} doesn't exist" });
        }
        
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetAllQuestions = async (req, res) => {
    try {
        const questions = await questionModel.getQuestions();
        return res.status(200).json({ success: true, questions });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onGetQuestionByID = async (req, res) => {
    try {
        const question = await questionModel.getQuestionByID(req.params.id);
        return res.status(200).json({ success: true, question });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onUpdateHistory = async (req, res) => {
    try {
      const validation = makeValidation((types) => ({
        payload: req.body,
        checks: {
          studentID: { type: types.string, optional: false },
          grade: { type: types.number, optional: false },
        },
      }));
  
      if (!validation.success) {
        return res.status(400).json(validation); // Return validation errors
      }
  
      const questionID = req.params.id; // Get the question ID from URL params
      const { studentID, grade } = req.body; // Get the student ID and grade from the request body
  
      // Fetch the question from the database
      const question = await questionModel.findById(questionID);
  
      if (!question) {
        return res.status(404).json({ success: false, message: 'Question not found' });
      }
  
      // Find the existing history record for this student ID
      let historyRecord = question.history.find((h) => h.studentID === studentID);
  
      if (historyRecord) {
        // Update the grade if the history record exists
        historyRecord.grade = grade;
      } else {
        // If not, create a new history record
        question.history.push({ studentID, grade });
      }
  
      // Save the updated question back to the database
      await question.save();
  
      return res.status(200).json({ success: true, question });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ success: false, error: error.message });
    }
  };
  
module.exports = {
    onCreateQuestion,
    onEditQuestionByID,
    onDeleteQuestionByID,
    onGetAllQuestions,
    onGetQuestionByID,
    onSearchQuestion,
    onUpdateHistory
};