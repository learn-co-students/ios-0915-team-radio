//
//  PGBIntroViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/23/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBIntroViewController.h"

@interface PGBIntroViewController ()
@property (weak, nonatomic) IBOutlet UIView *gifView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@end

@implementation PGBIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hopper" ofType:@"gif"];
    NSData *gif = [NSData dataWithContentsOfFile:filePath];
    
    UIWebView *webViewBG = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.titleImage.frame.size.height, self.gifView.frame.size.width, self.gifView.frame.size.height)];
    [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    
    webViewBG.userInteractionEnabled = NO;
    
//    webViewBG = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:webViewBG];
    
    UIView *filter = [[UIView alloc] initWithFrame:self.gifView.frame];
    filter.backgroundColor = [UIColor blackColor];
    filter.alpha = 0.05;
    [self.view addSubview:filter];
    
    webViewBG.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
