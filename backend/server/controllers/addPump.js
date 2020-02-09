const handleNewPump = (req, res, db) => {
	const query = {
		name: "insertNewPump",
		text: `INSERT INTO pump ("pumpid","flow", "pumpname") 
		VALUES ($1,-1.$2)`,
		values: [
			req.body.mac_address,
			req.body.pump_name
		]
	};
	
	db.query(query, (err, data) => {
		if(err) {
			consosle.log(err.stack);
		}
	});
};

module.exports = {
	handleNewPump
};
