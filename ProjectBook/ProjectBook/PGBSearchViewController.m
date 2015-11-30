//
//  PGBSearchViewController.m
//  ProjectBook
//
//  Created by Wo Jun Feng on 11/30/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBSearchViewController.h"
#import <Masonry/Masonry.h>

@interface PGBSearchViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic)UISearchBar *searchBar;
@property (strong, nonatomic)UISearchController *searchController;
//@property (strong, nonatomic)

@end

@implementation PGBSearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 10, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height/2)];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonCountry",@"Country"), NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
    self.searchController.searchBar.delegate = self;
    
    //    self.tableView.tableHeaderView = self.searchController.searchBar;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"search controller protocol!!");
}



@end
