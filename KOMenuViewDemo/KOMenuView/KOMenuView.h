//
//  KOMenuView.h
//  KOMenuViewDemo
//  Beta
//  Created by kino on 15/3/16.
//  Copyright (c) 2015年 kino. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KOMenuClickBlock)(NSInteger itemIndex);
typedef void(^KOMenuframeChangeBlock)(CGRect destFrame);

@protocol KOMenuViewDelegate <NSObject>

- (void)menuViewWillChangeInAnimation:(CGRect)destFrame;

- (void)menuDidClickByIndex:(NSInteger)itemIndex;

@end


@interface KOMenuView : UIView

@property (weak, nonatomic) id<KOMenuViewDelegate> delegate;


///fold menu automatically when select item,default NO
@property (assign, nonatomic) BOOL foldMenuWhenClickItem;
///animation duration, default 0.25
@property (assign, nonatomic) CGFloat animaDuration;


@property (copy, nonatomic) KOMenuClickBlock clickHandle;
@property (copy, nonatomic) KOMenuframeChangeBlock frameChangedHandle;



+ (instancetype)menuViewWithItem:(NSArray *)items
                   withPlaceView:(UIView *)view;

+ (instancetype)menuViewWithItem:(NSArray *)items
                   withPlaceView:(UIView *)view
                withClickByIndex:(KOMenuClickBlock)clickhandle;

+ (instancetype)menuViewWithItem:(NSArray *)items
                      itemHeight:(CGFloat)itemHeight
                   withPlaceView:(UIView *)view
                withClickByIndex:(KOMenuClickBlock)clickhandle;

@end

