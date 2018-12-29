//
//  MediaListControl.m
//  VSFinance
//
//  Created by yunzhang on 2018/11/6.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import "MediaListControl.h"
@interface MediaListControl()
//流量提示视图标题
@property (nonatomic,strong)UILabel * titleLabel_flowToast;
@end
@implementation MediaListControl

//-(void)txijkCreatUI{
//    //头部视图
//    self.topPanel = [[UIView alloc]init];
//    self.topPanel.userInteractionEnabled = YES;
//    [self.controlBtn addSubview:self.topPanel];
//    [self.topPanel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(self);
//    }];
//
//    UIImageView * shadowView = [[UIImageView alloc]initWithImage:WSImage(@"jianbian-yiying")];
//    [self.topPanel addSubview:shadowView];
//    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.topPanel);
//    }];
//
//    //列表控制
//    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _backButton.tag = 1200;
//    [_backButton setImage:WSImage(@"fullScreenh") forState:UIControlStateNormal];
//    [_backButton addTarget:self action:@selector(fullbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    _backButton.hidden = YES;
//    [self.topPanel addSubview:_backButton];
//    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.topPanel.mas_left).offset(0);
//        make.top.equalTo(self.topPanel.mas_top).offset(0);
//        make.size.mas_equalTo(CGSizeMake(0, 0));
//    }];
//    _playTitleLabel = [KTFactory creatLabelWithText:@"" fontValue:font750(30) textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
//    _playTitleLabel.font = [UIFont boldSystemFontOfSize:font750(32)];
//    [self.topPanel addSubview:_playTitleLabel];
//    [_playTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_backButton.mas_right).offset(Anno750(30));
//        //            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-Anno750(200), Anno750(40)));
//        make.right.equalTo(self.mas_right).offset(-Anno750(30));
//        make.top.equalTo(self.topPanel.mas_top).offset(Anno750(30));
//    }];
//    _shareBtn = [KTFactory creatButtonWithNormalImage:@"kecheng-fx" selectImage:@"kecheng-fx"];
//    [self.shareBtn addTarget:self action:@selector(fullScreenShowShare:) forControlEvents:UIControlEventTouchUpInside];
//    [self.topPanel addSubview:_shareBtn];
//    _shareBtn.hidden = YES;
//    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        //            make.size.mas_equalTo()
//        make.centerY.equalTo(_playTitleLabel);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
//
//    _playNumsLabel = [KTFactory creatLabelWithText:@"" fontValue:font750(22) textColor:UIColorFromRGB(0xffffff) textAlignment:NSTextAlignmentLeft];
//    [self.topPanel addSubview:_playNumsLabel];
//    [_playNumsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_playTitleLabel);
//        make.top.equalTo(_playTitleLabel.mas_bottom).offset(Anno750(16));
//    }];
//    self.bottomPannel = [[UIView alloc]init];
//    self.bottomPannel.userInteractionEnabled = YES;
//    [self.controlBtn addSubview:self.bottomPannel];
//    [self.bottomPannel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self);
//        make.height.equalTo(@(Anno750(100)));
//    }];
//
//    UIImageView * botView = [[UIImageView alloc]initWithImage:WSImage(@"jianbian-xia")];
//    [self.bottomPannel addSubview:botView];
//    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.bottomPannel);
//    }];
//
//    //
//    self.playBtn = [KTFactory creatButtonWithNormalImage:@"redian-bf" selectImage:@"redian-zt"];
//    [self.playBtn addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    //默认是yes的
//    self.playBtn.selected = YES;
//    [self.controlBtn addSubview:self.playBtn];
//    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(Anno750(76), Anno750(76)));
//        make.center.equalTo(self);
//    }];
//    self.startTimeLabel = [KTFactory creatLabelWithText:@"00:00" fontValue:font750(26) textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
//    [self.bottomPannel addSubview:self.startTimeLabel];
//    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bottomPannel.mas_left).offset(Anno750(30));
//        make.centerY.equalTo(self.bottomPannel);
//        make.size.mas_equalTo(CGSizeMake(Anno750(80), Anno750(40)));
//    }];
//    //
//    _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _fullScreenBtn.tag = 1210;
//    [_fullScreenBtn setImage:WSImage(@"mingrenmingt-qp") forState:UIControlStateNormal];
//    [_fullScreenBtn setImage:WSImage(@"mrmt-thqp") forState:UIControlStateSelected];
//    [_fullScreenBtn addTarget:self action:@selector(fullbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomPannel addSubview:_fullScreenBtn];
//    [_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bottomPannel);
//        make.right.equalTo(self).offset(-Anno750(20));
//        make.size.mas_equalTo(CGSizeMake(Anno750(60), Anno750(50)));
//    }];
//    //
//    self.allTimeLabel = [KTFactory creatLabelWithText:@"00:00" boldFontValue:font750(26) textColor:UIColorFromRGB(0xffffff) textAlignment:NSTextAlignmentLeft];
//    self.allTimeLabel.font =[UIFont systemFontOfSize:font750(26)];
//    [self.bottomPannel addSubview:self.allTimeLabel];
//    [self.allTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.bottomPannel);
//        make.right.equalTo(self.fullScreenBtn.mas_left).offset(-Anno750(20));
//    }];
//    //缓冲进度
//    //进度条高度不可修改
//    self.bufferProgress = [[UIProgressView alloc] initWithFrame:CGRectZero];
//    //设置进度条的颜色
//    self.bufferProgress.progressTintColor = [UIColor whiteColor];
//    //设置进度条的当前值，范围：0~1；
//    self.bufferProgress.progress = 0.001;
//    self.bufferProgress.progressViewStyle = UIProgressViewStyleDefault;
//    [self.bottomPannel addSubview:self.bufferProgress];
//
//
//    //播放进度
//    self.mediaProgressSlider = [[VsPlayerSlider alloc]init];
//    self.mediaProgressSlider.maximumValue = 1.0;
//    self.mediaProgressSlider.minimumValue = 0;
//    self.mediaProgressSlider.value = 0;
//    self.mediaProgressSlider.minimumTrackTintColor = Main_red_titleColor;
//    //    Audio_progessWhite
//    self.mediaProgressSlider.maximumTrackTintColor = [UIColor clearColor];
//    self.mediaProgressSlider.thumbTintColor = [UIColor clearColor];
//    [self.mediaProgressSlider setThumbImage:[UIImage imageNamed:@"mingrenmingt-yd"] forState:UIControlStateNormal];
//    [self.mediaProgressSlider setThumbImage:[UIImage imageNamed:@"mingrenmingt-yd"] forState:UIControlStateSelected];
//    [self.mediaProgressSlider setThumbImage:[UIImage imageNamed:@"mingrenmingt-yd"] forState:UIControlStateDisabled];
//    [self.mediaProgressSlider setThumbImage:[UIImage imageNamed:@"mingrenmingt-yd"] forState:UIControlStateHighlighted];
//    //    self.slider.continuous=NO;
//    [self.mediaProgressSlider addTarget:self action:@selector(pressSliderTouchDown) forControlEvents:UIControlEventTouchDown];
//    [self.mediaProgressSlider addTarget:self action:@selector(pressSliderTouchCancel) forControlEvents:UIControlEventTouchCancel];
//    [self.mediaProgressSlider addTarget:self action:@selector(pressSliderTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//    [self.mediaProgressSlider addTarget:self action:@selector(pressSliderTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
//    [self.mediaProgressSlider addTarget:self action:@selector(pressSliderValueChanged) forControlEvents:UIControlEventValueChanged];
//    [self.bottomPannel addSubview:self.mediaProgressSlider];
//    [self.mediaProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.startTimeLabel.mas_right).offset(Anno750(32));
//        make.centerY.equalTo(self.startTimeLabel);
//        make.right.equalTo(self.allTimeLabel.mas_left).offset(-Anno750(30));
//    }];
//    [self.bufferProgress mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.startTimeLabel.mas_right).offset(Anno750(32));
//        make.centerY.equalTo(self.mediaProgressSlider).offset(Anno750(1));
//        make.right.equalTo(self.allTimeLabel.mas_left).offset(-Anno750(30));
//    }];
//    //  一开始隐藏，等视频能播放时，show
////    [self hide];
//    [super txijkCreatUI];
//}
#pragma mark-修改默认的顶部视图
//-(void)txijkCreatTopPanel{
//    UIView * bgView;
//    for (int i =0; i<3; i++) {
//
//        if (i==0) {
//            bgView = self.loadingView;
//        }else if (i==1){
//            bgView = self.playFailView;
//        }else{
//            bgView = self.flowView;
//        }
//        UIView *topPanel = [[UIView alloc]init];
//        topPanel.userInteractionEnabled = YES;
//        [bgView addSubview:topPanel];
//        [topPanel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self);
//        }];
//
//        UIImageView * shadowView = [[UIImageView alloc]initWithImage:WSImage(@"jianbian-yiying")];
//        [topPanel addSubview:shadowView];
//        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(topPanel);
//        }];
//
//        //列表控制
//        UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.tag = 400+i;
//        [backButton setImage:WSImage(@"fullScreenh") forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(fullbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        backButton.hidden = YES;
//        [topPanel addSubview:backButton];
//        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(topPanel.mas_left).offset(0);
//            make.top.equalTo(topPanel.mas_top).offset(0);
//            make.size.mas_equalTo(CGSizeMake(0, 0));
//        }];
//        UILabel * playTitleLabel = [KTFactory creatLabelWithText:@"" fontValue:font750(30) textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
//        playTitleLabel.tag = 100+i;
//        playTitleLabel.font = [UIFont boldSystemFontOfSize:font750(32)];
//        [topPanel addSubview:playTitleLabel];
//        [playTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(backButton.mas_right).offset(Anno750(30));
//            make.right.equalTo(self.mas_right).offset(-Anno750(30));
//            make.top.equalTo(topPanel.mas_top).offset(Anno750(30));
//        }];
//        UIButton * shareBtn = [KTFactory creatButtonWithNormalImage:@"kecheng-fx" selectImage:@"kecheng-fx"];
//        [shareBtn addTarget:self action:@selector(fullScreenShowShare:) forControlEvents:UIControlEventTouchUpInside];
//        [topPanel addSubview:shareBtn];
//        shareBtn.hidden = YES;
//        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(playTitleLabel);
//            make.right.equalTo(self.mas_right).offset(-15);
//            make.size.mas_equalTo(CGSizeMake(30, 30));
//        }];
//
//       UILabel * playNumsLabel = [KTFactory creatLabelWithText:@"" fontValue:font750(22) textColor:UIColorFromRGB(0xffffff) textAlignment:NSTextAlignmentLeft];
//        playNumsLabel.tag = 200+i;
//        [topPanel addSubview:playNumsLabel];
//        [playNumsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(playTitleLabel);
//            make.top.equalTo(playTitleLabel.mas_bottom).offset(Anno750(16));
//        }];
//    }
//
//}
#pragma mark-进度条事件
//-(void)pressSliderTouchDown{
//    self.isMediaSliderBeingDragged = YES;
//}
//-(void)pressSliderTouchCancel{
//    self.isMediaSliderBeingDragged = NO;
//}
//-(void)pressSliderTouchUpInside{
//    if ([self.delegate respondsToSelector:@selector(mediaControlShouldSeeking:)]) {
//        [self.delegate mediaControlShouldSeeking:self.mediaProgressSlider.value];
//    }
//    self.isMediaSliderBeingDragged = NO;
//}
//-(void)pressSliderTouchUpOutside{
//    self.isMediaSliderBeingDragged = NO;
//}
//-(void)pressSliderValueChanged{
//    [self continueDragMediaSlider];
//}
//- (void)continueDragMediaSlider
//{
//    [self refreshMediaControl];
//}
////播放按钮点击事件
//-(void)playButtonClick:(UIButton *)btn{
//    if ([self.delegate respondsToSelector:@selector(mediaControlShouldPlayOrPause:)]) {
//        [self.delegate mediaControlShouldPlayOrPause:btn];
//    }
//    btn.selected = !btn.selected;
//}
////全屏按钮点击事件
//-(void)fullbuttonClick:(UIButton *)btn{
//    btn.selected = !btn.selected;
//    if ([self.delegate respondsToSelector:@selector(mediaControlFullScreenClick:)]) {
//        [self.delegate mediaControlFullScreenClick:btn];
//    }
//}
////返回按钮事件
//-(void)backBtnClick:(UIButton *)btn{
//    if ([self.delegate respondsToSelector:@selector(mediaControlFullScreenClick:)]) {
//        [self.delegate mediaControlFullScreenClick:btn];
//    }
//}
////分享事件
//-(void)fullScreenShowShare:(UIButton *)btn{
//    if ([self.delegate respondsToSelector:@selector(mediaControlShareBtnClick:)]) {
//        [self.delegate mediaControlShareBtnClick:btn];
//    }
//}
////更新标题
//-(void)updateTitleView:(NSString *)title withNumbers:(NSString *)nums{
//    self.playTitleLabel.text = title;
//    self.playNumsLabel.text = nums;
//    for (int i =0; i<3; i++) {
//        UILabel * titleLabel = [self viewWithTag:100+i];
//        titleLabel.text = title;
//        UILabel * numLabel  = [self viewWithTag:200+i];
//        numLabel.text = nums;
//    }
//}
////屏幕旋转的通知
//-(void)mediaBaseControlObserDeviceChange:(UIDeviceOrientation)orign{
//    if (orign==UIDeviceOrientationPortrait) {
//        self.backButton.hidden = YES;
//        [self.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topPanel.mas_top).offset(0);
//            make.size.mas_equalTo(CGSizeZero);
//        }];
//        for (int i =0; i<3; i++) {
//            UIButton * btn =[self viewWithTag:400+i];
//            btn.hidden = YES;
//            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.topPanel.mas_top).offset(0);
//                make.size.mas_equalTo(CGSizeZero);
//            }];
//        }
//    }else{
//        self.backButton.hidden = NO;
//        [self.backButton mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topPanel.mas_top).offset(StatusBarHeight);
//            make.size.mas_equalTo(CGSizeMake(Anno750(80), Anno750(50)));
//        }];
//        for (int i =0; i<3; i++) {
//            UIButton * btn =[self viewWithTag:400+i];
//            btn.hidden = NO;
//            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.topPanel.mas_top).offset(StatusBarHeight);
//                make.size.mas_equalTo(CGSizeMake(Anno750(80), Anno750(50)));
//            }];
//        }
//    }
//}
@end
