const express = require('express');
const exam = require('../controllers/exam');
const roleChecker = require('../middlewares/roleChecker');

const router = express.Router();

router
  .get('/', exam.onGetExams)
  .post('/', roleChecker(['admin', 'instructor']), exam.onCreateExam)
  .get('/:id/:term/:courseID', exam.onGetExam)
  .delete('/:id/:term/:courseID', roleChecker(['admin']), exam.onDeleteExam)
  .patch('/:id/:term/:courseID', roleChecker(['admin', 'instructor']), exam.onEditExam);

module.exports = router;