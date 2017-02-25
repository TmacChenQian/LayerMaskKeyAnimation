//
//  ViewController.m
//  maskLayerDemo
//
//  Created by 陈乾 on 2017/2/25.
//  Copyright © 2017年 Cha1ien. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>

@property (strong, nonatomic) IBOutlet UIView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor colorWithRed:98.0/255.0 green:247.0/255.0 blue:210.0/255.0 alpha:1];
    
    //中间遮盖层
    UIView *backGroundView = [[UIView alloc] initWithFrame:self.navigationController.view.layer.frame];
    backGroundView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.view addSubview:backGroundView];
    [self.navigationController.view bringSubviewToFront:backGroundView];
    
    //将图片放到mask里面 同时把mask添加到layer的mask属性
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
    mask.position = self.view.center;
    mask.bounds = CGRectMake(0, 0, 60,60);
    self.navigationController.view.layer.mask = mask;

    //创建关键帧动画
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    keyFrameAnimation.delegate = self;
    keyFrameAnimation.duration = 1.0f;
    keyFrameAnimation.removedOnCompletion = false;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    CAMediaTimingFunction *func = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    keyFrameAnimation.timingFunctions = @[func,func,func];
    keyFrameAnimation.beginTime = CACurrentMediaTime() + 1;
    
    CGRect fristBounds = self.navigationController.view.layer.mask.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 90, 90);
    CGRect threeBounds = CGRectMake(0, 0, 2000, 2000);

    NSValue *fristValue = [NSValue valueWithCGRect:fristBounds];
    NSValue *secondValue = [NSValue valueWithCGRect:secondBounds];
    NSValue *threeValue = [NSValue valueWithCGRect:threeBounds];
    
    keyFrameAnimation.values = @[fristValue,secondValue,threeValue];
    keyFrameAnimation.keyTimes = @[@0,@0.5,@1];
    
    //添加关键帧动画
    [self.navigationController.view.layer.mask addAnimation:keyFrameAnimation forKey:@"keyFrameAnimation"];
    
    //移除背景view
    [UIView animateWithDuration:0.25 delay:1.3 options:UIViewAnimationOptionTransitionNone animations:^{
        backGroundView.alpha = 0;
    } completion:^(BOOL finsihed){
        [backGroundView removeFromSuperview];
    }];
    
    //给navigationController.view加个简单动画
    [UIView animateKeyframesWithDuration:0.25 delay:1.3 options:0 animations:^{
        self.navigationController.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.navigationController.view.transform = CGAffineTransformIdentity;
        } completion:nil];

    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
