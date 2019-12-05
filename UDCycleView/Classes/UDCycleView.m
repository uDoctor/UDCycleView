//
//  UDCycleView.m
//  TS_UDCycleView
//
//  Created by uDoctor on 2019/12/4.
//  Copyright © 2019 UD. All rights reserved.
//

#import "UDCycleView.h"
#import "UDCycleViewCell.h"
#import "UDPageControl.h"

@interface UDCycleView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, weak) NSTimer         * autoTimer;
@property (nonatomic, assign) CGFloat     itemWidth;

// left middle right 3 View
@property (nonatomic, strong) UDCycleViewCell * leftView;
@property (nonatomic, strong) UDCycleViewCell * middleView;
@property (nonatomic, strong) UDCycleViewCell * rightView;

@property (nonatomic, strong) UDPageControl *pageControl;
//
@property (nonatomic, assign) NSInteger     rightIndex;
@property (nonatomic, assign) NSInteger     middleIndex;
@property (nonatomic, assign) NSInteger     leftIndex;

//
@property (nonatomic, assign) NSInteger     itemCount;

@property (nonatomic, strong) NSLock *lock;
@end
@implementation UDCycleView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupData];
        [self setupViews];
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupViews];
        [self setupLayout];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame pageControl:(UDPageControl *)pageControl {
    self = [super initWithFrame:frame];
    if (self) {
        self.pageControl = pageControl;
        [self setupData];
        [self setupViews];
        [self setupLayout];
    }
    return self;
}
#pragma mark - tap 点击事件
- (void)tapClick:(UITapGestureRecognizer*)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(oBCycleView:itemIndex:)]) {
        [self.delegate oBCycleView:self itemIndex:self.middleIndex];
    }
}


#pragma mark - reload data method
- (void)reloadCycleData {
    if (self.imagesArray.count <=0) {
        return;
    }
    if (self.space > 0.01) {
        UDCycleViewCell *cell0 = [self.mainScrollView viewWithTag:1010];
        UDCycleViewCell *cell4 = [self.mainScrollView viewWithTag:1011];
        NSInteger index0 = (self.leftIndex -1) < 0? (self.imagesArray.count-1): (self.leftIndex -1);
        [cell0 fillElementWithImgString:self.imagesArray[index0]];
        NSInteger index4 = (self.rightIndex +1) > (self.imagesArray.count-1)? 0:(self.rightIndex +1);
        [cell4 fillElementWithImgString:self.imagesArray[index4]];
    }
    
    [self.leftView fillElementWithImgString:self.imagesArray[_leftIndex]];
    [self.middleView fillElementWithImgString:self.imagesArray[_middleIndex]];
    [self.rightView fillElementWithImgString:self.imagesArray[_rightIndex]];
 
    
}

- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    self.itemCount = imagesArray.count;
    self.pageControl.pageCount = imagesArray.count;
    [self loadConfigData];
    [self reloadCycleData];
    //
    [self timerStart];
}

#pragma mark - private
- (void)setupData {
    
    NSLock *lock = [[NSLock alloc] init];
    self.lock = lock;
    self.space = 0;
    self.timeInterval = 5;
    self.autoScroll = YES;
    [self loadConfigData];
}

- (void)loadConfigData {
    self.itemWidth = self.bounds.size.width-self.space*4;
    self.itemCount = self.imagesArray.count;
    if (self.itemCount ==1) {
        self.mainScrollView.scrollEnabled = NO;
    }else
        self.mainScrollView.scrollEnabled = YES;
    
    if (self.itemCount >2) {
        self.leftIndex   =self.imagesArray.count - 1;
        self.middleIndex =0;
        self.rightIndex  =1;
    } else if(self.itemCount == 2) {
        self.leftIndex   =1;
        self.middleIndex =0;
        self.rightIndex  =1;
    } else if(self.itemCount == 1) {
        self.leftIndex   =0;
        self.middleIndex =0;
        self.rightIndex  =0;
    }
    self.pageControl.pageCount = self.imagesArray.count;
    self.pageControl.selectIndex = self.middleIndex;
}

