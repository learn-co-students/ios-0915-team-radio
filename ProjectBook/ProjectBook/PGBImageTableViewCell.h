//
//  PGBImageTableViewCell.h
//  NOVEL
//
//  Created by Lauren Reed on 7/24/16.
//  Copyright © 2016 FIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface PGBImageTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *mainImage;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
