const makeValidation = require('@withvoid/make-validation');
const studentModel = require('../models/student');

const onCreateStudent = async (req, res) => {
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
    const student = await studentModel.createStudent(firstName, middleName, lastName, department);
    return res.status(200).json({ success: true, student });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
};

const onEditStudentByID = async (req, res) => {
    try {
        const validation = makeValidation(types => ({
        payload: req.params,
        checks: {
            id: { type: types.string },
        }
        }));
        if (!validation.success) return res.status(400).json(validation);

        const {id} = req.params;
        const { firstName, middleName, lastName, department, coursesTaken, advisorID, 
            yearOfDeparture, enteringYear, allTakenCourses, totalGrade, totalCredits} = req.body;
        const student = await studentModel.editStudentByID( id, firstName, middleName, lastName, department, coursesTaken, advisorID, 
            yearOfDeparture, enteringYear, allTakenCourses, totalGrade, totalCredits);
        return res.status(200).json({ success: true, student });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onDeleteStudentByID = async (req, res) => {
    try {
        const student = await studentModel.deleteStudentByID(req.params.id);
        if(student.deletedCount !== 0){
            return res.status(200).json({ 
                success: true, 
                message: `Deleted a student with ID ${req.params.id}.` 
                });
        }
         else {
            res.status(404).json({ error: "Student with id ${req.params.id} doesn't exist" });
         }
        
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetAllStudents = async (req, res) => {
    try {
        const students = await studentModel.getStudents();
        return res.status(200).json({ success: true, students });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetStudentByID = async (req, res) => {
    try {
        const student = await studentModel.getStudentByID(req.params.id);
        return res.status(200).json({ success: true, student });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

// const onGetStudentAttendance = async (req, res) => {
//     try {
//       const { id } = req.params; // The student ID
  
//       const student = await studentModel.findOne({ id });
//       if (!student) {
//         return res.status(404).json({ error: "Student not found." });
//       }
  
//       return res.status(200).json({ success: true, attendance: student.attendance });
//     } catch (error) {
//       return res.status(500).json({ success: false, error: error.message });
//     }
//   };

module.exports = {
    onCreateStudent,
    onEditStudentByID,
    onDeleteStudentByID,
    onGetAllStudents,
    onGetStudentByID,
    //onGetStudentAttendance
};