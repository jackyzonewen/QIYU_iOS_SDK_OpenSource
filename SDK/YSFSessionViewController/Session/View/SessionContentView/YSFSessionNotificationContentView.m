//
//  NIMSessionNotificationContentView.m
//  YSFKit
//
//  Created by chris on 15/3/9.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "YSFSessionNotificationContentView.h"
#import "YSFMessageModel.h"
#import "YSFKitUtil.h"
#import "YSFDefaultValueMaker.h"
#import "QYCustomUIConfig.h"
#import "YSFStartServiceObject.h"
#import "YSFEvaluationTipObject.h"
#import "NSMutableAttributedString+YSFVendor.h"
#import "YSFNotification.h"

@implementation YSFSessionNotificationContentView

- (instancetype)initSessionMessageContentView
{
    if (self = [super initSessionMessageContentView]) {
        _label = [[YSFAttributedLabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:[[QYCustomUIConfig sharedInstance] tipMessageTextFontSize]];
        _label.textColor = [[QYCustomUIConfig sharedInstance] tipMessageTextColor];
        _label.backgroundColor = [UIColor clearColor];
        _label.numberOfLines = 0;
        _label.textAlignment = kCTTextAlignmentCenter;
        [self addSubview:_label];
        self.bubbleType = YSFKitBubbleTypeNotify;
    }
    return self;
}

- (void)refresh:(YSFMessageModel *)model{
    [super refresh:model];
    id<YSFCellLayoutConfig> config = model.layoutConfig;
    if ([config respondsToSelector:@selector(formatedMessage:)]) {
        YSF_NIMCustomObject *object = (YSF_NIMCustomObject *)model.message.messageObject;
        if ([object.attachment isKindOfClass:[YSFStartServiceObject class]]) {
            _label.text = [model.layoutConfig formatedMessage:model];
        }
        else if ([object.attachment isKindOfClass:[YSFEvaluationTipObject class]]) {
            YSFEvaluationTipObject *attachment = (YSFEvaluationTipObject *)object.attachment;
            if (attachment.kaolaTipContent.length > 0 ) {
                _label.text = attachment.kaolaTipContent;
            }
            else {
                _label.text = attachment.tipContent;
                NSMutableAttributedString *attributedstring = [[NSMutableAttributedString alloc] initWithString:attachment.tipResult];
                [attributedstring ysf_setFont:[UIFont boldSystemFontOfSize:[[QYCustomUIConfig sharedInstance] tipMessageTextFontSize]]];
                [attributedstring ysf_setTextColor:[[QYCustomUIConfig sharedInstance] tipMessageTextColor]];
                [_label appendAttributedText:attributedstring];
                [_label appendText:@"。非常感谢！"];
            }
        }
        else if ([object.attachment isKindOfClass:[YSFNotification class]]) {
            _label.text = [model.layoutConfig formatedMessage:model];
        }
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.ysf_frameSize = [self.label sizeThatFits:CGSizeMake(self.ysf_frameWidth - 112 - 20, CGFLOAT_MAX)];
    self.label.ysf_frameCenterX = self.ysf_frameWidth * .5f;
    self.label.ysf_frameCenterY = self.ysf_frameHeight * .5f;
    self.bubbleImageView.frame = CGRectInset(self.label.frame, -8, 0);
    self.label.ysf_frameCenterY = self.label.ysf_frameCenterY + 2;
}



@end
