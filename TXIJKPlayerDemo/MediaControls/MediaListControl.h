//
//  MediaListControl.h
//  VSFinance
//
//  Created by yunzhang on 2018/11/6.
//  Copyright © 2018年 TianXuan. All rights reserved.
//

#import "MediaBaseControl.h"

@interface MediaListControl : MediaBaseControl
@property (nonatomic,strong)UIButton * backButton;
@property (nonatomic,strong)UILabel * playTitleLabel;
@property (nonatomic,strong)UIButton * shareBtn;
@property (nonatomic,strong)UILabel * playNumsLabel;
@property (nonatomic,strong)UIButton *fullScreenBtn;
//特定更新标题
-(void)updateTitleView:(NSString *)title withNumbers:(NSString *)nums;
@end
