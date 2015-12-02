//
//  PGBProfileViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 11/30/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBProfileViewController.h"

@interface PGBProfileViewController ()

@end

@implementation PGBProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (IBAction)backToBooksTapped:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
