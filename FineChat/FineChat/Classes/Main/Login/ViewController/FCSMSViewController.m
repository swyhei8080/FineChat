//
//  FCSMSViewController.m
//  FineChat
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCSMSViewController.h"
#import "FCLoginField.h"
#import "SWYNetworkResponse.h"
#import "FCSmsUtil.h"
#import "FCLoginApi.h"
#import "FCRegisterApi.h"

@interface FCSMSViewController ()

@property (strong, nonatomic) UIScrollView *rootScrollView;

@property (strong, nonatomic) UIButton *submitBtn;

@property (strong, nonatomic) FCLoginField *phoneField;

@property (strong, nonatomic) FCLoginField *smsField;

@property (strong, nonatomic) UIButton *promptBtn;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) NSInteger totalSeconds;

@end

@implementation FCSMSViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setNavBar];
    
    [self startCountDown];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self stopCountDown];
}

#pragma mark - 初始化设置界面方法
/**
 *  创建自定义导航栏
 */
- (void)setNavBar
{
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FCScreenW, 64)];
    bar.backgroundColor = FCColor(255, 255, 255, 0.8);
    [self.view addSubview:bar];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(15, 27, 40, 30);
    [bar addSubview:backBtn];
}

/**
 *  初始化设置界面
 */
-(void)setupUI
{
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.rootScrollView.backgroundColor = [UIColor whiteColor];
    self.rootScrollView.contentSize = CGSizeMake(self.view.width, FCScreenH+ 1);
    [self.view addSubview:self.rootScrollView];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, FCScreenW, 40)];
    titleLb.text = @"短信验证码已发送,请查收";
    titleLb.font = [UIFont systemFontOfSize:21];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [self.rootScrollView addSubview:titleLb];
    
    NSString *num = [NSString stringWithFormat:@"%@%@",self.areaCode,self.phoneNum];
    FCLoginField *field1 = [[FCLoginField alloc] initWithTitle:@"手机号" content:num placeholder:nil];
    field1.y = CGRectGetMaxY(titleLb.frame) + 20;
    field1.noEdit = YES;
    [self.rootScrollView addSubview:field1];
    self.phoneField = field1;
    
    FCLoginField *field2 = [[FCLoginField alloc] initWithTitle:@"验证码" content:nil placeholder:@"请输入验证码"];
    field2.y = CGRectGetMaxY(self.phoneField.frame) + 10;
    field2.inputField.keyboardType = UIKeyboardTypeNumberPad;
    [field2.inputField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.rootScrollView addSubview:field2];
    self.smsField = field2;
    
    self.submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.smsField.frame) + 30, FCScreenW - 2 * 20, 45)];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitHandler:) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn.enabled = NO;
    UIImage *bkImg = [[UIImage imageNamed:@"button_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.submitBtn setBackgroundImage:bkImg forState:UIControlStateNormal];
    [self.rootScrollView addSubview:self.submitBtn];
    
    self.promptBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.submitBtn.frame) + 20, FCScreenW, 30)];
    [self.promptBtn setTitle:@"接收短信大概需要60秒" forState:UIControlStateNormal];
    [self.promptBtn setTitleColor:FCColor(100, 80, 80, 1.0) forState:UIControlStateNormal];
    self.promptBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.promptBtn addTarget:self action:@selector(reGetSMSCodeHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.rootScrollView addSubview:self.promptBtn];
}

#pragma mark - 到计时相关
- (void)startCountDown
{
    [self stopCountDown];
    
    self.totalSeconds = 60;
    [self.promptBtn setTitle:@"接收短信大概需要60秒" forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeSeconds) userInfo:nil repeats:YES];
}

- (void)stopCountDown
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    
    self.timer = nil;
}

