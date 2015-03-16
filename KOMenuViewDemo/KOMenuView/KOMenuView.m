//
//  KOMenuView.m
//  KOMenuViewDemo
//
//  Created by kino on 15/3/16.
//  Copyright (c) 2015年 kino. All rights reserved.
//

#import "KOMenuView.h"
#import "UIView+Utils.h"

static const CGFloat MenuItemHeightDefault = 50.f;
static const CGFloat MenuItemPadding = 1.f;

static const CGFloat expandHeight = 30.f;

@interface KOMenuView()

@property (strong, nonatomic) UIToolbar *backBLurView;
@property (strong, nonatomic) NSMutableArray *menuItems;
@property (strong, nonatomic) UIView *menuControlItem;
@property (strong, nonatomic) CALayer *menuControlFlagLayer;

@property (weak, nonatomic)   UIView *placeView;

@property (assign, nonatomic, getter=isExpandMenu) BOOL expandMenu;
@property (assign, nonatomic) CGFloat itemViewHeight;

@end

@implementation KOMenuView

- (NSMutableArray *)menuItems{
    if (_menuItems == nil) {
        _menuItems = [[NSMutableArray alloc] init];
    }
    return _menuItems;
}

+ (instancetype)menuViewWithItem:(NSArray *)items
                   withPlaceView:(UIView *)view{
    return [KOMenuView menuViewWithItem:items
                          withPlaceView:view
                       withClickByIndex:nil];
}

+ (instancetype)menuViewWithItem:(NSArray *)items
                   withPlaceView:(UIView *)view
                withClickByIndex:(KOMenuClickBlock)clickhandle{
    return [KOMenuView menuViewWithItem:items itemHeight:MenuItemHeightDefault
                          withPlaceView:view withClickByIndex:clickhandle];
}

+ (instancetype)menuViewWithItem:(NSArray *)items
                      itemHeight:(CGFloat)itemHeight
                   withPlaceView:(UIView *)view
                withClickByIndex:(KOMenuClickBlock)clickhandle{
    KOMenuView *menuView = [[KOMenuView alloc] initWithFrame:
                            CGRectMake(0, view.frame.size.height - itemHeight,
                                       view.frame.size.width, itemHeight)
                                               withPlaceView:view itemHeight:itemHeight];
    menuView.clickHandle = clickhandle;
    [menuView setItems:items];
    
    return menuView;
}

- (id)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withPlaceView:(UIView *)placeView{
    if (self = [super initWithFrame:frame]) {
        self.placeView = placeView;
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withPlaceView:(UIView *)placeView itemHeight:(CGFloat)itemHeight{
    if (self = [super initWithFrame:frame]) {
        self.placeView = placeView;
        self.itemViewHeight = itemHeight;
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    //default setting
    self.animaDuration = 0.25;
    self.itemViewHeight = (_itemViewHeight == 0.f ? MenuItemHeightDefault : _itemViewHeight);
    
    _backBLurView = [[UIToolbar alloc] init];
    _backBLurView.barStyle = UIBarStyleBlackOpaque;
    
    [self addSubview:_backBLurView];
    
    _menuControlItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _itemViewHeight)];
    _menuControlFlagLayer = [CALayer layer];
    UIImage *flagImage = [UIImage imageNamed:@"menuIcon"];
    _menuControlFlagLayer.frame = CGRectMake(_menuControlItem.width/2 - flagImage.size.width/2,
                                             _menuControlItem.height/2 - flagImage.size.height/2,
                                             flagImage.size.width, flagImage.size.height);
    _menuControlFlagLayer.contents = (id)flagImage.CGImage;
    [_menuControlItem.layer addSublayer:_menuControlFlagLayer];
    _menuControlItem.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    [self addSubview:_menuControlItem];
    
}

- (void)layoutSubviews{
    _backBLurView.frame = self.bounds;
    
    [super layoutSubviews];
}


- (void)setItems:(NSArray *)items{
    [self.menuItems removeAllObjects];
    
    NSInteger lastPositionY = self.itemViewHeight;
    for (NSString *itemName in items) {
        
        //create sub view
        UIView *itemView = [[UIView alloc] initWithFrame:
                            CGRectMake(0, lastPositionY, self.frame.size.width, self.itemViewHeight)];
        itemView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, itemView.width - 40, itemView.height)];
        titleLabel.text = itemName;
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        titleLabel.textColor = [UIColor whiteColor];
        [itemView addSubview:titleLabel];
        
        [self addSubview:itemView];
        //add to self array to manage
        [self.menuItems addObject:itemView];
        //calculate next position
        lastPositionY += (self.itemViewHeight + MenuItemPadding);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPt = [[touches anyObject] locationInView:self];
    
    if (CGRectContainsPoint(_menuControlItem.frame, touchPt)) {
        //touch control item, expand or not
        [self expandOrFoldMenu];
    }else{
        [self.menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *itemView = obj;
            if (CGRectContainsPoint(itemView.frame, touchPt)) {
                if ([self.delegate respondsToSelector:@selector(menuDidClickByIndex:)]) {
                    [self.delegate menuDidClickByIndex:idx];
                }
                
                if (self.clickHandle) {
                    self.clickHandle(idx);
                }
                
                if (self.foldMenuWhenClickItem) {
                    [self expandOrFoldMenu];
                }
                
                *stop = true;
            }
        }];
    }
}

