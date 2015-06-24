var http = require('http')
var dispatcher = require('httpdispatcher')

const PORT = 8080

dispatcher.onGet("/200", function(req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain'})
    res.end('200 OK')
})

dispatcher.onGet("/401", function(req, res) {
    res.writeHead(401, {'Content-Type': 'text/plain'})
    res.end('401 Unauthorized')
})

function handleRequest(request, response) {
    try {
        console.log("request: " + request.url)
        dispatcher.dispatch(request, response)
    } catch(err) {
        console.log(err)
    }
}

var server = http.createServer(handleRequest)

server.listen(PORT, function() {
    console.log("Server listening on http://localhost:%s", PORT)
})
