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

    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : FlatGreenDark }
                                             forState:UIControlStateNormal];
    
    UIImage *homeIcon = [IonIcons imageWithIcon:ion_ios_home_outline
                                      iconColor:FlatGreenDark
                                       iconSize:40.0f
                                      imageSize:CGSizeMake(90.0f, 90.0f)];
    
    [self.tabBar.items[0] setTitle:nil];
    [self.tabBar.items[0] setImage:homeIcon];
    self.tabBar.items[0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UIImage *selectedHomeIcon = [IonIcons imageWithIcon:ion_ios_home
                                              iconColor:FlatGreenDark
                                               iconSize:40.0f
                                              imageSize:CGSizeMake(90.0f, 90.0f)];
    
    self.tabBar.items[0].selectedImage = selectedHomeIcon;
    
    
    UIImage *searchIcon = [IonIcons imageWithIcon:ion_ios_search
                                        iconColor:FlatGreenDark
                                         iconSize:40.0f
                                        imageSize:CGSizeMake(90.0f, 90.0f)];
    
    [self.tabBar.items[1] setTitle:nil];
    [self.tabBar.items[1] setImage:searchIcon];
    self.tabBar.items[1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UIImage *selectedSearchIcon = [IonIcons imageWithIcon:ion_ios_search_strong
                                                iconColor:FlatGreenDark
                                                 iconSize:40.0f
                                                imageSize:CGSizeMake(90.0f, 90.0f)];
    
    self.tabBar.items[1].selectedImage = selectedSearchIcon;
    
    UIImage *libraryIcon = [IonIcons imageWithIcon:ion_ios_bookmarks_outline
                                         iconColor:FlatGreenDark
                                          iconSize:40.0f
                                         imageSize:CGSizeMake(90.0f, 90.0f)];
    [self.tabBar.items[2] setTitle:nil];
    [self.tabBar.items[2] setImage:libraryIcon];
    self.tabBar.items[2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    UIImage *selectedLibraryIcon = [IonIcons imageWithIcon:ion_ios_bookmarks
                                                 iconColor:FlatGreenDark
                                                  iconSize:40.0f
                                                 imageSize:CGSizeMake(90.0f, 90.0f)];
    
    self.tabBar.items[2].selectedImage = selectedLibraryIcon;

    UIImage *chatIcon = [IonIcons imageWithIcon:ion_ios_chatbubble_outline
                                      iconColor:FlatGreenDark
                                       iconSize:40.0f
                                      imageSize:CGSizeMake(90.0f, 90.0f)];
    [self.tabBar.items[3] setTitle:nil];
    [self.tabBar.items[3] setImage:chatIcon];
    self.tabBar.items[3].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UIImage *selectedChatIcon = [IonIcons imageWithIcon:ion_ios_chatbubble iconColor:FlatGreenDark iconSize:40.0f imageSize:CGSizeMake(90.0f, 90.0f)];
    self.tabBar.items[3].selectedImage = selectedChatIcon;
    
}
@end
