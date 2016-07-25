//
//  PGBConstants.h
//  ProjectBook
//
//  Created by Wo Jun Feng on 12/11/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#ifndef PGBConstants_h
#define kDeviceOS [[UIDevice currentDevice] systemVersion] floatValue]
#define kScreenBound [[UIScreen mainScreen] bounds]
#define iPadUI UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define iPhoneUI UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#endif
@interface PGBConstants : NSObject

extern NSString *const GOODREADS_KEY;
extern NSString *const GOODREADS_SECRET;
extern NSString *const PARSE_ID;
extern NSString *const PARSE_CLIENT_KEY;


@end
