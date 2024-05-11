const Evaluation = require('../models/evaluation');

const onCreateEvaluation = async (req, res) => {
  try {

    
    const { term ,sectionId } = req.params;
    const { courseMessage, instructorMessage } = req.body;
    const evaluation = await Evaluation.createEvaluation(term, sectionId, courseMessage, instructorMessage);
    return res.status(200).json({ success: true, evaluation });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ success: false, error: error.message });
  }
};

const onGetAllEvaluationsBySectionId = async (req, res) => {
  try {
    const { term, sectionId } = req.params;
    const evaluations = await Evaluation.getAllEvaluationsBySectionId(term, sectionId);
    return res.status(200).json({ success: true, evaluations });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ success: false, error: error.message });
  }
};

module.exports = {
  onCreateEvaluation,
  onGetAllEvaluationsBySectionId,
};