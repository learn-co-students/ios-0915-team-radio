//
//  PGBBookViewController.m
//  ProjectBook
//
//  Created by Olivia Lim on 12/10/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBBookViewController.h"
#import "PGBDownloadHelper.h"
#import "PGBParseAPIClient.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Masonry/Masonry.h>
#import <YYWebImage/YYWebImage.h>

@interface PGBBookViewController ()

@property (weak, nonatomic) IBOutlet UITextView *titleTV;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *bookCover;
@property (weak, nonatomic) IBOutlet UITextView *bookDescriptionTV;
@property (weak, nonatomic) IBOutlet UIView *superContentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreOptions;

@end

@implementation PGBBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titleTV.editable = NO;
    self.titleTV.selectable = NO;
    
    self.titleTV.text = self.book.title;
    self.authorLabel.text = self.book.author;
//    self.genreLabel.text = self.book.genre;
//    self.languageLabel.text = self.book.language;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.authorLabel.adjustsFontSizeToFitWidth = YES;
    
    self.bookCover.layer.borderColor = [UIColor blackColor].CGColor;
    self.bookCover.layer.borderWidth = 3.0f;

//book description height and description
    CGRect rect = self.bookDescriptionTV.frame;
    rect.size.height = self.bookDescriptionTV.contentSize.height;
    self.bookDescriptionTV.frame = rect;
    
    CGFloat totalHeight = 0.0f;
    for (UIView *view in self.superContentView.subviews)
        if (totalHeight < view.frame.origin.y + view.frame.size.height) totalHeight = view.frame.origin.y + view.frame.size.height;
    
    self.bookDescriptionTV.text = @"";
    PGBGoodreadsAPIClient *goodreadsAPI = [[PGBGoodreadsAPIClient alloc] init];
    [goodreadsAPI getDescriptionForBookTitle:self.book completion:^(NSString *bookDescription) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([bookDescription isEqual:@""]) {
                self.bookDescriptionTV.text = @"There is no description for this book.";
            }else{
                self.bookDescriptionTV.text = bookDescription;
            }
        }];
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger fontSize = 20;
    //fits 50 W;s
    NSInteger lengthThreshold = 48;
    if([self.titleTV.text length] > lengthThreshold) {
        NSInteger newSize = fontSize - (([self.titleTV.text length] - 48)/3);
        self.titleTV.font = [UIFont fontWithName:@"Moon" size:newSize];
    }
}

- (IBAction)optionsButtonTapped:(id)sender {
    UIAlertController *view = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *download = [UIAlertAction actionWithTitle:@"Download Book" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
// download NEEDS TO CHANGELASKDFLAWER
    //        [self downloadButtonTapped:sender];
        //        [view dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Bookmark" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //bookmarks it NEED TO CHANGE
//        [self bookmarkButtonTapped:sender];
        //        [view dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                             style:UIAlertActionStyleCancel
                             handler:nil];
    
    [view addAction:download];
    [view addAction:save];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    
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
