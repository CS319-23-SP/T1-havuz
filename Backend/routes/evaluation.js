const express = require('express');
const evaluation = require('../controllers/evaluation.js');

const router = express.Router();

router
    .post('/:sectionId', evaluation.onCreateEvaluation)
    .get('/:sectionId', evaluation.onGetAllEvaluationsBySectionId);

module.exports = router;
