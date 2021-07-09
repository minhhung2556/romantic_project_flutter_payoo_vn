package vn.payoo.payoo_vn_plugin

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import vn.payoo.paybillsdk.PaybillConfig
import vn.payoo.paybillsdk.PayooPaybillSDK
import vn.payoo.paybillsdk.data.model.PaybillResultResponse
import vn.payoo.topupsdk.PayooTopupSDK
import vn.payoo.topupsdk.TopupConfig
import vn.payoo.topupsdk.data.model.response.TopupResultResponse


/**
 * This class is necessary for Payoo because they force the type of current activity of application is [AppCompatActivity]
 * Why don't they use just [android.app.Activity] or [androidx.fragment.app.FragmentActivity] ? They are base classes which must to use.
 * So we must do stupid work for this stupid sdk.
 */
class PayooActivity : AppCompatActivity(), PayooTopupSDK.OnTopupResultListener, PayooPaybillSDK.OnPaybillResultListener {
    companion object {
        const val TAG = "PayooActivity"
        val gson = Gson()

        fun startActivityForResult(activity: Activity, requestCode: Int, arguments: Map<*, *>) {
            val intent = Intent(activity, PayooActivity::class.java)
            intent.putExtra("arguments", gson.toJson(arguments))
            activity.startActivityForResult(intent, requestCode)
        }
    }

    var mPaused = false

    override fun onCreate(savedInstanceState: Bundle?) {
        overridePendingTransition(0, 0)

        super.onCreate(savedInstanceState)
        val arguments: Map<*, *> = gson.fromJson(intent.getStringExtra("arguments"), object : TypeToken<Map<*, *>?>() {}.type)
        when (val serviceId = arguments["serviceId"] as String) {
            PayooServiceIds.topup.name -> {
                val config = TopupConfig.newBuilder()
                        .withLocale(PayooTopupSDK.LOCALE_VI)
                        .build()
                PayooTopupSDK.start(this, config, this)
            }
            else -> {
                val config = PaybillConfig.newBuilder()
                        .withLocale(PayooPaybillSDK.LOCALE_VI)
                        .withServiceId(serviceId)
                        .build()
                PayooPaybillSDK.start(this, config, this)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d(TAG, "onActivityResult: requestCode = [${requestCode}], resultCode = [${resultCode}], data = [${data}]")
    }

    override fun onPause() {
        super.onPause()
        Log.d(TAG, "onPause")
        mPaused = true
    }

    override fun onResume() {
        super.onResume()
        Log.d(TAG, "onResume")
        if (mPaused) {
            finish()
        }
    }

    override fun onResult(data: TopupResultResponse) {
        Log.d(TAG, "onResult.Topup: data = [${data}]")

        val result = data.result
        val output: MutableMap<String, Any?> = HashMap()
        output["code"] = data.code
        output["groupType"] = data.groupType
        if (result != null) {
            output["authToken"] = result.authToken
            output["itemCode"] = result.itemCode
            output["orderChecksum"] = result.orderChecksum
            output["orderId"] = result.orderId
            output["orderInfo"] = result.orderInfo
            output["paymentCode"] = result.paymentCode
            output["paymentFee"] = result.paymentFee
            output["totalAmount"] = result.totalAmount
        }
        val intent = Intent()
        intent.putExtra("data", gson.toJson(output))
        setResult(Activity.RESULT_OK, intent)
    }

    override fun onResult(data: PaybillResultResponse) {
        Log.d(TAG, "onResult.Bill: data = [${data}]")

        val result = data.result
        val output: MutableMap<String, Any?> = HashMap()
        output["code"] = data.code
        output["groupType"] = data.groupType
        if (result != null) {
            output["authToken"] = result.authToken
            output["itemCode"] = result.itemCode
            output["orderChecksum"] = result.orderChecksum
            output["orderId"] = result.orderId
            output["orderInfo"] = result.orderInfo
            output["paymentCode"] = result.paymentCode
            output["paymentFee"] = result.paymentFee
            output["totalAmount"] = result.totalAmount
        }
        val intent = Intent()
        intent.putExtra("data", gson.toJson(output))
        setResult(Activity.RESULT_OK, intent)
    }
}