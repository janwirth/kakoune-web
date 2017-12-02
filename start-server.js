const { spawn } = require('child_process');
var WebSocketServer = new require('ws');
var JsonRPC = require('simple-jsonrpc-js');


const hello = () => ({ "jsonrpc": "2.0", "method": "keys", "params": ["iHello<esc>"] })

startServer()

// startKak : ( KakUpdate -> a ) -> tell 
function startKak (onData) {
  const kak = spawn('kak', ['-ui', 'json'])
  kak.stderr.on('data', data => onData(data.toString()) )
  kak.stdout.on('data', data => onData(data.toString()) )

  // tell : KakKeystrokes -> SideEffect@Kak
  const tell = message => kak.stdin.write(JSON.stringify(message))
  return tell
}

// startServer : () -> SideEffect@Server
function startServer () {
  const tellKak = startKak( data => console.log(data) )
  setTimeout( () => tellKak(hello()), 1000 )
}
/*
const kak = spawn('kak', ['-ui', 'json']);
startServer()

function startKak (callback) {

  kak.stdout.on('data', (data) => {
    console.log(`stdout: ${data}`);
    setTimeout(hello, 1000)
    
  });

  kak.stderr.on('data', (data) => {
    console.log(`stderr: ${data}`);
  });

  kak.on('close', (code) => {
    console.log(`child process exited with code ${code}`);
  });

  // TELL
  const tell = sth => kak.stdin.write(JSON.stringify(sth))
  // LISTEN
  kak.stdout.on('data', callback)

  return tell
}

function startServer () {
  function add(x, y){
    return x + y;
  }

  //over ws

  var webSocketServer = new WebSocketServer.Server({
      host: '0.0.0.0',
      port: 8090
  }).on('connection', function(ws) {
      var jrpc = new JsonRPC();
      ws.jrpc = jrpc;

      ws.jrpc.toStream = function(message){
          ws.send(message);
      };

      ws.on('ui.keypress', function(message) {
          jrpc.messageHandler(message);
      });

      jrpc.on('add', ['x', 'y'], add);

      jrpc.on('mul', ['x', 'y'], function(x, y){
          return x*y;
      });

      var item_id = 120;

      jrpc.on('create', ['item', 'rewrite'], function(item, rewrite){
          item_id ++;
          item.id = item_id;
          return item;
      });

      // KAKOUNE INTERFACE
      jrpc.call('ui.update', ["starting..."]);
      const callback = u => jrpc.call('kak.update', JSON.stringify(u))
      const tellKak = startKak(callback)
      setTimeout( x => tellKak(hello), 2000)
  });
}
*/
