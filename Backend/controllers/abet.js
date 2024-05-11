const Abet = require('../models/abet');

const onCreateAbet = async (req, res) => {
  try {
    const { sectionId } = req.params;
    const { messageText } = req.body;
    const parts = sectionId.split('-');
    const extractedText = parts[0];
    const abet = await Abet.createAbet(extractedText, messageText);
    return res.status(200).json({ success: true, abet });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ success: false, error: error.message });
  }
};

const onGetAbet = async (req, res) => {
  try {
    const { sectionId } = req.params;
    const parts = sectionId.split('-');
    const extractedText = parts[0];
    const abet = await Abet.getAllAbetsBySectionId(extractedText);
    return res.status(200).json({ success: true, abet });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ success: false, error: error.message });
  }
};

module.exports = {
  onCreateAbet,
  onGetAbet,
};