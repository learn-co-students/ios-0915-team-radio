//
//  PGBChatTableViewCell.h
//  ProjectBook
//
//  Created by Lauren Reed on 12/7/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PGBChatTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatTopicLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastActiveLabel;

@end
