import Flutter
import UIKit
import PayooCore
import PayooPayment
import PayooService
import PayooTopup

/** Setup the Payoo SDK instance with [settings] is the configuration.
    * */
public class SwiftPayooVnPlugin: NSObject, FlutterPlugin {
    private static let TAG = "SwiftPayooVnPlugin"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vn.payoo.plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftPayooVnPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    var localResult: FlutterResult?
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String : Any?]
        print(SwiftPayooVnPlugin.TAG+": arguments=" + toJsonString(data: arguments))
        
        switch call.method {
        case "initialize":
            let ok = initialize(arguments: arguments)
            result(ok)
            break;
        case "navigate":
            self.localResult = result
            navigate(arguments: arguments)
            break;
        default:
            result(FlutterMethodNotImplemented)
            break;
        }
    }
    
    /** Setup the Payoo SDK instance with [settings] is the configuration.
     * */
    private func initialize(arguments: [String : Any?]?) -> Bool{
        if arguments == nil {
            return false
        }
        
        let merchantId = arguments!["merchantId"] as! String
        let secretKey = arguments!["secretKey"] as! String
        let isDev = arguments!["isDev"] as? Bool
        
        if isDev == true {
            Configuration.set(environment: .development)
        } else {
            Configuration.set(environment: .production)
        }
        Configuration.set(language: .vietnamese)
        Configuration.set(merchantId: merchantId, secretKey: secretKey)
        
        //Use this to change the design colors
//        Appearance.navigationBarBackgroundColor = UIColor.blue
//        Appearance.navigationBarTintColor = UIColor.blue
//        Appearance.backgroundColor = UIColor.lightGray
//        Appearance.continueButtonColor = UIColor.green
        
        return true
    }
    
    private func resetCallbacks(){
        self.localResult = nil
    }
    
    /** Navigate to a Payoo Service by [arguments] that contains the serviceId. See also [PayooServiceIds].
     * */
    private func navigate(arguments: [String : Any?]?){
        if arguments == nil {
            self.localResult!("")
            resetCallbacks()
        }else {
            let currentViewController = UIApplication.shared.keyWindow?.rootViewController!
            
            let serviceId = arguments!["serviceId"] as? String
            if serviceId == PayooServiceIds.topup.rawValue {
                let config = TopupConfiguration(defaultCustomerPhone: nil, defaultCustomerEmail: nil, userId: nil)
                let context = TopupContext(configuration: config) { (groupType, response) in
                    var output: [String : Any?] = [:]
                    output["groupType"] = groupType.rawValue
                    if (response != nil) {
                        output["message"] = response?.message
                        output["code"] = response?.code
                        output["authToken"] = response?.data?.authToken
                        output["itemCode"] = response?.data?.itemCode
                        output["orderChecksum"] = response?.data?.orderChecksum
                        output["orderId"] = response?.data?.orderId
                        output["orderInfo"] = response?.data?.orderInfo
                        output["paymentCode"] = response?.data?.paymentCode
                        output["paymentFee"] = response?.data?.paymentFee
                        output["totalAmount"] = response?.data?.totalAmount
                    }
                    let jsonOutput = toJsonString(data: output)
                    print(SwiftPayooVnPlugin.TAG+".navigate.response: "+jsonOutput)
                    if(self.localResult != nil){
                        self.localResult!(jsonOutput)
                    }
                }
                context.present(from: currentViewController!)
            } else {
                let config = ServiceConfiguration(defaultServiceId: serviceId, defaultProviderId: nil, defaultCustomerId: nil, referAmount: nil, userId: nil, defaultCustomerEmail: nil, defaultCustomerPhone: nil)
                let context = ServiceContext(configuration:config) { (groupType, response) in
                    var output: [String : Any?] = [:]
                    output["groupType"] = groupType.rawValue
                    if (response != nil) {
                        output["message"] = response?.message
                        output["code"] = response?.code
                        output["authToken"] = response?.data?.authToken
                        output["itemCode"] = response?.data?.itemCode
                        output["orderChecksum"] = response?.data?.orderChecksum
                        output["orderId"] = response?.data?.orderId
                        output["orderInfo"] = response?.data?.orderInfo
                        output["paymentCode"] = response?.data?.paymentCode
                        output["paymentFee"] = response?.data?.paymentFee
                        output["totalAmount"] = response?.data?.totalAmount
                    }
                    let jsonOutput = toJsonString(data: output)
                    print(SwiftPayooVnPlugin.TAG+".navigate.response: "+jsonOutput)
                    if(self.localResult != nil){
                        self.localResult!(jsonOutput)
                    }
                }
                context.present(from: currentViewController!)
            }
        }
    }
}

func toJsonString(data: [String : Any?]?) -> String {
    var myJsonString = ""
    do {
        let strData =  try JSONSerialization.data(withJSONObject:data!, options: .prettyPrinted)
        myJsonString = NSString(data: strData, encoding: String.Encoding.utf8.rawValue)! as String
    } catch {
        print(error.localizedDescription)
    }
    return myJsonString
}

/**
 * Current supported services from Payoo SDK.
 * These are exactly ids defined by Payoo.
 */
enum PayooServiceIds : String {
    case topup = "topup", electric = "DIEN", water = "NUOC"
    
    static let values = [topup, electric, water]
}
