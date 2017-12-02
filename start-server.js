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
      S.map(S.fromMaybe({})) // only valid values
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

function startEditor(onMsg) {
  const onClose = code => {
    console.log('editor closed with code ', code)
  }
  const tellKak = startKak( onMsg, onClose )
  return tellKak
}

// startServer : () -> SideEffect@Server
function startServer () {
  const host = '0.0.0.0'
  const port = '8090'
  const server = new WebSocketServer.Server({ host, port })
  server.on('connection', socket => {
    const jrpc = new JsonRPC()
    socket.jrpc = jrpc
    jrpc.toStream = msg => socket.send(msg)
    socket.on('message', function(message) {
        jrpc.messageHandler(message);
    });



    const onKakUpdate = data => {
      // console.log('NEW MESSAGE')
      // console.log(data)
      socket.jrpc.call('ui.update', [data])
    }

    const tellKak = startEditor(onKakUpdate)

    socket.on('ui.keys', msg => jrpc.messageHandler(msg))

    jrpc.on('ui.keys', ['keys'], keys => {
      console.log(keys)
      tellKak(keys)
      return 'OK'
    })

    jrpc.call('ui.update', ['editor started'])


  })
}

