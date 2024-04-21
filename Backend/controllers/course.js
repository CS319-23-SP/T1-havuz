const makeValidation = require('@withvoid/make-validation');
const courseModel = require('../models/course');

const onCreateCourse = async (req, res) => {
    try {
      const validation = makeValidation(types => ({
        payload: req.body,
        checks: {
          id: { type: types.string },
          term: { type: types.string },
          department: { type: types.string },
          credits: { type: types.string },
        }
      }));
      if (!validation.success) return res.status(400).json(validation);
  
      const { id, term, department, coordinatorID, credits} = req.body;
      const course = await courseModel.createCourse(id, term, department, coordinatorID, credits);
      return res.status(200).json({ success: true, course });
    } catch (error) {
      return res.status(500).json({ success: false, error: error })
    }
  };
  
  const onEditCourseByIDAndTerm = async (req, res) => {
      try {
          const validation = makeValidation(types => ({
          payload: req.params,
          checks: {
            id: { type: types.string },
            term: { type: types.string },
          }
          }));
          if (!validation.success) return res.status(400).json(validation);
  
          const {id, term} = req.params;
          const { syllabus, department, coordinatorID, credits, sections, exams, finalgrades} = req.body;
          const course = await courseModel.editCourseByIDAndTerm( id, term, syllabus, department, coordinatorID, credits, sections, exams, finalgrades);
          return res.status(200).json({ success: true, course });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }
  
  const onDeleteCourseByIDAndTerm = async (req, res) => {
      try {
          const course = await courseModel.deleteCourseByIDAndTerm(req.params.id, req.params.term);
          if(course.deletedCount !== 0){
              return res.status(200).json({ 
                  success: true, 
                  message: `Deleted a course with ID ${req.params.id} and Term ${req.params.term}.` 
                  });
          }
           else {
              res.status(404).json({ error: `Course with ID ${req.params.id} and Term ${req.params.term} doesnt exist.`});
           }
          
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }
  
  
  const onGetCourses = async (req, res) => {
      try {
          const courses = await courseModel.getCourses();
          return res.status(200).json({ success: true, courses });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }
  
  
  const onGetCourseByIDAndTerm = async (req, res) => {
      try {
          const course = await courseModel.getCourseByIDAndTerm(req.params.id, req.params.term);
          return res.status(200).json({ success: true, course });
      } catch (error) {
          return res.status(500).json({ success: false, error: error })
      }
  }

  const onGetCourseByID = async (req, res) => {
    try {
        const course = await courseModel.getCourseByID(req.params.id);
        return res.status(200).json({ success: true, course });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onGetCourseByTerm = async (req, res) => {
    try {
        const course = await courseModel.getCourseByTerm(req.params.term);
        return res.status(200).json({ success: true, course });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}
  
  module.exports = {
    onCreateCourse,
    onEditCourseByIDAndTerm,
    onDeleteCourseByIDAndTerm,
    onGetCourses,
    onGetCourseByIDAndTerm,
    onGetCourseByID,
    onGetCourseByTerm
  };