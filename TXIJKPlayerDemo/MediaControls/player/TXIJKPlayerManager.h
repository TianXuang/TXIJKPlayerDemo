//
//  TXIJKPlayerManager.h
//  VSFinance
//
//  Created by yunzhang on 2018/12/19.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXIJKPlayEnum.h"
#import "TXIJKPlayModel.h"
#import "TXIJKPlayer.h"
#import "MediaBaseControl.h"
@interface TXIJKPlayerManager : NSObject
+(TXIJKPlayerManager *)defaultManager;
//开始播放
-(UIView *)playWithModel:(TXIJKPlayModel *)model;
@end
