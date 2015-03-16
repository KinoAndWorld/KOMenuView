# KOMenuView

***

This is a simple Menu View On One's View Bottom.

![Screenshot](https://cloud.githubusercontent.com/assets/1878740/5596864/2269a630-927f-11e4-8d3b-aa58ef0e3b8e.png) 

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


### License

`KOMenuView` is released under the MIT license.

### Author

Kino
Email: 992276678@qq.com/ kinoandworld@gmail.com
Weibo: http://weibo.com/u/1878504510
contact me if had any quetion .
