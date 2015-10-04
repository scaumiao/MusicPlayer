//
//  FetchDataFromNet.h
//  MusicApp
//
//  Created by 许汝邈 on 15/10/3.
//  Copyright © 2015年 miao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchDataFromNet : NSObject

typedef void(^fetchTrackDataAndError)(NSString *itemString, NSInteger page, NSError *error);

+ (void)fetchMusicData:(NSString *)key page:(NSInteger)page callback:(fetchTrackDataAndError)callback;


@end
