//
//  MessageViewController.m
//  FineChat
//
//  Created by shi on 16/7/7.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

static NSString *cellId = @"messageCell";

#import "FCMessageViewController.h"

@interface FCMessageViewController ()

@property (copy)void(^bblock)(void);

@end

@implementation FCMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"temp"];
    
    cell.textLabel.text = @"标题";
    cell.detailTextLabel.text = @"子标题";
    
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, 130, 50)];
    lb.text = [NSString stringWithFormat:@"%ld",(long)arc4random()];
    lb.textColor = [UIColor redColor];
    [cell.contentView addSubview:lb];
    
    NSLog(@"%@",cell);
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


@end
