//
//  NIMNetCallManagerProtocol.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMGlobalDefs.h"

/**
 *  发起通话Block
 *
 *  @param error 发起通话结果, 如果成功error为nil
 *  @param callID 发起通话的call id, 如果发起失败则为0
 */
typedef void(^YSF_NIMNetCallStartHandler)(NSError *error, UInt64 callID);

/**
 *  响应通话请求Block
 *
 *  @param error  响应通话请求结果, 如果成功error为nil
 *  @param callID 响应通话的call id
 */
typedef void(^YSF_NIMNetCallResponseHandler)(NSError *error, UInt64 callID);



/**
 *  网络通话状态
 */
typedef NS_ENUM(NSInteger, YSF_NIMNetCallStatus){
    /**
     *  已连接
     */
    YSF_NIMNetCallStatusConnect,
    /**
     *  已断开
     */
    YSF_NIMNetCallStatusDisconnect,
};

/**
 *  网络通话的网络状态
 */
typedef NS_ENUM(NSInteger, YSF_NIMNetCallNetStatus){
    /**
     *  网络非常好
     */
    YSF_NIMNetCallNetStatusVeryGood = 0,
    /**
     *  网络好
     */
    YSF_NIMNetCallNetStatusGood     = 1,
    /**
     *  网络差
     */
    YSF_NIMNetCallNetStatusBad      = 2,
    /**
     *  网络非常差
     */
    YSF_NIMNetCallNetStatusVeryBad  = 3,
};

/**
 *  网络通话控制类型
 */
typedef NS_ENUM(NSInteger, YSF_NIMNetCallControlType){
    /**
     *  开启了音频
     */
    YSF_NIMNetCallControlTypeOpenAudio      = 1,
    /**
     *  关闭了音频
     */
    YSF_NIMNetCallControlTypeCloseAudio     = 2,
    /**
     *  开启了视频
     */
    YSF_NIMNetCallControlTypeOpenVideo      = 3,
    /**
     *  关闭了视频
     */
    YSF_NIMNetCallControlTypeCloseVideo     = 4,
    /**
     *  切换到视频模式
     */
    YSF_NIMNetCallControlTypeToVideo        = 5,
    /**
     *  同意切换到视频模式，用于切到视频模式需要对方同意的场景
     */
    YSF_NIMNetCallControlTypeAgreeToVideo   = 6,
    /**
     *  拒绝切换到视频模式，用于切到视频模式需要对方同意的场景
     */
    YSF_NIMNetCallControlTypeRejectToVideo  = 7,
    /**
     *  切换到音频模式
     */
    YSF_NIMNetCallControlTypeToAudio        = 8,
    /**
     *  占线
     */
    YSF_NIMNetCallControlTypeBusyLine       = 9,
    /**
     *  没有可用摄像头
     */
    YSF_NIMNetCallControlTypeNoCamera       = 10,
    /**
     *  应用切换到了后台
     */
    YSF_NIMNetCallControlTypeBackground     = 11,
    /**
     *  收到呼叫请求的反馈，通常用于被叫告诉主叫可以播放回铃音了
     */
    YSF_NIMNetCallControlTypeFeedabck       = 12,
};

/**
 *  视频通话使用的摄像头
 */
typedef NS_ENUM(NSInteger, YSF_NIMNetCallCamera){
    /**
     *  前置摄像头
     */
    YSF_NIMNetCallCameraFront,
    /**
     *  后置摄像头
     */
    YSF_NIMNetCallCameraBack,
};

/**
 *  音视频聊天相关回调
 */
@protocol YSF_NIMNetCallManagerDelegate <NSObject>

@optional

/**
 *  被叫收到呼叫（振铃）
 *
 *  @param callID call id
 *  @param caller 主叫帐号
 *  @param type   呼叫类型
 */
- (void)onReceive:(UInt64)callID
             from:(NSString *)caller
             type:(YSF_NIMNetCallType)type;

/**
 *  主叫收到被叫响应
 *
 *  @param callID   call id
 *  @param callee 被叫帐号
 *  @param accepted 是否接听
 */
- (void)onResponse:(UInt64)callID
              from:(NSString *)callee
          accepted:(BOOL)accepted;

/**
 *  对方挂断电话
 *
 *  @param callID call id
 *  @param user   对方帐号
 */
- (void)onHangup:(UInt64)callID
              by:(NSString *)user;

/**
 *  这通呼入通话已经被该帐号其他端处理
 *
 *  @param callID   呼入通话的call id
 *  @param accepted 是否被接听
 */
- (void)onResponsedByOther:(UInt64)callID
                  accepted:(BOOL)accepted;

