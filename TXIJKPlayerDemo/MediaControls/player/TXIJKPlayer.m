//
//  TXIJKPlayer.m
//  VSFinance
//
//  Created by yunzhang on 2018/12/19.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import "TXIJKPlayer.h"
@interface TXIJKPlayer()
//播放控制器
@property (nonatomic,strong)id <IJKMediaPlayback>TXIJKPlayerVC;
//当前播放类型
@property (nonatomic,assign)TXIJKPlayType type;
//网络监听
@property (nonatomic,strong)Reachability *reachability;
//记录之前的网络状态
@property (nonatomic,assign)NetworkStatus netStatus;
//当前播放url
@property (nonatomic,strong)NSURL * playUrl;
//定时器
@property (nonatomic,strong)dispatch_source_t timer;
//播放层的父视图
@property (nonatomic,strong)UIView * supView;
@end
static TXIJKPlayer * player;
@implementation TXIJKPlayer
+(TXIJKPlayer*)player{
    static dispatch_once_t onceToken;
    // 一次函数
    dispatch_once(&onceToken, ^{
        if (player == nil) {
            player = [[super alloc]init];
            //初始化播放监听
            [player initObserver];
            [player startMontiorNetWork];
        }
    });
    return player;
}
#pragma mark-监听网络
-(void)startMontiorNetWork{
    if (self.reachability) {
        return;
    }
    // 设置网络检测的站点
    NSString *remoteHostName = @"www.apple.com";
    self.reachability = [Reachability reachabilityWithHostName:remoteHostName];
    // 设置网络状态变化时的通知函数
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kReachabilityChangedNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        Reachability* curReach = [x object];
        if (curReach == self.reachability) {
            NetworkStatus netStatus = [curReach currentReachabilityStatus];
            if ([self.delegate respondsToSelector:@selector(TXIJKNetWorkStartChangeWithStart:andEndStatus:)]) {
                [self.delegate TXIJKNetWorkStartChangeWithStart:self.netStatus andEndStatus:netStatus];
            }
            self.netStatus = netStatus;
        }
    }];
    [self.reachability startNotifier];
    /***
     代理中判断中
     if (startStatus == ReachableViaWiFi&&endStatus == ReachableViaWWAN) {
     NSLog(@"wifi 转 4G");
     }else if(startStatus == ReachableViaWWAN && endStatus == ReachableViaWiFi){
     NSLog(@"4g 转 wifi");
     }else{
     NSLog(@"无网络");
     }
     */
}
/**监听通知*/
-(void)initObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
}
#pragma mark-移除监听通知（因为是单例，所以）
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:nil];
    
}
/***************************************处理通知方法****************************************************/
#pragma mark-加载状态改变（拖拽和开始加载都会走这个方法，必须不能设置自动播放）
-(void)loadStateDidChange:(NSNotification *)fication{
    IJKAVMoviePlayerController * play =fication.object;
    IJKMPMovieLoadState loadState = [play loadState];
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) // 加载通过状态
    {
        if ([self.delegate respondsToSelector:@selector(TXIJKPlayerWillShowFluency)]&&self.TXIJKPlayerVC.isPlaying) {
            [self.delegate TXIJKPlayerWillShowFluency];
        }
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) // 停滞状态（缓冲）
    {
        if ([self.delegate respondsToSelector:@selector(TXIJKPlayerWillShowKartun)]) {
            [self.delegate TXIJKPlayerWillShowKartun];
        }
    }else{//加载未知状态 当卡顿处理
        if ([self.delegate respondsToSelector:@selector(TXIJKPlayerWillShowKartun)]) {
            [self.delegate TXIJKPlayerWillShowKartun];
        }
    }
    return;
}
#pragma mark- 当视频播放结束或用户退出播放时
-(void)moviePlayBackFinish:(NSNotification *)fication{
    
    int reason =[[[fication userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    NSInteger index = 0;
    NSString * alertMessage = @"";
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: 播放完毕: %d\n", reason);
            if ([self.delegate respondsToSelector:@selector(TXIJKPlayerWillPlayFinish)]) {
                [self.delegate TXIJKPlayerWillPlayFinish];
            }
            break;
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: 用户退出播放: %d\n", reason);
            break;
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: 播放出现错误: %d\n", reason);
            if ([self.delegate respondsToSelector:@selector(TXIJKPlayerWillPlayFailwithPlayType:)]) {
                [self.delegate TXIJKPlayerWillPlayFailwithPlayType:self.type];
            }
            break;
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}
#pragma mark-准备播放状态改变的通知（视频准备开始播放的时候，上传播放记录）
-(void)mediaIsPreparedToPlayDidChange:(NSNotification *)fication{
    [self txijkPlay];
    if ([self.delegate respondsToSelector:@selector(TXIJKPlayerWillStartPlay)]) {
        [self.delegate TXIJKPlayerWillStartPlay];
    }
}
#pragma  mark- 播放状态改变的通知（暂停，播放，快进，后退等）
-(void)moviePlayBackStateDidChange:(NSNotification *)fication{
    NSLog(@"当回放状态发生变化时，可以通过编程方式或由用户发布");
    switch (self.TXIJKPlayerVC.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange stoped");
            break;
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange : playing");
            break;
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange : paused");
            //每次播放视频都会调用，不知道啥情况
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange : interrupted");
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange : seeking");
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange : unknown");
            break;
        }
    }
}
/**
 开始播放
 */
-(id)txIJKPlayerPlayWithUrl:(NSURL *)url withPlayType:(TXIJKPlayType)type{
    @weakify(self);
    self.type = type;
    self.playUrl = url;
    if (type==TXIJKPlayTypeVideoPlay) {
        //视频播放
        self.TXIJKPlayerVC = [[IJKAVMoviePlayerController alloc] initWithContentURL:url];
        [self.TXIJKPlayerVC setPauseInBackground:YES];
    }else{
        //直播播放
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
        [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
        //静音设置
        //    [options setPlayerOptionValue:@"1" forKey:@"an"];
        //硬解码
        [options setOptionIntValue:1 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
        [options setOptionIntValue:60 forKey:@"max-fps" ofCategory:kIJKFFOptionCategoryPlayer];
        // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
        [options setPlayerOptionIntValue:29.97 forKey:@"r"];
        // 设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推）
        [options setPlayerOptionIntValue:768 forKey:@"vol"];
        // 跳帧开关
        //    [options setPlayerOptionIntValue:0 forKey:@"framedrop"];
        // 指定最大宽度
        //    [options setPlayerOptionIntValue:960 forKey:@"videotoolbox-max-frame-width"];
        // 自动转屏开关
        //    [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
        // 重连次数
        //    [options setFormatOptionIntValue:3 forKey:@"reconnect"];
        // 超时时间，timeout参数只对http设置有效，若果你用rtmp设置timeout，ijkplayer内部会忽略timeout参数。rtmp的timeout参数含义和http的不一样。
        [options setFormatOptionIntValue:3*1000*1000  forKey:@"timeout"];
        ////    async:
        //如果是rtsp协议，可以优先用tcp(默认是用udp)
        [options setFormatOptionValue:@"tcp" forKey:@"rtsp_transport"];
        //播放前的探测Size，默认是1M, 改小一点会出画面更快
        [options setFormatOptionIntValue:1024 * .1 forKey:@"probesize"];
        //播放前的探测时间
        [options setFormatOptionIntValue:5000 forKey:@"analyzeduration"];
        //软解，更稳定
        //    [options setPlayerOptionIntValue:0 forKey:@"videotoolbox"];
        //解码参数，画面更清晰
        [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];
        //
        [options setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
        
        // Param for living
        [options setPlayerOptionIntValue:2000 forKey:@"max_cached_duration"];   // 最大缓存大小是3秒，可以依据自己的需求修改
        [options setPlayerOptionIntValue:1 forKey:@"infbuf"];  // 无限读
        [options setPlayerOptionIntValue:0 forKey:@"packet-buffering"];  //  关闭播放器缓冲
         self.TXIJKPlayerVC = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] withOptions:options];
    }
    [self.TXIJKPlayerVC setScalingMode:IJKMPMovieScalingModeAspectFit];
    self.TXIJKPlayerVC.shouldAutoplay = NO;
    [self.TXIJKPlayerVC prepareToPlay];
    //监听播放
    [RACObserve(self.TXIJKPlayerVC, isPlaying) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.isPlayering = [x boolValue];
    }];
    //展示加载视图
    if ([self.delegate respondsToSelector:@selector(TXIJKPlayerWillShowFluency)]) {
        [self.delegate TXIJKPlayerWillShowFluency];
    }
    return self.TXIJKPlayerVC.view;
}
#pragma mark-设置定时器
-(void)startOpenTimer{
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        // 创建一个定时器(dispatch_source_t本质还是个OC对象)
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        
        // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
        /**
         何时开始执行第一个任务 (开始计时时间)
         dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
         */
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
        dispatch_source_set_timer(_timer, start, interval, 0);
        // 设置回调
        dispatch_source_set_event_handler(_timer, ^{
            // 是否需要重复计时(默认是重复计时的)
            //        dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(TXIJKPlayerWillGetStartTime:endDuration:)]) {
                    [self.delegate TXIJKPlayerWillGetStartTime:self.TXIJKPlayerVC.currentPlaybackTime endDuration:self.TXIJKPlayerVC.duration];
                }
                
            });
        });
        // 启动定时器 -(可以根据自己的需求,调用此方法)
        dispatch_resume(_timer);
    }
}
#pragma mark-停止定时器
- (void)stopTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil; // OK
    }
}
/*********************************************功能指令******************************************/
//播放
-(void)txijkPlay{
    [self.TXIJKPlayerVC play];
    [self startOpenTimer];
}
//暂停
-(void)txijkPause{
    [self.TXIJKPlayerVC pause];
    [self stopTimer];
}
//设置进度
-(void)settingPlayBackTime:(NSTimeInterval)time{
    self.TXIJKPlayerVC.currentPlaybackTime = time;
}
//重新播放
-(void)txijkReplay{
    [self txIJKPlayerPlayWithUrl:self.playUrl withPlayType:self.type];
}
/**释放通知*/
-(void)txIJKPlayeDelloc{
    [self.TXIJKPlayerVC shutdown];
    self.TXIJKPlayerVC = nil;
    [self stopTimer];
}
/**设置屏幕旋转*/
-(void)interfaceOrientation:(UIInterfaceOrientation)orientation{
    if ([UIApplication sharedApplication].statusBarOrientation ==UIInterfaceOrientationPortrait) {
        //保存之前的父视图，用于推出全屏时使用
        self.supView = self.TXIJKPlayerVC.view.superview;
        //进入全屏
        self.isFullScreen = YES;
        [self setDeveiceOrientation:orientation];
        [self.TXIJKPlayerVC.view removeFromSuperview];
        AppDelegate *wDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [wDelegate.window addSubview:self.TXIJKPlayerVC.view];
        [self.TXIJKPlayerVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(wDelegate.window);
        }];
    }else{
        //退出全屏
        [self.TXIJKPlayerVC.view removeFromSuperview];
        [self.supView addSubview:self.TXIJKPlayerVC.view];
        [self.TXIJKPlayerVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.supView);
        }];
        self.isFullScreen = NO;
        [self setDeveiceOrientation:UIInterfaceOrientationPortrait];
    }
}
-(void)setDeveiceOrientation:(UIInterfaceOrientation)orientation{
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TXIJKSETSCREENORIGNCHANGE object:nil userInfo:@{@"orign":[NSString stringWithFormat:@"%ld",(long)orientation]}];
}
-(void)dealloc{
    NSLog(@"TX得到释放");
}
@end
