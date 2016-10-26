//
//  FCPhoneViewController.h
//  FineChat
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#ifndef OperationType_enum
#define OperationType_enum
typedef NS_ENUM(NSInteger, OperationType) {
    OperationTypePhoneRegister,
    OperationTypePhoneLogin
};
#endif

#import <UIKit/UIKit.h>

@interface FCPhoneViewController : UIViewController

@property (assign, nonatomic) OperationType opType;

@end
