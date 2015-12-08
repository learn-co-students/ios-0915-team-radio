//
//  PGBTabBarViewController.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 12/2/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBTabBarViewController.h"
#import <IonIcons.h>

@interface PGBTabBarViewController ()

@end

@implementation PGBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    UIImage *homeIcon = [IonIcons imageWithIcon:ion_ios_home
                                  iconColor:[UIColor colorWithRed:0.3216 green:0.749 blue:1.0 alpha:1.0]
                                   iconSize:37.0f
                                  imageSize:CGSizeMake(90.0f, 90.0f)];
    [self.tabBar.items[0] setTitle:@"Home"];
    [self.tabBar.items[0] setImage:homeIcon];
    
    UIImage *searchIcon = [IonIcons imageWithIcon:ion_ios_search_strong
                                      iconColor:[UIColor colorWithRed:0.3216 green:0.749 blue:1.0 alpha:1.0]
                                       iconSize:37.0f
                                      imageSize:CGSizeMake(90.0f, 90.0f)];
    [self.tabBar.items[1] setTitle:@"Search"];
    [self.tabBar.items[1] setImage:searchIcon];
    
    UIImage *libraryIcon = [IonIcons imageWithIcon:ion_ios_book
                                      iconColor:[UIColor colorWithRed:0.3216 green:0.749 blue:1.0 alpha:1.0]
                                       iconSize:37.0f
                                      imageSize:CGSizeMake(90.0f, 90.0f)];
    [self.tabBar.items[2] setTitle:@"Library"];
    [self.tabBar.items[2] setImage:libraryIcon];
    
    UIImage *chatIcon = [IonIcons imageWithIcon:ion_chatbubbles
                                         iconColor:[UIColor colorWithRed:0.3216 green:0.749 blue:1.0 alpha:1.0]
                                          iconSize:37.0f
                                         imageSize:CGSizeMake(90.0f, 90.0f)];
//    [self.tabBar.items[3] setTitle:@"Chat"];
//    [self.tabBar.items[3] setImage:chatIcon];
    
}

@end
