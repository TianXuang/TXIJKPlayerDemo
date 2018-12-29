//
//  TXIJKPlayModel.h
//  VSFinance
//
//  Created by yunzhang on 2018/12/19.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXIJKPlayEnum.h"
@interface TXIJKPlayModel : NSObject
//播放类型
@property (nonatomic,assign)TXIJKPlayType playtype;
//界面样式
@property (nonatomic,assign)TXIJKPlayViewType viewType;
//标题
@property (nonatomic,strong)NSString * title;
//数量
@property (nonatomic,strong)NSString * playNums;
//播放url
@property (nonatomic,strong)NSString * playUrl;
//展示的背景层
@property (nonatomic,strong)UIView * playGroundView;
@end
