const { Client } = require('pg');

const connectionString = "postgres://postgres:hackathonDB@database-1.cp00z02f8kdz.us-east-2.rds.amazonaws.com:5432/postgres";


const client = new Client({
	connectionString: connectionString
	//host: 'database-1.cp00z02f8kdz.us-east-2.rds.amazonaws.com',
	//port: 5432,
	//user: 'postgres',
	//password: 'hackathonDB',
});

//const connectionString = "postgres://postgres:hackathon@db.us-est-2.rds.amazonaws.com:5432/database-1";

client.connect(err => {
	if (err) {
		console.error('connection error', err.stack)
	} else {
		console.log('connected')
	}
});

module.exports = client;
