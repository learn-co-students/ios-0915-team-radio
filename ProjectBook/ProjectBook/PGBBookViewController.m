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

@interface PGBBookViewController () <UIScrollViewDelegate>

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
//    self.genreLabel.text = self.book.genre;
//    self.languageLabel.text = self.book.language;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.authorLabel.adjustsFontSizeToFitWidth = YES;
    
    self.bookCover.layer.borderColor = [UIColor blackColor].CGColor;
    self.bookCover.layer.borderWidth = 3.0f;

// genre and language stack view
    UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor whiteColor];
    [view1 setFrame:CGRectMake(0, 0, 100, 100)];
    
    NSLog (@"%@", self.book.genre);
    UILabel *genreLabel = [[UILabel alloc]init];
    genreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    genreLabel.text = self.book.genre;
    genreLabel.adjustsFontSizeToFitWidth = YES;
    genreLabel.font = [UIFont fontWithName:@"Open Sans" size:13.0f];
    
    [view1 addSubview:genreLabel];
    
    [genreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_top);
        make.bottom.equalTo(view1.mas_bottom);
        make.centerX.equalTo(view1.mas_centerX);
    }];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(genreLabel.mas_height);
    }];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    [view2 setFrame:CGRectMake(0, 0, 100, 100)];
    
    UILabel *languageLabel = [[UILabel alloc]init];
    languageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    languageLabel.text = self.book.language;
    languageLabel.adjustsFontSizeToFitWidth = YES;
    languageLabel.font = [UIFont fontWithName:@"Open Sans" size:13.0f];
    
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
    
//    [self textViewDidChange:self.bookDescriptionTV];
    
    
    CGFloat totalHeight = 0.0f;
    for (UIView *view in self.superContentView.subviews)
        if (totalHeight < view.frame.origin.y + view.frame.size.height) totalHeight = view.frame.origin.y + view.frame.size.height;
    
    self.bookDescriptionTV.text = @"";
    self.bookDescriptionTV.editable = NO;
    self.bookDescriptionTV.selectable = NO;
    
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
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //LEO - this is causing crash when back from book detail
    [self getReviewswithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"Succed to get description from API call - LEO");
        } else {
            NSLog(@"failed to get description from API call - LEO");
            self.bookDescriptionTV.text = @"There is no review for this book.";
        }
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath   ofObject:(id)object   change:(NSDictionary *)change   context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])  / 2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (IBAction)optionsButtonTapped:(id)sender {
    UIAlertController *view = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //download
    UIAlertAction *download = [UIAlertAction actionWithTitle:@"Download Book" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *parsedEbookID = [self.book.ebookID substringFromIndex:5];
        
        NSString *idURL = [NSString stringWithFormat:@"http://www.gutenberg.org/ebooks/%@.epub.images", parsedEbookID];
        
        NSURL *URL = [NSURL URLWithString:idURL];
        
        [PGBDownloadHelper download:URL withCompletion:^{
            
            //after download is finished
            UIAlertController *downloadComplete = [UIAlertController alertControllerWithTitle:@"Book Downloaded" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                       }];
            
            [downloadComplete addAction:ok];
            [self presentViewController:downloadComplete animated:YES completion:nil];
            
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
        }];
    }];
    
    //open in iBook
    UIAlertAction *open = [UIAlertAction actionWithTitle:@"Open in iBooks" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    }];
    
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
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                             style:UIAlertActionStyleCancel
                             handler:nil];
    
    [view addAction:download];
    [view addAction:open];
    [view addAction:save];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
    
}



-(void)getReviewswithCompletion:(void (^)(BOOL))completionBlock
{
    [PGBGoodreadsAPIClient getReviewsForBook:self.book completion:^(NSDictionary *reviewDict) {
        
        if (reviewDict) {
            
            self.htmlString = [reviewDict[@"reviews_widget"] mutableCopy];
            
            NSData *htmlData = [self.htmlString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *baseURL = [NSURL URLWithString:@"https://www.goodreads.com"];
            
            // make / constrain webview
            
            CGRect webViewFrame = CGRectMake(0, 0, self.webViewContainer.frame.size.width, self.webViewContainer.frame.size.height);
            
            self.webView = [[WKWebView alloc]initWithFrame: webViewFrame];
            [self.webViewContainer addSubview:self.webView];
            //                self.webView.translatesAutoresizingMaskIntoConstraints = NO;
            //
            //                [self.webView.leftAnchor constraintEqualToAnchor:self.webViewContainer.leftAnchor].active = YES;
            //                [self.webView.rightAnchor constraintEqualToAnchor:self.webViewContainer.rightAnchor].active = YES;
            //                [self.webView.topAnchor constraintEqualToAnchor:self.webViewContainer.bottomAnchor].active = YES;
            //                [self.webView.bottomAnchor constraintEqualToAnchor:self.webViewContainer.bottomAnchor].active = YES;
            
            
            [self.webView loadData:htmlData MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:baseURL];
            
            self.webView.navigationDelegate = self;
            
            //            [self.webView.heightAnchor constraintEqualToConstant:300];
            //            [self.webViewContainer layoutSubviews];
            completionBlock(YES);
        } else {
            completionBlock(NO);
        }
    }];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
    
    [webView.scrollView setZoomScale:0.6];
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    //    [webView.scrollView zoomToRect:CGRectMake(0, 0, 20, 20) animated:YES];
}



-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog (@"didCommitNavigation");
    
    [webView.scrollView setZoomScale:0.6];
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
}

- (void)dealloc {
    //    [self.webView setDelegate:nil];
    
    self.webView.navigationDelegate = nil;
    [self.webView stopLoading];
}

@end
