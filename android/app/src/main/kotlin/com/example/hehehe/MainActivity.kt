package com.example.hehehe

import android.os.Bundle
import android.os.Looper
import android.content.Context
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL = "com.example.app/gps"
    private val EVENT_CHANNEL = "com.example.app/gps_stream"

    private var locationManager: LocationManager? = null
    private var locationListener: LocationListener? = null

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Untuk request 1x lokasi
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getGpsLocation") {
                getSingleLocation(result)
            } else {
                result.notImplemented()
            }
        }

        // Untuk stream lokasi realtime
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

                    locationListener = object : LocationListener {
                        override fun onLocationChanged(location: Location) {
                            val data = mapOf(
                                "latitude" to location.latitude,
                                "longitude" to location.longitude,
                                "accuracy" to location.accuracy
                            )
                            events?.success(data)
                        }

                        override fun onProviderEnabled(provider: String) {}
                        override fun onProviderDisabled(provider: String) {}
                        @Deprecated("Deprecated in Java")
                        override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
                    }

                    try {
                        locationManager?.requestLocationUpdates(
                            LocationManager.GPS_PROVIDER,
                            1000L, // minimal interval 2 detik
                            1f,    // minimal perubahan 1 meter
                            locationListener as LocationListener,
                            Looper.getMainLooper()
                        )
                    } catch (e: SecurityException) {
                        events?.error("PERMISSION_DENIED", "Permission not granted", null)
                    }
                }

                override fun onCancel(arguments: Any?) {
                    locationManager?.removeUpdates(locationListener as LocationListener)
                }
            }
        )
    }

    private fun getSingleLocation(result: MethodChannel.Result) {
        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

        try {
            val isGpsEnabled = locationManager!!.isProviderEnabled(LocationManager.GPS_PROVIDER)

            if (!isGpsEnabled) {
                result.error("GPS_DISABLED", "GPS is not enabled", null)
                return
            }

            val listener = object : LocationListener {
                override fun onLocationChanged(location: Location) {
                    val locationMap = mapOf(
                        "latitude" to location.latitude,
                        "longitude" to location.longitude,
                        "accuracy" to location.accuracy
                    )

                    result.success(locationMap)
                    locationManager?.removeUpdates(this)
                }

                override fun onProviderEnabled(provider: String) {}
                override fun onProviderDisabled(provider: String) {
                    result.error("GPS_DISABLED", "GPS provider disabled", null)
                }

                @Deprecated("Deprecated in Java")
                override fun onStatusChanged(provider: String?, status: Int, extras: Bundle?) {}
            }

            locationManager?.requestSingleUpdate(
                LocationManager.GPS_PROVIDER,
                listener,
                Looper.getMainLooper()
            )

        } catch (e: SecurityException) {
            result.error("PERMISSION_DENIED", "Location permission not granted", null)
        }
    }
}