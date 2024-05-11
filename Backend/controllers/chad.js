const makeValidation = require('@withvoid/make-validation');
const ChadMessageModel = require('../models/chadMessage');
const ChadRoomModel = require('../models/chadRoom');
const AuthModel = require('../models/auth');

const initiate = async (req, res) => {
  try {      
    const validation = makeValidation(types => ({
      payload: req.body,
      checks: {
        userIds: { 
          type: types.array, 
          options: { unique: true, empty: false, stringOnly: true } 
        },
      }
    }));
    
    if (!validation.success) return res.status(400).json({ ...validation });
    
    const { userIds } = req.body;
    const { _id: chadInitiator } = req;
    const allUserIds = [...userIds, chadInitiator];
    const chadRoom = await ChadRoomModel.initiateChat(allUserIds, chadInitiator);

    global.io.emit('newchatroom', chadRoom);
    global.io.emit('event', chadRoom);
    
    return res.status(200).json({ success: true, chatRoom: chadRoom });
  } catch (error) {
    return res.status(500).json({ success: false, error: error })
  }
}

const postMessage = async (req, res) => {
  try {
    const { roomId } = req.params;
    const validation = makeValidation(types => ({
      payload: req.body,
      checks: {
        messageText: { type: types.string },
      }
    }));    

    if (!validation.success) return res.status(400).json(validation);
    
    const messagePayload = {
      messageText: req.body.messageText,
    };
    const currentLoggedUser = req._id;
    const post = await ChadMessageModel.createPostInChatRoom(roomId, messagePayload, currentLoggedUser);
    
    global.io.emit('newmessage', roomId);
    
    return res.status(200).json({ success: true, post });
  } catch (error) {
    return res.status(500).json({ success: false, error: error });
  }
};

module.exports = { initiate, postMessage };



const getConversationByRoomId = async (req, res) => {
  try {
    const { roomId } = req.params;
    const room = await ChadRoomModel.getChatRoomByRoomId(roomId)
    if (!room) {
      return res.status(400).json({
        success: false,
        message: 'No room exists for this id',
      });
    }
    console.log(room.userIds);
    const users = await AuthModel.getAuthByIds(room.userIds);
    const options = {
      page: parseInt(req.query.page) || 0,
      limit: parseInt(req.query.limit) || 10,
    };
    //console.log(roomId)
    const conversation = await ChadMessageModel.getConversationByRoomId(roomId, options);
    return res.status(200).json({
      success: true,
      conversation,
      users,
    });
  } catch (error) {
    return res.status(500).json({ success: false, error });
  }
}

const getConversations = async (req, res) => {
  try {
      const currentLoggedUser = req._id;      

      const userChatRooms = await ChadRoomModel.getChatRoomsByUserId(currentLoggedUser);
      if (!userChatRooms || userChatRooms.length === 0) {
          return res.status(200).json({
              success: true,
              conversations: [],
          });
      }

      const roomIds = userChatRooms.map(room => room._id);

      const conversations = await Promise.all(roomIds.map(async roomId => {
          const room = await ChadRoomModel.getChatRoomByRoomId(roomId);
          //const users = await AuthModel.getAuthByIds(room.userIds);
          const options = {
              page: parseInt(req.query.page) || 0,
              limit: parseInt(req.query.limit) || 10,
          };
          const conversation = await ChadMessageModel.getConversationByRoomId(roomId, options);
          return {
              room,
              //users,
              conversation
          };
      }));

      return res.status(200).json({
          success: true,
          conversations,
      });
  } catch (error) {
      return res.status(500).json({ success: false, error });
  }
}

module.exports = {
    initiate,
    postMessage,
    getConversations,
    getConversationByRoomId,
  };

