//
//  TXIJKPlayEnum.h
//  VSFinance
//
//  Created by yunzhang on 2018/12/19.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#ifndef TXIJKPlayEnum_h
#define TXIJKPlayEnum_h
#import "Reachability.h"
#import <ReactiveObjC.h>
#define LeastDistance 15
/**
 支持的播放类型
 */
typedef NS_ENUM(NSUInteger, TXIJKPlayType) {
    TXIJKPlayTypeVideoPlay=0,//视频播放
    TXIJKPlayTypeLivePlay=1,//直播播放
};

/**
 展示的播放的方式
 */
typedef NS_ENUM(NSUInteger, TXIJKPlayViewType) {
    TXIJKPlayViewType_List=0,//列表播放
    TXIJKPlayViewType_Detail=1,//详情播放
};

//手势操作的类型
//typedef NS_ENUM(NSUInteger,WMControlType) {
//    progressControl,//视频进度调节操作
//    voiceControl,//声音调节操作
//    lightControl,//屏幕亮度调节操作
//    noneControl//无任何操作
//} ;
/**设置屏幕旋转方向的通知*/
static NSString * const TXIJKSETSCREENORIGNCHANGE = @"TXIJKSETSCREENORIGNCHANGE";

typedef NS_ENUM(NSInteger,liveFailType){
    liveFailType_0,//未直播
    liveFailType_1,//直播开始
    liveFailType_2,//回看内容生成中
    liveFailType_VideoDetail,//视频详情播放错误
    liveFailType_LiveFail,//直播加载失败
    liveFailType_LiveFinish//直播已结束
};

//手势操作的类型
typedef NS_ENUM(NSUInteger,WMControlType) {
    progressControl,//视频进度调节操作
    voiceControl,//声音调节操作
    lightControl,//屏幕亮度调节操作
    noneControl//无任何操作
} ;
#endif /* TXIJKPlayEnum_h */
