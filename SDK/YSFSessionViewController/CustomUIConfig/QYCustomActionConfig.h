//
//  QYCustomActionConfig.h
//  QYSDK
//
//  Created by towik on 7/28/16.
//  Copyright (c) 2016 Netease. All rights reserved.
//

typedef NS_ENUM(NSInteger, QuitType) {
    QYQuitTypeNone,
    QYQuitTypeContinue,
    QYQuitTypeNext,
    QYQuitTypeCancel,
};

/**
 *  提供了所有自定义行为的接口;每个接口对应一个自定义行为的处理，如果设置了，则使用设置的处理，如果不设置，则采用默认处理
 */
typedef void (^QYLinkClickBlock)(NSString *linkAddress);
typedef void (^QYBotClickBlock)(NSString *target, NSString *params);
typedef void (^QYShowQuitWaitingBlock)(QuitType quitType);
typedef void (^QYShowQuitBlock)(QYShowQuitWaitingBlock block);


/**
 *  自定义行为配置类
 */
@interface QYCustomActionConfig : NSObject

+ (instancetype)sharedInstance;

/**
 *  所有消息中的链接（自定义商品消息、文本消息、机器人答案消息）的回调处理
 */
@property (nonatomic, copy) QYLinkClickBlock linkClickBlock;

/**
 *  bot相关点击
 */
@property (nonatomic, copy) QYBotClickBlock botClick;

@property (nonatomic, copy) QYShowQuitBlock showQuitBlock;

/**
 *  设置录制或者播放语音完成以后是否自动deactivate AVAudioSession
 *
 *  @param deactivate 是否deactivate，默认为YES
 */
- (void)setDeactivateAudioSessionAfterComplete:(BOOL)deactivate;

- (void)showQuitWaiting:(QYShowQuitWaitingBlock)showQuitWaitingBlock;

@end



