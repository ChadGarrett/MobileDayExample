import http.server
import random
import socketserver
import json

# Define a Pokemon class
class Pokemon:
    def __init__(self, name, level, experience):
        self.name = name
        self.level = level
        self.experience = experience

pokemon_list = [
    Pokemon(name=f"Pokemon {i}", level=random.randint(10, 99), experience=random.randint(100, 5000))
    for i in range(1, 101)
]

# Define a handler to handle incoming requests
class PokemonHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Set response headers
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.end_headers()

        pokemon = random.choice(pokemon_list)
        pokemon_json = json.dumps({
            'name': pokemon.name,
            'level': pokemon.level,
            'experience': pokemon.experience
        })

        # Send the JSON response
        self.wfile.write(pokemon_json.encode('utf-8'))

# Set up the server
port = 8000
httpd = socketserver.TCPServer(('', port), PokemonHandler)

print(f'Serving on port {port}')
httpd.serve_forever()
