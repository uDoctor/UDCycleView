//
//  UDCycleView.h
//  TS_UDCycleView
//
//  Created by uDoctor on 2019/12/4.
//  Copyright © 2019 UD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UDPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@class UDCycleView;

@protocol UDCycleViewDelegate <NSObject>

@optional
- (void)oBCycleView:(UDCycleView *)cycleView itemIndex:(NSInteger)index;

@end

@interface UDCycleView : UIView


/**
 推荐实例化

 @param frame frame
 @param pageControl 配置好的指示器
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame pageControl:(UDPageControl *)pageControl;
/**
 * 网络图片 url string 数组
 */
@property (nonatomic, copy) NSArray * imagesArray;

/**
 * 每张图片对应要显示的文字数组
 */
@property (nonatomic, strong) NSArray *titlesArray;

@property (nonatomic, strong) UIImage *placeholderImage;

/**
 * item 点击的代理回调
 */
@property (nonatomic, weak) id<UDCycleViewDelegate> delegate;


/**
 * 是否自动轮播，默认是自动轮播
 */
@property (nonatomic, assign) BOOL autoScroll;


/**
 * 自定义轮播时间，默认 5秒
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 每个item的间距，不要写太大，不然不好看
 */
@property (nonatomic, assign) CGFloat space;

@end

NS_ASSUME_NONNULL_END
