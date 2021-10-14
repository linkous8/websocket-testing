#!/usr/bin/env python

import asyncio
import http
import signal

import websockets
import websockets.server

async def ws_echo(websocket: websockets.server.WebSocketServerProtocol, path: str):
    async for message in websocket:
        await websocket.send(message)

async def health_check(path, request_headers):
    if path == "/healthz":
        return http.HTTPStatus.OK, [], b"OK\n"

async def main():
    # Set the stop condition when receiving SIGTERM.
    loop = asyncio.get_running_loop()
    stop = loop.create_future()
    loop.add_signal_handler(signal.SIGTERM, stop.set_result, None)

    async with websockets.serve(
        ws_echo,
        host="",
        port=80,
        process_request=health_check,
    ):
        await stop

if __name__ == "__main__":
    asyncio.run(main())
