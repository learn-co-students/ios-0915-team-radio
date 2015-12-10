//
//  PGBBookViewController.h
//  ProjectBook
//
//  Created by Olivia Lim on 12/10/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <WebKit/WebKit.h>
#import "PGBRealmBook.h"
#import "PGBGoodreadsAPIClient.h"

@interface PGBBookViewController : UIViewController <WKUIDelegate, WKNavigationDelegate, UIActionSheetDelegate>

@property (strong, nonatomic)PGBRealmBook *book;

@property (strong, nonatomic) WKWebView *webView;

@end
