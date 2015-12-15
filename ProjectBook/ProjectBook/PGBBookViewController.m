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

@interface PGBBookViewController ()

@property (weak, nonatomic) IBOutlet UITextView *titleTV;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *bookCover;
@property (weak, nonatomic) IBOutlet UITextView *bookDescriptionTV;
@property (weak, nonatomic) IBOutlet UIView *superContentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreOptions;

@property (strong, nonatomic) NSMutableString *htmlString;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (weak, nonatomic) IBOutlet UIStackView *infoStackView;

@property (strong, nonatomic) PGBDownloadHelper *downloadHelper;
@property UIDocumentInteractionController *docController;

@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (weak, nonatomic) IBOutlet UIButton *reviewsButton;

@end

@implementation PGBBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTV.editable = NO;
    self.titleTV.selectable = NO;
    
    self.titleTV.text = self.book.title;
    self.titleTV.layoutManager.hyphenationFactor = 1;
    //    [self.titleTV addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    self.authorLabel.text = self.book.author;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.authorLabel.adjustsFontSizeToFitWidth = YES;
    
    self.bookCover.layer.borderColor = [UIColor blackColor].CGColor;
    self.bookCover.layer.borderWidth = 3.0f;
    
    // genre and language stack view
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor clearColor];
    view1.layer.borderColor = [[UIColor whiteColor]CGColor];
    view1.layer.borderWidth = 3;
    
    [view1 setFrame:CGRectMake(0, 0, 200, 200)];
    
    NSLog (@"%@", self.book.genre);
    UILabel *genreLabel = [[UILabel alloc]init];
    genreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    genreLabel.text = self.book.genre;
    genreLabel.adjustsFontSizeToFitWidth = YES;
    genreLabel.font = [UIFont fontWithName:@"Moon-Bold" size:13.0f];
    genreLabel.textColor = [UIColor whiteColor];
    
    [view1 addSubview:genreLabel];
    
    [genreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_top);
        make.bottom.equalTo(view1.mas_bottom);
        make.centerX.equalTo(view1.mas_centerX);
    }];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor clearColor];
    view2.layer.borderColor = [[UIColor whiteColor]CGColor];
    view2.layer.borderWidth = 3;
    [view2 setFrame:CGRectMake(0, 0, 100, 100)];
    
    UILabel *languageLabel = [[UILabel alloc]init];
    languageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    languageLabel.text = self.book.language;
    languageLabel.adjustsFontSizeToFitWidth = YES;
    languageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:13.0f];
    languageLabel.textColor = [UIColor whiteColor];
    
    [view2 addSubview:languageLabel];
    
    [languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_top);
        make.bottom.equalTo(view2.mas_bottom);
        make.centerX.equalTo(view2.mas_centerX);
    }];
    
    [self.infoStackView addArrangedSubview:view1];
    [self.infoStackView addArrangedSubview:view2];
    
    //book description height and description
    //    [self.view addSubview:self.bookDescriptionTV];
    [self.bookDescriptionTV sizeToFit];
    [self.bookDescriptionTV layoutIfNeeded];
    
    CGRect rect = self.bookDescriptionTV.frame;
    rect.size.height = self.bookDescriptionTV.contentSize.height;
    self.bookDescriptionTV.frame = rect;
    
    
    CGFloat totalHeight = 0.0f;
    for (UIView *view in self.superContentView.subviews)
        if (totalHeight < view.frame.origin.y + view.frame.size.height) totalHeight = view.frame.origin.y + view.frame.size.height;
    
    self.bookDescriptionTV.text = @"";
    self.bookDescriptionTV.editable = NO;
    self.bookDescriptionTV.selectable = NO;
    self.bookDescriptionTV.textAlignment = NSTextAlignmentJustified;
    
    self.bookDescriptionTV.layer.borderWidth = 3;
    self.bookDescriptionTV.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.bookDescriptionTV.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8);
    
    PGBGoodreadsAPIClient *goodreadsAPI = [[PGBGoodreadsAPIClient alloc]init];
    [goodreadsAPI getDescriptionForBookTitle:self.book completion:^(NSString *bookDescription) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([bookDescription isEqual:@""]) {
                self.bookDescriptionTV.text = @"There is no description for this book.";
            }else{
                self.bookDescriptionTV.text = bookDescription;
            }
        }];
    }];
    
    //download and read buttons
    self.downloadButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.downloadButton.layer.borderWidth = 3;
    
    self.readButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.readButton.layer.borderWidth = 3;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //LEO - this is causing for some books, AFNetworking crash!!!
    //    [self getReviewswithCompletion:^(BOOL success) {
    //        if (success) {
    //            NSLog(@"Succed to get reviews from API call - LEO");
    //        } else {
    //            NSLog(@"failed to get reviews from API call - LEO");
    //            self.bookDescriptionTV.text = @"There is no review for this book.";
    //        }
    //    }];
}

