//
//  PGBSettingsViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 12/1/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBSettingsTableViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "PGBSignUpViewController.h"
#import "PGBHomeViewController.h"
#import "PGBProfileViewController.h"

@interface PGBSettingsTableViewController ()

@end

@implementation PGBSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (IBAction)backButtonTapped:(id)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (IBAction)logoutButtonTapped:(id)sender {

    [PFUser logOut];
    [self dismissViewControllerAnimated:YES completion:nil];
    

}

@end
