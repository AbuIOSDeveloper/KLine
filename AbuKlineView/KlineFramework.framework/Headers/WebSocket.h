//
//  WebSocket.h
//  WebSocket
//
//  Created by jefferson on 2018/7/9.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol webSocketDelegate <NSObject>

@optional

- (void)socketConnected;
- (void)resKlineList:(NSDictionary *_Nullable)dict;
- (void)refreshKline:(NSDictionary *_Nullable)dict;

@end

@interface WebSocket : NSObject


+(WebSocket *_Nonnull)shareWebSocketManage;

- (void)connectWebServiceWithURL:(NSString *_Nullable)url;

- (void)reConnect;

-(void)SocketClose;

@property (nonatomic, weak) id<webSocketDelegate> delegate;


@end
