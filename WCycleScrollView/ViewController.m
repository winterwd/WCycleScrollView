//
//  ViewController.m
//  WCycleScrollView
//
//  Created by wwinter on 16/1/16.
//  Copyright © 2016年 d. All rights reserved.
//

#import "ViewController.h"
#import "WCycleScrollView.h"

@interface ViewController ()<WCycleScrollViewDeleate>
@property (weak, nonatomic) IBOutlet WCycleScrollView *cycleScrollView1;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg"
                            ];
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    // 情景三：图片配文字
    NSArray *titles = @[@"参考别人的",
                        @"这个不是我写的",
                        @"我只是代码搬运",
                        @"我只是学习而已"
                        ];
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.cycleScrollView1.bounds.size.height;
    
    self.cycleScrollView1.delegate = self;
    self.cycleScrollView1.placeholdImage = [UIImage imageNamed:@"placeholder"];
    self.cycleScrollView1.localImageNameArray = imageNames;
    self.cycleScrollView1.pageControlStyle = WCycleScrollViewPageControlStyle_Animated;
    
    WCycleScrollView *cycleScrollView2 = [WCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView1.frame) + 20, w, h) delegate:self placeholdImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView2.currentPageDotColor = [UIColor blueColor];
    cycleScrollView2.otherPageDotColor = [UIColor whiteColor];
    [self.scrollView addSubview:cycleScrollView2];
    
    double delayInSeconds = 1.5;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        cycleScrollView2.imageURLStringsArray = imagesURLStrings;
    });
    
    
    WCycleScrollView *cycleScrollView3 = [WCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, CGRectGetMaxY(cycleScrollView2.frame) + 20, w, h) delegate:self placeholdImage:[UIImage imageNamed:@"placeholder"]];
    cycleScrollView3.imageURLStringsArray = imagesURLStrings;
    cycleScrollView3.bannerTitleArray = titles;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
    cycleScrollView3.otherPageDotImager = [UIImage imageNamed:@"pageControlDot"];
    [self.scrollView addSubview:cycleScrollView3];
}

#pragma mark -
#pragma mark - cycleScrillView delegate

- (void)cycleScrollView:(WCycleScrollView *)ScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击第 %ld 张图片",(long)index);
}
@end
