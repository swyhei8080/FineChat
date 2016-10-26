//
//  SWYActionSheet.m
//  FineChat
//
//  Created by shi on 16/10/8.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SWYActionSheet.h"

static CGFloat const kBtnHeight = 50.0f;   //按钮高度

static CGFloat const kMsgVertSpace = 20.0f;  //提示文本上下间隙

@interface SWYActionSheet ()

@property (strong,nonatomic)NSArray *otherTitles;    //一般的按钮

@property (strong,nonatomic)NSString *cancelTitle;   //取消按钮

@property (strong,nonatomic)NSString *destroyTitle;  //销毁按钮,颜色为红色

@property (strong,nonatomic)UIView *btnContaner;     //放置所有按钮的容器view

@property (strong,nonatomic)NSString *message;       //提示文字

@end

@implementation SWYActionSheet

+(instancetype)addActionSheetWithCancelTitle:(NSString *)cancel
                                destroyTitle:(NSString *)destroy
                                  otherTitle:(NSArray *)others
                                     message:(NSString *)msg
{
    UIWindow *kwindow = [UIApplication sharedApplication].keyWindow;
    
    SWYActionSheet *sheet = [[SWYActionSheet alloc] initWithFrame:kwindow.bounds];
    sheet.cancelTitle = cancel;
    sheet.destroyTitle = destroy;
    sheet.otherTitles = others;
    sheet.message = msg;
    sheet.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [kwindow addSubview:sheet];
    
    UITapGestureRecognizer *resture = [[UITapGestureRecognizer alloc] initWithTarget:sheet
                                                                              action:@selector(hideActionSheet)];
    [sheet addGestureRecognizer:resture];
    
    [sheet setupUI];
    
    return sheet;
}

- (void)dealloc
{
    FCLog(@"SWYActionSheet释放");
}

/**
 *  创建按钮视图
 */
-(void)setupUI
{
    //创建按钮容器
    self.btnContaner = [[UIView alloc] init];
    self.btnContaner.backgroundColor = FCColor(232, 232, 232, 1.0);
    [self addSubview:self.btnContaner];
    
    //message文字所在的View的高度
    CGFloat lbContanerHeigth = 0;
    if (self.message) {
        //创建message标签
        UILabel *messageLb = [[UILabel alloc] init];
        messageLb.numberOfLines = 0;
        messageLb.textAlignment = NSTextAlignmentCenter;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 4.0f;
        
        NSDictionary *attr = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:14],
                               NSForegroundColorAttributeName:FCColor(136, 136, 136, 1),
                               NSParagraphStyleAttributeName:paraStyle
                               };
        messageLb.attributedText = [[NSAttributedString alloc] initWithString:self.message attributes:attr];
        CGSize messgeSize = [self.message boundingRectWithSize:CGSizeMake(FCScreenW - 40, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attr context:nil].size;
        
        CGFloat msgLbX = (FCScreenW - messgeSize.width) / 2;
        messageLb.frame = CGRectMake(msgLbX, kMsgVertSpace, messgeSize.width, messgeSize.height);
        
        //计算message文字所在的View的高度
        lbContanerHeigth = messgeSize.height + 2 * kMsgVertSpace;
        
        UIView *lbContaner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FCScreenW, lbContanerHeigth)];
        lbContaner.backgroundColor = [UIColor whiteColor];
        [lbContaner addSubview:messageLb];
        [self.btnContaner addSubview:lbContaner];
    }
    
    
    //设置按钮容器Frame
    NSInteger numberOfbtn = 0;
    if (self.cancelTitle) {
        ++numberOfbtn;
    }
    if (self.destroyTitle) {
        ++numberOfbtn;
    }
    numberOfbtn += self.otherTitles.count;
    
    //取消按钮与别的按钮之间的间隔,如果没有取消按钮或只有取消按钮则不需要间隔
    NSInteger spaceOfcancelBtnToOther = 7;
    if (!self.cancelTitle || (self.cancelTitle && numberOfbtn == 1)) {
        spaceOfcancelBtnToOther = 0;
    }
    
    CGFloat BtnContanerH = kBtnHeight * numberOfbtn + lbContanerHeigth + spaceOfcancelBtnToOther;
    self.btnContaner.frame = CGRectMake(0, FCScreenH - BtnContanerH, FCScreenW, BtnContanerH);
    
    //创建cancel按钮
    if (self.cancelTitle) {
        UIButton *cancelBtn = [self createBtnWithTitle:self.cancelTitle
                                            titleColor:[UIColor blackColor]
                                                   tag:0];
        cancelBtn.frame = CGRectMake(0, BtnContanerH - kBtnHeight, FCScreenW, kBtnHeight);
    }
    
    //创建destroy按钮
    if (self.destroyTitle) {
        UIButton *destroyBtn = [self createBtnWithTitle:self.destroyTitle
                                             titleColor:[UIColor redColor]
                                                    tag:self.otherTitles.count + 1];
        CGFloat destroyBtnY = lbContanerHeigth + self.otherTitles.count * kBtnHeight;
        destroyBtn.frame = CGRectMake(0, destroyBtnY, FCScreenW, kBtnHeight);
    }
    
    //创建其它按钮
    for (int i = 0; i < self.otherTitles.count; ++i) {
        NSString *titleStr = self.otherTitles[i];
        UIButton *otherBtn = [self createBtnWithTitle:titleStr
                                           titleColor:[UIColor blackColor]
                                                  tag:i + 1];
        otherBtn.frame = CGRectMake(0, lbContanerHeigth + i * kBtnHeight, FCScreenW, kBtnHeight);
    }
    
    //创建分割线
    for (int i = 0; i < self.otherTitles.count + 1; ++i) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, lbContanerHeigth + i * kBtnHeight, FCScreenW, 0.5)];
        line.backgroundColor = FCColor(215, 215, 215, 1.0);
        [self.btnContaner addSubview:line];
    }
    
    //动画方式显示这个view
    self.btnContaner.transform = CGAffineTransformMakeTranslation(0, BtnContanerH);
    [UIView animateWithDuration:0.2f animations:^{
        self.btnContaner.transform = CGAffineTransformIdentity;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }];
}

/**
 *  隐藏actionSheet
 */
-(void)hideActionSheet
{
    [UIView animateWithDuration:0.2f animations:^{
        self.btnContaner.transform = CGAffineTransformMakeTranslation(0, self.btnContaner.frame.size.height);
    } completion:^(BOOL finished) {
        //手动释放block
        self.actionSheetBlock = nil;
        
        [UIView animateWithDuration:0.2f animations:^{
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }];
}

/**
 *  创建按钮
 *
 *  @param title 按钮标题
 *  @param color 按钮标题颜色
 *  @param tag   按钮tag
 *
 *  @return 返回按钮
 */
-(UIButton *)createBtnWithTitle:(NSString *)title titleColor:(UIColor *)color tag:(NSUInteger)tag
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.tag = tag;
    btn.backgroundColor = [UIColor whiteColor];
    [self.btnContaner addSubview:btn];
    
    [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)actionBtnClick:(UIButton *)sender
{
    [self hideActionSheet];
    
    if (self.actionSheetBlock) {
        self.actionSheetBlock(sender.tag,sender.titleLabel.text);
    }
}

@end