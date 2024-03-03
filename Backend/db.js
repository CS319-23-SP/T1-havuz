const {MongoClient} = require("mongodb");

let dbConnection;

module.exports = {
    connectToDb: (cb) => {
        MongoClient.connect("mongodb://localhost:27017/db")
            .then( (client) => {
                dbConnection = client.db();
                return cb();
            })
            .catch(err => {
                console.log("erro connectin database");
                return cb(err);
            })
    },
    getDb: () => dbConnection
}