//
//  YSF_NIMNetCallNotificationContent.h
//  NIMLib
//
//  Created by Netease
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMGlobalDefs.h"
#import "NIMNotificationContent.h"


/**
 *  网络电话类型
 */
typedef NS_ENUM(NSInteger, YSF_NIMNetCallEventType){
    /**
     *  对方拒接电话
     */
    YSF_NIMNetCallEventTypeReject = -1,
    /**
     *  对方无人接听
     */
    YSF_NIMNetCallEventTypeNoResponse = -2,
    /**
     *  未接电话
     */
    YSF_NIMNetCallEventTypeMiss = 101,
    /**
     *  电话回单
     */
    YSF_NIMNetCallEventTypeBill = 102,
};


/**
 *  网络通话通知内容
 */
@interface YSF_NIMNetCallNotificationContent : YSF_NIMNotificationContent
/**
 *  网络通话类型
 */
@property (nonatomic,assign)   YSF_NIMNetCallType callType;
/**
 *  操作类型
 */
@property (nonatomic,assign)   YSF_NIMNetCallEventType eventType;
/**
 *  call id
 */
@property (nonatomic,assign)   UInt64 callID;
/**
 *  时长
 */
@property (nonatomic,assign)   NSTimeInterval duration;

@end
