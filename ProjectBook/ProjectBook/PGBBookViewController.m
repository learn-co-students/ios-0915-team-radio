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
#import <QuartzCore/QuartzCore.h>
#import "PGBReviewViewController.h"
#import "MBProgressHUD.h"
#import "PGBConstants.h"

@interface PGBBookViewController ()

@property (strong, nonatomic) UITextView *titleTextView;
@property (strong, nonatomic) UILabel *authorLabel;
@property (strong, nonatomic) UITextView *bookDescriptionTextView;

@property (strong, nonatomic) NSMutableString *htmlString;
@property (strong, nonatomic) UIView *webViewContainer;
@property (strong, nonatomic) UIStackView *infoStackView;

@property (strong, nonatomic) PGBDownloadHelper *downloadHelper;
@property UIDocumentInteractionController *docController;

@property (strong, nonatomic) UIButton *downloadButton;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIButton *readButton;
@property (strong, nonatomic) UIButton *reviewsButton;
@property (strong, nonatomic) UIView *aboveMostView;

@property (strong, nonatomic) UIImage *clearBookmark;
@property (strong, nonatomic) UIImage *redBookmark;
@property (strong, nonatomic) UIButton *bookmarkButton;
@property (strong, nonatomic) UIBarButtonItem *bookmarkBarItem;

@end

@implementation PGBBookViewController

// TODO: rewrite views to be better looking and account for smaller sized phone

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.29 green:0.72 blue:0.31 alpha:1.0];
    self.navigationController.navigationBar.alpha = 1.0f;
    
    //find book in Realmboook
    PGBRealmBook *bookFound = [PGBRealmBook findRealmBookInRealDatabaseWithRealmBook:self.book];
    if (bookFound) {
        self.book = bookFound;
    }
    
    //check file exist
    if (![self checkFileExists]) {
        self.readButton.hidden = YES;
    }
    self.downloadButton = [UIButton new];
    self.readButton = [UIButton new];
    self.reviewsButton = [UIButton new];

    [self setViews];
    self.clearBookmark = [UIImage imageNamed:@"clear_boomark"];
    self.redBookmark = [UIImage imageNamed:@"red_bookmark"];
    
    CGRect frame = CGRectMake(0, 0, self.clearBookmark.size.width+5, self.clearBookmark.size.height+5);
    self.bookmarkButton =  [[UIButton alloc] initWithFrame:frame];
    if (!self.book.isBookmarked) {
        [self.bookmarkButton setBackgroundImage:self.clearBookmark forState:UIControlStateNormal];
        [self.bookmarkButton setShowsTouchWhenHighlighted:YES];
        
        [self.bookmarkButton addTarget:self action:@selector(bookmarkButtonTapped) forControlEvents:(UIControlEventTouchDown)];
        
        self.bookmarkBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.bookmarkButton];
        
        [self.navigationItem setRightBarButtonItem:self.bookmarkBarItem];
    } else {
        [self.bookmarkButton setBackgroundImage:self.redBookmark forState:UIControlStateNormal];
        [self.bookmarkButton setShowsTouchWhenHighlighted:YES];
        
        [self.bookmarkButton addTarget:self action:@selector(bookmarkButtonTapped) forControlEvents:(UIControlEventTouchDown)];
        
        self.bookmarkBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.bookmarkButton];
        
        [self.navigationItem setRightBarButtonItem:self.bookmarkBarItem];
    }
}