- (IBAction)downloadButtonTapped:(id)sender {
    
    //    [self performSegueWithIdentifier:@"downloadSegue" sender:sender];
    
    NSString *parsedEbookID = [self.book.ebookID substringFromIndex:5];
    
    NSString *idURL = [NSString stringWithFormat:@"http://www.gutenberg.org/ebooks/%@.epub.images", parsedEbookID];
    
    NSURL *URL = [NSURL URLWithString:idURL];
    
    [PGBDownloadHelper download:URL withCompletion:^(BOOL success) {
        if (success) {
            
            UIAlertController *downloadCompleted = [UIAlertController alertControllerWithTitle:@"Book Downloaded" message:@"Open in iBooks?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *open = [UIAlertAction actionWithTitle:@"Open"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             NSString *litFileName = [NSString stringWithFormat:@"pg%@-images.epub", parsedEbookID];
                                                             
                                                             //    NSString *litFileName = [NSString stringWithFormat:@"pg%@", self.ebookIndex];
                                                             NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:litFileName];
                                                             NSURL *targetURL = [NSURL fileURLWithPath:filePath];
                                                             
                                                             self.docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
                                                             
                                                             if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-books:"]]) {
                                                                 
                                                                 [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
                                                                 
                                                                 //        [self.docController presentOpenInMenuFromRect:_openInIBooksButton.bounds inView:self.openInIBooksButton animated:YES];
                                                                 
                                                                 NSLog(@"iBooks installed");
                                                                 
                                                             } else {
                                                                 UIAlertController *invalid = [UIAlertController alertControllerWithTitle:@"You don't have iBooks installed." message:@" Download iBooks and try again"preferredStyle:UIAlertControllerStyleAlert];
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
                    //            if ([PFUser currentUser]) {
                    //                [PGBRealmBook storeUserBookDataFromRealmStoreToParseWithRealmBook:self.book andCompletion:^{
                    //                    NSLog(@"saved book to parse");
                    //                }];
                    //            }
                    
                }];
            }
        } else {
            
            UIAlertController *downloadFailed = [UIAlertController alertControllerWithTitle:@"Fail to download book" message:@"Please try again" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                       }];
            
            [downloadFailed addAction:ok];
            [self presentViewController:downloadFailed animated:YES completion:nil];
            //
        }
        
    }];
}

- (IBAction)readButtonTapped:(id)sender {
    NSString *parsedEbookID = [self.book.ebookID substringFromIndex:5];
    
    NSString *litFileName = [NSString stringWithFormat:@"pg%@-images.epub", parsedEbookID];
    
    //    NSString *litFileName = [NSString stringWithFormat:@"pg%@", self.ebookIndex];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:litFileName];
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];
    
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"itms-books:"]]) {
        
        [self.docController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
        //        [self.docController presentOpenInMenuFromRect:_openInIBooksButton.bounds inView:self.openInIBooksButton animated:YES];
        
        NSLog(@"iBooks installed");
        
    } else {
        UIAlertController *invalid = [UIAlertController alertControllerWithTitle:@"You don't have iBooks installed." message:@" Download iBooks and try again"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
        [invalid addAction:ok];
        [self presentViewController:invalid animated:YES completion:nil];
        
    }
    
    NSLog(@"iBooks not installed");
}

- (IBAction)optionsButtonTapped:(id)sender {
    UIAlertController *view = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //bookmark
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Bookmark" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.book.ebookID.length) {
            
            [PGBRealmBook storeUserBookDataWithBookwithUpdateBlock:^PGBRealmBook *{
                self.book.isBookmarked = YES;
                return self.book;
            } andCompletion:^{
                //            if ([PFUser currentUser]) {
                //                [PGBRealmBook storeUserBookDataFromRealmStoreToParseWithRealmBook:self.book andCompletion:^{
                //                    NSLog(@"saved book to parse");
                //                }];
                //            }
                
            }];
            
            NSString *bookIsBookmarked = [NSString stringWithFormat:@"%@ bookmarked", self.book.title];
            
            UIAlertController *bookmarked = [UIAlertController alertControllerWithTitle:bookIsBookmarked message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                       }];
            [bookmarked addAction:ok];
            [self presentViewController:bookmarked animated:YES completion:nil];
            
        }
    }];
    
    [view addAction:save];
    [self presentViewController:view animated:YES completion:nil];
    
}

- (IBAction)reviewsButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"reviewSegue" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"reviewSegue"]) {
        
        PGBReviewViewController *reviewVC = segue.destinationViewController;
        
        reviewVC.book = self.book;
    }
}

@end
