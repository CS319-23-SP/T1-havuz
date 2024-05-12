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
          deadline: { type: types.string},
          name: { type: types.string},
          weights: {type: types.array}
        }
      }));
      if (!validation.success) return res.status(400).json(validation);
  
      const { term, sectionID, questions, deadline, name, weights} = req.body;
      const assignment = await assignmentModel.createAssignment(term, sectionID, questions, deadline, name, weights);
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
          const { questions, deadline, grades, solutionKey, name} = req.body;
          const assignment = await assignmentModel.editAssignment( id, term, sectionID, questions, deadline, grades, solutionKey, name);
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

const onGetAssignmentForSection = async (req, res) => {
  try {
    const assignments = await assignmentModel.getAssignmentsForSection(req.params.term, req.params.sectionID);
    return res.status(200).json({ success: true, assignments });
  } catch (error) {
      return res.status(500).json({ success: false, error: error })
  }
}

const onUpdateAssGrade = async (req, res) => {
  try {
    const validation = makeValidation((types) => ({
      payload: req.body,
      checks: {
        grade: { type: types.string, optional: false },
      },
    }));

    if (!validation.success) {
      return res.status(400).json(validation); // Return validation errors
    }

    const { id, term, sectionID, studentID } = req.params;
    const grade = req.body.grade; // Get the grade from the body

    // Find the assignment with the given ID, term, and sectionID
    const assignment = await assignmentModel.findOne({
      id,
      term,
      sectionID,
    });

    if (!assignment) {
      return res.status(404).json({ success: false, message: 'Assignment not found' });
    }

    // Find the existing `grades` entry with the matching `studentID`
    let existingGrade = assignment.grades.find(
      (g) => g.studentID === studentID
    );

    if (existingGrade) {
      // Update the existing grade
      existingGrade.grade = grade;
    } else {
      // Create a new `grades` entry
      assignment.grades.push({ studentID, grade });
    }

    await assignment.save(); // Save the updated assignment

    return res.status(200).json({ success: true, assignment });
  } catch (error) {
    console.error('Error updating assignment grade:', error);
    return res.status(500).json({ success: false, message: 'Server error' });
  }
};



  
  module.exports = {
    onCreateAssignment,
    onEditAssignment,
    onDeleteAssignment,
    onGetAssignment,
    onGetAssignments,
    onGetAssignmentForSection,
    onUpdateAssGrade
  };