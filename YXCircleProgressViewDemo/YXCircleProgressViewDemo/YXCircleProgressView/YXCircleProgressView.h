//
//  QHTCircleProgressView.h
//  CheckFormalin
//
//  Created by df on 15-7-3.
//  Copyright (c) 2015年 com.dsecet.qinghetao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXCircleProgressView : UIView


/**
 *  环形进度条背景色
 */
@property(nonatomic,strong)UIColor * circleBgColor;

/**
 *  正常值的颜色
 */
@property(nonatomic,strong)UIColor * circleNormalColor;

/**
 *  警告值的颜色
 */
@property(nonatomic,strong)UIColor * circleAlertColor;

/**
 *  超出正常值的颜色
 */
@property(nonatomic,strong)UIColor * circleOverflowColor;

/**
 *  正常值
 */
@property(nonatomic,assign)float circleNormalValue;

/**
 *  警告值
 */
@property(nonatomic,assign)float circleAlertValue;

/**
 *  超出正常值
 */
@property(nonatomic,assign)float circleOverflowValue;

/**
 *  线条宽度
 */
@property(nonatomic,assign)float lineWidth;

/**
 *  速度时间
 */
@property(nonatomic,assign)float speedInterval;

/**
 *  最大值
 */
@property(nonatomic,assign)float  maxValue;

/**
 *  最小值
 */
@property(nonatomic,assign)float  minValue;

/**
 *  值
 */
@property(nonatomic,assign)float  value;

/**
 *  进度条中间的名字
 */
@property(nonatomic,strong)UILabel * midNameLabel;




@end
