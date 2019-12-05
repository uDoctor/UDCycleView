//
//  UDCycleViewCell.h
//  TS_UDCycleView
//
//  Created by uDoctor on 2019/12/4.
//  Copyright © 2019 UD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UDCycleViewCell : UIView

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) UIImageView *contentIV;

- (void)fillElementWithImgString:(NSString *)imgUrl;

@end

NS_ASSUME_NONNULL_END
