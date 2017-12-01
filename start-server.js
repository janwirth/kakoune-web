const { spawn } = require('child_process');
const ls = spawn('kak', ['-ui', 'json']);

const hello = () => ls.stdin.write('{ "jsonrpc": "2.0", "method": "keys", "params": ["iHello<esc>"] }')
ls.stdout.on('data', (data) => {
  console.log(`stdout: ${data}`);
  setTimeout(hello, 1000)
  
});

ls.stderr.on('data', (data) => {
  console.log(`stderr: ${data}`);
});

ls.on('close', (code) => {
  console.log(`child process exited with code ${code}`);
});

