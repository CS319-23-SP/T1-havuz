const express = require('express');
const question = require('../controllers/question');

const router = express.Router();

router
  .get('/', question.onGetAllQuestions)
  .post('/', question.onCreateQuestion)
  .post('/search', question.onSearchQuestion)
  .get('/:id', question.onGetQuestionByID)
  .delete('/:id', question.onDeleteQuestionByID)
  .patch('/:id', question.onEditQuestionByID);

module.exports = router;