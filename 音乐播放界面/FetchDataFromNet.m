//
//  FetchDataFromNet.m
//  MusicApp
//
//  Created by 许汝邈 on 15/10/3.
//  Copyright © 2015年 miao. All rights reserved.
//

#import "FetchDataFromNet.h"

//定义网络路径
#define url @"http://music.163.com/api/song/lyric"
//?os=pc&id=93920&lv=-1&kv=-1&tv=-1"
//定义可以获取的歌曲数
#define kLimit 10
@implementation FetchDataFromNet
+ (void)fetchMusicData:(NSString *)key page:(NSInteger)page callback:(fetchTrackDataAndError)callback{
    
    NSURL *musicURL = [NSURL URLWithString:url];
    //创建该路径下的请求，用来设置http头部中的参数和方法类型
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:musicURL];
    
    [request setValue:@"deflate,gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"http://music.163.com/" forHTTPHeaderField:@"Referer"];
    [request setValue:@"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)" forHTTPHeaderField:@"User-Agent"];
    NSLog(@"%@",request);
    [request setHTTPMethod:@"POST"];
    
    NSString *bodyString = [NSString stringWithFormat:@"os=pc&id=%@&lv=-1&kv=-1&tv=-1",key];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    //发送同步请求
    @try {
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
        NSString *itemString = [[itemDictionary objectForKey:@"lrc"] objectForKey:@"lyric"];
        callback(itemString,page,nil);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    
    /*
    //建立网络链接，发送异步请求；
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            callback(nil,page,connectionError);
        } else{
            //创建一个可变数组，用来存放解析后的歌曲
            
            NSString *itemString;
            @try {
                //创建一个字典用来存储json格式解析后的数据
                NSDictionary *itemDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
                //NSLog(@"%@",itemDictionary);
                
                itemString = [[itemDictionary objectForKey:@"lrc"] objectForKey:@"lyric"];
                
                //调用回调方法，将歌曲传给array
                callback(itemString,page,nil);
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
              
                
            }
        }
    }];
    */
}

@end