- (void)setViews {
    UIView *headerView = [UIView new];
    [self.view addSubview:headerView];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(self.view.mas_height).dividedBy(3.5f);
    }];
    
    UIView *bookCover = [UIView new];
    [self.view addSubview:bookCover];
    bookCover.backgroundColor = [UIColor blackColor];
    [bookCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_centerY);
        make.width.mas_equalTo(self.view.mas_width).dividedBy(3.0f);
        make.height.mas_equalTo(headerView.mas_height);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    self.titleTextView = [UITextView new];
    [bookCover addSubview:self.titleTextView];
    self.titleTextView.text = self.book.title;
    self.titleTextView.font = [UIFont boldSystemFontOfSize:16.0f];
    self.titleTextView.textAlignment = NSTextAlignmentCenter;
    self.titleTextView.backgroundColor = [UIColor blackColor];
    self.titleTextView.textColor = [UIColor whiteColor];
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookCover.mas_top);
        make.centerX.mas_equalTo(bookCover.mas_centerX);
        make.width.mas_equalTo(bookCover.mas_width);
        make.height.mas_equalTo(bookCover.mas_height).dividedBy(1.5f);
    }];
    
    self.authorLabel = [UILabel new];
    [bookCover addSubview:self.authorLabel];
    self.authorLabel.text = self.book.author;
    self.authorLabel.textAlignment = NSTextAlignmentCenter;
    self.authorLabel.backgroundColor = [UIColor blackColor];
    self.authorLabel.textColor = [UIColor whiteColor];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bookCover.mas_bottom);
        make.centerX.mas_equalTo(bookCover.mas_centerX);
        make.width.mas_equalTo(bookCover.mas_width);
        make.height.mas_equalTo(bookCover.mas_height).dividedBy(4.0f);
    }];
    NSInteger height = (iPhoneUI) ? 24.0f : 48.0f;
    self.bookDescriptionTextView = [UITextView new];
    [self.view addSubview:self.bookDescriptionTextView];
    [self.bookDescriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bookCover.mas_bottom).offset(16.0f);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(self.view.mas_width).offset(-32.0f);
        make.height.mas_equalTo(height);
    }];
    
    self.bookDescriptionTextView.text = @"Loading description...";
    self.bookDescriptionTextView.editable = NO;
    self.bookDescriptionTextView.selectable = NO;
    self.bookDescriptionTextView.scrollEnabled = NO;
        self.bookDescriptionTextView.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    
    self.bookDescriptionTextView.layer.borderWidth = 3;
    self.bookDescriptionTextView.layer.borderColor = [[UIColor whiteColor] CGColor];
    // TODO: add insets for ipad ui and adjust insets to vertically center text given updated dynamic height
    self.bookDescriptionTextView.textContainerInset = UIEdgeInsetsMake(2, 4, 8, 8);
    [self getBookDiscriptionAndSetDescriptiontext];
    
    UILabel *genreLabel = [UILabel new];
    UILabel *languageLabel = [UILabel new];

    UIView *aboveMostView = self.bookDescriptionTextView;
    NSInteger offSet = (iPadUI) ? 8.0f : 2.0f;
    
    if (self.book.genre.length > 0) {
        genreLabel.backgroundColor = [UIColor whiteColor];
        genreLabel.text = self.book.genre;
        genreLabel.font = [UIFont fontWithName:@"Moon-Bold" size:13.0f];
        genreLabel.textColor = [UIColor blackColor];
        genreLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:genreLabel];
        [genreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(aboveMostView.mas_bottom).offset(offSet);
            make.width.mas_equalTo(self.bookDescriptionTextView.mas_width);
            make.height.mas_equalTo(height);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        aboveMostView = genreLabel;
    }
    
    if (self.book.language.length != 0) {
        languageLabel.backgroundColor = [UIColor whiteColor];
        languageLabel.text = self.book.language;
        languageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:13.0f];
        languageLabel.textColor = [UIColor blackColor];
        languageLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:languageLabel];
        [languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(aboveMostView.mas_bottom).offset(offSet);
            make.width.mas_equalTo(self.bookDescriptionTextView.mas_width);
            make.height.mas_equalTo(height);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        aboveMostView = languageLabel;
    }
    
    [self.downloadButton setBackgroundColor:[UIColor blackColor]];
    [self.downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadButton setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
    [self.downloadButton.titleLabel setFont:[UIFont fontWithName:@"Moon-Bold" size:14.0f]];
    [self.downloadButton addTarget:self action:@selector(downloadButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downloadButton];
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(aboveMostView.mas_bottom).offset(offSet * 2);
        make.left.mas_equalTo(self.bookDescriptionTextView.mas_left);
        make.right.mas_equalTo(self.bookDescriptionTextView.mas_right);
        make.height.mas_equalTo(height);
    }];

    [self.readButton setBackgroundColor:[UIColor blackColor]];
    [self.readButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.readButton setTitle:@"READ" forState:UIControlStateNormal];
    [self.readButton.titleLabel setFont:[UIFont fontWithName:@"Moon-Bold" size:14.0f]];
    [self.readButton addTarget:self action:@selector(readButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.readButton];
    [self.readButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(aboveMostView.mas_bottom).offset(offSet * 2);
        make.left.mas_equalTo(self.bookDescriptionTextView.mas_centerX).offset(offSet * 2);
        make.right.mas_equalTo(self.bookDescriptionTextView.mas_right);
        make.height.mas_equalTo(height);
    }];
    self.readButton.hidden = YES;

    [self.reviewsButton setBackgroundColor:[UIColor blackColor]];
    [self.reviewsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reviewsButton setTitle:@"READ REVIEWS" forState:UIControlStateNormal];
    [self.reviewsButton.titleLabel setFont:[UIFont fontWithName:@"Moon-Bold" size:14.0f]];
    [self.reviewsButton addTarget:self action:@selector(readReviewsTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reviewsButton];
    [self.reviewsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.downloadButton.mas_bottom).offset(offSet * 2);
        make.width.mas_equalTo(self.view.mas_width).dividedBy(3.0f);
        make.height.mas_equalTo(height);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

- (void)getBookDiscriptionAndSetDescriptiontext {
    
    PGBGoodreadsAPIClient *goodreadsAPI = [[PGBGoodreadsAPIClient alloc]init];
    [goodreadsAPI getDescriptionForBookTitle:self.book completion:^(NSString *bookDescription) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (bookDescription.length) {
                if ([bookDescription isEqualToString:@"There is no description for this book."]) {
                    self.bookDescriptionTextView.textAlignment = NSTextAlignmentCenter;
                    self.bookDescriptionTextView.text = @"There is no description for this book.";
                } else {
                    self.bookDescriptionTextView.text = bookDescription;
                    NSInteger height = [self getHeightOfTextViewFromText:bookDescription];
                    [self.bookDescriptionTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(height);
                    }];
                }
            } else {
                self.bookDescriptionTextView.text = @"There is no description for this book.";
                self.bookDescriptionTextView.textAlignment = NSTextAlignmentCenter;
            }
        }];
    }];
}

