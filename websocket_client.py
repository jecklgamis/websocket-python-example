import asyncio
import logging
import sys

import websockets

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

WS_URL = "ws://localhost:8080/ws"


async def run() -> None:
    logger.info("Connecting to %s", WS_URL)
    async with websockets.connect(WS_URL) as ws:
        logger.info("Connected — type a message and press Enter to send (Ctrl+C to quit)")
        loop = asyncio.get_event_loop()
        while True:
            line = await loop.run_in_executor(None, sys.stdin.readline)
            message = line.rstrip("\n")
            if not message:
                continue
            await ws.send(message)
            response = await ws.recv()
            logger.info("Response: %s", response)


if __name__ == "__main__":
    try:
        asyncio.run(run())
    except KeyboardInterrupt:
        logger.info("Disconnected")
