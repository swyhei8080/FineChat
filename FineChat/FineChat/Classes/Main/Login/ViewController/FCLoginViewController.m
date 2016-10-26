//
//  LoginViewController.m
//  FineChat
//
//  Created by shi on 16/6/15.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCLoginViewController.h"
#import "SWYActionSheet.h"
#import "FCLoginField.h"
#import "FCRegisterViewController.h"
#import "FCLoginUserNameViewController.h"
#import "FCPhoneViewController.h"
#import "FCLoginApi.h"

@interface FCLoginViewController ()

@property (strong, nonatomic) UIScrollView *rootScrollView;

@property (strong, nonatomic) UIImageView *headIconView;

@property (strong, nonatomic) UILabel *userNameLb;

@property (strong, nonatomic) FCLoginField *pwdField;

@property (strong, nonatomic) UIButton *loginBtn;

@end

@implementation FCLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupView];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:kUserNameKey];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] stringForKey:kUserPasswdKey];
    
    self.userNameLb.text = userName;
    self.pwdField.inputField.text = pwd;
    if (pwd.length > 0) {
        self.loginBtn.enabled = YES;
    }
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

-(void)setupView
{
    CGFloat marginLeft = 20;
    CGFloat marginVert = 10;
    
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.rootScrollView.backgroundColor = [UIColor whiteColor];
    self.rootScrollView.contentSize = CGSizeMake(FCScreenW, FCScreenH +1);
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditView:)];
    gesture.numberOfTapsRequired = 1;
    [self.rootScrollView addGestureRecognizer:gesture];
    [self.view addSubview:self.rootScrollView];
    
    self.headIconView = [[UIImageView alloc] initWithFrame:CGRectMake((FCScreenW - 80) / 2, 64, 80, 80)];
    self.headIconView.backgroundColor = FCColor(235, 235, 235, 1.0);
    self.headIconView.layer.borderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5].CGColor;
    [self.rootScrollView addSubview:self.headIconView];
    
    self.userNameLb = [[UILabel alloc] init];
    self.userNameLb.font = [UIFont boldSystemFontOfSize:17];
    self.userNameLb.textColor = [UIColor blackColor];
    self.userNameLb.textAlignment = NSTextAlignmentCenter;
    self.userNameLb.backgroundColor = [UIColor whiteColor];
    self.userNameLb.frame = CGRectMake(marginLeft, CGRectGetMaxY(self.headIconView.frame) + marginVert, FCScreenW - 2 * marginLeft, 30);
    [self.rootScrollView addSubview:self.userNameLb];
    self.userNameLb.text = @"";
    
    self.pwdField = [[FCLoginField alloc] initWithTitle:@"密码" content:nil placeholder:@"请输入密码"];
    self.pwdField.y = CGRectGetMaxY(self.userNameLb.frame) + 15;
    [self.pwdField.inputField addTarget:self action:@selector(fieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.rootScrollView addSubview:self.pwdField];
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginLeft, CGRectGetMaxY(self.pwdField.frame) + 30, FCScreenW - 2 * marginLeft, 45)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.enabled = NO;
    UIImage *bkImg = [[UIImage imageNamed:@"button_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.loginBtn setBackgroundImage:bkImg forState:UIControlStateNormal];
    [self.rootScrollView addSubview:self.loginBtn];
    
    
    UIButton *(^createBtnBlock)(NSString *title, SEL acton) = ^UIButton *(NSString *title, SEL acton){
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitleColor:FCColor(100, 80, 80, 1.0) forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:acton forControlEvents:UIControlEventTouchUpInside];
        [self.rootScrollView addSubview:btn];
        return btn;
    };
    
    UIButton *issueBtn = createBtnBlock(@"登录遇到问题",@selector(issueBtnClick:));
    [issueBtn sizeToFit];
    issueBtn.frame = CGRectMake((FCScreenW - CGRectGetWidth(issueBtn.frame)) / 2, CGRectGetMaxY(self.loginBtn.frame) + 20, issueBtn.width, issueBtn.height);
    
    UIButton *moreBtn = createBtnBlock(@"更多",@selector(moreChoice:));
    moreBtn.frame = CGRectMake((FCScreenW - 50) / 2, FCScreenH - 50, 50, 30);
}

#pragma mark - 事件方法
- (void)fieldTextDidChange:(UITextField *)field
{
    if(self.pwdField.inputField.text.length > 0){
        self.loginBtn.enabled = YES;
    }else{
        self.loginBtn.enabled = NO;
    }
}

-(void)loginBtnClick:(id)sender
{
    FCLoginApi *loginApi = [[FCLoginApi alloc] init];
    
    NSString *userName = self.userNameLb.text;
    NSString *pwd = self.pwdField.inputField.text;
    
    NSMutableDictionary *params = [@{
                                    @"method":@"pwd",
                                    @"client":@"ios"
                                    }mutableCopy];
    params[@"userName"] = userName;
    params[@"passwd"] = pwd;
    loginApi.params = params;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [loginApi startRequestWithProgressBlock:nil successCallBack:^(SWYNetworkBaseAPI *api, SWYNetworkResponse *response) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([response.responseObject[@"code"] integerValue] == 0) {
            [FCPromptUtil showMessage:@"用户名密码登录成功" to:nil];
            
            NSString *token = response.responseObject[@"datas"][@"token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kUserNameKey];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:kUserTokenKey];
            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:kUserPasswdKey];
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

-(void)issueBtnClick:(id)sender
{
    FCLog(@"出现问题");
}

-(void)moreChoice:(id)sender
{
    SWYActionSheet *actSheet = [SWYActionSheet addActionSheetWithCancelTitle:@"取消" destroyTitle:nil otherTitle:@[@"注册",@"修改登录方式"] message:nil];
    actSheet.actionSheetBlock = ^(NSInteger tag,NSString *title){
        
        if ([title isEqualToString:@"注册"]) {
            
            SWYActionSheet *actSheet1 = [SWYActionSheet addActionSheetWithCancelTitle:@"取消" destroyTitle:nil otherTitle:@[@"手机号注册",@"帐号和密码注册"] message:nil];
            actSheet1.actionSheetBlock = ^(NSInteger tag,NSString *title){
                if ([title isEqualToString:@"帐号和密码注册"]) {
                    FCRegisterViewController *vc = [[FCRegisterViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                }else if ([title isEqualToString:@"手机号注册"]){
                    FCPhoneViewController *vc = [[FCPhoneViewController alloc] init];
                    vc.opType = OperationTypePhoneRegister;
                    [self presentViewController:vc animated:YES completion:nil];
                }
            };
            
        }else if ([title isEqualToString:@"修改登录方式"]) {
            SWYActionSheet *actSheet2 = [SWYActionSheet addActionSheetWithCancelTitle:@"取消" destroyTitle:nil otherTitle:@[@"手机号",@"帐号和密码"] message:nil];
            actSheet2.actionSheetBlock = ^(NSInteger tag,NSString *title){
                if ([title isEqualToString:@"帐号和密码"]) {
                    FCLoginUserNameViewController *vc = [[FCLoginUserNameViewController alloc] init];
                    [self presentViewController:vc animated:YES completion:nil];
                }else if ([title isEqualToString:@"手机号"]){
                    FCPhoneViewController *vc = [[FCPhoneViewController alloc] init];
                    vc.opType = OperationTypePhoneLogin;
                    [self presentViewController:vc animated:YES completion:nil];
                }
            };
            
        }
    };
}

-(void)endEditView:(UITapGestureRecognizer *)gesture
{
    [self.pwdField endEditing:YES];
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
        self.rootScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardFrame.size.height, 0);
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
