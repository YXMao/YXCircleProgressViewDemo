//
//  QHTCircleProgressView.m
//  CheckFormalin
//
//  Created by df on 15-7-3.
//  Copyright (c) 2015年 com.dsecet.qinghetao. All rights reserved.
//

#import "YXCircleProgressView.h"
#import <AVFoundation/AVFoundation.h>

@interface YXCircleProgressView()
/**
 *  上一次的值
 */
@property (nonatomic, assign) float previousValue;

/**
 *  上一次的值所占总值的比例
 */
@property (nonatomic, assign) float previousPercent;


/**
 *  显示层
 */
@property(nonatomic,strong)CAShapeLayer * showLayer;


/**
 *  指针
 */
@property(nonatomic,strong)UIImageView * pointView;

@end


@implementation YXCircleProgressView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2) radius:CGRectGetWidth(self.frame) / 2 - 5 startAngle: 3 * M_PI_4 endAngle:M_PI_4 clockwise:YES];
        
        self.pointView = [[UIImageView alloc]init];
        self.pointView.bounds = CGRectMake(0, 0, 10, 50);
        self.pointView.contentMode = UIViewContentModeScaleAspectFit;
        self.pointView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
        self.pointView.image = [UIImage imageNamed:@"panel_point"];
        [self.pointView setTransform:CGAffineTransformMakeRotation(5.0 * M_PI_4)];
        [self.pointView.layer setAnchorPoint:CGPointMake(0.5, 1)];
        [self.pointView.layer setPosition:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2)];
        [self addSubview:self.pointView];
        
        
        //高亮为绿色
        self.showLayer = [CAShapeLayer layer];
        self.showLayer.path = path.CGPath;
        self.showLayer.fillColor = [UIColor clearColor].CGColor;
        self.showLayer.strokeStart = 0;
        self.showLayer.strokeEnd = 1.0;
        [self.layer addSublayer:self.showLayer];
        
    }
    return self;
}


- (void)setValue:(float)value
{
    _value = value;
    if (self.lineWidth == 0) {
        self.lineWidth = 10;
    }
    
    //设置线条宽度
    self.showLayer.lineWidth = self.lineWidth;

    
    if (value <= self.circleNormalValue) {
        //在正常值
        self.showLayer.strokeColor = self.circleNormalColor.CGColor;
    }
    else if (value <= self.circleAlertValue){
        //警告值
        self.showLayer.strokeColor = self.circleAlertColor.CGColor;
    }
    else{
        //超出正常值
        self.showLayer.strokeColor = self.circleOverflowColor.CGColor;
    }
    
    //根据值，创建并执行动画
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if (value <= self.maxValue && self.previousPercent < 1) {
        //未超出最大值，且上一次的的值小于等于最大值
        animation.fromValue = @(self.previousPercent);
        animation.toValue = @([self convertValue:value]);
    }
    else if (value < self.maxValue && self.previousPercent >= 1){
        //未超出最大值，且上一次的的值大于等于最大值，即从最大值开始执行动画
        animation.fromValue = @(1);
        animation.toValue = @([self convertValue:value]);
    }
    else{
        //超出最大值，仅移动到最大值
        animation.fromValue = @(self.previousPercent);
        animation.toValue = @(1);
    }
    
    animation.duration = self.speedInterval;
    animation.fillMode = kCAFillModeForwards;
    [animation setRemovedOnCompletion:NO];
    [self.showLayer addAnimation:animation forKey:nil];
    
    
    //算出指针需要旋转的值
    float result = [self convertValueToAngle:value];
    [self rotateViewAnimated:self.pointView withDuration:self.speedInterval byAngle:result];
    
    
    self.previousValue = self.value;
    self.previousPercent = self.value / self.maxValue;
}


/**
 *  旋转对应的角度
 *
 *  @param view     需要旋转的视图
 *  @param duration 旋转的时间
 *  @param angle    旋转的角度
 */
- (void) rotateViewAnimated:(UIView*)view
               withDuration:(CFTimeInterval)duration
                    byAngle:(CGFloat)angle
{
    [CATransaction begin];
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:angle];
    rotationAnimation.duration = duration;
    
    [CATransaction setCompletionBlock:^{
        view.transform = CGAffineTransformRotate(view.transform, angle);
    }];
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];
}

/**
 *  把值转换为标准值（0-1）
 *
 *  @param value 需要转换的值
 *
 *  @return 转换之后的标准值
 */
- (float)convertValue:(float)value
{
    return value / self.maxValue;
}


/**
 *  前后两次差值需要旋转的角度
 *
 *  @param value 当前的值
 *
 *  @return 旋转角度
 */
- (double)convertValueToAngle:(float)value
{
    //算出当前差值所占总比例，及旋转的角度
    float percentage;
    
    //当前值所占总值的比例
    float valuePercent = value / self.maxValue;
    
    if (self.previousPercent > valuePercent) {
        //上一次的比例大于此次的比例
        if (self.previousPercent >= 1 && valuePercent <= 1) {
            //1.上一次的值大于最大值且此次的值小于最大值，则逆时针旋转 （一大一小）
            percentage =  -ABS(1 - valuePercent);
        }
        else if(self.previousPercent<= 1 && valuePercent <= 1){
            //两小
            percentage =  -ABS(self.previousPercent - valuePercent);
        }
        else{
            //两大
            return 0;
        }
    }
    else if (self.previousPercent < valuePercent){
        //上一次的比例小于此次的比例
        if (valuePercent >= 1 && self.previousPercent <= 1) {
            //1.且上次的值小于最大值，则顺时针旋转 （一小一大）
            percentage =  ABS(1 - self.previousPercent);
        }
        else if((valuePercent <= 1 && self.previousPercent <= 1)){
            //两小
            percentage =  ABS(valuePercent - self.previousPercent);
        }
        else{
            return 0;
        }
    }
    else{
        //两者相等
        return 0;
    }
    return percentage * (M_PI * 2 - M_PI_2);
}


@end
