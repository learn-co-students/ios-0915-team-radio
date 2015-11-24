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

@property (weak, nonatomic) IBOutlet UITextView *bookDescriptionTV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *bookDescriptionSV;


@end

@implementation PGBBookPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSLog(@"view loaded");
    
    [PGBRealmBook generateTestBookData];
    NSArray *books = [PGBRealmBook getUserBookDataInArray];
    self.books = @[books[0], books[1], books[2]];
    
    self.bookDescriptionTV.editable = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *datePublished = [dateFormatter stringFromDate:[NSDate date]];
    
    self.titleLabel.text = self.titleBook;
    self.authorLabel.text = self.author;
    self.genreLabel.text = self.genre;
    self.yearLabel.text = datePublished;
    self.languageLabel.text = self.language;
    self.bookDescriptionTV.text = self.bookDescription;
    
    [self.bookDescriptionTV setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    
}

- (IBAction)downloadButtonTapped:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"http://www.gutenberg.org/ebooks/4028.epub.images"];
    self.downloadHelper = [[PGBDownloadHelper alloc] init];
    [self.downloadHelper download:URL];
    
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
