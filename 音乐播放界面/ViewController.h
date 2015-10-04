//
//  ViewController.h
//  音乐播放界面
//
//  Created by 许汝邈 on 15/9/30.
//  Copyright © 2015年 miao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayerViewController.h"

@interface ViewController : UIViewController


@property(strong,nonatomic)MusicPlayerViewController *musicPlayerVC;

- (IBAction)nextVC:(id)sender;

@end

