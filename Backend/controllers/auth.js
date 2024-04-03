const makeValidation = require('@withvoid/make-validation');
const authModel = require('../models/auth');

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

    const { id, password, role} = req.body;
    const auth = await authModel.createAuth(id, password, role);
    return res.status(200).json({ success: true, auth });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
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
    const {id, password} = req.body;

    try {
        const auth = await Auth.findOne({ id: id});
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