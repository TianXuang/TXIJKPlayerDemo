//
//  commond.h
//  BigTimeStrategy
//

//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
typedef void(^DelayBlock)(void);
typedef enum : NSUInteger {
    ToastPositionBottom,
    ToastPositionCenter,
} ToastPositon;
@interface Commond : NSObject

//调节系统音量
+(void)setSysVolumWith:(double)value;
+(CGFloat)getSystemVolumValue;
@end
