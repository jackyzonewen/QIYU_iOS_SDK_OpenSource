//
//  YSF_NIMSystemNotification.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSession.h"
#import "NIMUser.h"

/**
 *  系统通知类型
 */
typedef NS_ENUM(NSInteger, YSF_NIMSystemNotificationType){
    /**
     *  申请入群
     */
    YSF_NIMSystemNotificationTypeTeamApply              = 0,
    /**
     *  拒绝入群
     */
    YSF_NIMSystemNotificationTypeTeamApplyReject        = 1,
    /**
     *  邀请入群
     */
    YSF_NIMSystemNotificationTypeTeamInvite             = 2,
    /**
     *  拒绝入群邀请
     */
    YSF_NIMSystemNotificationTypeTeamIviteReject        = 3,
    
    /**
     *  添加好友
     */
    YSF_NIMSystemNotificationTypeFriendAdd              = 5,
    
};


/**
 *  系统通知
 */
@interface YSF_NIMSystemNotification : NSObject
/**
 *  通知类型
 */
@property (nonatomic,assign,readonly)       YSF_NIMSystemNotificationType type;

/**
 *  时间戳
 */
@property (nonatomic,assign,readonly)       NSTimeInterval timestamp;
/**
 *  操作者
 */
@property (nonatomic,copy,readonly)         NSString *sourceID;
/**
 *  目标ID,群ID或者是用户ID
 */
@property (nonatomic,copy,readonly)         NSString *targetID;

/**
 *  附言
 */
@property (nonatomic,copy,readonly)         NSString *postscript;

/**
 *  是否已读
 *  @discussion 修改这个属性并不会修改db中的数据
 */
@property (nonatomic,assign)                BOOL read;

/**
 *  消息处理状态
 *  @discussion 修改这个属性,后台会自动更新db中对应的数据,SDK调用者可以使用这个值来持久化他们对消息的处理结果,默认为0
 */
@property (nonatomic,assign)                NSInteger handleStatus;


/**
 *  附件
 *  @discussion 额外信息,目前只有好友添加有额外信息,attachment为YSF_NIMUserAddAttachment
 */
@property (nonatomic,strong,readonly)       id attachment;

@end


/**
 *  添加好友附件
 */
@interface YSF_NIMUserAddAttachment : NSObject

/**
 *  好友操作类型
 */
@property (nonatomic,assign,readonly)   YSF_NIMUserOperation    operationType;

@end


/**
 *  自定义系统消息
 */
@interface YSF_NIMCustomSystemNotification : NSObject

/**
 *  时间戳
 */
@property (nonatomic,assign,readonly)       NSTimeInterval timestamp;

/**
 *  通知发起者id
 */
@property (nonatomic,copy,readonly)         NSString *sender;

/**
 *  通知接受者id
 */
@property (nonatomic,copy,readonly)         NSString *receiver;


/**
 *  通知接受者类型
 */
@property (nonatomic,assign,readonly)       YSF_NIMSessionType  receiverType;

/**
 *  透传的消息体内容
 */
@property (nonatomic,copy,readonly)         NSString    *content;

/**
 *  是否只发送给在线用户
 *  @discussion 默认为YES 如果这个值为NO,通知接受者如果在通知投递时不在线,那么他会在下次登录时收到这个通知。如果消息接受者是群,则只允许投递到当前在线的用户
 */
@property (nonatomic,assign)                BOOL sendToOnlineUsersOnly;

/**
 *  apns推送文案
 *  @discussion 默认为nil,用户可以设置当前通知的推送文案
 */
@property (nonatomic,copy)                  NSString *apnsContent;


- (instancetype)initWithContent:(NSString *)content;

@end
