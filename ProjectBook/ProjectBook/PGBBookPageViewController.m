//
//  ViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBBookPageViewController.h"
#import "PGBDownloadHelper.h"

@interface PGBBookPageViewController ()

@property (strong, nonatomic) PGBDownloadHelper *downloadHelper;
@property UIDocumentInteractionController *docController;

@end

@implementation PGBBookPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ebookIndex = @"4028.epub.images";
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.gutenberg.org/ebooks/%@", self.ebookIndex]];
    self.downloadHelper = [[PGBDownloadHelper alloc] init];
    [self.downloadHelper download:URL];
    
}
- (IBAction)readButtonTapped:(id)sender
{
    NSString *litFileName = [NSString stringWithFormat:@"pg%@", self.ebookIndex];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:litFileName];
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];

    self.docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-books:"]]) {
        
        [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
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
