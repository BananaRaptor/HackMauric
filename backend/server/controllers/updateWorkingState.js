const addPump = require('./addPump');

const handleWorkingStateUpdate = (req, res, db) => {
    const query = {
        name: "update working state",
        text: `UPDATE pump SET workingstate = TRUE WHERE pumpid = $1`,
        values: [
            req.body.mac
        ]
    };
    db.query(query, (err, data) => {
        if(err) {
            console.log(err.stack);
            addPump.saveNewPump(req.body.mac, flow, true, client);
        }
    });
}

module.exports = {
    handleWorkingStateUpdate
}