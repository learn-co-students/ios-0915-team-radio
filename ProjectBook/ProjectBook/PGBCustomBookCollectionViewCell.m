//
//  PGBCustomBookCollectionViewCell.m
//  ProjectBook
//
//  Created by Olivia Lim on 12/7/15.
//  Copyright © 2015 FIS. All rights reserved.
//

#import "PGBCustomBookCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PGBCustomBookCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor blackColor];
    
    _titleLabel = [UILabel new];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;

//    self.titleLabel.font = [UIFont fontWithName:@"Moon" size:14.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    [self addSubview: _titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.mas_width);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    
    _authorLabel = [UILabel new];
    _authorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _authorLabel.numberOfLines = 0;
    _authorLabel.textAlignment = NSTextAlignmentCenter;
    _authorLabel.adjustsFontSizeToFitWidth = YES;
    //    self.titleLabel.font = [UIFont fontWithName:@"Moon" size:14.0f];
    _authorLabel.textColor = [UIColor whiteColor];
    [self addSubview:_authorLabel];
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.mas_width);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    return self;
}

@end
