//
//  MediaBaseControl.h
//  TZInvestment
//
//  Created by yunzhang on 2018/10/15.
//  Copyright © 2018年 TianXuan. All rights reserved.
//本类是播放器展示层父类
//已实现快进快退，调节亮度，调节音量功能
//调用refreshMediaControl 设置定时器来更新时间和进度
//

#import <UIKit/UIKit.h>
#import "FastForwardView.h"
#import "WMLightView.h"
#import "VsPlayerSlider.h"
#import "MediaProgressHud.h"
#import "TXIJKPlayEnum.h"
#import <ReactiveObjC.h>
#import "Commond.h"
/**
 目的 使其具备最基本的能力
 1 滑动快进，后退
 2 左侧调节亮度
 3 右侧调节音量
 */
//控制层代理
@protocol MediaBaseControlDelegate <NSObject>
@optional
//通知外界更改播放进度
-(void)mediaControlShouldSeeking:(CGFloat)progress;
//通知外界修改音量
-(void)mediaControlShouldVolum:(CGFloat)progress;
//分享按钮点击事件
-(void)mediaControlShareBtnClick:(UIButton *)btn;
//点击返回按钮
-(void)mediaControlShouldBackClick:(UIButton *)btn;
//全屏按钮点击事件
-(void)mediaControlFullScreenClick:(UIButton *)btn;
//播放按钮
-(void)mediaControlShouldPlayOrPause:(UIButton *)btn;
//上一首
-(void)mediaControlShouldPlayFront:(UIButton *)btn;
//下一首
-(void)mediaControlshouldPlayNext:(UIButton *)btn;
//继续播放(流量提示为4g)
-(void)mediaControlShouldPlayWith4G:(UIButton *)btn;
//需外界重新播放
-(void)mediaControlShouldReplay:(UIButton *)btn;
@required
@end
@interface MediaBaseControl : UIView
//设置代理
@property (nonatomic,weak)id<MediaBaseControlDelegate>delegate;
//当前播放时间
@property (nonatomic,assign)NSTimeInterval currentTime;
//总时间
@property (nonatomic,assign)NSTimeInterval duration;
//滑动状态监听
@property (nonatomic,assign)BOOL isMediaSliderBeingDragged;
/********************************view层************************************/
////调节快进的
@property (nonatomic,strong)FastForwardView * FF_View;
//调节亮度的
@property (nonatomic,strong)WMLightView * lightView;
//进度条
@property (nonatomic,strong)VsPlayerSlider * mediaProgressSlider;
//缓冲进度条
@property (nonatomic,strong) UIProgressView * bufferProgress;
//播放按钮
@property (nonatomic,strong)UIButton * playBtn;
//开始时间控件
@property (nonatomic,strong)UILabel * startTimeLabel;
//总时间控件
@property (nonatomic,strong)UILabel * allTimeLabel;
//头部底部视图
@property (nonatomic,strong)UIView * topPanel;
@property (nonatomic,strong)UIImageView * topShadowView;
//尾部底部视图
@property (nonatomic,strong)UIView * bottomPannel;
//流量提示视图
@property (nonatomic,strong)UIView * flowView;
//直播失败的视图/获取视频播放错误
@property (nonatomic,strong)UIView * playFailView;
//loading加载视图
@property (nonatomic,strong)UIView * loadingView;
//底部阴影视图，同self大小（根据页面要求来取决于用 topPannel bottomPannel 还是用controlBtn）控制显示还是隐藏
@property (nonatomic,strong)UIButton * controlBtn;
//调用后选择是否自动隐藏
-(void)showControlViewAfterHidden:(BOOL)hidden;
//更新播放进度progress
-(void)updateProgress:(CGFloat)progress;
//控制层展示(展示后不自动隐藏)
-(void)showControlView;
//展示流量提示
-(void)showFlowToastView;
//隐藏流量提示
-(void)hiddenFlowToastView;
//直播失败的视图调用/或者视频播放错误
-(void)liveFailViewWithType:(liveFailType)type;
-(void)liveFailViewRemove;
//展示加载视图
-(MediaProgressHud *)showHudLoadingAtView;
-(void)hiddenHudLoadingAtView;
/****************************************子类选择重写一下方法***************************************/
//控制层隐藏
-(void)hideControlView;
//重写刷新方法，外部调用，或者自己选择时间调用
- (void)refreshMediaControl;
//重写屏幕旋转监听方法
-(void)mediaBaseControlObserDeviceChange:(UIDeviceOrientation)orign;
//更新标题
-(void)updateTitleView:(NSString *)title;
//释放控制层
-(void)dealloc_MediaControl;
//子类必须实现该方法创建UI 并最后调用super.txijkCreatUI;
-(void)txijkCreatUI;
//重写顶部视图加载样式
-(void)txijkCreatTopPanel;
@end
