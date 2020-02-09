const handleGetFlow = (req, res, db) => {
    console.log("got req");
    const query = {
        name: "user get flow data",
        text: `SELECT flow, workingstate FROM pump WHERE pumpid = $1`,
        values: [
            req.params.mac
        ]
    };
    db.query(query, (err, data) => {
        if(err) {
            console.log(err.stack);
        }else{
            console.log(data.rows[0]);
            res.send(data.rows[0]);
            console.log("sent data");
        }
    });
}

module.exports = {
    handleGetFlow
}