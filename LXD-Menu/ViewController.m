//
//  ViewController.m
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import "ViewController.h"
#import "LXDMenu.h"

#define lxddebug
#ifdef lxddebug
#import "LXDMenuItem.h"
#endif

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)  UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef lxddebug
    //LXDMenuItem *item = [LXDMenuItem LXDMenuItemWithTitle:@"ceshi测试呢，这是测试啊" WithFrame:CGRectMake(0, 0, 200, 50)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.view addSubview:_tableView];
    
    LXDMenu *menu  = [LXDMenu menuViewWithItem:@[@"ceshi"] forViewController:self];
    
    [self.view addSubview:menu];
    
    //[self.view addSubview:item];
#endif
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor colorWithRed:0.12 * indexPath.row green:0.8 blue:0.9 alpha:1.0];
    
    cell.textLabel.text = [NSString stringWithFormat:@"PlaceHolder Text : %ld",(long)indexPath.row];
    return cell;
}

@end
