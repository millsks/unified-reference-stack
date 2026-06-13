const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'node-api' });
});

app.get('/', (req, res) => {
  res.json({ message: 'Hello from unified-reference-stack / node-api' });
});

app.listen(PORT, () => {
  console.log(`node-api listening on port ${PORT}`);
});

module.exports = app;
