package com.example.nirpay

import android.content.Context
import android.nfc.cardemulation.HostApduService
import android.os.Bundle
import android.util.Log
import java.util.Arrays

class NirpayHceService : HostApduService() {

    companion object {
        private const val TAG = "NirpayHceService"
        
        // Command APDU to select the Nirpay AID: F0010203040506
        private val SELECT_APDU = byteArrayOf(
            0x00.toByte(), 0xA4.toByte(), 0x04.toByte(), 0x00.toByte(),
            0x07.toByte(), 
            0xF0.toByte(), 0x01.toByte(), 0x02.toByte(), 0x03.toByte(), 0x04.toByte(), 0x05.toByte(), 0x06.toByte()
        )

        // Command APDU to read data from the card
        private val READ_DATA_APDU = byteArrayOf(
            0x00.toByte(), 0xCA.toByte(), 0x00.toByte(), 0x00.toByte(), 0x00.toByte()
        )

        // Command APDU sent by the receiver after it successfully reads transaction data.
        private val SEND_ACK_APDU = byteArrayOf(
            0x00.toByte(), 0xDA.toByte(), 0x00.toByte(), 0x00.toByte(), 0x00.toByte()
        )

        // "OK" status word sent in response to SELECT AID command (0x9000)
        private val SELECT_OK_SW = byteArrayOf(0x90.toByte(), 0x00.toByte())

        // "UNKNOWN" status word sent in response to invalid APDU command (0x6F00)
        private val UNKNOWN_CMD_SW = byteArrayOf(0x6F.toByte(), 0x00.toByte())

        private const val PREFS_NAME = "FlutterSharedPreferences"
        private const val KEY_HCE_DATA = "flutter.hce_data"
        private const val KEY_HCE_STATUS = "flutter.hce_status"
        private const val KEY_HCE_ACK_STATUS = "flutter.hce_ack_status"
        private const val KEY_HCE_SENT_AT = "flutter.hce_sent_at"
        private const val KEY_HCE_ACK_RECEIVED_AT = "flutter.hce_ack_received_at"
    }

    override fun processCommandApdu(commandApdu: ByteArray?, extras: Bundle?): ByteArray {
        if (commandApdu == null) return UNKNOWN_CMD_SW

        Log.d(TAG, "Received APDU: ${bytesToHex(commandApdu)}")

        if (Arrays.equals(SELECT_APDU, commandApdu)) {
            Log.d(TAG, "SELECT AID command matched. Returning OK.")
            return SELECT_OK_SW
        } else if (Arrays.equals(READ_DATA_APDU, commandApdu)) {
            Log.d(TAG, "READ DATA command matched. Fetching from SharedPreferences.")
            
            val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val nfcData = prefs.getString(KEY_HCE_DATA, "No data") ?: "No data"
            prefs.edit()
                .putString(KEY_HCE_STATUS, "DATA_SENT")
                .putLong(KEY_HCE_SENT_AT, System.currentTimeMillis())
                .apply()
            
            val dataBytes = nfcData.toByteArray(Charsets.UTF_8)
            val response = ByteArray(dataBytes.size + SELECT_OK_SW.size)
            System.arraycopy(dataBytes, 0, response, 0, dataBytes.size)
            System.arraycopy(SELECT_OK_SW, 0, response, dataBytes.size, SELECT_OK_SW.size)
            
            Log.d(TAG, "Sending data: $nfcData")
            return response
        } else if (Arrays.equals(SEND_ACK_APDU, commandApdu)) {
            Log.d(TAG, "SEND ACK command matched. Marking transaction as received.")

            val prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit()
                .putString(KEY_HCE_STATUS, "PENDING_SYNC")
                .putString(KEY_HCE_ACK_STATUS, "ACK_RECEIVED")
                .putLong(KEY_HCE_ACK_RECEIVED_AT, System.currentTimeMillis())
                .apply()

            return SELECT_OK_SW
        }

        return UNKNOWN_CMD_SW
    }

    override fun onDeactivated(reason: Int) {
        Log.d(TAG, "Deactivated: $reason")
    }

    private fun bytesToHex(bytes: ByteArray): String {
        val hexChars = CharArray(bytes.size * 2)
        for (j in bytes.indices) {
            val v = bytes[j].toInt() and 0xFF
            hexChars[j * 2] = "0123456789ABCDEF"[v ushr 4]
            hexChars[j * 2 + 1] = "0123456789ABCDEF"[v and 0x0F]
        }
        return String(hexChars)
    }
}
