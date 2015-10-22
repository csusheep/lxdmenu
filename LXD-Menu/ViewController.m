//
//  ViewController.m
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import "ViewController.h"

#define lxddebug
#ifdef lxddebug
#import "LXDMenuItem.h"
#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef lxddebug
    LXDMenuItem *item = [LXDMenuItem LXDMenuItemWithTitle:@"ceshi测试呢，这是测试啊" WithFrame:CGRectMake(0, 0, 200, 50)];
    
    [self.view addSubview:item];
#endif
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
