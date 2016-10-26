//
//  FCLoginRegionButton.m
//  FineChat
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCLoginRegionButton.h"

@interface FCLoginRegionButton ()

@property (strong, nonatomic) UILabel *promptLb;

@property (strong, nonatomic) UIView *line;

@end

@implementation FCLoginRegionButton

- (instancetype)initLoginRegionButton
{
    self = [self initWithFrame:CGRectMake(20, 0, FCScreenW - 20, 50)];    //Y值最后还需要按实际来重新设置
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.promptLb = [[UILabel alloc] init];
        self.promptLb.font = [UIFont systemFontOfSize:16];
        self.promptLb.textColor = [UIColor blackColor];
        self.promptLb.text = @"国家/地区";
        [self addSubview:self.promptLb];
        
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitle:@"中国大陆" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"temp"] forState:UIControlStateNormal];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    self.promptLb.frame = CGRectMake(0, 0, 90, h);
    
    self.titleLabel.frame = CGRectMake(90, 0, w - 90 - h, h);
    
    self.imageView.frame = CGRectMake(w - h, 0, h, h);
}

@end
