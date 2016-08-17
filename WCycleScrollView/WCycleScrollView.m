//
//  WCycleScrollView.m
//  WCycleScrollView
//
//  Created by wwinter on 16/1/16.
//  Copyright © 2016年 d. All rights reserved.
//

#import "WCycleScrollView.h"
#import "WCycleViewCell.h"
#import "TAPageControl.h" // 自定义pageControl

#import "UIImageView+WebCache.h"

@interface WCycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) UIImageView *placeholdImageView;

@property (nonatomic, strong) NSArray *imagePathArray;
@property (nonatomic, weak) UIControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger itemTotalCount;
@end

@implementation WCycleScrollView

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<WCycleScrollViewDeleate>)delegate placeholdImage:(UIImage *)placeholdImage
{
    WCycleScrollView *instance = [[WCycleScrollView alloc] initWithFrame:frame];
    instance.delegate = delegate;
    instance.placeholderImage = placeholdImage;
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self configureSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
        [self configureSubViews];
    }
    return self;
}

- (void)initialization
{
    _autoScrollTimeInterval = 2.0;
    _infiniteLoop = YES;
    _autoScroll = YES;
    
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    _showPageControl = YES;
    _hidePCForSingleImage = YES;
    _pageControlStyle = WCycleScrollViewPageControlStyle_Classic;
    _pageControlAliment = WCycleScrollViewPageControlAliment_Center;
    _currentPageDotColor = [UIColor whiteColor];
    _otherPageDotColor = [UIColor lightGrayColor];
    _pageDotSize = CGSizeMake(10, 10);
    
    _bannerTitleColor = [UIColor whiteColor];
    _bannerTitleFont = [UIFont systemFontOfSize:14.0];
    _bannerTitleHeight = 30;
    _bannerTitleBackgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    
//    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)configureSubViews
{
    UIImageView *placeholdImageView = [[UIImageView alloc] init];
    placeholdImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:placeholdImageView];
    self.placeholdImageView = placeholdImageView;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowLayout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[WCycleViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark -
#pragma mark - property

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.flowLayout.itemSize = frame.size;
}

- (void)setPlaceholderImage:(UIImage *)placeholdImage
{
    _placeholderImage = placeholdImage;
    self.placeholdImageView.image = placeholdImage;
}

- (void)setPageDotSize:(CGSize)pageDotSize
{
    _pageDotSize = pageDotSize;
    // 这个就是要自定义了
    [self setUpPageControl];
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *taPageControl = (TAPageControl *)self.pageControl;
        taPageControl.dotSize = pageDotSize;
    }
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}

- (void)setPageControlStyle:(WCycleScrollViewPageControlStyle)pageControlStyle
{
    _pageControlStyle = pageControlStyle;
    [self setUpPageControl];
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *taPageControl = (TAPageControl *)self.pageControl;
        taPageControl.dotColor = currentPageDotColor;
    }
    else {
        UIPageControl *pageControl = (UIPageControl *)self.pageControl;
        pageControl.currentPageIndicatorTintColor = currentPageDotColor;
    }
}

- (void)setOtherPageDotColor:(UIColor *)otherPageDotColor
{
    _otherPageDotColor = otherPageDotColor;
    
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)self.pageControl;
        pageControl.pageIndicatorTintColor = otherPageDotColor;
    }
}

- (void)setCurrentPageDotImage:(UIImage *)currentPageDotImage
{
    _currentPageDotImage = currentPageDotImage;
    [self setPageDotImage:currentPageDotImage isCurrentImage:YES];
}

- (void)setOtherPageDotImager:(UIImage *)otherPageDotImager
{
    _otherPageDotImager = otherPageDotImager;
    [self setPageDotImage:otherPageDotImager isCurrentImage:NO];
}

- (void)setPageDotImage:(UIImage *)image isCurrentImage:(BOOL)isCurrentImage
{
    if (!image || self.pageControl) {
        return;
    }
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *taPageControl = (TAPageControl *)self.pageControl;
        if (isCurrentImage) {
            taPageControl.currentDotImage = image;
        }
        else {
            taPageControl.dotImage = image;
        }
    }
    else {
        UIPageControl *pageControl = (UIPageControl *)self.pageControl;
        if (isCurrentImage) {
            [pageControl setValue:image forKeyPath:@"_currentPageImage"];
        }
        else {
            [pageControl setValue:image forKeyPath:@"_pageImage"];
        }
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        [self setupTimer];
    }
}

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.isAutoScroll];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    if (self.imagePathArray.count > 0) {
        [self setImagePathArray:self.imagePathArray];
    }
}

- (void)setImagePathArray:(NSArray *)imagePathArray
{
    _imagePathArray = imagePathArray;
    
    self.itemTotalCount = self.isInfinteLoop ? imagePathArray.count * 100 : imagePathArray.count;
    
    if (imagePathArray.count != 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.isAutoScroll];
    }
    else {
        self.collectionView.scrollEnabled = NO;
    }
    [self setUpPageControl];
    [self.collectionView reloadData];
}

- (void)setLocalImageNameArray:(NSArray *)localImageNameArray
{
    _localImageNameArray = localImageNameArray;
    self.imagePathArray = [localImageNameArray copy];
}

- (void)setImageURLStringsArray:(NSArray *)imageUrlStringArray
{
    _imageURLStringsArray = imageUrlStringArray;
    
    // NSString
    NSMutableArray *temp = [NSMutableArray array];
    for (id obj in imageUrlStringArray) {
        NSString *objString = nil;
        if ([obj isKindOfClass:[NSString class]]) {
            objString = obj;
        }
        else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            objString = url.absoluteString;
        }
        if (objString) {
            [temp addObject:objString];
        }
    }
    self.imagePathArray = [temp copy];
}

