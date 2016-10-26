
//
//  TransitionUtil.m
//  FineChat
//
//  Created by shi on 16/7/6.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "FCTransitionUtil.h"
#import "FCTabBarController.h"
#import "FCMessageViewController.h"

@implementation FCTransitionUtil

+(instancetype)shareInstance
{
    static FCTransitionUtil *transitionUtil = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        transitionUtil = [[FCTransitionUtil alloc] init];
    });
    
    return transitionUtil;
}

/**
 *  跳转到主界面
 */
+(void)setRootViewController
{
    UIWindow *kwd = [UIApplication sharedApplication].keyWindow;
    FCTabBarController *tbbarVC = [[FCTabBarController alloc] init];
    kwd.rootViewController = tbbarVC;
    
    FCMessageViewController *vc0 = [[FCMessageViewController alloc] initWithStyle:UITableViewStylePlain];
    vc0.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:nil selectedImage:nil];
    vc0.view.backgroundColor = [UIColor redColor];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:nil selectedImage:nil];
    vc1.view.backgroundColor = [UIColor redColor];
    
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:nil selectedImage:nil];
    vc2.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:nil selectedImage:nil];
    vc3.view.backgroundColor = [UIColor grayColor];
    
    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"其他" image:nil selectedImage:nil];
    vc4.view.backgroundColor = [UIColor blueColor];
    
    UIViewController *vc5 = [[UIViewController alloc] init];
    vc5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"其他1" image:nil selectedImage:nil];
    vc5.view.backgroundColor = [UIColor blueColor];
    
    tbbarVC.viewControllers = @[vc0,vc1,vc2,vc3,vc4,vc5];

    
}

@end
