//
//  ADView.m
//  FrameWork
//
//  Created by 刘雨双 on 15/3/3.
//  Copyright (c) 2015年 刘雨双. All rights reserved.
//

#import "ADView.h"
#import "UIImageView+WebCache.h"

// 屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ADView ()
{
    BOOL isImageName;//图片数组标签，是否是image name
    
}

@property (nonatomic,strong) UIScrollView * mainScrollView;//底部的scrollView
@property (nonatomic,strong) UIPageControl * pageControl;//分页控制
@property (nonatomic,strong) UIImageView * imageViewOne;
@property (nonatomic,strong) UIImageView * imageViewTwo;
@property (nonatomic,strong) UIImageView * imageViewThree;

@property (nonatomic,strong) NSMutableArray * adImagesArray;//存放广告图
@property (nonatomic,strong) NSTimer * timer;//计时器
@property (nonatomic,assign) NSUInteger currentPageIndex;//当前广告图的页码
@property (nonatomic,assign) NSInteger duration;//间隔时间


- (void)p_setupSubViewsWithImageNameArray:(NSArray *)imageNameArray imageUrlArray:(NSArray *)imageUrlArray duration:(int)duration;//加载子视图
- (void)p_setupAdViewWithImageNameArray:(NSArray *)imageNameArray imageUrlArray:(NSArray *)imageUrlArray duration:(int)duration;//加载广告图片
- (void)p_setSingleAdImageView;//加载单个视图
- (void)p_setMoreAdImageViews;//加载多个视图
- (NSUInteger)p_getValidNextPageIndexWithPageIndex:(NSInteger)pageIndex;//根据当前的索引判断来获取有效的索引


@end


@implementation ADView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithFrame:(CGRect)frame imageUrlArray:(NSArray *)imageUrlArray imageNameArray:(NSArray *)imageNameArray duration:(int)duration
{
    self = [super initWithFrame:frame];
    if (self) {
    //加载子子视图
        [self p_setupSubViewsWithImageNameArray:imageNameArray imageUrlArray:imageUrlArray duration:duration];
    }
    return self;
}

#pragma mark ----加载子视图
- (void)p_setupSubViewsWithImageNameArray:(NSArray *)imageNameArray imageUrlArray:(NSArray *)imageUrlArray duration:(int)duration
{
    self.adImagesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.currentPageIndex = 0;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mainScrollView];
    
    //给mainScrollView添加轻拍手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickScrollViewAction:)];
    [self.mainScrollView addGestureRecognizer:tapGesture];
    

    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, ScreenWidth, 20)];
    self.pageControl.currentPage = 0;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:self.pageControl];
    self.pageControl.userInteractionEnabled = NO;
//    [self.pageControl addTarget:self action:@selector(didClickPageControlChangeAction:) forControlEvents:UIControlEventValueChanged];
    
    
    self.imageViewOne = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.imageViewOne.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.bounds))];
    [self.imageViewTwo.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, CGRectGetHeight(self.bounds))];
    [self.imageViewThree.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    [self.mainScrollView addSubview:self.imageViewOne];
    [self.mainScrollView addSubview:self.imageViewTwo];
    [self.mainScrollView addSubview:self.imageViewThree];
    
    //加载广告图
    [self p_setupAdViewWithImageNameArray:imageNameArray imageUrlArray:imageUrlArray duration:duration];
    
}
#pragma mark ----加载广告图
- (void)p_setupAdViewWithImageNameArray:(NSArray *)imageNameArray imageUrlArray:(NSArray *)imageUrlArray duration:(int)duration
{
    if (imageNameArray !=nil) {
        //名称
        isImageName = YES;
        [self.adImagesArray removeAllObjects];
        [self.adImagesArray addObjectsFromArray:imageNameArray];
    }else if(imageUrlArray !=nil){
        //URL
        isImageName = NO;
        [self.adImagesArray removeAllObjects];
        [self.adImagesArray addObjectsFromArray:imageUrlArray];
    }

    
    self.currentPageIndex = 0;

    self.pageControl.numberOfPages = self.adImagesArray.count;
    self.pageControl.currentPage = 0;
    if (self.adImagesArray.count <= 1) {
        [self p_setSingleAdImageView];
    }else{
        [self p_setMoreAdImageViews];
        //持续时间
        self.duration = duration;
        [self startOutoADView];
    }
}

