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

#import "HJTabViewBar.h"
#import "HJTabViewController+Private.h"
#import "HJTabViewController+ViewController.h"
#import "HJTabViewController.h"
#import "HJTabViewControllerPlugin_Base.h"
#import "HJTabViewControllerPlugin_BottomInset.h"
#import "HJTabViewControllerPlugin_HeaderScroll.h"
#import "HJTabViewControllerPlugin_TabViewBar.h"

FOUNDATION_EXPORT double HJTabViewControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char HJTabViewControllerVersionString[];

