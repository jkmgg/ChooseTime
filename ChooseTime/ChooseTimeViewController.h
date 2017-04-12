//
//  ChooseTimeViewController.h
//  shijian
//
//  Created by IOS_MAC PRO on 2017/4/6.
//  Copyright © 2017年 com.ASS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTimeViewController : UIViewController

/**
 店铺上班时间
 */
@property(nonatomic,copy)NSString * startTime;
/**
 店铺下班时间
 */
@property(nonatomic,copy)NSString * endTime;

/**
 时间间隔（分钟）
 */
@property(nonatomic,assign)NSInteger timeInterval;

/**
 确定按钮点击返回时间戳
 */
@property (nonatomic,copy) void (^ChooseTimeConfirmClickBlock)(NSTimeInterval selectTimeInterval);

@end
