//
//  FCPhoneInputView.h
//  FineChat
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCPhoneInputView : UIView

@property (strong, nonatomic, readonly) UITextField *areaNumField;

@property (strong, nonatomic, readonly) UITextField *phoneNumField;

- (instancetype)initPhoneInputView;

@end
