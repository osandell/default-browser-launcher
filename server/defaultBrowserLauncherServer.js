// The purpose of this server is to recieve a url from the Chrome extension
// and open it in the default browser.

open = require("open");

var express = require("express");
var app = express();

var socketServer = require("http").createServer(app);
var io = require("socket.io")(socketServer);

socketServer.listen(58347, function () {
  console.log("Socket server listening on : 58347");
});

io.on("connection", function (socket) {
  console.log("Socket connection established");

  socket.on("message", (url) => {
    console.log("Received message: " + url);
    url && open(url);
  });
});
