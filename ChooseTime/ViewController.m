//
//  ViewController.m
//  shijian
//
//  Created by IOS_MAC PRO on 2017/4/6.
//  Copyright © 2017年 com.ASS. All rights reserved.
//

#import "ViewController.h"
#import "ChooseTimeViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *text1;
@property (weak, nonatomic) IBOutlet UITextField *text2;
@property (weak, nonatomic) IBOutlet UITextField *text3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.text1.placeholder = @"请输入x:xx格式";
    self.text2.placeholder = @"请输入x:xx格式";

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn:(id)sender {
    
    if (self.text2.text.length >0 ||self.text1.text.length > 0) {
        ChooseTimeViewController * choosetime = [[ChooseTimeViewController alloc]init];
        choosetime.ChooseTimeConfirmClickBlock = ^(NSTimeInterval selectTimeInterval) {
            
            NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *comps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:[NSDate dateWithTimeIntervalSince1970:selectTimeInterval]];
            NSArray * weakArray = @[@"周六",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
            
            self.text3.text = [NSString stringWithFormat:@"%ld月%ld日 %@ %ld:%ld",comps.month,comps.day,weakArray[comps.weekday],comps.hour,comps.minute];
        };
        choosetime.startTime = self.text1.text;
        choosetime.endTime = self.text2.text;
//        choosetime.timeInterval = 10;
        [self.navigationController pushViewController:choosetime animated:YES];
    }
}


@end
