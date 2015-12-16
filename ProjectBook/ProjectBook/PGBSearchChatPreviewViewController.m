//
//  PGBSearchChatPreviewViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 12/7/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBSearchChatPreviewViewController.h"
#import "PGBGoodreadsAPIClient.h"

@interface PGBSearchChatPreviewViewController ()

@property (weak, nonatomic) IBOutlet UITextView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *authLabel;

@property (weak, nonatomic) IBOutlet UITextView *bookDescriptionTextView;


@end


@implementation PGBSearchChatPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUI];
}

-(void)setBook:(PGBRealmBook *)book
{
    _book = book;
    [self updateUI];
}

-(void)updateUI
{
    self.titleView.text = self.book.title;
    self.authLabel.text = self.book.author;
    
    PGBGoodreadsAPIClient *goodreadsAPI = [[PGBGoodreadsAPIClient alloc]init];
    [goodreadsAPI getDescriptionForBookTitle:self.book completion:^(NSString *bookDescription) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            

            if (![bookDescription isEqual:@""]) {
               
                self.bookDescriptionTextView.text = @"There is no description for this book.";
                self.bookDescriptionTextView.textAlignment = NSTextAlignmentCenter;
                self.bookDescriptionTextView.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
            } else if ([bookDescription isEqualToString:@"There is no description for this book."]) {
                self.bookDescriptionTextView.textAlignment = NSTextAlignmentCenter;
                self.bookDescriptionTextView.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
            }else {
                self.bookDescriptionTextView.text = bookDescription;
                self.bookDescriptionTextView.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
            }
        }];
    }];

}

@end
