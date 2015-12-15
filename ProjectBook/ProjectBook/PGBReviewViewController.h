//
//  PGBDownloadViewController.h
//  ProjectBook
//
//  Created by Olivia Lim on 12/14/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "PGBRealmBook.h"

@interface PGBReviewViewController : UIViewController <WKNavigationDelegate>

@property (strong, nonatomic)PGBRealmBook *book;
@property (strong, nonatomic) WKWebView *webView;


@end
