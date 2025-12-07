from ignis.widgets import Widget, Box
from ignis.services.notifications import NotificationService


class Notifications(Box):
    def __init__(self):
        self.notifications = NotificationService.get_default()
        self.notifications.connect(
            "notified",
            lambda x, notification: print(notification.app_name, notification.summary),
        )

        super().__init__(
            child=[
                Widget.Scroll(
                    child=Widget.Box(
                        vertical=True,
                        child=self.notifications.bind(
                            "notifications", lambda x: self.get_notes_list()
                        ),
                        halign="start",
                        spacing=5,
                    )
                )
            ],
            css_classes=["controller"],
            vertical=True,
        )

        def get_notes_list(self):
            return [
                Widget.Label(label=x.summary, halign="start")
                for x in self.notifications.notifications
            ]
