#!/usr/bin/env python

import asyncio
import datetime
import sys
import websockets

URI = "ws://websocket-echo:80"

async def run(client_id: int, messages):
    while True:
        start_time = datetime.datetime.now()
        async with websockets.connect(URI) as websocket:
            for message_id in range(messages):
                await websocket.send("{client_id}:{message_id}")
                await websocket.recv()

        print(f"Sent {messages} messages from {clients} clients in {datetime.datetime.now() - start_time}")


async def benchmark(clients, messages):
    await asyncio.wait([
        asyncio.create_task(run(client_id, messages))
        for client_id in range(clients)
    ])


if __name__ == "__main__":
    clients, messages = int(sys.argv[1]), int(sys.argv[2])
    print(f"Starting load gen with {messages} messages from {clients} clients")
    asyncio.run(benchmark(clients, messages))
