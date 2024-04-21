const makeValidation = require('@withvoid/make-validation');
const authModel = require('../models/auth');
const path = require('path');
const fs = require('fs');

const onCreateAuth = async (req, res) => {
    try {
      const validation = makeValidation(types => ({
        payload: req.body,
        checks: {
          id: { type: types.string },
          password: { type: types.string },
          role: { type: types.string },
        }
      }));
      if (!validation.success) return res.status(400).json(validation);
  
      let profile = null;
      if (req.file) {
          const fileExt = req.file.originalname.split('.').pop(); 
          const filename = `${req.body.id}.${fileExt}`; 
          const newPath = path.join('uploads', filename); 
  
          await fs.promises.rename(req.file.path, newPath);
          profile = newPath; 
      }
  
      const { id, password, role} = req.body;
      const auth = await authModel.createAuth(id, password, role, profile);
      return res.status(200).json({ success: true, auth });
    } catch (error) {
      console.error(error); // Log any caught errors
      return res.status(500).json({ success: false, error: error.message });
    }
  };



const onEditAuthByID = async (req, res) => {
    try {
        const validation = makeValidation(types => ({
        payload: req.body,
        checks: {
            id: { type: types.string },
        }
        }));
        if (!validation.success) return res.status(400).json(validation);

        const { id, password, role} = req.body;
        const auth = await authModel.editAuthByID( id, password, role);
        return res.status(200).json({ success: true, auth });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onDeleteAuthByID = async (req, res) => {
    try {
        const auth = await authModel.deleteAuthByID(req.params.id);
        return res.status(200).json({ 
        success: true, 
        message: `Deleted an authentication with ID ${req.params.id}.` 
        });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetAllAuths = async (req, res) => {
    try {
        const auths = await authModel.getAuths();
        return res.status(200).json({ success: true, auths });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}


const onGetAuthByID = async (req, res) => {
    try {
        const auth = await authModel.getAuthById(req.params.id);
        return res.status(200).json({ success: true, auth });
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

const onLogin = async (req, res) => {
    const {password} = req.body;
    const {id} = req.params;

    try {
        const auth = await authModel.findOne({ id: id});
        const role = auth.role;
        
        if(auth) {
            if(password === auth.password) {
                return res.status(200).json({success: true, authorization: req.authToken, role: role});
            }
        } else {
            return res.status(400).json({success: false});
        }
    } catch (error) {
        return res.status(500).json({ success: false, error: error })
    }
}

module.exports = {
    onCreateAuth,
    onEditAuthByID,
    onDeleteAuthByID,
    onGetAllAuths,
    onGetAuthByID,
    onLogin
};