- (void)expandOrFoldMenu{
    if (self.expandMenu) {
        //fold
        NSInteger height = self.itemViewHeight;
        [self updateMenuItemPosition];
        [UIView animateWithDuration:self.animaDuration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             //calc all height
                             self.top += (self.height - height);
                             
                             if ([self.delegate respondsToSelector:@selector(menuViewWillChangeInAnimation:)]) {
                                 [self.delegate menuViewWillChangeInAnimation:self.frame];
                             }
                             
                         } completion:^(BOOL finished) {
                             self.expandMenu = false;
                             _menuControlFlagLayer.contents = (id)[UIImage imageNamed:@"menuIcon"].CGImage;
                         }];
    }else{
        if (self.menuItems.count <= 0) return;
        
        //expand
        NSInteger height = (self.menuItems.count + 1) * self.itemViewHeight +
        (self.menuItems.count * MenuItemPadding) + expandHeight;
        [self updateMenuItemPosition];
        [UIView animateWithDuration:self.animaDuration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             //calc all height
                             self.height = height;
                             self.top -= (height - self.itemViewHeight - expandHeight);
                             
                             if ([self.delegate respondsToSelector:@selector(menuViewWillChangeInAnimation:)]) {
                                 [self.delegate menuViewWillChangeInAnimation:self.frame];
                             }
                         } completion:^(BOOL finished) {
                             self.expandMenu = true;
                             _menuControlFlagLayer.contents = (id)[UIImage imageNamed:@"menuClose"].CGImage;
                             self.height -= expandHeight;
                         }];
    }
}

- (void)updateMenuItemPosition{
    if (self.expandMenu) {
        [self.menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *itemView = obj;
            itemView.frame = CGRectMake(0, (idx+1) * self.itemViewHeight + idx*MenuItemPadding,
                                        itemView.width, itemView.height);
        }];
        self.menuControlItem.frame = CGRectMake(0, 0,
                                                self.menuControlItem.width,
                                                self.menuControlItem.height);
    }else{
        [self.menuItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *itemView = obj;
            itemView.frame = CGRectMake(0, idx * self.itemViewHeight + idx*MenuItemPadding,
                                        itemView.width, itemView.height);
        }];
        self.menuControlItem.frame = CGRectMake(0,
                                                self.menuItems.count * self.itemViewHeight +
                                                (self.menuItems.count) * MenuItemPadding,
                                                self.menuControlItem.width,
                                                self.menuControlItem.height);
    }
}
@end
