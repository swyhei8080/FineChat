//
//  LoginUserNameViewController.m
//  FineChat
//
//  Created by shi on 16/6/27.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCLoginUserNameViewController.h"
#import "FCLoginField.h"
#import "FCLoginApi.h"

@interface FCLoginUserNameViewController ()

@property (strong, nonatomic) UIScrollView *rootScrollView;

@property (strong, nonatomic) UIButton *loginBtn;

@property (strong, nonatomic) FCLoginField *accountField;

@property (strong, nonatomic) FCLoginField *pwdField;

@end

@implementation FCLoginUserNameViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self setNavBar];
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
    titleLb.text = @"输入帐号与密码";
    titleLb.font = [UIFont systemFontOfSize:21];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [self.rootScrollView addSubview:titleLb];
    
    FCLoginField *field1 = [[FCLoginField alloc] initWithTitle:@"帐号" content:nil placeholder:@"请输入用户名/手机号"];
    field1.y = CGRectGetMaxY(titleLb.frame) + 20;
    [field1.inputField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.rootScrollView addSubview:field1];
    self.accountField = field1;
    
    FCLoginField *field2 = [[FCLoginField alloc] initWithTitle:@"密码" content:nil placeholder:@"请输入密码"];
    field2.y = CGRectGetMaxY(self.accountField.frame) + 10;
    [field2.inputField setSecureTextEntry:YES];
    [field2.inputField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.rootScrollView addSubview:field2];
    self.pwdField = field2;
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.pwdField.frame) + 30, FCScreenW - 2 * 20, 45)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.enabled = NO;
    UIImage *bkImg = [[UIImage imageNamed:@"button_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.loginBtn setBackgroundImage:bkImg forState:UIControlStateNormal];
    [self.rootScrollView addSubview:self.loginBtn];
}

#pragma mark - 事件方法
- (void)fieldTextDidChange:(UITextField *)field
{
    if(self.accountField.inputField.text.length > 0 && self.pwdField.inputField.text.length > 0){
        self.loginBtn.enabled = YES;
    }else{
        self.loginBtn.enabled = NO;
    }
}

-(void)loginBtnClick:(UIButton *)sender
{
    NSString *userName = self.accountField.inputField.text;
    NSString *passwd = self.pwdField.inputField.text;
    
    if (0 == userName.length || 0 == passwd.length) {
        [FCPromptUtil showMessage:@"请输入用户名或密码" to:nil];
        return;
    }
    
    FCLoginApi *loginApi = [[FCLoginApi alloc] init];
    loginApi.params = @{
                        @"userName":userName,
                        @"method":@"pwd",
                        @"passwd":passwd,
                        @"client":@"ios"
                        };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [loginApi startRequestWithProgressBlock:nil successCallBack:^(SWYNetworkBaseAPI *api, SWYNetworkResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([response.responseObject[@"code"] integerValue] == 0) {
            [FCPromptUtil showMessage:@"用户名密码登录成功" to:nil];
            
            NSString *token = response.responseObject[@"datas"][@"token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserNameKey];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:passwd forKey:kUserPasswdKey];
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

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 键盘处理相关
/**
 *  键盘出现时视图向上移动
 */
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardFrame = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyBoardY = FCScreenH - keyBoardFrame.size.height;
    
    CGFloat loginBtnMaxY = CGRectGetMaxY(self.loginBtn.frame);
    
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
