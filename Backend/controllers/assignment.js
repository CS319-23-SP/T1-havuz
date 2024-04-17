const makeValidation = require('@withvoid/make-validation');
const assignmentModel = require('../models/assignment');

const onCreateAssignment = async (req, res) => {
    try {
      const validation = makeValidation(types => ({
        payload: req.body,
        checks: {
          term: { type: types.string },
          sectionID: { type: types.string },
          questions: { type: types.array },
          deadline: { type: types.string}
        }
      }));
      if (!validation.success) return res.status(400).json(validation);
  
      const { term, sectionID, questions, deadline} = req.body;
      const assignment = await assignmentModel.createAssignment(term, sectionID, questions, deadline);
      return res.status(200).json({ success: true, assignment });
    } catch (error) {
      return res.status(500).json({ success: false, error: error })
    }
  };
  
  const onEditAssignment = async (req, res) => {
      try {
          const validation = makeValidation(types => ({
          payload: req.params,
          checks: {
            id: { type: types.string },
            term: { type: types.string },
            sectionID: {type: types.string}
          }
          }));
          if (!validation.success) return res.status(400).json(validation);
  
          const {id, term, sectionID} = req.params;
          const { questions, deadline, grades, solutionKey} = req.body;
          const assignment = await assignmentModel.editAssignment( id, term, sectionID, questions, deadline, grades, solutionKey);
          return res.status(200).json({ success: true, assignment });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }
  
  const onDeleteAssignment = async (req, res) => {
      try {
          const assignment = await assignmentModel.deleteAssignment(req.params.id, req.params.term, req.params.sectionID);
          if(assignment.deletedCount !== 0){
              return res.status(200).json({ 
                  success: true, 
                  message: `Deleted an assignment with ID ${req.params.id}, Term ${req.params.term}, and Section ID ${req.params.sectionID}.` 
                  });
          }
           else {
              res.status(404).json({ error: `Assignment with ID ${req.params.id}, Term ${req.params.term}, and Section ID ${req.params.sectionID}. doesnt exist.`});
           }
          
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }

  
  const onGetAssignment = async (req, res) => {
      try {
          const assignment = await assignmentModel.getAssignment(req.params.id, req.params.term, req.params.sectionID);
          return res.status(200).json({ success: true, assignment });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }

  const onGetAssignments = async (req, res) => {
    try {
        const assignments = await assignmentModel.getAssignments();
        return res.status(200).json({ success: true, assignments });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

  
  module.exports = {
    onCreateAssignment,
    onEditAssignment,
    onDeleteAssignment,
    onGetAssignment,
    onGetAssignments
  };