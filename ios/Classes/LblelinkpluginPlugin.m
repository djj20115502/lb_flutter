#import "LblelinkpluginPlugin.h"
#if __has_include(<lblelinkplugin/lblelinkplugin-Swift.h>)
#import <lblelinkplugin/lblelinkplugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lblelinkplugin-Swift.h"
#endif

@implementation LblelinkpluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLblelinkpluginPlugin registerWithRegistrar:registrar];
}
@end
