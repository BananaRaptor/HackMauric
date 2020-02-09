const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const client = require('./connections/db_connection');
const addPump = require('./controllers/addPump');
const updateFlow = require('./controllers/updateFlow');
const getFlow = require('./controllers/getFlow');
const updateWorkingState = require('./controllers/updateWorkingState');

var minutes = 0.2, the_interval = minutes * 60 * 1000;
var pumps = [];
var lastPumps = [];

app.use(bodyParser.urlencoded({
	extended: true
}));

app.use(bodyParser.json());

client.query('SELECT * FROM pump', (err, res) => {
	console.log(res.rows[0]);
});

function getIndex(name){
	return index = pumps.findIndex(function(item, i){
		return item.mac === name
    });
}

function updatePumps(){
	lastPumps = pumps;
	pumps = [];
}

setInterval(function() {
	var length = lastPumps.length;
	if(length <= 0){
		updatePumps();
		return;
	}
	for (var i = 0; i<length; ++i){
		var index = getIndex(lastPumps[i].mac);
		console.log("index :" + index);
		if (index < 0){
			const query = {
				name: "update working state false",
				text: `UPDATE pump AS p SET flow = 0 WHERE p.pumpid = $1`,
				values: [
					lastPumps[i].mac
				]
			};
			client.query(query, (err, data) => {
				if(err) {
					console.log(err.stack);
				}
			});
		}		
	}
	updatePumps();
}, the_interval);

//get////////////////////////////////////////////////////////////////////////////////////
app.get('/', function (req, res) {
	res.send('Bonjour Hubert');
});

app.get('/getFlow/:mac', (req, res) => {
	getFlow.handleGetFlow(req, res, client)
});

// posts/////////////////////////////////////////////////////////////////////////////////

app.post("/addpump", (req, res) => {
	addPump.handelNewPump(req, res, client);
});

app.post('/flow', (req, res) => {
	var index = pumps.findIndex(function(item, i){
		return item.mac === req.body.mac
	});
	if(index == -1){
		pumps.push({mac: req.body.mac, flow: req.body.flow});
		updateWorkingState.handleWorkingStateUpdate(req, res, client);
	}else{
		pumps[index].flow = req.body.flow;
		updateFlow.updateFlow(req, res, client);
	}
	res.send("return");
});
app.listen(3000)
