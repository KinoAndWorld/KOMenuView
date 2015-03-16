# KOMenuView

***

This is a simple Menu View On One's View Bottom.

![Screenshot](http://ww3.sinaimg.cn/large/6ff7b43ejw1eq7krl21p3g207g0dc4qq.gif) 

## Features

- spring bounds effect
- simple use 
- adjustable menu item height  

## Installation

Grab the files in `KOMenuView/` and put it in your project. 

## Usage

first,  import `KOMenuView.h`
```objectivec
_blurMenuView = [KOMenuView menuViewWithItem:@[@"Menu 01",@"Menu 02",@"Menu 03",@"Menu 04",@"Menu 05"]
                               withPlaceView:self.view
                            withClickByIndex:^(NSInteger itemIndex) {
                                NSLog(@"itemIndex : %ld",(long)itemIndex);
                            }];
```
or you can custom menu item height
```objectivec
_blurMenuView = [KOMenuView menuViewWithItem:@[@"Menu 01",@"Menu 02",@"Menu 03",@"Menu 04",@"Menu 05"]
                                  itemHeight:60.f
                               withPlaceView:self.view
                            withClickByIndex:^(NSInteger itemIndex) {
                                NSLog(@"itemIndex : %ld",(long)itemIndex);
                            }];
```
you can set other funtion if you want
```
_blurMenuView.foldMenuWhenClickItem = YES;   ///fold menu automatically when select item, default NO
_blurMenuView.animaDuration = 0.3;          ///animation duration, default 0.25
```


### License

`KOMenuView` is released under the MIT license.

### Author

Kino

`Email: 992276678@qq.com/ kinoandworld@gmail.com`

`Weibo: http://weibo.com/u/1878504510`

contact me if had any quetion .
