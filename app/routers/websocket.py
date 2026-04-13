import logging

from fastapi import APIRouter, WebSocket
from starlette.websockets import WebSocketDisconnect

logger = logging.getLogger(__name__)

router = APIRouter(tags=["ws"])


@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket) -> None:
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            logger.info("Message received: %s", data)
            await websocket.send_text(data)
    except WebSocketDisconnect:
        logger.info("Client disconnected")
