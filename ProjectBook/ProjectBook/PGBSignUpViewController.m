//
//  PGBSignUpViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 11/30/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBSignUpViewController.h"

@interface PGBSignUpViewController ()

@property (strong, nonatomic) UIImageView *backgroundImageView;

@end

@implementation PGBSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hoppers.gif"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.signUpView addSubview:self.backgroundImageView];
    [self.signUpView sendSubviewToBack:self.backgroundImageView];
    
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NOVEL_Logo_Green.png"]]];
    
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateHighlighted];
    
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.usernameField setBackgroundColor:[UIColor clearColor]];
    
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setBackgroundColor:[UIColor clearColor]];
    
    [self.signUpView.emailField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.emailField setBackgroundColor:[UIColor clearColor]];
    
    [self.signUpView.additionalField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.additionalField setBackgroundColor:[UIColor clearColor]];

    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"buttonOutline.png"] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:[UIImage imageNamed:@"buttonOutline.png"] forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"Sign Up" forState:UIControlStateHighlighted];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Move all fields down on smaller screen sizes
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat width = screenRect.size.width;
    CGFloat height = screenRect.size.height;
    
    CGFloat leftMargin = width * 1/8;
    CGFloat rightMargin = width * 3/4;
    
    [self.signUpView.dismissButton setFrame:CGRectMake(15.0f, 25.0f, 30.5f, 30.5f)];
    [self.signUpView.logo setFrame:CGRectMake(width * 1/5, height * 1/7, width * 3/5, 58.5f)];
    
    
    [self.signUpView.usernameField setFrame:CGRectMake(leftMargin, height * 2.4/8, rightMargin, 50.0f)];
    [self.signUpView.passwordField setFrame:CGRectMake(leftMargin, height * 2.4/8 + 50, rightMargin, 50.0f)];
    
    
    [self.signUpView.emailField setFrame:CGRectMake(leftMargin, height * 2.4/8 + 100, rightMargin, 50.0f)];
  
    
    [self.signUpView.additionalField setPlaceholder:@"Name"];
    [self.signUpView.additionalField setFrame:CGRectMake(leftMargin, height * 2.4/8 + 150, rightMargin, 50.0f)];
    
    [self.signUpView.signUpButton setFrame:CGRectMake(leftMargin + 20, height * 2.4/8 + 230, width * 3/4 - 40, 50.0f)];

    
    [self.backgroundImageView setFrame: self.signUpView.frame];

}

@end
