const { spawn } = require('child_process');
const S = require('sanctuary')
var WebSocketServer = new require('ws');
var JsonRPC = require('simple-jsonrpc-js');


const hello = () => ({ "jsonrpc": "2.0", "method": "keys", "params": ["iHello<esc>"] })
const bye = () => ({ "jsonrpc": "2.0", "method": "keys", "params": [":q<ret>"] })

startServer()

Buffer$prototype$toString = function(){
  return 'new Buffer(' + toString(Array.from(this)) + ')';
};

// startKak : ( List KakUpdate -> a ) -> tell
function startKak (onData, onClose) {
  const kak = spawn('kak', ['-ui', 'json'])
  const handleData = data => {
    const res = S.pipe([
      S.splitOn('\n'), // split into kak msg lines
      S.map(S.parseJson(S.is(Object))), // parse messages
      S.filter(S.isJust), // filter out empty last line
      S.map(S.fromMaybe({})), // only valid values
      S.toString // convert back to JSON
    ])(data.toString()) // convert buffer to string; Sanctuary does not like Buffers https://github.com/sanctuary-js/sanctuary-type-classes/issues/31
    onData(res)
  }
  // kak.stderr.on('data', data => onData(data.toString().split('\n')) )
  kak.stdout.on('data', handleData )
  kak.on('close', onClose)

  // tell : KakKeystrokes -> SideEffect@Kak
  const tell = message => kak.stdin.write(JSON.stringify(message))
  return tell
}

function startEditor() {
  const onMsg = data => {
    console.log('NEW MESSAGE')
    console.log(data) 
  }
  const onClose = code => {
    console.log('editor closed with code ', code)
  }
  const tellKak = startKak( onMsg, onClose )
  setTimeout( () => tellKak(hello()), 1000 )
  setTimeout( () => tellKak(bye()), 3000 )
}

// startServer : () -> SideEffect@Server
function startServer () {
  const host = '0.0.0.0'
  const port = '8090'
  const server = new WebSocketServer.Server({ host, port })
  server.on('connection', socket => {
    startEditor()
  })
}


/*

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