#pragma mark -
#pragma mark - private method

- (void)setUpPageControl
{
    if (self.pageControl) {
        // 重新初始化
        [self.pageControl removeFromSuperview];
    }
    
    if (self.isHidePCSingleImage && self.imagePathArray.count <= 1) {
        return;
    }
    
    switch (self.pageControlStyle) {
        case WCycleScrollViewPageControlStyle_Classic:
        {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathArray.count;
            pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
            pageControl.pageIndicatorTintColor = self.otherPageDotColor;
            pageControl.userInteractionEnabled = NO;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
            break;
        }
        case WCycleScrollViewPageControlStyle_Animated:
        {
            TAPageControl *pageControl = [[TAPageControl alloc] init];
            pageControl.numberOfPages = self.imagePathArray.count;
            pageControl.dotColor = self.currentPageDotColor;
            pageControl.userInteractionEnabled = NO;
            [self addSubview:pageControl];
            self.pageControl = pageControl;
            break;
        }
        case WCycleScrollViewPageControlStyle_None: {
            break;
        }
    }
    
    // 重新设置pageControl图片
    [self setOtherPageDotImager:self.otherPageDotImager];
    [self setCurrentPageDotImage:self.currentPageDotImage];
}

- (void)setupTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(autoScrollBanner) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)autoScrollBanner
{
    if (0 == self.itemTotalCount) {
        return;
    }
    
    int currentIndex = self.collectionView.contentOffset.x / self.flowLayout.itemSize.width;
    int targetIndex = currentIndex + 1;
    if (targetIndex == self.itemTotalCount) {
        if (self.isInfinteLoop) {
            targetIndex = self.itemTotalCount * 0.5;
        }
        else {
            return;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

// 父视图 remove时 timer停掉
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
// 避免野指针
- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.flowLayout.itemSize = self.bounds.size;
    self.collectionView.frame = self.bounds;
    
    if (self.placeholdImageView) {
        self.placeholdImageView.frame = self.bounds;
    }
    
    // 设置初始滚动 
    if (self.collectionView.contentOffset.x == 0 && self.itemTotalCount) {
        NSInteger targetIndex = 0;
        if (self.isInfinteLoop) {
            targetIndex = self.itemTotalCount * 0.5;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    // 设置控件 pageControl 位置
    if (WCycleScrollViewPageControlStyle_None == self.pageControlStyle) {
        return;
    }
    CGSize size = CGSizeZero;
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)self.pageControl;
        size = [pageControl sizeForNumberOfPages:self.imagePathArray.count];
    }
    else {
        size = CGSizeMake(self.imagePathArray.count * self.pageDotSize.width * 1.2, self.pageDotSize.height + 10);
    }
    
    // 居中
    CGFloat x = (self.bounds.size.width - size.width) * 0.5;
    if (WCycleScrollViewPageControlAliment_Right == self.pageControlStyle) {
        x = self.bounds.size.width - size.width - 10;
    }
    else if (WCycleScrollViewPageControlAliment_Left == self.pageControlStyle) {
        x = 10;
    }
    CGFloat y = self.bounds.size.height - size.height - 10;
    
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
    self.pageControl.hidden = !self.isShowPageControl;
    [self.pageControl sizeToFit];
}

#pragma mark -
#pragma mark - collectionView delegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemTotalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WCycleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imagePathArray.count;
    
    NSString *imagePath = self.imagePathArray[itemIndex];
    if ([imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath hasPrefix:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
        }
        else {
            cell.imageView.image = [UIImage imageNamed:imagePath];
        }
    }
    else if ([imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    if (self.bannerTitleArray.count && itemIndex < self.bannerTitleArray.count) {
        cell.title = self.bannerTitleArray[itemIndex];
    }
    if (!cell.isHasConfigure) {
        cell.hasConfigure = YES;
        cell.bannerTitleFont = self.bannerTitleFont;
        cell.bannerTitleColor = self.bannerTitleColor;
        cell.bannerTitleHeight = self.bannerTitleHeight;
        cell.bannerTitleBackgroundColor = self.bannerTitleBackgroundColor;
        cell.imageView.contentMode = self.bannerImageViewContentMode;
        [cell setClipsToBounds:YES];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.imagePathArray.count];
    }
}

#pragma mark -
#pragma mark - scrollview delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isAutoScroll) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.imagePathArray.count == 0) {
        return;
    }
    int index = (scrollView.contentOffset.x + self.collectionView.bounds.size.width * 0.5) / self.collectionView.bounds.size.width;
    int pageControlIndex = index % self.imagePathArray.count;
    
    if ([self.pageControl isKindOfClass:[TAPageControl class]]) {
        TAPageControl *pageControl = (TAPageControl *)self.pageControl;
        pageControl.currentPage = pageControlIndex;
    }
    else {
        UIPageControl *pageControl = (UIPageControl *)self.pageControl;
        pageControl.currentPage = pageControlIndex;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.imagePathArray.count == 0) {
        return;
    }
    NSInteger index = (scrollView.contentOffset.x + self.collectionView.bounds.size.width * 0.5) / self.collectionView.bounds.size.width;
    NSInteger pageControlIndex = index % self.imagePathArray.count;
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:pageControlIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoScroll) {
        [self setupTimer];
    }
}
@end
