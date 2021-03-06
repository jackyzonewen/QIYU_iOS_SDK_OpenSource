//
//  YSF_NIMResourceManager.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  上传Block
 *
 *  @param urlString 上传后得到的URL,失败时为nil
 *  @param error     错误信息,成功时为nil
 */
typedef void(^YSF_NIMUploadCompleteBlock)(NSString *urlString,NSError *error);

/**
 *  上传/下载进度Block
 *
 *  @param progress 进度 0%-100%
 */
typedef void(^YSF_NIMHttpProgressBlock)(CGFloat progress);


/**
 *  下载Block
 *
 *  @param error 错误信息,成功时为nil
 */
typedef void(^YSF_NIMDownloadCompleteBlock)(NSError *error);

/**
 *  清理文件完成Block
 *
 *  @param error 错误信息,成功时为nil
 */
typedef void(^YSF_NIMCleanResourceCompleteBlock)(NSError *error);



/**
 *  资源管理
 */
@protocol YSF_NIMResourceManager <NSObject>

/**
 *  上传文件
 *
 *  @param filepath   上传文件路径
 *  @param progress   进度Block
 *  @param completion 上传Block
 */
- (void)upload:(NSString *)filepath
      progress:(YSF_NIMHttpProgressBlock)progress
    completion:(YSF_NIMUploadCompleteBlock)completion;

/**
 *  下载文件
 *
 *  @param urlString  下载的RL
 *  @param filepath   下载路径
 *  @param progress   进度Block
 *  @param completion 完成Block
 */
- (void)download:(NSString *)urlString
        filepath:(NSString *)filepath
        progress:(YSF_NIMHttpProgressBlock)progress
      completion:(YSF_NIMDownloadCompleteBlock)completion;

/**
 *  取消上传/下载任务
 *
 *  @param filepath 上传/下载任务对应的文件路径
 *  @discussion 如果同一个文件同时上传或者下载(理论上不应该出现这种情况),ResourceManager会进行任务合并,基于这个原则cancel的操作对象是某个文件对应的所有的上传/下载任务
 */
- (void)cancelTask:(NSString *)filepath;

/**
 删除指定文件缓存

 @param filePath 文件路径
 @param completionBlock 删除文件完成Block
 */
- (void)deleteFileByPath:(NSString *)filePath completionBlock:(YSF_NIMCleanResourceCompleteBlock)completionBlock;

/**
 清除缓存文件

 @param completionBlock 清理缓存完成Block
 */
- (void)cleanResourceCacheWithBlock:(YSF_NIMCleanResourceCompleteBlock)completionBlock;

/**
 *  将 http url 转换为 https url
 *
 *  @param httpURLString http url 地址
 *  @discussion SDK 会自动处理除自定义消息外所有消息内的 http url 以保证符合苹果的审核请求，但是自定义消息中的 http 地址 SDK 并不知道具体属性在哪，所以在做这些文件下载时，需要上层自己处理
 *              如果传入的 url 是 https 地址，直接返回字符串本身。如果传入的 url 是云信无法识别 host 的 http 地址，直接返回添加了 https 的地址
 */
- (NSString *)convertHttpToHttps:(NSString *)httpURLString;

@end