- (void)changeSeconds
{
    self.totalSeconds--;
    
    if (self.totalSeconds < 0) {
        [self stopCountDown];
        [self.promptBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        return;
    }
    NSString *title = [NSString stringWithFormat:@"接收短信大概需要%d秒",(int)self.totalSeconds];
    [self.promptBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - 事件方法
- (void)fieldTextDidChange:(UITextField *)field
{
    if(field.text.length > 0){
        self.submitBtn.enabled = YES;
    }else{
        self.submitBtn.enabled = NO;
    }
}

-(void)submitHandler:(UIButton *)sender
{
    NSString *smsCode = self.smsField.inputField.text;
    
    if (0 == smsCode.length) {
        [FCPromptUtil showMessage:@"验证码不能为空" to:nil];
        return;
    }
    
    if (self.opType == OperationTypePhoneLogin) {
        [self loginUsePhoneNumBy:smsCode];
    }else{
        [self registerUsePhoneNumBy:smsCode];
    }
    
}

/**
 *  重新获取验证码
 */
- (void)reGetSMSCodeHandler:(UIButton *)sender
{
    if (self.totalSeconds > 0) {
        return;
    }
    
    NSString *msg = [NSString stringWithFormat:@"您确定要向+%@%@手机号发送验证码吗?",self.areaCode,self.phoneNum];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取验证码
        [FCSmsUtil getSMSCodeByPhoneNum:self.phoneNum zone:self.areaCode customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                [self startCountDown];
            } else {
                FCLog(@"错误信息：%@",error);
                [FCPromptUtil showMessage:error.userInfo[@"getVerificationCode"] to:nil];
            }
        }];
    }]];

    alertVC.preferredAction = alertVC.actions[1];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 网络相关
/**
 *
 */
- (void)loginUsePhoneNumBy:(NSString *)smsCode
{
    FCLoginApi *loginApi = [[FCLoginApi alloc] init];
    loginApi.params = @{
                        @"method":@"sms",
                        @"userName":self.phoneNum,
                        @"zone":self.areaCode,
                        @"smsCode":smsCode,
                        @"client":@"ios"
                        };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [loginApi startRequestWithProgressBlock:nil successCallBack:^(SWYNetworkBaseAPI *api, SWYNetworkResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([response.responseObject[@"code"] integerValue] == 0) {
            [FCPromptUtil showMessage:@"手机验证码登录成功" to:nil];
            
            NSString *token = response.responseObject[@"datas"][@"token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneNum forKey:kUserNameKey];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserPasswdKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            [FCPromptUtil showMessage:[NSString stringWithFormat:@"%@",response.responseObject[@"errorMsg"]] to:nil];
        }
        
        NSLog(@"%@",response.responseObject);
        
    } failureCallBack:^(SWYNetworkBaseAPI *api, SWYNetworkResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [FCPromptUtil showMessage:@"登录失败" to:nil];
        NSLog(@"%@",response.responseString);
    }];

}

- (void)registerUsePhoneNumBy:(NSString *)smsCode
{
    FCRegisterApi *registerApi = [[FCRegisterApi alloc] init];
    registerApi.params = @{
                           @"userName":self.phoneNum,
                           @"zone":self.areaCode,
                           @"smsCode":smsCode,
                           @"accountType":@"2",
                           @"client":@"ios"
                           };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [registerApi startRequestWithProgressBlock:nil successCallBack:^(SWYNetworkBaseAPI *api, SWYNetworkResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        FCLog(@"------%@",response.responseObject);
        
        if ([response.responseObject[@"code"] integerValue] == 0) {
            [FCPromptUtil showMessage:@"手机验证码注册成功" to:nil];
            
            NSString *token = response.responseObject[@"datas"][@"token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneNum forKey:kUserNameKey];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kUserPasswdKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            [FCPromptUtil showMessage:[NSString stringWithFormat:@"%@",response.responseObject[@"errorMsg"]] to:nil];
        }
        
        
    } failureCallBack:^(SWYNetworkBaseAPI *api, SWYNetworkResponse *response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [FCPromptUtil showMessage:@"请求失败" to:nil];
    }];

}

#pragma mark - 键盘处理相关
/**
 *  键盘出现时视图向上移动
 */
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardFrame = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyBoardY = FCScreenH - keyBoardFrame.size.height;
    
    CGFloat loginBtnMaxY = CGRectGetMaxY(self.submitBtn.frame);
    
    if (loginBtnMaxY + 10 > keyBoardY) {
        self.rootScrollView.contentInset = UIEdgeInsetsMake(0, 0, loginBtnMaxY + 10 - keyBoardY, 0);
        [UIView animateWithDuration:0.25 animations:^{
            self.rootScrollView.contentOffset = CGPointMake(0, loginBtnMaxY + 10 - keyBoardY);
        } completion:nil];
    }
}

/**
 *  键盘消失时复原
 */
-(void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.25 animations:^{
        self.rootScrollView.contentOffset = CGPointMake(0, 0);
        
    } completion:^(BOOL finished) {
        self.rootScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

@end
