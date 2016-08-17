//
//  WCycleViewCell.h
//  WCycleScrollView
//
//  Created by wwinter on 16/1/16.
//  Copyright © 2016年 d. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCycleViewCell : UICollectionViewCell

/**  */
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, copy) NSString *title;

/** 配置cell  */
@property (nonatomic, getter=isHasConfigure) BOOL hasConfigure;

/** banner 文字字体颜色 */
@property (nonatomic, strong) UIColor *bannerTitleColor;
/** banner 文字字体大小 */
@property (nonatomic, strong) UIFont *bannerTitleFont;
/** banner 文字背景色 */
@property (nonatomic, strong) UIColor *bannerTitleBackgroundColor;
/** banner 文字 高度 */
@property (nonatomic, assign) CGFloat bannerTitleHeight;
@end
