const express = require('express');
const question = require('../controllers/question');
const roleChecker = require('../middlewares/roleChecker');

const router = express.Router();

router
  .get('/', roleChecker(['admin', 'instructor']), question.onGetAllQuestions)
  .post('/', roleChecker(['admin', 'instructor']), question.onCreateQuestion)
  .post('/search', roleChecker(['admin', 'instructor']), question.onSearchQuestion)
  .get('/:id', question.onGetQuestionByID)
  .delete('/:id', roleChecker(['admin', 'instructor']), question.onDeleteQuestionByID)
  .patch('/:id', roleChecker(['admin', 'instructor']), question.onEditQuestionByID)
  .put('/update-history/:id', roleChecker(['admin', 'instructor']), question.onUpdateHistory);

module.exports = router;