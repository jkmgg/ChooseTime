//
//  LBChooseTimeViewController.m
//  shijian
//
//  Created by IOS_MAC PRO on 2017/4/6.
//  Copyright © 2017年 com.ASS. All rights reserved.
//

#import "LBChooseTimeViewController.h"
#import "LBChooseTimeCollectionViewCell.h"

@interface LBChooseTimeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)BOOL ShowTomorrow;
@property(nonatomic,nonnull,strong)NSArray * weakArray;

@end

@implementation LBChooseTimeViewController

- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)weakArray{
    
    if (_weakArray == nil) {
        _weakArray = @[@"周六",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    }
    return _weakArray;
}
- (UIView *)lineView{
    
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor redColor];
    }
    return _lineView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self dateDataProcessing:[NSDate date]];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    
    CGFloat btnW = self.view.frame.size.width*0.2;
    for (int i = 0; i < 5; i++) {
        
        NSDate * date ;
        if (self.ShowTomorrow) {
            date = [NSDate dateWithTimeInterval:24*60*60*(i+1) sinceDate:[NSDate date]];
        }else{
            date = [NSDate dateWithTimeInterval:24*60*60*i sinceDate:[NSDate date]];
        }
        NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps1 = [calendar components:NSCalendarUnitWeekday fromDate:date];
        
        UIButton * timetitlebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [timetitlebtn setTitle:[NSString stringWithFormat:@"%@\n%@",self.weakArray[comps1.weekday%7],[self Detailedstringwithdate:date type:@"MM月dd"]] forState:UIControlStateNormal];
        timetitlebtn.titleLabel.numberOfLines = 0;
        timetitlebtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [timetitlebtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [timetitlebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        timetitlebtn.frame = CGRectMake(i*btnW, 0, btnW, topView.frame.size.height - 1);
        [topView addSubview:timetitlebtn];
        timetitlebtn.titleLabel.font = [UIFont systemFontOfSize:14];
        timetitlebtn.tag = i;
        [timetitlebtn addTarget:self action:@selector(topbtnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.lineView.frame = CGRectMake(0, topView.frame.size.height - 1, btnW, 1);
    [topView addSubview:self.lineView];

    [self.view addSubview:topView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.frame.size.width, 10)];
    [flowLayout setItemSize:CGSizeMake(self.view.frame.size.width*0.2, 40)];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, self.view.frame.size.height - 114 - 50) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor lightGrayColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:@"LBChooseTimeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ChooseTimeCell"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)dateDataProcessing:(NSDate *)date{
    
    [self.dataArray removeAllObjects];

    NSString* currenstart = @"6:09";
    NSString* currenstend = @"23:59";
    
    NSString * currendataY = [self Detailedstringwithdate:date type:@"yyyy"];
    NSString * currendataM = [self Detailedstringwithdate:date type:@"MM"];
    NSString * currendataD = [self Detailedstringwithdate:date type:@"dd"];

    NSString* currenstarstr = [NSString stringWithFormat:@"%@-%@-%@ %@",currendataY,currendataM,currendataD,currenstart];
    NSString* currenstendstr = [NSString stringWithFormat:@"%@-%@-%@ %@",currendataY,currendataM,currendataD,currenstend];

    NSTimeInterval startTimeInterval = [self dateofdatestr:currenstarstr];
    NSTimeInterval endTimeInterval = [self dateofdatestr:currenstendstr];

    NSString * dataste = [self Detailedstringwithdate:[NSDate date] type:@"HH:mm"];
    int nowF = [[[dataste componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    int nowH = [[[dataste componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
    
    NSTimeInterval currenTimeInterval = [[NSDate date] timeIntervalSince1970];
    if ( currenTimeInterval < startTimeInterval ) {
        //不处理默认时间
        currenTimeInterval = startTimeInterval;
        if (startTimeInterval - currenTimeInterval == 1800) {
            currenTimeInterval = currenTimeInterval == 1800;
        }
        
    }else if (currenTimeInterval> endTimeInterval - 1800){
        //显示明天时间
        currenTimeInterval = startTimeInterval;
        self.ShowTomorrow = YES;

    }else{
        
        NSString * timestr;
        
        if (nowF>30) {
            timestr = [NSString stringWithFormat:@"%@-%@-%@ %d:30",currendataY,currendataM,currendataD,nowH+1];
            currenTimeInterval = [self dateofdatestr:timestr];
            
        }else{
            timestr = [NSString stringWithFormat:@"%@-%@-%@ %d:00",currendataY,currendataM,currendataD,nowH+1];
            currenTimeInterval = [self dateofdatestr:timestr];
        }
    }
    for (NSTimeInterval i = currenTimeInterval; i<endTimeInterval ; i+=1800) {
        
        NSLog(@"--------%ld------%@",(long)time,[self Detailedstringwithdate:[NSDate dateWithTimeIntervalSince1970:i] type:@"MM-dd HH:mm"]);
        [self.dataArray addObject:@(i)];
    }
 
    [self.collectionView reloadData];
}

- (NSTimeInterval)dateofdatestr:(NSString *)datestr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate * date = [formatter dateFromString:datestr];
    return [date timeIntervalSince1970];
}

- (NSString *)Detailedstringwithdate:(NSDate *)date type:(NSString *)type{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:type];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString * datestr = [formatter stringFromDate:date];
    return datestr;
}

- (void)topbtnclick:(UIButton *)btn{
    
    NSTimeInterval timeInterval = 24*60*60*btn.tag;
    [self dateDataProcessing:[NSDate dateWithTimeInterval:timeInterval sinceDate:[NSDate date]]];

    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.lineView.frame;
        rect.origin.x = btn.frame.origin.x;
        self.lineView.frame = rect;
    }completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 animations:^{
//            CGRect rect = self.lineView.frame;
//            rect.size.width = self.view.frame.size.width/5;
//            self.lineView.frame = rect;
//            
//        }];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LBChooseTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChooseTimeCell" forIndexPath:indexPath];
    NSInteger time = [self.dataArray[indexPath.row] integerValue];
    cell.titleLabel.text = [self Detailedstringwithdate:[NSDate dateWithTimeIntervalSince1970:time] type:@"HH:mm"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger time = [self.dataArray[indexPath.row] integerValue];
    NSLog(@"%@",[self Detailedstringwithdate:[NSDate dateWithTimeIntervalSince1970:time] type:@"yyyy-MM-dd HH:mm"]);
}
@end
