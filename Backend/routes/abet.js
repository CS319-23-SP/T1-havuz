const express = require('express');
const abet = require('../controllers/abet.js');

const router = express.Router();

router
    .post('/:sectionId', abet.onCreateAbet)
    .get('/:sectionId', abet.onGetAbet);

module.exports = router;