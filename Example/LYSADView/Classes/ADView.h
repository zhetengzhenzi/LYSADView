//
//  ADView.h
//  FrameWork
//
//  Created by 刘雨双 on 15/3/3.
//  Copyright (c) 2015年 刘雨双. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADView;


#pragma mark -- ADViewDelegate
/*
 用于ADView点击事件
 */
@protocol ADViewDelegate <NSObject>

- (void)didClickScrollViewChangedActionWithADView:(ADView *)adView selecteIndex:(int)index;

@end


@interface ADView : UIView<UIScrollViewDelegate>

/*
 ADView delegate
 用于ADView点击事件

 */
@property (nonatomic,assign) id<ADViewDelegate> delegate;

/*
 初始化ADView
 
 @参数frame：ADView的frame
 @参数imageUrlArray：通过“网络获取的图片URL”数组，初始化ADView
 @参数imageNameArray：通过“本地图片名称”数组，初始化ADView
 @参数duration：每次轮播的时间间隔
 
 注意：ADView就是一个可以使一张或多张图片轮播的View，初始化完成后，记得addSubview到相应的View上。
 */
- (instancetype)initWithFrame:(CGRect)frame imageUrlArray:(NSArray *)imageUrlArray imageNameArray:(NSArray *)imageNameArray duration:(int)duration;

/*
 开始轮播
 */
- (void)startOutoADView;
/*
 停止轮播
 */
- (void)stopOutoADView;

@end
