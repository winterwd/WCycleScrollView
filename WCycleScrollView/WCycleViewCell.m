//
//  WCycleViewCell.m
//  WCycleScrollView
//
//  Created by wwinter on 16/1/16.
//  Copyright © 2016年 d. All rights reserved.
//

#import "WCycleViewCell.h"

@interface WCycleViewCell ()
/**  */
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation WCycleViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureSubViews];
    }
    return self;
}

- (void)configureSubViews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 图片铺满
    self.imageView.frame = self.bounds;
    
    CGFloat titleWidth = self.bounds.size.width;
    CGFloat titleHeight = 21;
    CGFloat originX = 0;
    CGFloat originY = CGRectGetHeight(self.bounds) - titleHeight;
    self.titleLabel.frame = CGRectMake(originX, originY, titleWidth, titleHeight);
    self.titleLabel.hidden = !self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    self.titleLabel.text = title;
}

- (void)setBannerTitleColor:(UIColor *)bannerTitleColor
{
    _bannerTitleColor = bannerTitleColor;
    self.titleLabel.textColor = bannerTitleColor;
}

- (void)setBannerTitleFont:(UIFont *)bannerTitleFont
{
    _bannerTitleFont = bannerTitleFont;
    self.titleLabel.font = bannerTitleFont;
}

- (void)setBannerTitleBackgroundColor:(UIColor *)bannerTitleBackgroundColor
{
    _bannerTitleBackgroundColor = bannerTitleBackgroundColor;
    self.titleLabel.backgroundColor = bannerTitleBackgroundColor;
}

- (void)setBannerTitleHeight:(CGFloat)bannerTitleHeight
{
    _bannerTitleHeight = bannerTitleHeight;
    CGRect tempRect = self.titleLabel.frame;
    tempRect.size.height = bannerTitleHeight;
    self.titleLabel.frame = tempRect;
}
@end
