//
//  FCPhoneInputView.m
//  FineChat
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCPhoneInputView.h"

@interface FCPhoneInputView ()

@property (strong, nonatomic) UITextField *areaNumField;

@property (strong, nonatomic) UITextField *phoneNumField;

@property (strong, nonatomic) UIView *lineVert;

@property (strong, nonatomic) UIView *lineBottom;

@property (strong, nonatomic) UIView *lineTop;

@end

@implementation FCPhoneInputView

- (instancetype)initPhoneInputView
{
    self = [self initWithFrame:CGRectMake(20, 0, FCScreenW - 20, 50)];    //Y值最后还需要按实际来重新设置
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.areaNumField = [[UITextField alloc] init];
        self.areaNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.areaNumField.placeholder = @"输入区号";
        self.areaNumField.text = @"+86";
        self.areaNumField.font = [UIFont systemFontOfSize:16];
        self.areaNumField.keyboardType = UIKeyboardTypePhonePad;
//        self.areaNumField.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.areaNumField];
        
        self.phoneNumField = [[UITextField alloc] init];
        self.phoneNumField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.phoneNumField.placeholder = @"输入手机号";
        self.phoneNumField.font = [UIFont systemFontOfSize:16];
        self.phoneNumField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:self.phoneNumField];
        
        self.lineBottom = [[UIView alloc] init];
        self.lineBottom.backgroundColor = FCColor(230, 230, 230, 1);
        [self addSubview:self.lineBottom];
        
        self.lineVert = [[UIView alloc] init];
        self.lineVert.backgroundColor = FCColor(230, 230, 230, 1);
        [self addSubview:self.lineVert];
        
        self.lineTop = [[UIView alloc] init];
        self.lineTop.backgroundColor = FCColor(230, 230, 230, 1);
        [self addSubview:self.lineTop];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    self.areaNumField.frame = CGRectMake(10, 0, 80, h);
    
    self.phoneNumField.frame = CGRectMake(100, 0, w - 100 - 10, h);
    
    self.lineTop.frame = CGRectMake(0, 0, w, 1);
    
    self.lineVert.frame = CGRectMake(90, 0, 1, h);
    
    self.lineBottom.frame = CGRectMake(0, h - 1, w, 1);
}

@end
