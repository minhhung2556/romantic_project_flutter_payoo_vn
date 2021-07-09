package vn.payoo.flutter

import android.app.Activity
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import vn.payoo.paybillsdk.PayooMerchant
import vn.payoo.paybillsdk.PayooPaybillSDK
import vn.payoo.topupsdk.PayooTopupMerchant
import vn.payoo.topupsdk.PayooTopupSDK
import vn.payoo.topupsdk.TopupEnvironment


/** PayooVnPlugin */
class PayooVnPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    companion object {
        const val TAG = "PayooVnPlugin"
        const val CHANNEL_NAME = "vn.payoo.plugin"
        const val TOPUP_REQUEST_CODE = 730000
        const val ELECTRIC_REQUEST_CODE = 731000
        const val WATER_REQUEST_CODE = 732000
    }

    private var lockRequestResult: Result? = null
    private val resultListener: PluginRegistry.ActivityResultListener = PluginRegistry.ActivityResultListener { requestCode, resultCode, data ->
        Log.d(TAG, "requestCode = [${requestCode}], resultCode = [${resultCode}], data = [${data}]")
        if (activity != null && lockRequestResult != null) {
            when (requestCode) {
                TOPUP_REQUEST_CODE -> {
                    //TODO currently, it is unnecessary to handle the activity result.
                }
                ELECTRIC_REQUEST_CODE -> {
                    //TODO currently, it is unnecessary to handle the activity result.
                }
                WATER_REQUEST_CODE -> {
                    //TODO currently, it is unnecessary to handle the activity result.
                }
            }
            if (resultCode == Activity.RESULT_OK) {
                lockRequestResult!!.success(data.getStringExtra("data"))
            } else {
                lockRequestResult!!.success("")
            }
            resetCallbacks()
            true
        } else {
            false
        }

    }


    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var initialized = false

    private fun resetCallbacks() {
        lockRequestResult = null
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        setActivity(binding.activity)
        binding.addActivityResultListener(resultListener)
    }

    override fun onDetachedFromActivity() {
        setActivity(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initialize" -> {
                val arguments = call.arguments as Map<*, *>
                val ok = initialize(arguments)
                result.success(ok)
            }
            "navigate" -> {
                lockRequestResult = result
                val arguments = call.arguments as Map<*, *>
                navigate(arguments)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun setActivity(activity: Activity?) {
        if (activity != null) {
            this.activity = activity
        } else {
            this.activity = null
        }
    }

    /** Navigate to a Payoo Service by [arguments] that contains the serviceId. See also [PayooServiceIds].
     * */
    private fun navigate(arguments: Map<*, *>) {
        if (!initialized) {
            Log.e(TAG, "navigate: not initialized yet!")
            return
        }

        val requestCode: Int = when (arguments["serviceId"]) {
            PayooServiceIds.topup.name -> {
                TOPUP_REQUEST_CODE
            }
            PayooServiceIds.DIEN.name -> {
                ELECTRIC_REQUEST_CODE
            }
            PayooServiceIds.NUOC.name -> {
                WATER_REQUEST_CODE
            }
            else -> {
                -1
            }
        }
        if (requestCode != -1)
            this.activity?.let { PayooActivity.startActivityForResult(it, requestCode, arguments) }
    }

    /** Setup the Payoo SDK instance with [settings] is the configuration.
     * */
    private fun initialize(settings: Map<*, *>): Boolean {
        if (initialized) return true
        val merchantId = settings["merchantId"] as String
        val secretKey = settings["secretKey"] as String
        val isDev = settings["isDev"] as Boolean
        val payooMerchant: PayooMerchant = PayooMerchant.newBuilder()
                .merchantId(merchantId)
                .secretKey(secretKey)
                .isDevMode(isDev)
                .build()
        PayooPaybillSDK.initialize(activity!!.application, payooMerchant)

        val payooTopUpMerchant: PayooTopupMerchant = PayooTopupMerchant.newBuilder()
                .merchantId(merchantId)
                .secretKey(secretKey)
                .environment(if (isDev) TopupEnvironment.DEVELOPMENT else TopupEnvironment.PRODUCTION)
                .build()
        PayooTopupSDK.initialize(activity!!.application, payooTopUpMerchant)

        initialized = true
        return true
    }
}
