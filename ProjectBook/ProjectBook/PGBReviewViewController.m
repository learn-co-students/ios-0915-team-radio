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
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;

@end

@implementation PGBReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    //LEO - this is causing for some books, AFNetworking crash!!!
//    [self getReviewswithCompletion:^(BOOL success) {
//        if (success) {
//            NSLog(@"Succed to get reviews from API call - LEO");
//        } else {
//            NSLog(@"failed to get reviews from API call - LEO");
//        }
//    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"LEO view will appear");
    
    [self getReviewswithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"start block");

            self.webView.navigationDelegate = self;
            
            //            [self.webView.heightAnchor constraintEqualToConstant:300];
            //            [self.webViewContainer layoutSubviews];
            
            NSLog(@"Succed to get reviews from API call - LEO");
        } else {
            NSLog(@"failed to get reviews from API call - LEO");
            
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
            
            // make / constrain webview
            
            CGRect webViewFrame = CGRectMake(0, 0, self.webViewContainer.frame.size.width, self.view.frame.size.height);
            
            self.webView = [[WKWebView alloc]initWithFrame: webViewFrame];
            [self.webViewContainer addSubview:self.webView];
            //                self.webView.translatesAutoresizingMaskIntoConstraints = NO;
            //                [self.webView.leftAnchor constraintEqualToAnchor:self.webViewContainer.leftAnchor].active = YES;
            //                [self.webView.rightAnchor constraintEqualToAnchor:self.webViewContainer.rightAnchor].active = YES;
            //                [self.webView.topAnchor constraintEqualToAnchor:self.webViewContainer.bottomAnchor].active = YES;
            //                [self.webView.bottomAnchor constraintEqualToAnchor:self.webViewContainer.bottomAnchor].active = YES;
            
            
            [self.webView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:baseURL];
//            self.webView.navigationDelegate = self;
            
            //            [self.webView.heightAnchor constraintEqualToConstant:300];
            //            [self.webViewContainer layoutSubviews];
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
    
    //    [webView.scrollView zoomToRect:CGRectMake(0, 0, 20, 20) animated:YES];
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
