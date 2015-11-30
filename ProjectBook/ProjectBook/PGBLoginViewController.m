//
//  PGBLoginViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 11/30/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBLoginViewController.h"
@interface PGBLoginViewController ()

@property (strong, nonatomic) UIImageView *backgroundImageView;

@end

@implementation PGBLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hoppers.gif"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.logInView addSubview:self.backgroundImageView];
    [self.logInView sendSubviewToBack:self.backgroundImageView];
    
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NOVEL_Logo_Green.png"]]];

    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateHighlighted];
    
    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];

    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"buttonOutline.png"] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"buttonOutline.png"] forState:UIControlStateNormal];
    
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
    
    
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"buttonOutline.png"] forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"buttonOutline.png"] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.logInButton setBackgroundImage:[UIImage imageNamed:@"buttonOutline.png"] forState:UIControlStateNormal];
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.usernameField setBackgroundColor:[UIColor clearColor]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setBackgroundColor:[UIColor clearColor]];
    
    [self.logInView.passwordForgottenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat width = screenRect.size.width;
    CGFloat height = screenRect.size.height;
    
    CGFloat leftMargin = width * 1/8;
    CGFloat rightMargin = width * 3/4;
    
    CGFloat widthOfBottomButtons = 30.0f;
    
    // CGRectMake(x, y, width, height)
    // Set frame for elements
    
    [self.logInView.dismissButton setFrame:CGRectMake(15.0f, 25.0f, 30.5f, 30.5f)];
    
    [self.logInView.logo setFrame:CGRectMake(width * 1/5, height * 1/8, width * 3/5, 58.5f)];
    
    [self.logInView.usernameField setFrame:CGRectMake(leftMargin, height * 1/4, rightMargin, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(leftMargin, height * 1/4 + 50, rightMargin, 50.0f)];
    
    [self.logInView.logInButton setFrame:CGRectMake(leftMargin + 20, height * 1/4 + 124, width * 3/4 - 40, 50.0f)];
    [self.logInView.passwordForgottenButton setFrame:CGRectMake(width * 1/4, height * 1/4 + 165, 200.0f, 50.0f)];
    
    [self.logInView.facebookButton setFrame:CGRectMake(leftMargin, height * 6.9/8 + 38, rightMargin, widthOfBottomButtons)];
    [self.logInView.signUpButton setFrame:CGRectMake(leftMargin, height * 6.9/8, rightMargin, widthOfBottomButtons)];
    
    [self.backgroundImageView setFrame: self.logInView.frame];

}

@end
