import config


# Dull colors if volume is muted
config.volume.volume_slider.style = (
    f"opacity: {0.5 if config.volume.audio.speaker.is_muted else 1};"
)
config.volume.start_volume()
