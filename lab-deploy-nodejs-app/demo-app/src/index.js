const express = require('express');
const app = express();
const port = process.env.APP_PORT || 8080;
const { networkInterfaces } = require('os');

app.set('json spaces', 2);
app.get('/', function mainRoute(req, res) {
  const network = networkInterfaces();
  delete network['lo']; // remove loopback interface

  const mainResponse = {
    "hello": "Indonesia Belajar!",
    "network": network
  };

  res.json(mainResponse);
});

app.listen(port, function() {
  console.log(`API server running on port ${port}`);
});