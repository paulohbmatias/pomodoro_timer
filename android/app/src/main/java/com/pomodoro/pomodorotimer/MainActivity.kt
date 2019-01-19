package com.pomodoro.pomodorotimer;

import android.graphics.BitmapFactory
import android.os.Bundle
import android.support.v4.app.NotificationCompat
import android.support.v4.app.NotificationManagerCompat

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.media.RingtoneManager
import android.net.Uri
import android.app.PendingIntent
import android.content.Intent




class MainActivity: FlutterActivity() {

  private val CHANNEL = "com.pomodoro.pomodorotimer/notification"
  private val notificationTime = NotificationCompat.Builder(this, CHANNEL)
  private val notificationTimeOver = NotificationCompat.Builder(this, CHANNEL)
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      val contentIntent = PendingIntent.getActivity(this, 0,
              Intent(this, MainActivity::class.java), PendingIntent.FLAG_UPDATE_CURRENT)
      when (call.method) {
          "createNotification" -> {
            val title = call.argument<String>("title")
            val content = call.argument<String>("content")
            createNotification(title, content, contentIntent)
            result.success("")
          }
          "timeOverNotification" -> {
            val title = call.argument<String>("title")
            val content = call.argument<String>("content")
            timeOverNotification(title, content, contentIntent)
            result.success("")
          }
          "updateNotification" -> {
            val content = call.argument<String>("content")
            updateNotification(content)
            result.success("")
          }
          "cancelNotification" -> {
            cancelNotification()
            result.success("")
          }
          else -> result.notImplemented()
      }

    }

  }

  private fun createNotification(title: String?, content: String?, contentIntent: PendingIntent){
    notificationTime
            .setSmallIcon(R.drawable.ic_stat_pomodoro)
            .setLargeIcon(BitmapFactory.decodeResource(this.resources,
                    R.mipmap.ic_launcher))
            .setContentTitle(title)
            .setContentIntent(contentIntent)
            .setContentText(content).priority = NotificationCompat.PRIORITY_MAX
    with(NotificationManagerCompat.from(this)) {
      // notificationId is a unique int for each notification that you must define
      cancel(2)
      notify(1, notificationTime.build())
    }
  }

  private fun updateNotification(content: String?){
    notificationTime.setContentText(content)
    with(NotificationManagerCompat.from(this)) {
      // notificationId is a unique int for each notification that you must define
      notify(1, notificationTime.build())
    }
  }

  private fun cancelNotification(){
    with(NotificationManagerCompat.from(this)) {
      // notificationId is a unique int for each notification that you must define
      cancel(1)
    }
  }

  private fun timeOverNotification(title: String?, content: String?, contentIntent: PendingIntent){
    val alarmSound = Uri.parse("android.resource://" + packageName + "/" + R.raw.good_things_happen)
    val vibrate = longArrayOf(500, 500, 500, 500, 500, 500, 500)
    notificationTimeOver
            .setSmallIcon(R.drawable.ic_stat_pomodoro)
            .setLargeIcon(BitmapFactory.decodeResource(this.resources,
                    R.mipmap.ic_launcher))
            .setContentTitle(title)
            .setSound(alarmSound)
            .setVibrate(vibrate)
            .setContentIntent(contentIntent)
            .setContentText(content).priority = NotificationCompat.PRIORITY_DEFAULT
    with(NotificationManagerCompat.from(this)) {
      // notificationId is a unique int for each notification that you must define
      cancel(1)
      notify(2, notificationTimeOver.build())
    }
  }
}
