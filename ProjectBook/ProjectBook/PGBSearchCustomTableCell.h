//
//  BookTableViewCell.h
//  ProjectBook
//
//  Created by Olivia Lim on 11/18/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGBSearchCustomTableCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
//@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (strong, nonatomic) NSURL *bookURL;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

@end
