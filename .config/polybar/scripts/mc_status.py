#from mcstatus import MinecraftServer
import time
import json
import argparse

# initial config
parser = argparse.ArgumentParser()
parser.add_argument(
    '-c',
    '--cache',
    type=str,
    metavar='cache file',
    dest='CACHE_FILE',
    default="/tmp/mc_status.cache"
)
args = parser.parse_args()

now = int(time.time())

# get player data from cache or server
with open(args.CACHE_FILE, "w+") as cache_file:
    try:
        cache = json.loads(cache_file.read())
    except json.decoder.JSONDecodeError:
        cache = json.loads('{"time":-1}')
    if cache["time"]+15 < now:
        cache["time"] = now

        server = MinecraftServer.lookup("***REMOVED***")
        try:
            status = server.status()
            players = list(map(lambda x: x.name, status.players.sample))
            cache["players"] = players
        except TypeError:
            cache["players"] = []
        except OSError:
            cache["players"] = ['turning on']
        finally:
            json.dump(cache, cache_file)

# construct scrolling output
raw = ' '.join(cache["players"])

window = 16
idx = int(time.time()) % window
raw += window//(len(raw)+1) * (' ' + raw)
display = raw[idx:idx+window]

# output the final string
print(display)
