//
//  FCSMSViewController.h
//  FineChat
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef OperationType_enum
#define OperationType_enum
typedef NS_ENUM(NSInteger, OperationType) {
    OperationTypePhoneRegister,
    OperationTypePhoneLogin
};
#endif

@interface FCSMSViewController : UIViewController

@property (strong, nonatomic) NSString *phoneNum;

@property (strong, nonatomic) NSString *areaCode;

@property (assign, nonatomic) OperationType opType;

@end
