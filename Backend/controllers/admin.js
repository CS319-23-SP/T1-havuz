const makeValidation = require('@withvoid/make-validation');
const adminModel = require('../models/admin');

const onCreateAdmin = async (req, res) => {
  try {
    const validation = makeValidation(types => ({
      payload: req.body,
      checks: {
        firstName: { type: types.string },
        lastName: { type: types.string },
        title: { type: types.string },
      }
    }));
    console.log("3");
    if (!validation.success) return res.status(400).json(validation);
    console.log("31231");
    const { firstName, middleName, lastName, title } = req.body;
    const admin = await adminModel.createAdmin(firstName, middleName, lastName, title);
    console.log("3121342231");
    return res.status(200).json({ success: true, admin });
  } catch (error) {
    return res.status(500).json({ success: false, error: error });
  }
};

const onEditAdminByID = async (req, res) => {
  try {
    const validation = makeValidation(types => ({
      payload: req.params,
      checks: {
        id: { type: types.string },
      }
    }));
    if (!validation.success) return res.status(400).json(validation);

    const {id} = req.params;
    
    const {firstName, middleName, lastName, title, enteringYear, yearOfDeparture } = req.body;
    const admin = await adminModel.editAdminByID(id, firstName, middleName, lastName, title, enteringYear, yearOfDeparture);
    
    return res.status(200).json({ success: true, admin });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
}

const onDeleteAdminByID = async (req, res) => {
  try {
    const admin = await adminModel.deleteAdminByID(req.params.id);
    if(admin.deletedCount !== 0){
      return res.status(200).json({ 
        success: true, 
        message: `Deleted an admin with ID ${req.params.id}.` 
      });
    } else {
      res.status(404).json({ error: "Admin with id ${id} doesn't exist" });
    }
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
}


const onGetAllAdmins = async (req, res) => {
  try {
    const admins = await adminModel.getAdmins();
    return res.status(200).json({ success: true, admins });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
}


const onGetAdminByID = async (req, res) => {
  try {
    const admin = await adminModel.getAdminByID(req.params.id);
    return res.status(200).json({ success: true, admin });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
}

module.exports = {
  onCreateAdmin,
  onEditAdminByID,
  onDeleteAdminByID,
  onGetAllAdmins,
  onGetAdminByID
};