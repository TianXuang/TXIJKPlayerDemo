//
//  commond.m
//  BigTimeStrategy
//
//  @Author: wsh on 16/6/15.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import "Commond.h"
#import <MediaPlayer/MediaPlayer.h>
@implementation Commond

#pragma mark- 获取系统音量大小
+(CGFloat)getSystemVolumValue{
    return [[self getSystemVolumSlider] value];
}
#pragma mark- 设置系统音量大小
+(void)setSysVolumWith:(double)value{
    [self getSystemVolumSlider].value = value;
}
#pragma mark- 获取系统音量滑块
+(UISlider*)getSystemVolumSlider{
    static UISlider * volumeViewSlider = nil;
    if (volumeViewSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 50, 200, 4)];
        
        for (UIView* newView in volumeView.subviews) {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)newView;
                break;
            }
        }
    }
    return volumeViewSlider;
}
@end