- (BOOL)textViewHeight:(NSInteger)textViewHeight iSmallerThantext:(NSString *)string {
    CGRect stringSize = [string boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32.0f, 9999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]}
                                             context:nil];
    if (textViewHeight < stringSize.size.height) {
        return  YES;
    } else return NO;
}

- (NSInteger)getHeightOfTextViewFromText:(NSString *)string {
    NSInteger maxHeight = self.view.frame.size.height / 3.5;
    NSInteger minHeight = 64.0f;
    CGRect stringSize = [string boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32.0f, 9999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]}
                                             context:nil];
    NSInteger stringHeight = stringSize.size.height + 16.0f;
    if (stringHeight > minHeight && stringHeight < maxHeight) {
        return stringHeight;
    } else if (stringHeight < minHeight){
        return minHeight;
    } else return maxHeight;
}

- (void)downloadButtonTapped {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Downloading Books";
    self.hud.labelFont = [UIFont fontWithName:@"Moon-Bold" size:14.0f];
    
    NSString *parsedEbookID = [self.book.ebookID substringFromIndex:5];
    NSString *idURL = [NSString stringWithFormat:@"http://www.gutenberg.org/ebooks/%@.epub.images", parsedEbookID];
    NSURL *URL = [NSURL URLWithString:idURL];
    [self downloadBookFromURL:URL withEbookID:parsedEbookID];
}

