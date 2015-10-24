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
#import "LXDMenuHeaderVIew.h"
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
    
    
    _displayLabel = [[UILabel alloc ] initWithFrame:CGRectMake(ScreenWidth/2 - 100, ScreenHeight/2, 200, 50)];
    _displayLabel.textColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.7 alpha:1];
    _displayLabel.font = [UIFont systemFontOfSize:50 weight:20];
    _displayLabel.text = @"default";
    [self.view addSubview:_displayLabel];
    
    UIView *mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 88)];
    mainview.backgroundColor = [UIColor clearColor];
    
    __weak ViewController *this = self;
    
    LXDMenuItem *first = [[LXDMenuItem alloc] initMenuItemWithTitle:@"测试啊" withCompletionHandler:^(BOOL flag){
        
        this.displayLabel.text = @"first";
        NSLog(@"first") ;
    }];
    LXDMenuItem *second = [[LXDMenuItem alloc] initMenuItemWithTitle:@"测试啊222" withCompletionHandler:^(BOOL flag){
       this.displayLabel.text = @"second";
        NSLog(@"second") ;
    }];
    
    LXDMenuItem *three = [[LXDMenuItem alloc] initMenuItemWithTitle:@"测试啊22adsf2" withCompletionHandler:^(BOOL flag){
        this.displayLabel.text = @"three";
        NSLog(@"three") ;
    }];
    
    LXDMenu *menu  = [LXDMenu menuViewWithItem:@[first,second,three] forViewController:self headerHeight:0 mainItem:mainview withClickByIndex:nil];
    
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
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    
    cell.backgroundColor = [UIColor colorWithRed:brightness green:saturation blue:hue alpha:0.8];
    
    return cell;
}

@end
