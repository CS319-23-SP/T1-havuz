const makeValidation = require('@withvoid/make-validation');
const ForumReply = require('../models/forumReply');
const ForumPost = require('../models/forumPost');
const AuthModel = require('../models/auth');
const { v4: uuidv4 } = require("uuid");

const createForumReply = async (req, res) => {
    try {
        
        const validation = makeValidation(types => ({
            payload: req.body,
            checks: {
                messageText: { type: types.string },
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

        const repliesOfPost = await ForumReply.getDirectRepliesOfReply(replId);
        const post = await ForumReply.findById(replId);

        return res.json({ repliesOfPost: repliesOfPost, post });
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
        
        const validation = makeValidation(types => ({
            payload: req.body,
            checks: {
              title: { type: types.string },
              messageText: { type: types.string },
            }
          }));   
          
        
        if (!validation.success) return res.status(400).json({ ...validation });

        const forumInitiator = req._id;
        const { title, message: messageText, sectionId } = req.body;

        const uniqueId = uuidv4();
        const forumPost = await ForumPost.createForumPost(
            forumInitiator,
            title,
            sectionId,
            uniqueId
        );

        const initialReply = await ForumReply.createForumReplyWithId(
            messageText,
            forumInitiator, 
            uniqueId,
            0, 
        );


        return res.status(201).json({ forumPost, initialReply });
    } catch (error) {
        console.error('Error creating forum post:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

const getForumPostsBySectionId = async (req, res) => {
    try {
        const { sectionId } = req.params;

        const forumPosts = await ForumPost.getAllForumPostsBySectionId(sectionId);

        return res.json({ forumPosts });
    } catch (error) {
        console.error('Error getting forum posts by section ID:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};


module.exports = {  
    createForumReply,
    getForumRepliesByReplyId,
    getFirstReplyWithReplies,
    createForumPost,
    getForumPostsBySectionId
    };
