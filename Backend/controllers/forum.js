const makeValidation = require('@withvoid/make-validation');
const ForumReply = require('../models/forumReply');
const ForumPost = require('../models/forumPost');
const AuthModel = require('../models/auth');

const createForumReply = async (req, res) => {
    try {
        
        const validation = makeValidation(types => ({
            payload: req.body,
            checks: {
                message: { type: types.string },
            },
        }));
        if (!validation.success) return res.status(400).json({ ...validation });

        const postedByUser  = req._id;
        const { parentReplyId } = req.params;
        const message = req.body;

        const parentReply = await ForumReply.findById(parentReplyId);
        if (!parentReply) {
            return res.status(404).json({ error: 'Parent reply not found' });
        }

        const forumReply = await ForumReply.createForumReply(message, postedByUser, parentReplyId);

        return res.status(201).json({ forumReply });
    } catch (error) {
        console.error('Error creating forum reply:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

const getForumRepliesByReplyId = async (req, res) => {
    try {
        const { replId } = req.params;

        //console.log(replId)

        const forumReplies = await ForumReply.getDirectRepliesOfReply(replId);

        return res.json({ forumReplies });
    } catch (error) {
        console.error('Error getting forum replies:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

const getFirstReplyWithReplies = async (req, res) => {
    try {
        const { postId } = req.params;

        const validation = makeValidation(types => ({
            params: {
                postId: types.string().required(),
            },
        }));
        if (!validation.success) return res.status(400).json({ ...validation });

        const firstReplyWithReplies = await ForumPost.getFirstReplyWithReplies(postId);

        return res.json({ firstReplyWithReplies });
    } catch (error) {
        console.error('Error getting first reply with replies:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

const createForumPost = async (req, res) => {
    try {
        
        //console.log(title)
        const validation = makeValidation(types => ({
            payload: req.body,
            checks: {
              title: { type: types.string },
              message: { type: types.string },
            }
          }));   
          
        
        if (!validation.success) return res.status(400).json({ ...validation });

        const forumInitiator = req._id;
        const { title, message } = req.body;

        const forumPost = await ForumPost.createForumPost(
            forumInitiator,
            title,
        );

        const initialReply = await ForumReply.createForumReply(
            message,
            forumInitiator, 
            forumPost.initialReplyId, 
        );


        return res.status(201).json({ forumPost, initialReply });
    } catch (error) {
        console.error('Error creating forum post:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

module.exports = {  
    createForumReply,
    getForumRepliesByReplyId,
    getFirstReplyWithReplies,
    createForumPost 
    };