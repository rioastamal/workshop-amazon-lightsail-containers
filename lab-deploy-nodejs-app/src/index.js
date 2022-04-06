const express = require('express');
const app = express();
const port = process.env.APP_PORT || 8080;

app.set('json spaces', 2);
app.get('/', function mainRoute(req, res) {
  const mainResponse = {
    "hello": "Indonesia Belajar!"
  };
  
  res.json(mainResponse);
});

app.listen(port, function() {
  console.log(`API server running on port ${port}`);
});