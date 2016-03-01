//
//  ViewController.m
//  YXCircleProgressViewDemo
//
//  Created by df on 16/3/1.
//  Copyright © 2016年 com.yuxiang. All rights reserved.
//

#import "ViewController.h"
#import "YXCircleProgressView.h"

@interface ViewController ()
{
    YXCircleProgressView * circleView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    circleView = [[YXCircleProgressView alloc]initWithFrame:CGRectMake(50, 100, 200, 200)];
    
    //最大值
    circleView.maxValue = 1.0;
    //最小值
    circleView.minValue = 0.0;
    
    //正常值
    circleView.circleNormalValue = 0.2;
    circleView.circleNormalColor = [UIColor greenColor];
    
    //警告值
    circleView.circleAlertValue = 0.35;
    circleView.circleAlertColor = [UIColor orangeColor];
    
    //超标值
    circleView.circleOverflowValue = 0.7;
    circleView.circleOverflowColor = [UIColor redColor];
    
    //设置动画时间
    circleView.speedInterval = 1;
    
    circleView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:circleView];
    
    circleView.value = 0.1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    circleView.value = circleView.value + 0.8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
