//
//  MediaProgressHud.h
//  TZInvestment
//
//  Created by yunzhang on 2018/10/17.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaProgressHud : UIView

+(MediaProgressHud*)showHudInView:(UIView *)view;
-(void)dissmiss;
@end
