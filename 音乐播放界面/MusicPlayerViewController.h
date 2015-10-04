//
//  MusicPlayerViewController.h
//  音乐播放界面
//
//  Created by 许汝邈 on 15/10/4.
//  Copyright © 2015年 miao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicPlayerView.h"
@interface MusicPlayerViewController : UIViewController
{
    BOOL isPlaying;
}
@property(strong,nonatomic)MusicPlayerView *musicPlayerView;
//{
//    UILabel *_currentPlaybackTime;//当前播放时间
//    UISlider *progress;//进度条
//    UILabel *_totalPlaybackTime;//结束时间
//    UIButton *_playButton;//开始播放按钮
//    UIButton *_preButton;//前一首按钮
//    UIButton *_nextButton;//后一首按钮
//    UIButton *_playbackButton;//单曲循环按钮
//    UIButton *_playListButton;//歌单列表按钮
//    UIButton * _collectButton;//星标按钮
//    // UILabel * noLrcLabel;//歌词
//    
//    BOOL isPlaying;
//    
//    
//}
//
//@property(strong,nonatomic)UITableView *noLrcTableView;
//
//时间
@property (nonatomic,strong)NSMutableArray *timeArray;

//歌词
@property (nonatomic,strong)NSMutableArray *wordArray;
//
//
//@property (nonatomic,strong) UIButton * downLoadButton;
//
@property(nonatomic,strong)AVAudioPlayer *player;
//
////定时器
@property(nonatomic,strong)NSTimer *CurrentTimeTimer;

-(void)getLyric:(NSString *)number;
-(void)parselyric:(NSString *)lyric;
@end
