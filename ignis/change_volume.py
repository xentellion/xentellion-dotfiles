import asyncio
import config


# Dull colors if volume is muted
config.volume.volume_slider.style = (
    f"opacity: {0.5 if config.volume.audio.speaker.is_muted else 1};"
)
task = asyncio.create_task(config.volume.start_volume())
