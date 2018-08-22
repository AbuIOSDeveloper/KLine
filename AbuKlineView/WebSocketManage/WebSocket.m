//
//  WebSocket.m
//  WebSocket
//
//  Created by jefferson on 2018/7/9.
//  Copyright © 2018年 jefferson. All rights reserved.
//

#import "WebSocket.h"


#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface WebSocket()<SRWebSocketDelegate>

@property (nonatomic, retain) SRWebSocket *socket;
@property (nonatomic, assign) BOOL isErrorLink;
@property (nonatomic, assign) BOOL isDisconnect; 
@property (nonatomic, strong) NSDictionary *responseDict;

@property (nonatomic, assign) NSTimeInterval reConnectTime;;

@property (nonatomic, copy)   NSString * _Nullable url;

@property (nonatomic, assign) BOOL isConnect;

@property (nonatomic, strong) NSTimer * heartBeat;

@property (nonatomic, copy) void(^ _Nullable connected)(BOOL connectSuccess);

@end


@implementation WebSocket

static WebSocket * webSocket;

+(WebSocket *)shareWebSocketManage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (webSocket == nil) {
            webSocket = [[self alloc] init];
        }
    });
    return webSocket;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (webSocket == nil) {
            webSocket = [super allocWithZone:zone];
        }
    });
    return webSocket;
}

- (id)copy{
    return self;
}

- (id)mutableCopy{
    return self;
}

- (void)connectWebServiceWithURL:(NSString *)url
{
    if (self.socket) {
        return;
    }
    if (url.length == 0) {
        return;
    }
    self.url = url;
    self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    self.socket.delegate = self;
    [self.socket open];
    
}


-(void)sentheart{

}




- (void)initHeartBeat
{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        _heartBeat = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_heartBeat forMode:NSRunLoopCommonModes];
    })
}

- (void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (_heartBeat) {
            if ([_heartBeat respondsToSelector:@selector(isValid)]){
                if ([_heartBeat isValid]){
                    [_heartBeat invalidate];
                    _heartBeat = nil;
                }
            }
        }
    })
}

- (void)ping{
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}
- (void)reConnect
{
    [self SocketClose];
    
    if (self.reConnectTime > 64) {

        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self connectWebServiceWithURL:self.url];
    });

    if (self.reConnectTime == 0) {
        self.reConnectTime = 2;
    }else{
        self.reConnectTime *= 2;
    }
}

-(void)SocketClose{
    if (self.socket){
        [self.socket close];
        self.socket = nil;
        [self destoryHeartBeat];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    self.reConnectTime = 0;
    [self initHeartBeat];
    if (webSocket == self.socket) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(socketConnected)]) {
            [self.delegate socketConnected];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    if (webSocket == self.socket) {
        self.socket = nil;
        [self reConnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    if (webSocket == self.socket) {
        [self SocketClose];
    }
   
}

-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

#pragma mark ---------------------------------------------------返回信息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    if (webSocket == self.socket) {
        
    }
}

- (SRReadyState)socketReadyState{
    return self.socket.readyState;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
