const express = require('express');
const evaluation = require('../controllers/evaluation.js');

const router = express.Router();

router
    .post('/:term/:sectionId', evaluation.onCreateEvaluation)
    .get('/:term/:sectionId', evaluation.onGetAllEvaluationsBySectionId);

module.exports = router;