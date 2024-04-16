const express = require('express');
const exam = require('../controllers/exam');

const router = express.Router();

router
  .get('/', exam.onGetExams)
  .post('/', exam.onCreateExam)
  .get('/:id/:term/:courseID', exam.onGetExam)
  .delete('/:id/:term/:courseID', exam.onDeleteExam)
  .patch('/:id/:term/:courseID', exam.onEditExam);

module.exports = router;