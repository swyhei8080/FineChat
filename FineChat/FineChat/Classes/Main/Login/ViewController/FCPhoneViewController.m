//
//  FCPhoneViewController.m
//  FineChat
//
//  Created by shi on 16/10/10.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCPhoneViewController.h"
#import "FCLoginRegionButton.h"
#import "FCPhoneInputView.h"
#import "FCSMSViewController.h"
#import "FCSmsUtil.h"

@interface FCPhoneViewController ()

@property (strong, nonatomic) UIScrollView *rootScrollView;

@property (strong, nonatomic) FCLoginRegionButton *regionBtn;

@property (strong, nonatomic) FCPhoneInputView *phoneInput;

@property (strong, nonatomic) UILabel *titleLb;

@property (strong, nonatomic) UIButton *submitBtn;

@end

@implementation FCPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    [self setNavBar];
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
    titleLb.font = [UIFont systemFontOfSize:21];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [self.rootScrollView addSubview:titleLb];
    self.titleLb = titleLb;
    if (self.opType == OperationTypePhoneRegister) {
        titleLb.text = @"请输入你的手机号";
    }else{
        titleLb.text = @"通过短信验证登陆";
    }
    
    FCLoginRegionButton *regionBtn = [[FCLoginRegionButton alloc] initLoginRegionButton];
    regionBtn.y = CGRectGetMaxY(titleLb.frame) + 20;
    [self.rootScrollView addSubview:regionBtn];
    self.regionBtn = regionBtn;
    
    FCPhoneInputView *field = [[FCPhoneInputView alloc] initPhoneInputView];
    field.y = CGRectGetMaxY(self.regionBtn.frame);
    [field.areaNumField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [field.phoneNumField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self.rootScrollView addSubview:field];
    self.phoneInput = field;
    
    self.submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneInput.frame) + 30, FCScreenW - 2 * 20, 45)];
    self.submitBtn.layer.cornerRadius = 7.0f;
    if (self.opType == OperationTypePhoneRegister) {
       [self.submitBtn setTitle:@"注册" forState:UIControlStateNormal];
    }else{
        [self.submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn addTarget:self action:@selector(submitHandler:) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn.enabled = NO;
    UIImage *bkImg = [[UIImage imageNamed:@"button_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.submitBtn setBackgroundImage:bkImg forState:UIControlStateNormal];
    [self.rootScrollView addSubview:self.submitBtn];
}

#pragma mark - 事件方法

- (void)fieldTextDidChange:(UITextField *)field
{
    if(self.phoneInput.areaNumField.text.length > 0 && self.phoneInput.phoneNumField.text.length > 0){
        self.submitBtn.enabled = YES;
    }else{
        self.submitBtn.enabled = NO;
    }
}

- (void)submitHandler:(UIButton *)sender
{
    NSString *phoneNum = self.phoneInput.phoneNumField.text;
    NSString *areaCode = self.phoneInput.areaNumField.text;
    
    if ([areaCode hasPrefix:@"+"]) {
        areaCode = [areaCode substringFromIndex:1];
    }
    
    NSString *msg = [NSString stringWithFormat:@"您确定要向+%@%@手机号发送验证码吗?",areaCode,phoneNum];
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取验证码
        [FCSmsUtil getSMSCodeByPhoneNum:phoneNum zone:areaCode customIdentifier:nil result:^(NSError *error) {
            if (!error) {
                FCSMSViewController *vc = [[FCSMSViewController alloc] init];
                vc.phoneNum = self.phoneInput.phoneNumField.text;
                vc.areaCode = self.phoneInput.areaNumField.text;
                vc.opType = self.opType;
                
                [self presentViewController:vc animated:YES completion:nil];
            } else {
                FCLog(@"错误信息：%@",error);
                [FCPromptUtil showMessage:error.userInfo[@"getVerificationCode"] to:nil];
            }
        }];
    }]];
    
    alerVC.preferredAction = alerVC.actions[1];
    [self presentViewController:alerVC animated:YES completion:nil];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
