//
//  MediaProgressHud.m
//  TZInvestment
//
//  Created by yunzhang on 2018/10/17.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import "MediaProgressHud.h"
@interface MediaProgressHud()
@property (nonatomic,strong)UIImageView * imageV;
@end
@implementation MediaProgressHud
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI{
    self.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"videoLoading"];
    [self addSubview:imageV];
    self.imageV = imageV;
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 1;
    animation.autoreverses = NO;
    animation.fillMode =kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.imageV.layer addAnimation:animation forKey:@"lay"];
}
-(void)dissmiss{
    [self.imageV.layer removeAllAnimations];
    [self removeFromSuperview];
}
+(MediaProgressHud*)showHudInView:(UIView *)view{
    MediaProgressHud * hud = [[MediaProgressHud alloc]init];
    [view addSubview:hud];
    [hud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return hud;
}
@end
