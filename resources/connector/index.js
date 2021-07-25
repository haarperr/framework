const http = require("http").createServer();
const express = require("express");
const app = express();

app.use(express);

const WebSocketServer = require("websocket").server;
const server = new WebSocketServer({
	httpServer: http,
	autoAcceptConnections: false,
});

const endpoints = new Set();

// Websocket server: callbacks.
server.on("request", function(socket) {
	if (!socket.remoteAddress || !socket.remoteAddress.match(/^::\d+/g)) {
		socket.reject();
		return
	}

	console.log("connected!")

	// Accept the socket.
	var websocket = socket.accept(null, socket.origin);

	websocket.on("message", message => {
		console.log("messaging", message)
	});
});

// Websocket server: listening.
http.listen(42111, () => {
	console.log("Connector open!")
});

on("playerConnecting", (name, setKickReason, deferrals) => {
	let player = source;
	let endpoint = GetPlayerEndpoint(player);

	if (!endpoints.has(endpoint)) {
		endpoints.add(endpoint);
	}

	deferrals.defer();
})