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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTouched:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)backButtonTapped:(id)sender {

    [self dismissViewControllerAnimated:YES
                             completion:nil];

}
- (IBAction)logoutButtonTapped:(id)sender {

    [PFUser logOut];
//    [self dismissViewControllerAnimated:YES completion:nil];
    

}

@end
