KEY = "a really long key used for encryption"

querystring = require("querystring")
util = require("util")
crypto = require("crypto")
hash = crypto.createHash("sha512")
encryptor = crypto.createCipher("aes-256-cbc", KEY)
decryptor = crypto.createDecipher("aes-256-cbc", KEY)

server = require("http").createServer (request, response) ->
  [action, input] = request.url.substring(1).split("/")

  result = switch action
    when "hash"
      hash.update(input).digest("hex")

    when "encrypt"
      encryptor.update(input)
      encryptor.final("hex")

    when "decrypt"
      decryptor.update(input, "hex")
      decryptor.final("utf8")

    else ""

  response.writeHead 200, {"Content-Type": "text/plain"}
  response.end "\n\t#{action}(#{input}) => #{result}\n\n"

server.listen 1337, "127.0.0.1"
console.log "Server running at http://127.0.0.1:1337/"