#pragma mark ----加载单个视图
- (void)p_setSingleAdImageView
{
    [self.mainScrollView setContentSize:CGSizeMake(ScreenWidth ,0)];
    [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
    
    if (self.adImagesArray) {
        if (isImageName == YES) {
            //名称
            self.imageViewOne.image = [self.adImagesArray objectAtIndex:0];

        }else if(isImageName == NO){
            //URL
            [self.imageViewOne sd_setImageWithURL:[self.adImagesArray objectAtIndex:0]];
        }
    }else{
        self.imageViewOne.image = nil;

    }
    
}

#pragma mark ----加载多个视图
- (void)p_setMoreAdImageViews
{
    [self.mainScrollView setContentSize:CGSizeMake(ScreenWidth*3, 0)];
    [self.mainScrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
    
    NSUInteger previousPageIndex = [self p_getValidNextPageIndexWithPageIndex:self.currentPageIndex -1];
    NSUInteger nextPageIndex = [self p_getValidNextPageIndexWithPageIndex:self.currentPageIndex +1];
    if (isImageName == YES) {
        //名称
        self.imageViewOne.image = [self.adImagesArray objectAtIndex:previousPageIndex];
        self.imageViewTwo.image = [self.adImagesArray objectAtIndex:self.currentPageIndex];
        self.imageViewThree.image = [self.adImagesArray objectAtIndex:nextPageIndex];
    }else if(isImageName == NO){
        //URL
        [self.imageViewOne sd_setImageWithURL:[self.adImagesArray objectAtIndex:previousPageIndex]];
        [self.imageViewTwo sd_setImageWithURL:[self.adImagesArray objectAtIndex:self.currentPageIndex]];
        [self.imageViewThree sd_setImageWithURL:[self.adImagesArray objectAtIndex:nextPageIndex]];
    }

    self.pageControl.currentPage = self.currentPageIndex;
    
}

#pragma mark ----根据当前的索引判断来获取有效的索引
- (NSUInteger)p_getValidNextPageIndexWithPageIndex:(NSInteger)pageIndex
{
    if (pageIndex == -1) {
        return self.adImagesArray.count -1;
    }else if (pageIndex == self.adImagesArray.count){
        return 0;
    }else{
        return pageIndex;
    }

}

#pragma mark ----开始滚动
- (void)startOutoADView
{
    if (self.adImagesArray.count <= 1) {
        return;
    }
    
    if (self.timer) {
        return;
    }
    
//    int animationTime = 4.0;//间隔时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(gotoNextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
}

#pragma mark ----停止滚动
- (void)stopOutoADView
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

- (void)gotoNextPage
{
    CGFloat offsetX = self.mainScrollView.contentOffset.x;
    [self.mainScrollView setContentOffset:CGPointMake(offsetX + ScreenWidth, 0) animated:YES];
    
}

#pragma mark ===scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopOutoADView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startOutoADView];
}
//scrollView滚动时要重新设置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.width <= ScreenWidth) {
            if (self.adImagesArray.count <= 1) {
                [self p_setSingleAdImageView];
            }else{
                [self p_setMoreAdImageViews];
            }
        }else {
        if (scrollView.contentOffset.x >= ScreenWidth*2){
            self.currentPageIndex = [self p_getValidNextPageIndexWithPageIndex:self.currentPageIndex+1];
            [self p_setMoreAdImageViews];
        }else if (scrollView.contentOffset.x <= 0){
            self.currentPageIndex = [self p_getValidNextPageIndexWithPageIndex:self.currentPageIndex-1];
            [self p_setMoreAdImageViews];
        }
    }
}


#pragma mark --- tap adView action
- (void)didClickScrollViewAction:(UIGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(didClickScrollViewChangedActionWithADView:selecteIndex:)]) {
        [self.delegate didClickScrollViewChangedActionWithADView:self selecteIndex:(int)self.currentPageIndex];
    }
}
#pragma mark ---- pageControl
//- (void)didClickPageControlChangeAction:(id)sender
//{
//    CGFloat offsetX = self.pageControl.currentPage * CGRectGetWidth(self.bounds);
//    [self.mainScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
//}


@end
