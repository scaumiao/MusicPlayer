//
//  ViewController.m
//  音乐播放界面
//
//  Created by 许汝邈 on 15/9/30.
//  Copyright © 2015年 miao. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "FetchDataFromNet.h"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
@interface MusicPlayerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentRow;
}
@end

@implementation MusicPlayerViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _musicPlayerView = [[MusicPlayerView alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height)];
                
        _timeArray = [[NSMutableArray alloc] init];
        _wordArray = [[NSMutableArray alloc] init];
        
        
        NSString *urlStr = @"http://101.4.136.6:9999/m2.music.126.net/XYVgKjLVhUz4E3Xzx6g1NA==/7957165651774040.mp3";
        NSURL *url = [[NSURL alloc]initWithString:urlStr];
        NSData * audioData = [NSData dataWithContentsOfURL:url];
        
        //将数据保存到本地指定位置
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
        [audioData writeToFile:filePath atomically:YES];
        
        //播放本地音乐
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        
        //_totalPlaybackTime.text = [self strWithTime:_player.duration];//duration为总时长
        _musicPlayerView.totalPlaybackTime.text = [self strWithTime:_player.duration];//duration为总时长
        
        
        [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
        
        
        [self getLyric:@"385544"];
        
        _musicPlayerView.noLrcTableView.delegate = self;
        _musicPlayerView.noLrcTableView.dataSource = self;
        [_musicPlayerView.progress addTarget:self action:@selector(processChanged) forControlEvents:UIControlEventValueChanged];
        [_musicPlayerView.playButton addTarget:self action:@selector(playButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_musicPlayerView];
    }
    return self;
}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    
//    _timeArray = [[NSMutableArray alloc] init];
//    _wordArray = [[NSMutableArray alloc] init];
//    
//    
//    _currentPlaybackTime = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 50, 25)];
//    _currentPlaybackTime.font =[UIFont boldSystemFontOfSize:14.0f];
//    _currentPlaybackTime.textAlignment = NSTextAlignmentCenter;
//    _currentPlaybackTime.textColor = [UIColor blackColor];
//    _currentPlaybackTime.text = @"00:00";
//    [self.view addSubview:_currentPlaybackTime];
//    
//    //设置slider的高度为手指能触摸到的高度即可
//    progress = [[UISlider alloc] initWithFrame:CGRectMake(_currentPlaybackTime.frame.size.width+_currentPlaybackTime.frame.origin.x, 20,self.view.frame.size.width-110,  25)];
//    progress.continuous = YES;
//    progress.minimumTrackTintColor = [UIColor colorWithRed:244.0f/255.0f green:147.0f/255.0f blue:23.0f/255.0f alpha:1.0f];
//    progress.maximumTrackTintColor = [UIColor lightGrayColor];
//    [progress setThumbImage:[UIImage imageNamed:@"player-progress-point-h"] forState:UIControlStateNormal];
//    //        [progress setThumbImage:nil forState:UIControlStateNormal];
//    [progress addTarget:self action:@selector(processChanged) forControlEvents:UIControlEventValueChanged];
//    
//    
//    [self.view addSubview:progress];
//    
//    
//    
//    
//    _totalPlaybackTime = [[UILabel alloc] initWithFrame:CGRectMake(progress.frame.size.width+progress.frame.origin.x, 20, 50, 25)];
//    _totalPlaybackTime.font =[UIFont boldSystemFontOfSize:14.0f];
//    _totalPlaybackTime.textAlignment = NSTextAlignmentCenter;
//    _totalPlaybackTime.textColor = [UIColor blackColor];
//    _totalPlaybackTime.text = @"00:00";
//    [self.view addSubview:_totalPlaybackTime];
//    
//    
//    
//    
//    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _playButton.frame = CGRectMake(self.view.frame.size.width/2-64/2,self.view.frame.size.height-64-10, 64, 64);
//    [_playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
//    [_playButton setImage:[UIImage imageNamed:@"playHight.png"] forState:UIControlStateHighlighted];
//    [_playButton addTarget:self action:@selector(playButtonEvent) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_playButton];
//    
//    
//    _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _preButton.frame = CGRectMake(_playButton.frame.origin.x-60, _playButton.frame.origin.y+8, 48, 48);
//    [_preButton setImage:[UIImage imageNamed:@"preSong.png"] forState:UIControlStateNormal];
//    // [_preButton addTarget:self action:@selector(preButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_preButton];
//    
//    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _nextButton.frame = CGRectMake(_playButton.frame.origin.x+70, _playButton.frame.origin.y+8, 48, 48);
//    [_nextButton setImage:[UIImage imageNamed:@"nextSong.png"] forState:UIControlStateNormal];
//    //[_nextButton addTarget:self action:@selector(nextButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_nextButton];
//    
//    
//    _playbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _playbackButton.frame =  CGRectMake(5, _preButton.frame.origin.y, 48, 48);
//    [_playbackButton setImage:[UIImage imageNamed:@"order.png"] forState:UIControlStateNormal];
//    //  [_playbackButton addTarget:self action:@selector(playBackButtonEvent) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_playbackButton];
//    //    isPlayBack = 0;
//    
//    
//    
//    
//    
//    _playListButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _playListButton.frame =  CGRectMake(self.view.frame.size.width-48-5, _preButton.frame.origin.y, 48, 48);
//    [_playListButton setImage:[UIImage imageNamed:@"playList.png"] forState:UIControlStateNormal];
//    //  [_playListButton addTarget:self action:@selector(playListButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_playListButton];
//    
//    
//    
//    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _collectButton.frame = CGRectMake(_currentPlaybackTime.frame.origin.x, _currentPlaybackTime.frame.origin.y+_currentPlaybackTime.frame.size.height, 48, 48);
//    [_collectButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
//    //[_collectButton addTarget:self action:@selector(collectButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_collectButton];
//    
//    self.downLoadButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.downLoadButton.frame = CGRectMake(_totalPlaybackTime.frame.origin.x, _totalPlaybackTime.frame.origin.y+_totalPlaybackTime.frame.size.height, 48, 48);
//    self.downLoadButton.enabled = NO;
//    [self.downLoadButton setImage:[UIImage imageNamed:@"downLoad"] forState:UIControlStateNormal];
//    // [self.downLoadButton addTarget:self action:@selector(downLoadButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.downLoadButton];
//    
//    
//    //    noLrcLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height/2-25/2, self.view.frame.size.width, 25)];
//    //    noLrcLabel.textAlignment = NSTextAlignmentCenter;
//    //    noLrcLabel.textColor =[UIColor colorWithRed:192.0f/255.0f green:37.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
//    //    [self.view addSubview:noLrcLabel];
//    //    noLrcLabel.font = [UIFont boldSystemFontOfSize:14.0f];
//    
//    _noLrcTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.downLoadButton.frame.origin.y + self.downLoadButton.frame.size.height, self.view.frame.size.width, 300) style:UITableViewStylePlain];
//    _noLrcTableView.delegate = self;
//    _noLrcTableView.dataSource = self;
//    [self.view addSubview:_noLrcTableView];
//    
//    
//    
//    
//    NSString *urlStr = @"http://101.4.136.6:9999/m2.music.126.net/XYVgKjLVhUz4E3Xzx6g1NA==/7957165651774040.mp3";
//    NSURL *url = [[NSURL alloc]initWithString:urlStr];
//    NSData * audioData = [NSData dataWithContentsOfURL:url];
//    
//    //将数据保存到本地指定位置
//    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
//    [audioData writeToFile:filePath atomically:YES];
//    
//    //播放本地音乐
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//    
//    _totalPlaybackTime.text = [self strWithTime:_player.duration];//duration为总时长
//    
//    
//    
//    [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
//    
//    
//    [self getLyric:@"385544"];
//    
//    
//    
//    
//    
//}

