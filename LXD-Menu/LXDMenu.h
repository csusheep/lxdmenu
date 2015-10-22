//
//  LXDMenu.h
//  LXD-Menu
//
//  Created by 刘 晓东 on 15/10/22.
//  Copyright © 2015年 刘 晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LXDMenuItemClickedBlock)(NSInteger index);

@interface LXDMenu : UIView

@property (nonatomic, assign) CGFloat animaDuration;
@property (nonatomic, copy) LXDMenuItemClickedBlock clickHandle;

@end
