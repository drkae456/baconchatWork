const express = require("express");
const path = require("path");
const app = express();
const port = 80;

// Serve static files from the src/public directory
app.use(express.static(path.join(__dirname, "src", "views"))); // Adjusted to serve from 'src/public'

// Route to serve index.html
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "src", "views", "index.html")); // Adjusted path
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
