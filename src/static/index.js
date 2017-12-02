// pull in desired CSS/SASS files
require( './styles/main.scss' );
import S from 'sanctuary'

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
const app = Elm.Main.embed( document.getElementById( 'main' ) );


var JsonRPC = require('simple-jsonrpc-js');

//configure
var jrpc = new JsonRPC();
var socket = new WebSocket("ws://localhost:8090");


//wait of call
jrpc.on('ui.update', updates => {
  S.pipe([
    S.filter( update => update.method === 'draw' ),
    S.map( update => {
      console.log(update.params[0])
      app.ports.draw.send(update.params[0][0])
    } )
  ])(updates)
})
window.app = app

socket.onmessage = function(event) {
    jrpc.messageHandler(event.data);
};

jrpc.toStream = function(_msg){
    socket.send(_msg);
};

socket.onerror = function(error) {
    console.error("Error: " + error.message);
};

socket.onclose = function(event) {
    if (event.wasClean) {
        console.info('Connection close was clean');
    } else {
        console.error('Connection suddenly close');
    }
    console.info('close code : ' + event.code + ' reason: ' + event.reason);
};

const hello = () => ({ "jsonrpc": "2.0", "method": "keys", "params": ["iHello<esc>"] })
const bye = () => ({ "jsonrpc": "2.0", "method": "keys", "params": [":q<ret>"] })


//usage
//after connect
socket.onopen = function(){

    //calls
    setTimeout(() => {
      console.log('calling keypress')
      jrpc.call('ui.keys', [hello()])
    }, 1000)

    setTimeout(() => {
      console.log('calling keypress')
      jrpc.call('ui.keys', [bye()])
    }, 2000)
    
};
