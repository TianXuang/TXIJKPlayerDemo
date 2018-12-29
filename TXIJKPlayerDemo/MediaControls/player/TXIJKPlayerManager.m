//
//  TXIJKPlayerManager.m
//  VSFinance
//
//  Created by yunzhang on 2018/12/19.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import "TXIJKPlayerManager.h"
@interface TXIJKPlayerManager()<TXIJKPlayerDelegate,MediaBaseControlDelegate>
//播放层
@property (nonatomic,strong)UIView * playView;
//控制层
@property (nonatomic,strong)MediaBaseControl * mediaControl;
@end
static TXIJKPlayerManager * txManager;
@implementation TXIJKPlayerManager
+(TXIJKPlayerManager *)defaultManager;{
    static dispatch_once_t onceToken;
    // 一次函数
    dispatch_once(&onceToken, ^{
        if (txManager == nil) {
            txManager = [[super alloc]init];
        }
    });
    return txManager;
}
-(UIView *)playWithModel:(TXIJKPlayModel *)model{
    
    if (self.playView) {
        [[TXIJKPlayer player]txIJKPlayeDelloc];
    }
    if (model.playtype==TXIJKPlayTypeVideoPlay||model.playtype == TXIJKPlayTypeLivePlay) {
        //视频播放/或者直播
     self.playView = [[TXIJKPlayer player] txIJKPlayerPlayWithUrl:[NSURL URLWithString:model.playUrl] withPlayType:model.playtype];
        self.playView.backgroundColor = [UIColor blackColor];
        [TXIJKPlayer player].delegate = self;
    }
    //播放的控制层区分
    if (model.viewType == TXIJKPlayViewType_List) {
        self.mediaControl = [MediaBaseControl new];
//        [(MediaBaseControl *)self.mediaControl updateTitleView:model.title withNumbers:model.playNums];
    }
    self.mediaControl.delegate = self;
    [self.playView addSubview:self.mediaControl];
    [self.mediaControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playView);
    }];
    
    [model.playGroundView addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(model.playGroundView);
    }];
    return self.playView;
}
#pragma mark-播放代理
//开始播放
-(void)TXIJKPlayerWillStartPlay{
    NSLog(@"开始播放");
}
//播放卡顿
-(void)TXIJKPlayerWillShowKartun{
    [self.mediaControl showHudLoadingAtView];
}
//播放顺畅
-(void)TXIJKPlayerWillShowFluency{
    [self.mediaControl hiddenHudLoadingAtView];
}
//播放完成
-(void)TXIJKPlayerWillPlayFinish{
    
}
//播放错误
-(void)TXIJKPlayerWillPlayFailwithPlayType:(TXIJKPlayType)type{
    
}
//更新控制层状态(定时器)
-(void)TXIJKPlayerWillGetStartTime:(NSTimeInterval)startTime endDuration:(NSTimeInterval)duration{
    self.mediaControl.currentTime = startTime;
    self.mediaControl.duration = duration;
    [self.mediaControl refreshMediaControl];
}
/**网络变化的通知*/
-(void)TXIJKNetWorkStartChangeWithStart:(NetworkStatus)startStatus andEndStatus:(NetworkStatus)endStatus{
    if (startStatus == ReachableViaWiFi&&endStatus == ReachableViaWWAN) {
        NSLog(@"wifi 转 4G");
    }else if(startStatus == ReachableViaWWAN && endStatus == ReachableViaWiFi){
        NSLog(@"4g 转 wifi");
    }else{
        NSLog(@"无网络");
    }
}
#pragma mark-控制层代理方法
//通知外界更改播放进度
-(void)mediaControlShouldSeeking:(CGFloat)progress{
    
}
//通知外界修改音量
-(void)mediaControlShouldVolum:(CGFloat)progress{
    
}
//分享按钮点击事件
-(void)mediaControlShareBtnClick:(UIButton *)btn{
    
}
//点击返回按钮
-(void)mediaControlShouldBackClick:(UIButton *)btn{
    
}
//全屏按钮点击事件
-(void)mediaControlFullScreenClick:(UIButton *)btn{
    [[TXIJKPlayer player] interfaceOrientation:UIInterfaceOrientationLandscapeRight];
}
//播放按钮
-(void)mediaControlShouldPlayOrPause:(UIButton *)btn{
    if (btn.selected == YES) {
        [[TXIJKPlayer player] txijkPause];
    }else{
        [[TXIJKPlayer player] txijkPlay];
    }
}
//上一首
-(void)mediaControlShouldPlayFront:(UIButton *)btn{}
//下一首
-(void)mediaControlshouldPlayNext:(UIButton *)btn{}
//继续播放(流量提示为4g)
-(void)mediaControlShouldPlayWith4G:(UIButton *)btn{
    
}
//需外界重新播放
-(void)mediaControlShouldReplay:(UIButton *)btn{
    
}
@end
