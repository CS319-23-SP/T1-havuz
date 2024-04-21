const socketIo = require('socket.io');

class WebSockets {
  constructor() {
    this.users = [];
  }

  connection = (client) => {
    client.on("disconnect", () => {
      this.users = this.users.filter((user) => user.socketId !== client.id);
    });
    client.on("identity", async (userId) => {
      this.users.push({
        socketId: client.id,
        userId: userId,
      });
    });
    client.on("subscribe", async (room, otherUserId = "") => {
      await this.subscribeOtherUser(room, otherUserId);
      client.join(room);
    });
    client.on("unsubscribe", async (room) => {
      client.leave(room);
    });
  };

  subscribeOtherUser = async (room, otherUserId) => {
    const userSockets = this.users.filter(
      (user) => user.userId === otherUserId
    );
    for (const userInfo of userSockets) {
      const socketConn = global.io.sockets.connected[userInfo.socketId];
      if (socketConn) {
        socketConn.join(room);
      }
    }
  };
}

module.exports = new WebSockets();
