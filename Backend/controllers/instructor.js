const makeValidation = require('@withvoid/make-validation');
const instructorModel = require('../models/instructor');

const onCreateInstructor = async (req, res) => {
  try {
    const validation = makeValidation(types => ({
      payload: req.body,
      checks: {
        firstName: { type: types.string },
        lastName: { type: types.string },
        department: { type: types.string },
      }
    }));
    if (!validation.success) return res.status(400).json(validation);

    const { firstName, middleName, lastName, department} = req.body;
    const instructor = await instructorModel.createInstructor(firstName, middleName, lastName, department);
    return res.status(200).json({ success: true, instructor });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
};

const onEditInstructorByID = async (req, res) => {
    try {
        const validation = makeValidation(types => ({
        payload: req.body,
        checks: {
            id: { type: types.string },
        }
        }));
        if (!validation.success) return res.status(400).json(validation);

        const { id, firstName, middleName, lastName, department, coursesGiven, advisedStudents, enteringYear, yearOfDeparture, allTimeCourses} = req.body;
        const instructor = await instructorModel.editInstructorByID( id, firstName, middleName, lastName, department, coursesGiven, advisedStudents, enteringYear, yearOfDeparture, allTimeCourses);
        return res.status(200).json({ success: true, instructor });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onDeleteInstructorByID = async (req, res) => {
    try {
        const instructor = await instructorModel.deleteInstructorByID(req.params.id);
        return res.status(200).json({ 
        success: true, 
        message: `Deleted an instructor with ID ${req.params.id}.` 
        });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetAllInstructors = async (req, res) => {
    try {
        const instructors = await instructorModel.getInstructors();
        return res.status(200).json({ success: true, instructors });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetInstructorByID = async (req, res) => {
    try {
        const instructor = await authModel.getInstructorById(req.params.id);
        return res.status(200).json({ success: true, instructor });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

module.exports = {
    onCreateInstructor,
    onEditInstructorByID,
    onDeleteInstructorByID,
    onGetAllInstructors,
    onGetInstructorByID
};