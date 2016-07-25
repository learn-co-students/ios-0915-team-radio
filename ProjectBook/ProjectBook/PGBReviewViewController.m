//
//  PGBDownloadViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 12/14/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBReviewViewController.h"
#import "PGBGoodreadsAPIClient.h"

@interface PGBReviewViewController ()

@property (strong, nonatomic) NSMutableString *htmlString;
@property (strong, nonatomic) UIView *webViewContainer;

@end

@implementation PGBReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webViewContainer = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webViewContainer];
    [self.webViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64.0f);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-113.0f);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getReviewswithCompletion:^(BOOL success) {
        if (success) {
            self.webView.navigationDelegate = self;
        
        } else {
            
            UIAlertController *fail = [UIAlertController alertControllerWithTitle:@"There are no reviews for this book" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
            [fail addAction:ok];
            [self presentViewController:fail animated:YES completion:nil];
        }
    }];
    
}

- (void)getReviewswithCompletion:(void (^)(BOOL))completionBlock {
    [PGBGoodreadsAPIClient getReviewsForBook:self.book completion:^(NSDictionary *reviewDict) {
        
        if (reviewDict) {
            
            self.htmlString = [reviewDict[@"reviews_widget"] mutableCopy];
            
            NSData *htmlData = [self.htmlString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *baseURL = [NSURL URLWithString:@"https://www.goodreads.com"];
            
            CGRect webViewFrame = CGRectMake(0, 0, self.webViewContainer.frame.size.width, self.view.frame.size.height);
            
            self.webView = [[WKWebView alloc]initWithFrame: webViewFrame];
            [self.webViewContainer addSubview:self.webView];
            [self.webView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:baseURL];

            completionBlock(YES);
        } else {
            completionBlock(NO);
        }
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"didFinishNavigation");
    
    if (webView == self.webView) {
        [webView.scrollView setZoomScale:0.6];
        [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
}



- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog (@"didCommitNavigation");
    
    [webView.scrollView setZoomScale:0.6];
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)dealloc {
    self.webView.navigationDelegate = nil;
    [self.webView stopLoading];
}

@end
