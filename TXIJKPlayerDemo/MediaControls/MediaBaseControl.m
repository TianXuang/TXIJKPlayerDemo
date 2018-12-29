//
//  MediaBaseControl.m
//  TZInvestment
//
//  Created by yunzhang on 2018/10/15.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import "MediaBaseControl.h"
#import "TXIJKPlayEnum.h"
@interface MediaBaseControl()
{
    //用来判断手势是否移动过
    BOOL _hasMoved;
    //记录触摸开始时的视频播放的时间
    float _touchBeginValue;
    //记录触摸开始亮度
    float _touchBeginLightValue;
    //记录触摸开始的音量
    CGFloat _touchBeginVoiceValue;
    
}
///记录touch开始的点
@property (nonatomic,assign)CGPoint touchBeginPoint;
///判断当前手势是在控制进度?声音?亮度?
@property (nonatomic, assign) WMControlType controlType;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;
//禁止点击controlBtn
@property (nonatomic,assign)BOOL isNotTap;
@property (nonatomic,strong)MediaProgressHud * mediaHud;
@end
@implementation MediaBaseControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatFF_View];
        self.lightView = [WMLightView sharedLightView];
        [[UIApplication sharedApplication].keyWindow addSubview:_lightView];
        [self creatControlView];
        [self txijkCreatUI];
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:TXIJKSETSCREENORIGNCHANGE object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            UIDeviceOrientation  orient = [UIDevice currentDevice].orientation;
            [self mediaBaseControlObserDeviceChange:orient];
        }];
    }
    return self;
}
//初始化加载动画层样式，错误页面样式 流量提醒层样式
-(void)txijkCreatUI{
    //播放错误层
    self.playFailView = [[UIView alloc]init];
    self.playFailView.hidden = YES;
    self.playFailView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.playFailView];
    [self.playFailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //加载层
    self.loadingView = [[UIView alloc]init];
    self.loadingView.hidden = YES;
    self.loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //流量提示层
    self.flowView = [[UIView alloc]init];
    self.flowView.hidden = YES;
    self.flowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.flowView];
    [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [RACObserve(self.playFailView, hidden) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]==NO) {
            //出现错误视图，不展示加载视图，不展示流量提醒视图
            self.loadingView.hidden = YES;
            self.flowView.hidden = YES;
        }
    }];
    [RACObserve(self.loadingView, hidden) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]==NO) {
            //出现加载视图，不展示错误视图，不展示流量提醒视图
            self.playFailView.hidden = YES;
            self.flowView.hidden = YES;
        }
    }];
    [RACObserve(self.flowView, hidden) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]==NO) {
            //出现流量提醒视图，不展示加载视图，不展示错误视图
            self.playFailView.hidden = YES;
            self.loadingView.hidden = YES;
        }
    }];
    [self txijkCreatTopPanel];
}
//便于子类定制头部默认视图
-(void)txijkCreatTopPanel{
    
}
//子类处理界面样式
-(void)mediaBaseControlObserDeviceChange:(UIDeviceOrientation)orign{
    
}
#pragma mark-定时刷新
- (void)refreshMediaControl
{
    NSString * duraStr = @"";
    NSString * currStr = @"";
    // duration
    NSTimeInterval duration = self.duration;
    NSInteger intDuration = duration;
    if (intDuration > 0) {
        self.mediaProgressSlider.maximumValue = duration;
        duraStr = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
        duraStr = @"00:00";
        self.mediaProgressSlider.maximumValue = 1.0f;
    }
    // position
    NSTimeInterval position;
    if (self.isMediaSliderBeingDragged) {
        position = self.mediaProgressSlider.value;
    } else {
        position = self.currentTime;
    }
    NSInteger intPosition = position;
    if (intDuration > 0) {
        self.mediaProgressSlider.value = position;
        currStr = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    } else {
        self.mediaProgressSlider.value = 0.0f;
        currStr = @"00:00";
    }
    self.startTimeLabel.text = currStr;
    self.allTimeLabel.text = duraStr;
}
#pragma mark-快进快退
-(void)creatFF_View{
    self.FF_View = [[NSBundle mainBundle] loadNibNamed:@"FastForwardView" owner:self options:nil].lastObject;
    self.FF_View.hidden = YES;
    self.FF_View.layer.cornerRadius = 10.0;
    [self addSubview:self.FF_View];
    
    [self.FF_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(@(120));
        make.height.equalTo(@60);
    }];
}
#pragma mark-滑动调节亮度 滑动调节音量
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //这个是用来判断, 如果有多个手指点击则不做出响应
    UITouch * touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || [touch tapCount] > 1 || event.allTouches.count > 1) {
        return;
    }
    //    这个是用来判断, 手指点击的是不是本视图, 如果不是则不做出响应
    if (![[(UITouch *)touches.anyObject view] isEqual:self] &&  ![[(UITouch *)touches.anyObject view] isEqual:self]) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
    
    //触摸开始, 初始化一些值
    _hasMoved = NO;
    _touchBeginValue = self.mediaProgressSlider.value;
    //位置
    _touchBeginPoint = [touches.anyObject locationInView:self];
    //亮度
    _touchBeginLightValue = [UIScreen mainScreen].brightness;
    //声音
    _touchBeginVoiceValue = [Commond getSystemVolumValue];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || [touch tapCount] > 1  || event.allTouches.count > 1) {
        return;
    }
    if (![[(UITouch *)touches.anyObject view] isEqual:self] && ![[(UITouch *)touches.anyObject view] isEqual:self]) {
        return;
    }
    [super touchesMoved:touches withEvent:event];
    
    //如果移动的距离过于小, 就判断为没有移动
    CGPoint tempPoint = [touches.anyObject locationInView:self];
    if (fabs(tempPoint.x - _touchBeginPoint.x) < LeastDistance && fabs(tempPoint.y - _touchBeginPoint.y) < LeastDistance) {
        return;
    }
    _hasMoved = YES;
    //如果还没有判断出使什么控制手势, 就进行判断
    //滑动角度的tan值
    float tan = fabs(tempPoint.y - _touchBeginPoint.y)/fabs(tempPoint.x - _touchBeginPoint.x);
    if (tan < 1/sqrt(3)) {    //当滑动角度小于30度的时候, 进度手势
        if (_touchBeginPoint.y>[UIScreen mainScreen].bounds.size.height-50) {
            //底部进度条，不让产生手势
            _controlType = noneControl;
        }else{
            _controlType = progressControl;
        }
        //            _controlJudge = YES;
    }else if(tan > sqrt(3)){  //当滑动角度大于60度的时候, 声音和亮度
        //判断是在屏幕的左半边还是右半边滑动, 左侧控制为亮度, 右侧控制音量
        if (_touchBeginPoint.x < self.bounds.size.width/2) {
            _controlType = lightControl;
        }else{
            _controlType = voiceControl;
        }
    }else{     //如果是其他角度则不是任何控制
        _controlType = noneControl;
        return;
    }
    if (_controlType == progressControl) {     //如果是进度手势
        CGFloat tempValue = [self moveProgressControllWithTempPoint:tempPoint];
        if (tempValue > _touchBeginValue) {
            self.FF_View.sheetStateImageView.image = WSImage(@"progress_icon_r");
        }else if(tempValue < _touchBeginValue){
            self.FF_View.sheetStateImageView.image =WSImage(@"progress_icon_l");
        }
        self.FF_View.hidden = NO;
        self.FF_View.sheetTimeLabel.text = [NSString stringWithFormat:@"%@/%@", [self convertTime:tempValue], [self convertTime:self.duration]];
        //通知外界去seek进度
        if ([self.delegate respondsToSelector:@selector(mediaControlShouldSeeking:)]) {
            [self.delegate mediaControlShouldSeeking:tempValue];
        }
    }else if(_controlType == voiceControl){    //如果是音量手势
        //        if (self.isFullscreen) {//全屏的时候才开启音量的手势调节
        //            if (self.enableVolumeGesture) {
        //根据触摸开始时的音量和触摸开始时的点去计算出现在滑动到的音量
        float voiceValue = _touchBeginVoiceValue - ((tempPoint.y - _touchBeginPoint.y)/self.bounds.size.height);
        //判断控制一下, 不能超出 0~1
        if ([self.delegate respondsToSelector:@selector(mediaControlShouldVolum:)]) {
            if (voiceValue < 0) {
                [self.delegate mediaControlShouldVolum:0];
            }else if(voiceValue > 1){
                [self.delegate mediaControlShouldVolum:1];
            }else{
                [self.delegate mediaControlShouldVolum:voiceValue];
            }
        }
    }else if(_controlType == lightControl){   //如果是亮度手势
        //根据触摸开始时的亮度, 和触摸开始时的点来计算出现在的亮度
        float tempLightValue = _touchBeginLightValue - ((tempPoint.y - _touchBeginPoint.y)/self.bounds.size.height);
        if (tempLightValue < 0) {
            tempLightValue = 0;
        }else if(tempLightValue > 1){
            tempLightValue = 1;
        }
        //        控制亮度的方法
        [UIScreen mainScreen].brightness = tempLightValue;
        //        实时改变现实亮度进度的view
        NSLog(@"亮度调节 = %f",tempLightValue);
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    //判断是否移动过,
    if (_hasMoved) {
        if (_controlType == progressControl) { //进度控制就跳到响应的进度
            CGPoint tempPoint = [touches.anyObject locationInView:self];
            float tempValue = _touchBeginValue + 90 * ((tempPoint.x - _touchBeginPoint.x)/([UIScreen mainScreen].bounds.size.width));
            if (tempValue > self.duration) {
                tempValue = self.duration;
            }else if (tempValue < 0){
                tempValue = 0.0f;
            }
            self.FF_View.hidden = YES;
            //调整进度
            if ([self.delegate respondsToSelector:@selector(mediaControlShouldSeeking:)]) {
                [self.delegate mediaControlShouldSeeking:tempValue];
            }
        }else if (_controlType == lightControl){//如果是亮度控制, 控制完亮度还要隐藏显示亮度的view
            
            
        }
    }else{
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesEnded");
    self.FF_View.hidden = YES;
    //    [self hideTheLightViewWithHidden:YES];
    [super touchesEnded:touches withEvent:event];
    //    //判断是否移动过,
}
#pragma mark - 用来控制移动过程中计算手指划过的时间
-(float)moveProgressControllWithTempPoint:(CGPoint)tempPoint{
    //    //90代表整个屏幕代表的时间
    float tempValue = _touchBeginValue + 90 * ((tempPoint.x - _touchBeginPoint.x)/([UIScreen mainScreen].bounds.size.width));
    if (tempValue > self.duration) {
        tempValue = self.duration;
    }else if (tempValue < 0){
        tempValue = 0.0f;
    }
    return tempValue;
}
#pragma mark-修改时间
- (NSString *)convertTime:(float)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    return [[self dateFormatter] stringFromDate:d];
}
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    }
    return _dateFormatter;
}
#pragma mark-创建控制层
-(void)creatControlView{
    if (!self.controlBtn) {
        self.controlBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        self.controlBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self addSubview:_controlBtn];
        [self.controlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        //默认是隐藏，选中的
        self.controlBtn.selected = YES;
        self.controlBtn .hidden = YES;
        [self.controlBtn addTarget:self action:@selector(controlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showControlViewHidden)];
        [self addGestureRecognizer:tap];
    }
}
//控制层底部按钮点击事件
-(void)controlBtnClick:(UIButton *)btn{
    if (btn.selected == YES) {
        btn.selected = NO;
        [self hideControlView];
    }else{
        btn.selected = YES;
        [self showControlViewAfterHidden:YES];
    }
}
-(void)showControlViewAfterHidden:(BOOL)hidden{
    if (hidden==YES) {
        [self showControlViewHidden];
    }else{
        //不隐藏
        [self showControlView];
    }
}
//隐藏
-(void)hideControlView{
    self.controlBtn.hidden = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:self];
}
//不自动隐藏()
-(void)showControlView{
    self.controlBtn.selected = YES;
    self.controlBtn.hidden = NO;
}
//当btncontrol隐藏后的点击方法
-(void)showControlViewHidden{
    if (_isNotTap==YES) {
        return;
    }
    self.controlBtn.hidden = NO;
    self.controlBtn.selected = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:self];
    [self performSelector:@selector(hideControlView) withObject:self afterDelay:3];
}
#pragma mark-更新播放进度
-(void)updateProgress:(CGFloat)progress{
    self.bufferProgress.progress = progress/self.duration;
}
-(void)updateTitleView:(NSString *)title{}
//释放控制层
-(void)dealloc_MediaControl{
    [self hiddenFlowToastView];
    [self.lightView removeFromSuperview];
    [self removeFromSuperview];
    [self removeObserver:self forKeyPath:UIDeviceOrientationDidChangeNotification];
}
#pragma mark-流量提示
//-(void)showFlowToastView{
//    self.mediaHud = nil;
//    if (!self.flowView) {
//        self.flowView = [[UIView alloc]init];
//        self.flowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//        [self addSubview:self.flowView];
//        [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//        UILabel * titleLabel = [KTFactory creatLabelWithText:@"正在使用非WiFi网络，播放将产生流量费用" fontValue:15 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
//        [self.flowView addSubview:titleLabel];
//        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.flowView);
//            make.centerY.equalTo(self.flowView).offset(-10);
//        }];
//
//        UIButton * button =[UIButton buttonWithType:UIButtonTypeCustom];
//        [button addTarget:self action:@selector(buttonLoadFailReLoad:) forControlEvents:UIControlEventTouchUpInside];
//        [button setTitle:@"继续播放" forState:UIControlStateNormal];
//        button.layer.borderColor = [UIColor whiteColor].CGColor;
//        button.layer.borderWidth = 0.5;
//        button.layer.cornerRadius = Anno750(10);
//        [button setImage:WSImage(@"播放三角") forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:12];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
//        [self.flowView addSubview:button];
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(titleLabel);
//            make.top.equalTo(titleLabel.mas_bottom).offset(15);
//            make.size.mas_equalTo(CGSizeMake(80, 25));
//        }];
//        //将top移到该视图上
//        [self.topPanel removeFromSuperview];
//        self.topShadowView.hidden = YES;
//        [self.flowView addSubview:self.topPanel];
//        [self.topPanel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self.flowView);
//            make.height.equalTo(@(50));
//        }];
//        self.isNotTap = YES;
//    }
//}
//-(void)hiddenFlowToastView{
//    if (!self.flowView) {
//        return;
//    }
//    //将top移到该视图上
//    if (![self.topPanel.superview isKindOfClass:[UIButton class]]) {
//        [self.topPanel removeFromSuperview];
//        self.topShadowView.hidden = NO;
//        [self.controlBtn addSubview:self.topPanel];
//        [self.topPanel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self.controlBtn);
//            make.height.equalTo(@(50));
//        }];
//    }
//    self.isNotTap = NO;
//    [self.flowView removeFromSuperview];
//    self.flowView = nil;
//}
//继续播放事件
-(void)buttonLoadFailReLoad:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(mediaControlShouldPlayWith4G:)]) {
        [self.delegate mediaControlShouldPlayWith4G:btn];
    }
}
//展示直播错误视图
//-(void)liveFailViewWithType:(liveFailType)type{
//    @weakify(self);
//    self.mediaHud = nil;
//    if (!self.playFailView) {
//        self.playFailView = [[LivePlayFailView alloc]init];
//        self.playFailView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//        [self.playFailView setShowType:type];
//        [self addSubview:self.playFailView];
//        [self.playFailView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//        //将top移到该视图上
//        [self.topPanel removeFromSuperview];
//        self.topShadowView.hidden = YES;
//        [self.playFailView addSubview:self.topPanel];
//        [self.topPanel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self.playFailView);
//            make.height.equalTo(@(50));
//        }];
//        //重新加载
//        self.playFailView.playBlock = ^(UIButton *btn) {
//            @strongify(self);
//            if ([self.delegate respondsToSelector:@selector(mediaControlShouldReplay:)]) {
//                [self.delegate mediaControlShouldReplay:btn];
//            }
//        };
//        self.isNotTap = YES;
//    }
//}
//-(void)liveFailViewRemove{
//    if (!self.playFailView) {
//        return;
//    }
//    //将top移到该视图上
//    if (![self.topPanel.superview isKindOfClass:[UIButton class]]) {
//        [self.topPanel removeFromSuperview];
//        self.topShadowView.hidden = NO;
//        [self.controlBtn addSubview:self.topPanel];
//        [self.topPanel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self.controlBtn);
//            make.height.equalTo(@(50));
//        }];
//    }
//    self.isNotTap = NO;
//    [self.playFailView removeFromSuperview];
//    self.playFailView = nil;
//}
//展示小菊花
-(MediaProgressHud *)showHudLoadingAtView{
    if (!self.mediaHud) {
        self.mediaHud = [MediaProgressHud showHudInView:self.loadingView];
        self.loadingView.hidden = NO;
        [self.loadingView sendSubviewToBack:self.mediaHud];
    }
    return self.mediaHud;
}
//隐藏小菊花
-(void)hiddenHudLoadingAtView{
    if (!self.mediaHud) {
        return ;
    }
    [self.mediaHud dissmiss];
    self.mediaHud =nil;
    self.loadingView.hidden = YES;
}
@end

