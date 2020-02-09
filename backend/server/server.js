const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const client = require('./connections/db_connection');
const addPump = require('./controllers/addPump');

var minutes = 0.5, the_interval = minutes * 60 * 1000;
var pumps = [];
var lastPumps = [];
var brokenPumps = [];

app.use(bodyParser.urlencoded({
        extended: true
}));

app.use(bodyParser.json());

client.query('SELECT * FROM pump', (err, res) => {
	console.log(res.rows[0]);
})

app.get('/', function (req, res) {
        res.send('Bonjour Hubert');
});

app.post("/addpump", (req, res) => {
        addpump.handleNewPump(req, res, client);
});

app.post('/flow', (req, res) => {
	res.send('Message recu');
	var index = pumps.findIndex(function(item, i){
		return item.mac === req.body.mac
	});
	if(index == -1){
		pumps.push({mac: req.body.mac, flow: req.body.flow});
    }else{
		pumps[index].flow = req.body.flow;
    }
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
	var length = pumps.length;
	if(length < 0){
		updatePumps();
	}
	for (var i = 0; i<length; ++i){
		var index = getIndex(pumps[i].mac);
		if (index < 0){
			clinet.query();
		}		
	}
}, the_interval);

app.listen(3000)
