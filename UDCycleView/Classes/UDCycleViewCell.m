//
//  UDCycleViewCell.m
//  TS_UDCycleView
//
//  Created by uDoctor on 2019/12/4.
//  Copyright © 2019 UD. All rights reserved.
//

#import "UDCycleViewCell.h"


@interface UDCycleViewCell()


@property (nonatomic, strong) UILabel *contentLabs;

@end

static NSCache *cache = nil;
@implementation UDCycleViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        
    }
    return self;
}


- (void)fillElementWithImgString:(NSString *)imgUrl {
    //    self.contentLabs.text = [NSString stringWithFormat:@"[%ld]",index];
    if (self.placeholderImage) {
        self.contentIV.image = self.placeholderImage;
    }
    if ([imgUrl hasPrefix:@"http"]) {
        UIImage *img = [cache objectForKey:imgUrl] ;
        if (img != nil) {
            self.contentIV.image = img;
            return;
        }
        NSString *imgStr = [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imgStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
        
        
        NSURLSession * session = [NSURLSession sharedSession];
        
        
        NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                //无缓存下载图片
                NSData * imageData = [NSData dataWithContentsOfURL:location];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (imageData) {
                        UIImage *img = [UIImage imageWithData:imageData];
                        self.contentIV.image = img;
                        [cache setObject:img forKey:imgUrl];
                    } else {
                        self.contentIV.image = [UIImage imageNamed:@"default_img.jpeg"];
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@", error.localizedDescription);
                    self.contentIV.image = [UIImage imageNamed:@"default_img.jpeg"];
                });
            }
        }];
        [downloadTask resume];
        
    }
    else {
        self.contentIV.image = [UIImage imageNamed:imgUrl];
    }
}

#pragma mark - private
- (void)setupViews {
    
    [self addSubview:self.contentIV];
    [self addSubview:self.contentLabs];
    if (cache == nil) {
        cache = [[NSCache alloc] init];
    }
}

- (void)setLayout {
    self.contentIV.frame = self.bounds;
    self.contentLabs.frame = CGRectZero;
}

- (void)layoutSubviews {
    [self setLayout];
}




#pragma mark - setter&getter
- (UIImageView *)contentIV {
    if (!_contentIV) {
        _contentIV = [[UIImageView alloc] init];
    }
    return _contentIV;
}



- (UILabel *)contentLabs {
    if (!_contentLabs) {
        _contentLabs = [[UILabel alloc] init];
        _contentLabs.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabs;
}

@end
