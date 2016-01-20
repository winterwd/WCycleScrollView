//
//  WCycleScrollView.h
//  WCycleScrollView
//
//  Created by wwinter on 16/1/16.
//  Copyright © 2016年 d. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WCycleScrollViewPageControlStyle){
    WCycleScrollViewPageControlStyle_Classic,   // 默认 系统的
    WCycleScrollViewPageControlStyle_Animated,  // 带动画的
    WCycleScrollViewPageControlStyle_None       // 不显示pageControl
};

typedef NS_ENUM(NSInteger, WCycleScrollViewPageControlAliment){
    WCycleScrollViewPageControlAliment_Left,
    WCycleScrollViewPageControlAliment_Right,
    WCycleScrollViewPageControlAliment_Center   //默认显示在中间
};

@class  WCycleScrollView;
@protocol WCycleScrollViewDeleate <NSObject>

@optional
/** 点击图片回调 */
- (void)cycleScrollView:(WCycleScrollView *)ScrollView didSelectItemAtIndex:(NSInteger)index;
/** 图片滚动回调 */
- (void)cycleScrollView:(WCycleScrollView *)ScrollView didScrollToIndex:(NSInteger)index;


@end

@interface WCycleScrollView : UIView

/** delegate */
@property (nonatomic, weak) id<WCycleScrollViewDeleate> delegate;

// ===================== 数据源

/** 本地图片 */
@property (nonatomic, strong) NSArray *localImageNameArray;
/** 网络图片URL地址 */
@property (nonatomic, strong) NSArray *imageUrlStringArray;
/** 图片需要显示的title */
@property (nonatomic, strong) NSArray *bannerTitleArray;

// ===================== 滚动控制

/** 自动滚动时间间隔 默认开启2s */
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;
/** 是否无限制滚动 默认开启 */
@property (nonatomic, getter=isInfinteLoop) BOOL infiniteLoop;
/** 是否自动滚动 默认开启 */
@property (nonatomic, getter=isAutoScroll) BOOL autoScroll;

// ===================== 图片显示的模式

/** 图片显示的模式 默认 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;
/** banner placeholdimage */
@property (nonatomic, strong) UIImage *placeholdImage;

// ===================== 自定义样式

/** 是否显示pageControl 默认开启显示 */
@property (nonatomic, getter=isShowPageControl) BOOL showPageControl;
/** 是否当只有一张图片时隐藏pageControl 默认隐藏 */
@property (nonatomic, getter=isHidePCSingleImage) BOOL hidePCForSingleImage;
/** pageControlStyle */
@property (nonatomic, assign) WCycleScrollViewPageControlStyle  pageControlStyle;
/** pageControlAliment */
@property (nonatomic, assign) WCycleScrollViewPageControlAliment pageControlAliment;

/** pageDot 大小 */
@property (nonatomic, assign) CGSize pageDotSize;
/** 当前pageDot 显示颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;
/** 其他pageDot 显示颜色 */
@property (nonatomic, strong) UIColor *otherPageDotColor;
/** 当前pageDot 显示图标 */
@property (nonatomic, strong) UIImage *currentPageDotImage;
/** 其他pageDot 显示图标 */
@property (nonatomic, strong) UIImage *otherPageDotImager;

/** banner 文字字体颜色 */
@property (nonatomic, strong) UIColor *bannerTitleColor;
/** banner 文字字体大小 */
@property (nonatomic, strong) UIFont *bannerTitleFont;
/** banner 文字背景色 */
@property (nonatomic, strong) UIColor *bannerTitleBackgroundColor;
/** banner 文字 高度 */
@property (nonatomic, assign) CGFloat bannerTitleHeight;

// ===================== 初始化
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<WCycleScrollViewDeleate>)delegate placeholdImage:(UIImage *)placeholdImage;


@end