- (void)downloadBookFromURL:(NSURL *)URL withEbookID:(NSString *)parsedEbookID {

    [PGBDownloadHelper download:URL withCompletion:^(BOOL success) {
        [self.hud setHidden:YES];
        
        if (success) {
            self.readButton.hidden = NO;
            NSInteger offSet = (iPadUI) ? 8.0f : 2.0f;
            [self.downloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.readButton.mas_left).offset(- offSet * 2);
            }];
            UIAlertController *downloadCompleted = [UIAlertController alertControllerWithTitle:@"Book Downloaded" message:@"Open in iBooks?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *open = [UIAlertAction actionWithTitle:@"Open"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                            NSString *litFileName = [NSString stringWithFormat:@"pg%@-images.epub", parsedEbookID];
                                                             
                                                             NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:litFileName];
                                                             NSURL *targetURL = [NSURL fileURLWithPath:filePath];
                                                             
                                                             self.docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
                                                             
                                                             if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-books:"]]) {
                                                                 
                                                                 [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
                                                                 
                                                                 NSLog(@"iBooks installed");
                                                                 
                                                             } else {
                                                                 UIAlertController *invalid = [UIAlertController alertControllerWithTitle:@"iBooks not installed" message:@" Download iBooks and try again"preferredStyle:UIAlertControllerStyleAlert];
                                                                 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                                                                              style:UIAlertActionStyleDefault
                                                                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                                                            }];
                                                                 [invalid addAction:ok];
                                                                 [self presentViewController:invalid animated:YES completion:nil];
                                                                 
                                                             }
                                                             
                                                         }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                           }];
            [downloadCompleted addAction:open];
            [downloadCompleted addAction:cancel];
            [self presentViewController:downloadCompleted animated:YES completion:nil];
            
            if (self.book.ebookID.length) {
                
                [PGBRealmBook storeUserBookDataWithBookwithUpdateBlock:^PGBRealmBook *{
                    self.book.isDownloaded = YES;
                    return self.book;
                } andCompletion:^{
                    // none
                }];
            }
        } else {
            
            UIAlertController *downloadFailed = [UIAlertController alertControllerWithTitle:@"Failed to download book" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                       }];
            
            [downloadFailed addAction:ok];
            [self presentViewController:downloadFailed animated:YES completion:nil];
            
        }
    }];
}

- (void)readButtonTapped {
    NSString *parsedEbookID = [self.book.ebookID substringFromIndex:5];
    
    NSString *litFileName = [NSString stringWithFormat:@"pg%@-images.epub", parsedEbookID];
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:litFileName];
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];
    
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-books:"]]) {
        
        [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
        NSLog(@"iBooks installed");
        
    } else {
        UIAlertController *invalid = [UIAlertController alertControllerWithTitle:@"iBooks not installed" message:@" Download iBooks and try again"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
        [invalid addAction:ok];
        [self presentViewController:invalid animated:YES completion:nil];
        
    }
}

- (void)bookmarkButtonTapped {
    
    if (self.book.ebookID.length) {
        
        [PGBRealmBook storeUserBookDataWithBookwithUpdateBlock:^PGBRealmBook *{
            if (!self.book.isBookmarked) {
                self.book.isBookmarked = YES;
                
                [self.bookmarkButton setBackgroundImage:self.redBookmark forState:UIControlStateNormal];
                [self.bookmarkButton setShowsTouchWhenHighlighted:YES];
                
                [self.bookmarkButton addTarget:self action:@selector(bookmarkButtonTapped) forControlEvents:(UIControlEventTouchDown)];
                
                self.bookmarkBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.bookmarkButton];
                
                [self.navigationItem setRightBarButtonItem:self.bookmarkBarItem];
            } else {
                self.book.isBookmarked = NO;
                
                [self.bookmarkButton setBackgroundImage:self.clearBookmark forState:UIControlStateNormal];
                [self.bookmarkButton setShowsTouchWhenHighlighted:YES];
                
                [self.bookmarkButton addTarget:self action:@selector(bookmarkButtonTapped) forControlEvents:(UIControlEventTouchDown)];
                
                self.bookmarkBarItem = [[UIBarButtonItem alloc]initWithCustomView:self.bookmarkButton];
                
                [self.navigationItem setRightBarButtonItem:self.bookmarkBarItem];
            }
            
            
            return self.book;
        } andCompletion:^{
            //no action
        }];
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    PGBReviewViewController *reviewVC = segue.destinationViewController;
    
    reviewVC.book = self.book;
    
}

- (void)readReviewsTapped {
    PGBReviewViewController *reviewVC = [[PGBReviewViewController alloc] init];
    reviewVC.book = self.book;
    
    [self.navigationController pushViewController:reviewVC animated:YES];
    
}

- (BOOL)checkFileExists {
    NSString *parsedEbookID = [self.book.ebookID substringFromIndex:5];
    
    NSString *litFileName = [NSString stringWithFormat:@"pg%@-images.epub", parsedEbookID];
    
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:litFileName];
    
    //check see if file exist
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

@end
