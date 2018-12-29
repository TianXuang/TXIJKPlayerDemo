//
//  TXIJKPlayer.h
//  VSFinance
//
//  Created by yunzhang on 2018/12/19.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "TXIJKPlayEnum.h"
#import "AppDelegate.h"
/**
 ijk播放器封装类
 只处理功能，不涉及页面层
 */
//ijk播放器代理方法
@protocol TXIJKPlayerDelegate <NSObject>
//开始播放
-(void)TXIJKPlayerWillStartPlay;
//播放卡顿
-(void)TXIJKPlayerWillShowKartun;
//播放顺畅
-(void)TXIJKPlayerWillShowFluency;
//播放完成
-(void)TXIJKPlayerWillPlayFinish;
//播放错误
-(void)TXIJKPlayerWillPlayFailwithPlayType:(TXIJKPlayType)type;
//更新控制层状态(定时器) 播放时间和总时间
-(void)TXIJKPlayerWillGetStartTime:(NSTimeInterval)startTime endDuration:(NSTimeInterval)duration;
/**网络变化的通知*/
-(void)TXIJKNetWorkStartChangeWithStart:(NetworkStatus)startStatus andEndStatus:(NetworkStatus)endStatus;
@end
@interface TXIJKPlayer : NSObject
//初始化
+(TXIJKPlayer*)player;
/************************属性表******************************/
/*是否正在播放*/
@property (nonatomic,assign)BOOL isPlayering;
//代理
@property (nonatomic,strong)id<TXIJKPlayerDelegate>delegate;
/**是否全屏*/
@property (nonatomic,assign)BOOL isFullScreen;
/**
 返回参数 遵守IJKMediaPlayback协议的控制器的view
 参数：NSURL 播放的url
 参数：播放类型 播放或者直播
 */
-(id)txIJKPlayerPlayWithUrl:(NSURL *)url withPlayType:(TXIJKPlayType)type;
//设置屏幕旋转方向 (不支持自动旋转)
-(void)interfaceOrientation:(UIInterfaceOrientation)orientation;
//释放通知 销毁等操作
-(void)txIJKPlayeDelloc;
//播放
-(void)txijkPlay;
//暂停
-(void)txijkPause;
//设置进度
-(void)settingPlayBackTime:(NSTimeInterval)time;
//重新播放
-(void)txijkReplay;
@end