/**
 *  收到对方网络通话控制信息，用于方便通话双方沟通信息
 *
 *  @param callID  相关网络通话的call id
 *  @param user    对方帐号
 *  @param control 控制类型
 */
- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(YSF_NIMNetCallControlType)control;

/**
 *  当前通话状态
 *
 *  @param callID 相关网络通话的call id
 *  @param status 通话状态, 收到NIMNetCallStatusDisconnect时无需调用hangup:挂断该通话
 */
- (void)onCall:(UInt64)callID
        status:(YSF_NIMNetCallStatus)status;
/**
 *  当前通话网络状态
 *
 *  @param callID 相关网络通话的call id
 *  @param status 网络状态
 */
- (void)onCall:(UInt64)callID
     netStatus:(YSF_NIMNetCallNetStatus)status;

/**
 *  本地摄像头预览就绪
 *
 *  @param layer 本地摄像头预览层
 */
- (void)onLocalPreviewReady:(CALayer *)layer;

/**
 *  远程视频画面就绪，每帧画面都会回调
 *
 *  @param image 远程视频画面
 */
- (void)onRemoteImageReady:(CGImageRef)image;


@end

/**
 *  网络通话协议
 */
@protocol YSF_NIMNetCallManager <NSObject>

/**
 *  主叫发起通话
 *
 *  @param callee 被叫帐号
 *  @param type  呼叫类型
 *  @param completion  发起通话结果回调
 */
- (void)start:(NSString *)callee
         type:(YSF_NIMNetCallType)type
   completion:(YSF_NIMNetCallStartHandler)completion;


/**
 *  被叫响应呼叫
 *
 *  @param callID call id
 *  @param accept  是否接听
 *  @param completion  响应呼叫结果回调
 *
 *  @discussion 被叫拒绝接听时, 主叫不需要再调用hangup:接口
 */
- (void)response:(UInt64)callID
          accept:(BOOL)accept
      completion:(YSF_NIMNetCallResponseHandler)completion;

/**
 *  挂断通话
 *
 *  @param callID 需要挂断电话的call id, 如果尚未获取到call id就填0
 *
 *  @discussion 被叫在响应呼叫之前不要调用挂断接口
 */
- (void)hangup:(UInt64)callID;

/**
 *  发送网络通话的控制信息，用于方便通话双方沟通信息
 *
 *  @param callID 控制信息相关通话的call id
 *  @param type   控制类型
 */
- (void)control:(UInt64)callID
           type:(YSF_NIMNetCallControlType)type;

/**
 *  设置网络通话静音模式
 *
 *  @param mute 是否开启静音
 *
 *  @return 开启静音是否成功
 *
 *  @discussion 切换网络通话类型将丢失该设置
 */
- (BOOL)setMute:(BOOL)mute;

/**
 *  设置网络通话扬声器模式
 *
 *  @param useSpeaker 是否开启扬声器
 *
 *  @return 开启扬声器是否成功
 *
 *  @discussion 切换网络通话类型将丢失该设置
 */
- (BOOL)setSpeaker:(BOOL)useSpeaker;

/**
 *  切换网络通话摄像头
 *
 *  @param camera 选择的摄像头
 *
 *  @discussion 切换网络通话类型将丢失该设置
 */
- (void)switchCamera:(YSF_NIMNetCallCamera)camera;

/**
 *  设置摄像头关闭
 *
 *  @param disable 是否关闭
 *
 *  @return 设置是否成功
 *
 *  @discussion 仅支持当前为视频模式时进行此设置, 切换网络通话类型将丢失该设置
 */
- (BOOL)setCameraDisable:(BOOL)disable;

/**
 *  切换网络通话类型
 *
 *  @param type 通话类型
 *
 *  @discussion 切换通话类型会丢失这些设置: 静音模式, 扬声器模式, 摄像头关闭, 切换摄像头
 */
- (void)switchType:(YSF_NIMNetCallType)type;


/**
 *  获得当前视频通话的本地预览层
 *
 *  @return 预览层
 */
- (CALayer *)localPreviewLayer;

/**
 *  获取正在进行中的网络通话call id
 *
 *  @return call id, 如果没有正在进行中的通话则返回0
 */
- (UInt64)currentCallID;

/**
 *  获取当前网络通话的网络状态
 *
 *  @return 网络状态
 */
- (YSF_NIMNetCallNetStatus)netStatus;

/**
 *  添加网络通话委托
 *
 *  @param delegate 网络通话委托
 */
- (void)addDelegate:(id<YSF_NIMNetCallManagerDelegate>)delegate;

/**
 *  移除网络通话委托
 *
 *  @param delegate 网络通话委托
 */
- (void)removeDelegate:(id<YSF_NIMNetCallManagerDelegate>)delegate;
@end
