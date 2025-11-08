package com.example.gallery_app

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.app.Notification
import android.os.Build
import androidx.annotation.RequiresApi

class NotificationListener : NotificationListenerService() {
    override fun onListenerConnected() {
        super.onListenerConnected()
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val notif = sbn.notification
        val extras = notif.extras
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val pkg = sbn.packageName
        val whenMs = sbn.postTime

        NotificationStore.save(applicationContext, pkg, title, text, whenMs)
    }
}
