var geoip = require('geoip-lite');

const updateF = (req, res, db) => {
    console.log(req.body);
    var ip = req.header('x-forwarded-for') || req.connection.remoteAddress;
    var geo = geoip.lookup(ip);
    console.log("ip = " + ip);
    update(req.body.mac, req.body.flow, db);
};

function update(mac, flow, db){
    const query = {
        name: "updateFlow",
        text: `UPDATE pump AS p SET flow = $1 WHERE p.pumpid = $2`,
        values: [
            flow,
            mac,
        ]
    };
    db.query(query, (err, data) => {
        if(err) {
            console.log(err.stack);
        }else{
            //console.log(data.rows[0]);
        }
    });
}

module.exports = {
    updateFlow: function(req, res, db) {updateF(req, res, db)}
}