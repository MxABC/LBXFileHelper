//
//  AppDelegate.m
//  FileHelperDemo
//
//  Created by 夏利兵 on 2020/11/4.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIWindow *window;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    window.backgroundColor = [UIColor whiteColor];
    
    window.rootViewController = [[MainViewController alloc]init];
                                 
    
    [window makeKeyAndVisible];
    
    return YES;
}





@end
