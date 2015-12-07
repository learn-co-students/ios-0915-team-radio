//
//  PGBProfileViewController.m
//  ProjectBook
//
//  Created by Lauren Reed on 11/30/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBProfileViewController.h"

@interface PGBProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *location;

@end

@implementation PGBProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    self.userNameLabel.text = currentUser.username;
    PFObject *object = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectID" equalTo:object.objectId];
    self.name.text = object[@"additional"];
    self.location.text = object[@"location"];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}


- (IBAction)backToBooksTapped:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
