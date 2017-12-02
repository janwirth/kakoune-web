// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
Elm.Main.embed( document.getElementById( 'main' ) );


var JsonRPC = require('simple-jsonrpc-js');

//configure
var jrpc = new JsonRPC();
var socket = new WebSocket("ws://localhost:8090");

//wait of call
jrpc.on('ui.update', u => console.log(u))

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

//usage
//after connect
socket.onopen = function(){

    //calls
    jrpc.call('add', [2, 3]).then(function (result) {
        document.getElementsByClassName('paragraph')[0].innerHTML += 'add(2, 3) result: ' + result + '<br>';
    });

    jrpc.call('mul', {y: 3, x: 2}).then(function (result) {
        document.getElementsByClassName('paragraph')[0].innerHTML += 'mul(2, 3) result: ' + result + '<br>';
    });

    jrpc.batch([
        {call:{method: "add", params: [5,2]}},
        {call:{method: "mul", params: [100, 200]}},
        {call:{method: "create", params: {item: {foo: "bar"}, rewrite: true}}}
    ]);
};
