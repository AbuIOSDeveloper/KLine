# FHHFPSIndicator

Installation
==============
### CocoaPods【使用CocoaPods】

1. Add `pod "FHHFPSIndicator"` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<FHHFPSIndicator/FHHFPSIndicator.h\>.

### Manually【手动导入】
1. Drag all source files under floder `FHHFPSIndicator` to your project.【将`FHHFPSIndicator`文件夹中的所有源代码拽入项目中】
2. Import the main header file：`#import "FHHFPSIndicator.h"`【导入主头文件：`#import "FHHFPSIndicator.h"`】

###Instruction
you shoud call `[FHHFPSIndicator sharedFPSIndicator] show]` after the keyWindw becomes keyAndVisible;【在[window makeKeyAndVisible]之后调用`[FHHFPSIndicator sharedFPSIndicator]`】

Advice:Use FHHFPSIndicator in DEBUG mode【建议在DEBUG模式下使用】


Demo Project
==============
See `Demo/FHHFPSIndicatorDemo`

add the code in AppDelegate.m 

<pre>
#if defined(DEBUG) || defined(_DEBUG)
#import "FHHFPSIndicator.h"
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    // add the follwing code after the window become keyAndVisible
    #if defined(DEBUG) || defined(_DEBUG)
        [[FHHFPSIndicator sharedFPSIndicator] show];
//        [FHHFPSIndicator sharedFPSIndicator].fpsLabelPosition = FPSIndicatorPositionTopRight;
    #endif
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    
    return YES;
}

</pre>

<img src="https://raw.githubusercontent.com/jvjishou/FHHFPSIndicator/master/Demo/Snapshots/snapshot1.PNG" width="320"><br/>

<img src="https://raw.githubusercontent.com/jvjishou/FHHFPSIndicator/master/Demo/Snapshots/snapshot2.PNG" width="320"><br/>

<img src="https://raw.githubusercontent.com/jvjishou/FHHFPSIndicator/master/Demo/Snapshots/snapshot3.PNG" width="320"><br/>

<img src="https://raw.githubusercontent.com/jvjishou/FHHFPSIndicator/master/Demo/Snapshots/snapshot4.PNG" width="320"><br/>

License
==============
FHHFPSIndicator is provided under the MIT license. See LICENSE file for details.