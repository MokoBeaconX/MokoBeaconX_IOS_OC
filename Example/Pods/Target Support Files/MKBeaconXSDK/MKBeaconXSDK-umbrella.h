#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CBPeripheral+eddystoneAdd.h"
#import "MKBaseReceiveBeacon.h"
#import "MKCentralManager.h"
#import "MKEddystoneAdopter.h"
#import "MKEddystoneDataParser.h"
#import "MKEddystoneInterface.h"
#import "MKEddystoneOperation.h"
#import "MKEddystoneOperationIDDefines.h"
#import "MKEddystoneSDK.h"
#import "MKEddystoneService.h"
#import "MKSDKDefines.h"

FOUNDATION_EXPORT double MKBeaconXSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char MKBeaconXSDKVersionString[];

