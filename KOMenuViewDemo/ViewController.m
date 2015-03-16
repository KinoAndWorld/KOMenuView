//
//  ViewController.m
//  KOMenuViewDemo
//
//  Created by kino on 15/3/16.
//  Copyright (c) 2015年 kino. All rights reserved.
//

#import "ViewController.h"
#import "KOMenuView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) KOMenuView *blurMenuView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _blurMenuView = [KOMenuView menuViewWithItem:@[@"Menu 01",@"Menu 02",@"Menu 03",@"Menu 04",@"Menu 05"]
                                   withPlaceView:self.view
                                withClickByIndex:^(NSInteger itemIndex) {
                                    NSLog(@"itemIndex : %ld",(long)itemIndex);
                                }];
    _blurMenuView.foldMenuWhenClickItem = YES;  ///fold menu automatically when select item,default NO
    _blurMenuView.animaDuration = 0.3;          ///animation duration, default 0.25
    
    
    
    [self.view addSubview:_blurMenuView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor colorWithRed:0.12 * indexPath.row green:0.8 blue:0.9 alpha:1.0];
    
    cell.textLabel.text = [NSString stringWithFormat:@"PlaceHolder Text : %ld",(long)indexPath.row];
    return cell;
}


@end
