import asyncio
import config


task = asyncio.create_task(config.backlight.start_light())
