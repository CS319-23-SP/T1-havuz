const {MongoClient} = require("mongodb");

let dbConnection;

const dburl = "mongodb://localhost:27017/db";

module.exports = {
    connectToDb: (cb) => {
        MongoClient.connect(dburl)
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