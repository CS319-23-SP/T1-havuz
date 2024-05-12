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
        studentID: { type: types.string },
        grade: { type: types.string }, // Assuming grade is a string
        term: { type: types.string },
      },
    }));

    if (!validation.success) {
      return res.status(400).json(validation); // Return validation errors
    }

    const questionID = req.params.id; // Get the question ID from URL params
    const { studentID, grade, term } = req.body; // Get student ID, grade, and term from the request body

    // Fetch the question from the database
    const question = await questionModel.findOne({ id: questionID });

    if (!question) {
      return res.status(404).json({ success: false, message: 'Question not found' });
    }
    // Check if the history record exists
    const historyRecord = question.history.find(
      (h) => h.studentID === studentID && h.term === term
    );

    let update;
    if (historyRecord) {
      // If record exists, update the grade
      update = { $set: { 'history.$[element].grade': grade } };
      arrayFilters = [{ 'element.studentID': studentID, 'element.term': term }];
    } else {
      // If record doesn't exist, add a new record
      update = {
        $addToSet: {
          history: {
            studentID,
            grade,
            term,
          },
        },
      };
      arrayFilters = []; // No array filters needed for new records
    }

    // Use findOneAndUpdate with array filters
    const updatedQuestion = await questionModel.findOneAndUpdate(
      { id: questionID },
      update,
      {
        new: true, // Return the updated document
        arrayFilters: arrayFilters,
        upsert: false, // No upsert to avoid creating new questions
      }
    );

    return res.status(200).json({ success: true, question: updatedQuestion });
  } catch (error) {
    console.error(`Error updating history: ${error.message}`);
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