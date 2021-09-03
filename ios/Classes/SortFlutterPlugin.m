#import "SortFlutterPlugin.h"
#if __has_include(<sort_flutter/sort_flutter-Swift.h>)
#import <sort_flutter/sort_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sort_flutter-Swift.h"
#endif

@implementation SortFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSortFlutterPlugin registerWithRegistrar:registrar];
}
@end
