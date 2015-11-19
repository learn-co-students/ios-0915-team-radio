//
//  ViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBBookPageViewController.h"
#import "PGBDownloadHelper.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Masonry/Masonry.h>

@interface PGBBookPageViewController ()

@property (strong, nonatomic) PGBDownloadHelper *downloadHelper;
@property UIDocumentInteractionController *docController;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *iBooksButton;

@end

@implementation PGBBookPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"view loaded");
}

- (IBAction)downloadButtonTapped:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"http://www.gutenberg.org/ebooks/4028.epub.images"];
    self.downloadHelper = [[PGBDownloadHelper alloc] init];
    [self.downloadHelper download:URL];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (![ PFUser currentUser]) {
        // do something
    }
    else{
        // we have a user! do somethin..
    }
//    NSArray *permissions = @[@"public_profile"];
//
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
//
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//        } else {
//            NSLog(@"User logged in through Facebook!");
//        }
//    }];
    
}

- (IBAction)readButtonTapped:(id)sender
{
//    self.ebookNumber = @"4028.epub.images";
    
    NSString *litFileName = @"pg4028-images.epub";
    
//    NSString *litFileName = [NSString stringWithFormat:@"pg%@", self.ebookIndex];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:litFileName];
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];

    self.docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-books:"]]) {
        
        [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
//        [self.docController presentOpenInMenuFromRect:_openInIBooksButton.bounds inView:self.openInIBooksButton animated:YES];

        NSLog(@"iBooks installed");
        
    } else {
        
        NSLog(@"iBooks not installed");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
