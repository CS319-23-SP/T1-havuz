const makeValidation = require('@withvoid/make-validation');
const examModel = require('../models/exam');

const onCreateExam = async (req, res) => {
    try {
      const validation = makeValidation(types => ({
        payload: req.body,
        checks: {
          term: { type: types.string },
          courseID: { type: types.string },
          questions: { type: types.array },
        }
      }));
      if (!validation.success) return res.status(400).json(validation);
  
      const { term, courseID, questions} = req.body;
      const exam = await examModel.createExam(term, courseID, questions);
      return res.status(200).json({ success: true, exam });
    } catch (error) {
      return res.status(500).json({ success: false, error: error })
    }
  };
  
  const onEditExam = async (req, res) => {
      try {
          const validation = makeValidation(types => ({
          payload: req.params,
          checks: {
            id: { type: types.string },
            term: { type: types.string },
            courseID: {type: types.string}
          }
          }));
          if (!validation.success) return res.status(400).json(validation);
  
          const {id, term, courseID} = req.params;
          const { questions, grades} = req.body;
          const exam = await examModel.editExam( id, term, courseID, questions, grades);
          return res.status(200).json({ success: true, exam });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }
  
  const onDeleteExam = async (req, res) => {
      try {
          const exam = await examModel.deleteExam(req.params.id, req.params.term, req.params.courseID);
          if(exam.deletedCount !== 0){
              return res.status(200).json({ 
                  success: true, 
                  message: `Deleted an exam with ID ${req.params.id}, Term ${req.params.term}, and Course ID ${req.params.courseID}.` 
                  });
          }
           else {
              res.status(404).json({ error: `Exam with ID ${req.params.id}, Term ${req.params.term}, and Course ID ${req.params.courseID} doesnt exist.`});
           }
          
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }

  
  const onGetExam = async (req, res) => {
      try {
          const exam = await examModel.getExam(req.params.id, req.params.term, req.params.courseID);
          return res.status(200).json({ success: true, exam });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }

  const onGetExams = async (req, res) => {
    try {
        const exams = await examModel.getExams();
        return res.status(200).json({ success: true, exams });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

  
  module.exports = {
    onCreateExam,
    onEditExam,
    onDeleteExam,
    onGetExams,
    onGetExam
  };