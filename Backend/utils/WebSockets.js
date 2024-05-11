class WebSockets {
  constructor() {
    this.users = [];
    this.io = null; 
  }

  init(io) {
    this.io = io;
    io.on('connection', this.connection);
  }

  connection = (socket) => {
    console.log('A user conneected');
    
    socket.on('disconnect', () => {
      console.log('User disconnected');
      this.users = this.users.filter((user) => user.socketId !== socket.id);
    });

    socket.on('identity', async (userId) => {
      console.log("he is", userId)
      this.users.push({
        socketId: socket.id,
        userId: userId,
      });
    });

    socket.on('subscribe', async (room, otherUserId = "") => {
      console.log(room, otherUserId)
      await this.subscribeOtherUser(room, otherUserId);
      socket.join(room);
    });

    socket.on('unsubscribe', async (room) => {
      socket.leave(room);
    });

    socket.on('chat message', (msg) => {
      console.log('Message: ' + msg);
      this.io.emit('chat message', msg); 
    });
  };

  subscribeOtherUser = async (room, otherUserId) => {
    const userSockets = this.users.filter(
      (user) => user.userId === otherUserId
    );
    for (const userInfo of userSockets) {
      const socketConn = this.io.sockets.connected[userInfo.socketId];
      if (socketConn) {
        socketConn.join(room);
      }
    }
  };
}

module.exports = new WebSockets();