- (void)setSpace:(CGFloat)space {
    _space = space;
    if (space > 0.001) {
        [self loadConfigData];
        [self setupLayout];
    }
}
- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (!autoScroll) {
        [self timerStop];
    }
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    if (!self.autoScroll) {
        [self timerStop];
    } else {
        [self timerStart];
    }
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    self.leftView.placeholderImage = placeholderImage;
    self.middleView.placeholderImage = placeholderImage;
    self.rightView.placeholderImage = placeholderImage;
    
}
- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainScrollView];
    [self addSubview:self.pageControl];
    
    
    self.leftView = [[UDCycleViewCell alloc] init];
    [self.mainScrollView addSubview:self.leftView];
    
    
    self.middleView = [[UDCycleViewCell alloc] init];
    [self.mainScrollView addSubview:self.middleView];
    
    // 在中间页面添加手势
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    //    tap.delegate = self;
    [self.middleView addGestureRecognizer:tap];
    
    
    
    self.rightView = [[UDCycleViewCell alloc] init];
    [self.mainScrollView addSubview:self.rightView];
}

- (void)setupLayout {
    if (self.space > 0.01) {
        
        
        CGFloat k_space = self.space;
        self.itemWidth = self.bounds.size.width-k_space*4;
        CGFloat k_w = self.itemWidth;
        self.mainScrollView.contentSize = CGSizeMake(k_w * 3+ k_space*4 +k_space*2 + k_w*2, self.bounds.size.height);
        self.leftView.frame = CGRectMake(k_w + k_space, 0, k_w, self.bounds.size.height);
        CGFloat m_x = CGRectGetMaxX(self.leftView.frame) + k_space;
        self.middleView.frame = CGRectMake(m_x, 0, k_w, self.bounds.size.height);
        CGFloat r_x = CGRectGetMaxX(self.middleView.frame) + k_space;
        self.rightView.frame = CGRectMake(r_x, 0, k_w, self.bounds.size.height);
        self.mainScrollView.contentOffset = CGPointMake( k_w +k_w, 0);
        
        //
        
        UDCycleViewCell *leftView0 = [[UDCycleViewCell alloc] init];
        leftView0.tag = 1010;
        leftView0.frame = CGRectMake(0, 0, k_w, self.bounds.size.height);
        [self.mainScrollView addSubview:leftView0];
        
        UDCycleViewCell *rightView0 = [[UDCycleViewCell alloc] init];
        CGFloat r0_x = CGRectGetMaxX(self.rightView.frame) + k_space;
        rightView0.frame = CGRectMake(r0_x, 0, k_w, self.bounds.size.height);
        rightView0.tag = 1011;
        [self.mainScrollView addSubview:rightView0];
        
    } else {
        
        CGFloat k_space = self.space;
        self.itemWidth = self.bounds.size.width-k_space*4;
        CGFloat k_w = self.itemWidth;
        self.mainScrollView.contentSize = CGSizeMake(k_w * 3+ k_space*4 +k_space*2, self.bounds.size.height);
        self.leftView.frame = CGRectMake(k_space*2, 0, k_w, self.bounds.size.height);
        CGFloat m_x = CGRectGetMaxX(self.leftView.frame) + k_space;
        self.middleView.frame = CGRectMake(m_x, 0, k_w, self.bounds.size.height);
        CGFloat r_x = CGRectGetMaxX(self.middleView.frame) + k_space;
        self.rightView.frame = CGRectMake(r_x, 0, k_w, self.bounds.size.height);
        self.mainScrollView.contentOffset = CGPointMake( k_w+k_space, 0);
    }
}


