//
//  UDPageControl.h
//  TS_UDCycleView
//
//  Created by uDoctor on 2019/12/4.
//  Copyright © 2019 UD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UDPageControl : UIView

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign) CGSize normalSize;
@property (nonatomic, assign) CGSize selectSize;

@property (nonatomic, strong) UIImage *normalImg;
@property (nonatomic, strong) UIImage *selectImg;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;

@end

NS_ASSUME_NONNULL_END