-(void)playButtonEvent
{
    if (isPlaying) {
        [_player pause];
        isPlaying = NO;
        [_musicPlayerView.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
       // [_playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        
    }
    else
    {
        [_musicPlayerView.playButton setImage:[UIImage imageNamed:@"pasue.png"] forState:UIControlStateNormal];
        //[_playButton setImage:[UIImage imageNamed:@"pasue.png"] forState:UIControlStateNormal];
        isPlaying = YES;
        [_player play];
        
    }
    NSLog(@"click");
}

/**
 *把时间长度-->时间字符串
 */
-(NSString *)strWithTime:(NSTimeInterval)time
{
    int minute=time / 60;
    int second=(int)time % 60;
    return [NSString stringWithFormat:@"%d:%d",minute,second];
}


#pragma mark - 滑动条事件
-(void)processChanged
{
//    [_player setCurrentTime:progress.value*_player.duration];
      [_player setCurrentTime:_musicPlayerView.progress.value*_player.duration];
}
#pragma mark - 计时器事件
//计算滑动条的长度以及更改当前时间显示
-(void)updateSliderValue
{
    _musicPlayerView.progress.value = _player.currentTime/_player.duration;
    _musicPlayerView.currentPlaybackTime.text = [self strWithTime:_player.currentTime];
    
    //处理歌词
    CGFloat currentTime = _player.currentTime;
    for (int i = 0; i < _timeArray.count; i ++) {
        
        NSArray *arr = [_timeArray[i] componentsSeparatedByString:@":"];
        
        CGFloat compTime = [arr[0] integerValue]*60 + [arr[1] floatValue];
        
        if (_player.currentTime > compTime)
        {
            currentRow = i;
        }
        else
        {
            break;
        }
    }
    
    [_musicPlayerView.noLrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [_musicPlayerView.noLrcTableView reloadData];
}


#pragma mark - 获取歌词
-(void)getLyric:(NSString *)number{
    
    [FetchDataFromNet fetchMusicData:number page:1 callback:^(NSString *stringItem, NSInteger page, NSError *error){
        if (error) {
            NSLog(@"error = %@",error);
        } else{
            
            [self parselyric:stringItem];
            
        }
        
    }];
    
    
}


#pragma mark - 解析歌词
-(void)parselyric:(NSString *)lyric
{
    
    NSArray *sepArray = [lyric componentsSeparatedByString:@"["];
    for (int i = 1; i < sepArray.count; i++) {
        NSArray *arr = [sepArray[i] componentsSeparatedByString:@"]"];
        [_timeArray addObject:arr[0]];
        [_wordArray addObject:arr[1]];
        
    }
    
}



#pragma mark - tableview协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_wordArray count];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    //重定位符
    //    static NSString * str = @"cell";
    //    //取出队列中的cell
    //    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    //    //如果cell为null ，则创建新的cell
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    //    }
    //
    //    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",_timeArray[indexPath.row],_wordArray[indexPath.row]];
    //    return cell;
    
    
    
    UITableViewCell *cell;
    UILabel *label =nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell ==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        CGFloat size = label.font.pointSize;
        [label setMinimumScaleFactor:FONT_SIZE/size];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        [[cell contentView]addSubview:label];
        
    }
    
    NSString *text = [_wordArray objectAtIndex:[indexPath row]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN *2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    if (!label)
        label = (UILabel*)[cell viewWithTag:1];
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN *2), MAX(size.height, 44.0f))];
    label.textAlignment = NSTextAlignmentCenter;
    
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",_wordArray[indexPath.row]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    NSString *text = [_wordArray objectAtIndex:[indexPath row]];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN *2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height =MAX(size.height, 44.0f);
    return height + (CELL_CONTENT_MARGIN *2);
}
@end
