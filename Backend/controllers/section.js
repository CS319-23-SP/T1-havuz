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
        const sections = await sectionModel.getSections();
        return res.status(200).json({ success: true, sections });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}
const onGetSectionByIDAndTerm = async (req, res) => {
  try {
    console.log(req.params)
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
const onGetMidterm = async (req, res) => {
  try {
    const { studentID, sectionID } = req.params;
    console.log(studentID);
    console.log(sectionID);

    // Find the section by its ID
    const section = await sectionModel.findOne({ id: sectionID,term : "2024 Spring" });
    if (!section) {
      return res.status(404).json({ success: false, error: "Section not found" });
    }
    // Find the midterm grade for the specified student
    const midterm = section.midterm.find(item => item.studentID === studentID);
    if (!midterm) {
      return res.status(404).json({ success: false, error: "Midterm grade not found for this student" });
    }

    // Return the midterm grade as a string value
    return res.status(200).json({ success: true, grade: midterm.grade.toString() });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
const onGetFinal = async (req, res) => {
  try {
    const { studentID, sectionID } = req.params;
    console.log(studentID);
    console.log(sectionID);
    // Find the section by its ID
    const section = await sectionModel.findOne({ id: sectionID, term : "2024 Spring" });
    if (!section) {
      return res.status(404).json({ success: false, error: "Section not found" });
    }

    // Find the final grade for the specified student
    const final = section.final.find(item => item.studentID === studentID);
    if (!final) {
      return res.status(404).json({ success: false, error: "Final grade not found for this student" });
    }

    // Return the final grade as a string value
    return res.status(200).json({ success: true, grade: final.grade.toString() });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};
const onUpdateMidtermGrade = async (req, res) => {
  try {
    const { sectionID } = req.params;
    const { studentID, grade, term } = req.body;

    // Find the section by its ID
    const section = await sectionModel.findOne({ id: sectionID, term: term });
    if (!section) {
      return res.status(404).json({ success: false, error: "Section not found" });
    }

    // Check if the student already has a midterm grade
    const existingMidterm = section.midterm.find(item => item.studentID === studentID);
    if (existingMidterm) {
      // If the student already has a midterm grade, update it
      await sectionModel.updateOne(
        { id: sectionID, term: term, "midterm.studentID": studentID },
        { $set: { "midterm.$.grade": grade } }
      );
    } else {
      // If the student does not have a midterm grade, add a new entry
      await sectionModel.updateOne(
        { id: sectionID, term: term },
        { $push: { midterm: { studentID, grade } } }
      );
    }

    return res.status(200).json({ success: true, message: "Midterm grade updated successfully" });
  } catch (error) {
    return res.status(500).json({ success: false, error: error.message });
  }
};

const onUpdateFinalGrade = async (req, res) => {
  try {
    const { sectionID } = req.params;
    const { studentID, grade, term } = req.body;

    // Update the final grade for the specified student
    const result = await sectionModel.updateOne(
      { id: sectionID, term: term, "final.studentID": studentID }, // Find document by section ID, term, and matching studentID
      { $set: { "final.$.grade": grade } } // Update the grade field for the matching studentID
    );

    // Check if the document was found and updated
    if (result.nModified === 0) {
      return res.status(404).json({ success: false, error: "Section or student not found" });
    }

    return res.status(200).json({ success: true, message: "Final grade updated successfully" });
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
    onUpdateMidtermGrade,
    onUpdateFinalGrade,
    onGetMidterm,
    onGetFinal,
    onGetStudentsBySectionID
  };