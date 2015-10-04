//
//  ViewController.m
//  音乐播放界面
//
//  Created by 许汝邈 on 15/9/30.
//  Copyright © 2015年 miao. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    
//   self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
//    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
//    self.navigationController.navigationBarHidden = NO;
   
//    //[self.view addSubview:_musicPlayerVC.view];
    
   
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.titleLabel.text = @"跳转";
    [self.view addSubview:btn];
    
}



- (IBAction)selectLeftAction:(id)sender {
     _musicPlayerVC = [[MusicPlayerViewController alloc] init];
   
    NSLog(@"%f",_musicPlayerVC.view.frame.origin.y);
    [self.navigationController pushViewController:_musicPlayerVC animated:true];
    
}
@end
