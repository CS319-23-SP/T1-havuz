const makeValidation = require('@withvoid/make-validation');
const sectionModel = require('../models/section');
const studentModel = require('../models/student'); 

const onCreateSection = async (req, res) => {
    try {
      const validation = makeValidation(types => ({
        payload: req.body,
        checks: {
          term: { type: types.string },
          courseID: { type: types.string },
          quota: { type: types.string },
        }
      }));
      if (!validation.success) return res.status(400).json(validation);
  
      const { term, courseID, quota} = req.body;
      const section = await sectionModel.createSection(term, courseID, quota);
      return res.status(200).json({ success: true, section });
    } catch (error) {
      return res.status(500).json({ success: false, error: error })
    }
  };
  
  const onEditSection = async (req, res) => {
      try {
          const validation = makeValidation(types => ({
          payload: req.params,
          checks: {
            id: { type: types.string },
            term: { type: types.string },
            courseID: {type: types.string}
          }
          }));
          if (!validation.success) return res.status(400).json(validation);
  
          const {id, term, courseID} = req.params;
          const { quota, students, assignments, instructorID, material} = req.body;
          const section = await sectionModel.editSection( id, term, courseID, quota, students, assignments, instructorID, material);
          return res.status(200).json({ success: true, section });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }
  
  const onDeleteSection = async (req, res) => {
      try {
          const section = await sectionModel.deleteSection(req.params.id, req.params.term, req.params.courseID);
          if(section.deletedCount !== 0){
              return res.status(200).json({ 
                  success: true, 
                  message: `Deleted a section with ID ${req.params.id}, Term ${req.params.term}, and Course ID ${req.params.courseID}.` 
                  });
          }
           else {
              res.status(404).json({ error: `Section with ID ${req.params.id}, Term ${req.params.term}, and Course ID ${req.params.courseID} doesnt exist.`});
           }
          
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }


  const onGetSection = async (req, res) => {
      try {
          const section = await sectionModel.getSection(req.params.id, req.params.term, req.params.courseID);
          return res.status(200).json({ success: true, section });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }

  const onGetSections = async (req, res) => {
    try {
      console.log(req.params);
        const sections = await sectionModel.getSections();
        return res.status(200).json({ success: true, sections });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onGetSectionTerm = async (req, res) => {
  try {
      const sections = await sectionModel.getSectionsbyTerm(req.params.term);
      return res.status(200).json({ success: true, sections });
  } catch (error) {
      return res.status(500).json({ success: false, error: error })
  }
}
const onGetSectionByIDAndTerm = async (req, res) => {
  try {
      const section = await sectionModel.getSectionByIDAndTerm(req.params.id, req.params.term);
      return res.status(200).json({ success: true, section });
  } catch (error) {
      return res.status(500).json({ success: false, error: error })
    }
}
const onGetStudentsBySectionID = async (req, res) => {
  try {
    console.log("ao");

    const { sectionID } = req.params; // Get section ID from route params

    // Find the section by its ID
    const section = await sectionModel.findOne({ id: sectionID, term: "2024 Spring" });
    if (!section) {
      console.log("ao");

      return res.status(404).json({ success: false, error: "Section not found" });
    }
console.log("ao");
    const studentIDs = section.students; // Array of student IDs in the section

    // Find all students with IDs in the section
    const students = await studentModel.find({ id: { $in: studentIDs } });

    // If no students are found, return an empty array
    if (!students) {
      return res.status(404).json({ success: false, error: "No students found" });
    }

    // Return the student data in the response
    return res.status(200).json({
      success: true,
      students: students.map(student => ({
        id: student.id,
        name: `${student.firstName} ${student.middleName ? student.middleName + ' ' : ''}${student.lastName}`, // Full name
      })),
    });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
 
  module.exports = {
    onCreateSection,
    onEditSection,
    onDeleteSection,
    onGetSections,
    onGetSection,
    onGetSectionByIDAndTerm,
    onGetStudentsBySectionID,
    onGetSectionTerm
  };