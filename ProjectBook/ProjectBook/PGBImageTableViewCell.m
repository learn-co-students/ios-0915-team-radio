//
//  PGBImageTableViewCell.m
//  NOVEL
//
//  Created by Lauren Reed on 7/24/16.
//  Copyright © 2016 FIS. All rights reserved.
//

#import "PGBImageTableViewCell.h"

@implementation PGBImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.mainImage = [UIImageView new];
        [self.contentView addSubview:self.mainImage];
        [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left);
            make.top.mas_equalTo(self.contentView.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

@end