- (void)reloadUI {
    
    CGFloat flag_right_x = 0; //向左向右的标志位置x
    CGFloat flag_left_x = 0;
    CGFloat offset_x = 0;   // 滑动的目的地
    if (self.space > 0.01) {
        flag_right_x = self.itemWidth*2-1;
        flag_left_x = self.itemWidth;
        offset_x = self.itemWidth*2;
    } else {
        flag_right_x = self.itemWidth -1;
        flag_left_x = 1;
        offset_x = self.itemWidth+self.space;
    }
    
    //像左滑动
    if (self.mainScrollView.contentOffset.x >= flag_right_x) {
        self.rightIndex  ++;
        self.middleIndex ++;
        self.leftIndex   ++;
        if (self.leftIndex > self.itemCount-1)   {self.leftIndex = 0;}
        if (self.middleIndex > self.itemCount-1) {self.middleIndex = 0;}
        if (self.rightIndex > self.itemCount-1)  {self.rightIndex = 0;}
        
    } else if (self.mainScrollView.contentOffset.x <= flag_left_x) {
        self.leftIndex   --;
        self.middleIndex --;
        self.rightIndex  --;
        if (self.leftIndex<0)   {self.leftIndex = self.itemCount-1;}
        if (self.middleIndex<0) {self.middleIndex = self.itemCount-1;}
        if (self.rightIndex<0)  {self.rightIndex = self.itemCount-1;}
    }
   
    self.pageControl.selectIndex = self.middleIndex;
    //先后执行，防止闪一下
    [self reloadCycleData];
    if (self.space > 0.01) {
        offset_x = self.itemWidth*2;
    } else {
        offset_x = self.itemWidth+self.space;
    }
    [self.mainScrollView setContentOffset:CGPointMake(offset_x, 0) animated:NO];
}
- (void)timeEvent:(NSTimer*)timer {
    if (!self.autoScroll) {
        [timer invalidate];
        [self timerStop];
    }
    //使用 UIView 动画使 view 滑行到终点
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.space > 0.01) {
            [self.mainScrollView setContentOffset:CGPointMake(self.itemWidth*3+self.space, 0)];
        } else {
            [self.mainScrollView setContentOffset:CGPointMake(self.itemWidth*2, 0)];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self reloadUI];
        }
    }];
    
}

- (void)timerStart {
    if (!self.autoScroll) {
        return;
    }
    [self timerStop];
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timeEvent:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.autoTimer forMode:NSRunLoopCommonModes];
}

- (void)timerStop {
    [self.autoTimer invalidate];
    self.autoTimer = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self timerStop];
}



- (void)scrolledView:(UIScrollView *)scrollView{
    
    if (self.autoScroll) {
        [self timerStart];
    } else {
        [self timerStop];
    }
    float view_w = self.itemWidth;
    CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
    BOOL left = point.x < 0;
    CGFloat final_x = 0;
    CGPoint finalPoint;
   
    if (self.space > 0.01) {
        //像左滑动
        if (self.mainScrollView.contentOffset.x > view_w*2+self.space ) {
            if (left) {
                final_x = view_w*2 + self.space + view_w;
            } else {
                final_x = view_w*2;
            }
        } else if (self.mainScrollView.contentOffset.x <= view_w*2+self.space -1) {
            if (left) {
                final_x = view_w*2;
            } else {
                final_x = view_w - self.space;
            }
        }
        
        finalPoint = CGPointMake(final_x, 0);
    } else {
        //像左滑动
        if (self.mainScrollView.contentOffset.x > view_w ) {
            if (left) {
                final_x = view_w *2 + 2* self.space;
            } else {
                final_x = view_w - self.space;
            }
        } else if (self.mainScrollView.contentOffset.x <= view_w -1) {
            if (left) {
                final_x = view_w - self.space;
            } else {
                final_x = - 2*self.space;
            }
        }
        
        finalPoint = CGPointMake(final_x, 0);
    }
    //使用 UIView 动画使 view 滑行到终点
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [scrollView setContentOffset:finalPoint animated:NO];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self reloadUI];
                         }
                     }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self scrolledView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrolledView:scrollView];
    }
}

#pragma mark - setter&getter
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainScrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        _mainScrollView.bounces = NO;
        _mainScrollView.delegate = self;
        [_mainScrollView setShowsHorizontalScrollIndicator:NO];
        [_mainScrollView setShowsVerticalScrollIndicator:NO];
    }
    return _mainScrollView;
}

- (UDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UDPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, self.bounds.size.width, 30)];
    }
    return _pageControl;
}


@end
