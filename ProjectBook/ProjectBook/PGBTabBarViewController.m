//
//  PGBTabBarViewController.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 12/2/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBTabBarViewController.h"
#import <IonIcons.h>
#import <ChameleonFramework/Chameleon.h>

@interface PGBTabBarViewController ()

@end

@implementation PGBTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : FlatGreenDark }
                                             forState:UIControlStateNormal];
    
    [self createTabBarIconForItem:0 unselectedIcon:ion_ios_home_outline selectedIcon:ion_ios_home];
    [self createTabBarIconForItem:1 unselectedIcon:ion_ios_search selectedIcon:ion_ios_search_strong];
    [self createTabBarIconForItem:2 unselectedIcon:ion_ios_bookmarks_outline selectedIcon:ion_ios_bookmarks];
    [self createTabBarIconForItem:3 unselectedIcon:ion_ios_chatbubble_outline selectedIcon:ion_ios_chatbubble];
}

- (void)createTabBarIconForItem:(NSUInteger)itemNumber unselectedIcon:(NSString *)unselectedIcon selectedIcon:(NSString *)selectedIcon
{
    UIImage *unselectedImage = [IonIcons imageWithIcon:unselectedIcon
                                      iconColor:FlatGreenDark
                                       iconSize:40.0f
                                      imageSize:CGSizeMake(90.0f, 90.0f)];
    
    [self.tabBar.items[itemNumber] setTitle:nil];
    [self.tabBar.items[itemNumber] setImage:unselectedImage];
    self.tabBar.items[itemNumber].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UIImage *selectedImage = [IonIcons imageWithIcon:selectedIcon
                                              iconColor:FlatGreenDark
                                               iconSize:40.0f
                                              imageSize:CGSizeMake(90.0f, 90.0f)];
    
    self.tabBar.items[itemNumber].selectedImage = selectedImage;
}


@end
