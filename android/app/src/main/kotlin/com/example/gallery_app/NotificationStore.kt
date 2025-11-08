package com.example.gallery_app

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

object NotificationStore {
    private const val PREF_KEY = "notification_store"

    fun save(context: Context, pkg: String, title: String, text: String, whenMs: Long) {
        val prefs = context.getSharedPreferences(PREF_KEY, Context.MODE_PRIVATE)
        val current = prefs.getString("items", "[]")
        val arr = JSONArray(current)
        val obj = JSONObject()
        obj.put("package", pkg)
        obj.put("title", title)
        obj.put("text", text)
        obj.put("timestamp", whenMs)
        arr.put(obj)
        prefs.edit().putString("items", arr.toString()).apply()
    }

    fun getNotifications(context: Context): String {
        val prefs = context.getSharedPreferences(PREF_KEY, Context.MODE_PRIVATE)
        return prefs.getString("items", "[]") ?: "[]"
    }

    fun clear(context: Context) {
        val prefs = context.getSharedPreferences(PREF_KEY, Context.MODE_PRIVATE)
        prefs.edit().remove("items").apply()
    }
}
