const handleNewPump = (req, res, db) => {
	saveNewPump(req.body.mac, -1, false, db);
};

function saveNewPump(mac, flow, running, db){
	const query = {
		name: "insertNewPump",
		text: `INSERT INTO pump ("pumpid", "flow", "workingstate") VALUES ($1, $2, $3)`,
		values: [
			mac,
			flow,
			running
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
	saveNewPump: function(mac, flow, running, db) {saveNewPump(mac, flow, running, db)},
	handelNewPump: function(req, res, db) {handleNewPump(req, res, db)}
}

