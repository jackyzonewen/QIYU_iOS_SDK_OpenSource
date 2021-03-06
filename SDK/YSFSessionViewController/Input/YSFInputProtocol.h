//
//  YSFInputProtocol.h
//  YSFKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

@class YSFMediaItem;


@protocol YSFInputActionDelegate <NSObject>

@optional
- (void)onTapMediaItem:(YSFMediaItem *)item;

- (void)onTextChanged:(id)sender;

- (BOOL)onSendText:(NSString *)text;

- (void)OnMediaPicturePressed;

- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId;


- (void)onPasteImage:(UIImage *)image;

- (void)onCancelRecording;

- (void)onStopRecording;

- (void)onStartRecording;

@end

