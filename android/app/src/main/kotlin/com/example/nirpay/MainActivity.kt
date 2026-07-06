package com.example.nirpay

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "nirpay.com/hce"
    private val prefsName = "FlutterSharedPreferences"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "setNfcData") {
                val data = call.argument<String>("data")
                val transactionId = call.argument<String>("transactionId")
                if (data != null) {
                    val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
                    prefs.edit()
                        .putString("flutter.hce_data", data)
                        .putString("flutter.hce_transaction_id", transactionId ?: "")
                        .putString("flutter.hce_status", "READY_TO_SEND")
                        .putString("flutter.hce_ack_status", "WAITING_FOR_READ")
                        .putLong("flutter.hce_prepared_at", System.currentTimeMillis())
                        .remove("flutter.hce_sent_at")
                        .remove("flutter.hce_ack_received_at")
                        .apply()
                    result.success(true)
                } else {
                    result.error("UNAVAILABLE", "Data is null", null)
                }
            } else if (call.method == "getNfcTransferStatus") {
                val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
                result.success(hashMapOf(
                    "transactionId" to (prefs.getString("flutter.hce_transaction_id", "") ?: ""),
                    "status" to (prefs.getString("flutter.hce_status", "IDLE") ?: "IDLE"),
                    "ackStatus" to (prefs.getString("flutter.hce_ack_status", "WAITING_FOR_READ") ?: "WAITING_FOR_READ"),
                    "preparedAt" to prefs.getLong("flutter.hce_prepared_at", 0L),
                    "sentAt" to prefs.getLong("flutter.hce_sent_at", 0L),
                    "ackReceivedAt" to prefs.getLong("flutter.hce_ack_received_at", 0L)
                ))
            } else if (call.method == "markNoAck") {
                val prefs = getSharedPreferences(prefsName, Context.MODE_PRIVATE)
                prefs.edit()
                    .putString("flutter.hce_status", "NO_ACK")
                    .putString("flutter.hce_ack_status", "NO_ACK")
                    .apply()
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }
}
