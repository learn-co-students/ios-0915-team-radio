//
//  PGBSearchChatPreviewViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 12/7/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBSearchChatPreviewViewController.h"

@interface PGBSearchChatPreviewViewController ()

@property (weak, nonatomic) IBOutlet UITextView *titleView;

@property (weak, nonatomic) IBOutlet UITextView *authorView;

//@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
//@property (weak, nonatomic) IBOutlet UILabel *yearPublishedLabel;
//@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImageView;
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
    self.authorView.text = self.book.author;
//    self.genreLabel.text = self.book.author;
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    NSString *datePublished = [dateFormatter stringFromDate:self.book.datePublished];
//    self.yearPublishedLabel.text = datePublished;
//    self.languageLabel.text = self.book.language;
}

@end
