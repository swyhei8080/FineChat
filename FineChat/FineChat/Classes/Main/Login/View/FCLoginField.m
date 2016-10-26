//
//  FCLoginField.m
//  FineChat
//
//  Created by shi on 16/10/9.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCLoginField.h"

@interface FCLoginField ()

@property (strong, nonatomic) UILabel *titleLb;

@property (strong, nonatomic) UITextField *inputField;

@property (strong, nonatomic) UIView *line;

@end

@implementation FCLoginField

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder
{
    self = [self initWithFrame:CGRectMake(20, 0, FCScreenW - 20, 50)];    //Y值最后还需要按实际来重新设置
    self.titleLb.text = title;
    self.inputField.placeholder = placeholder;
    self.inputField.text = content;
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *lb = [[UILabel alloc] init];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont systemFontOfSize:16];
        [self addSubview:lb];
        self.titleLb = lb;
        
        UITextField *field = [[UITextField alloc] init];
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.font = [UIFont systemFontOfSize:16];
        field.textColor = [UIColor blackColor];
        [self addSubview:field];
        self.inputField = field; 
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = FCColor(230, 230, 230, 1);
        [self addSubview:line];
        self.line = line;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    self.titleLb.frame = CGRectMake(0, 0, 70, h);
    
    CGFloat fieldX = CGRectGetMaxX(self.titleLb.frame) + 15;
    self.inputField.frame = CGRectMake(fieldX, 0, w - fieldX - 10, h);
    
    self.line.frame = CGRectMake(0, h - 1, w, 1);
}

- (void)setNoEdit:(BOOL)noEdit
{
    _noEdit = noEdit;
    
    if (noEdit) {
        self.titleLb.textColor = FCColor(150, 150, 150, 1);
        self.inputField.textColor = FCColor(150, 150, 150, 1);
        self.inputField.enabled = NO;
        return;
    }
    self.titleLb.textColor = [UIColor blackColor];
    self.inputField.textColor = [UIColor blackColor];
    self.inputField.enabled = NO;
    
}

@end
