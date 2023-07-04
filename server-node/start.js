const { spawn } = require('child_process');
const path = require('path');

const serverProcess = spawn('node', [path.join(__dirname, 'server.js')]);

serverProcess.stdout.on('data', (data) => {
  console.log(`Server output: ${data}`);
});

serverProcess.stderr.on('data', (data) => {
  console.error(`Server error: ${data}`);
});
