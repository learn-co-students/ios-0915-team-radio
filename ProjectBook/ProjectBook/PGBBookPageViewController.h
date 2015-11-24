//
//  PGBBookPageViewController.h
//  ProjectBook
//
//  Created by Olivia Lim on 11/17/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PGBRealmBook.h"

@interface PGBBookPageViewController : UIViewController

@property (strong, nonatomic)NSString *titleBook;
@property (strong, nonatomic)NSString *author;
@property (strong, nonatomic)NSString *genre;
@property (strong, nonatomic)NSString *language;
@property (strong, nonatomic)NSString *bookDescription;
@property (strong, nonatomic)NSDate *datePublished;
@property (assign, nonatomic)NSString *ebookID;
@property (strong, nonatomic)NSArray *books;

@end

