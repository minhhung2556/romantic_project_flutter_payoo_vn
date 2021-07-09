#import "PayooVnPlugin.h"
#if __has_include(<flutter_payoo_vn/flutter_payoo_vn-Swift.h>)
#import <flutter_payoo_vn/flutter_payoo_vn-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_payoo_vn-Swift.h"
#endif

@implementation PayooVnPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPayooVnPlugin registerWithRegistrar:registrar];
}
@end
