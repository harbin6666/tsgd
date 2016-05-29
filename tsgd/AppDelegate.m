//
//  AppDelegate.m
//  tsgd
//
//  Created by yuan jun on 15/1/15.
//  Copyright (c) 2015年 new. All rights reserved.
//

#import "AppDelegate.h"
#import "TodoVC.h"
#import "DoneVC.h"
#import "SearchVC.h"
@interface AppDelegate ()
@property(nonatomic,strong)TodoVC *vc1;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.vc1 = [[TodoVC alloc]init];
    UINavigationController *nc1 = [[UINavigationController alloc]initWithRootViewController:self.vc1];
    nc1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"待办工单" image:[UIImage imageNamed:@"item1"] tag:0];//[UIImage imageNamed:@"backlog_normal"] tag:0];
    
    
    DoneVC *vc3 = [[DoneVC alloc]init];
    UINavigationController *nc3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    nc3.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"已办工单" image:[UIImage imageNamed:@"item2"] tag:0];//[UIImage
    
    SearchVC *vc4 = [[SearchVC alloc]init];
    UINavigationController *nc4 = [[UINavigationController alloc]initWithRootViewController:vc4];
    nc4.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"查询工单" image:[UIImage imageNamed:@"item3"] tag:0];
    
    self.tabbarController = [[UITabBarController alloc]init];
    self.tabbarController.viewControllers = @[nc1, nc3, nc4];
    
    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tab_bg_main_pressed"]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    
    [self.tabbarController.tabBar setTintColor:[UIColor colorWithRed:57.0/255 green:237.0/255 blue:231.0/255 alpha:1.0]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"topbar"] forBarMetrics:UIBarMetricsDefault];
    //    [[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
    
    //    UITabBarItem *item = [self.tabbarController.tabBar.items objectAtIndex:0];
    //    item.image = [UIImage imageNamed:@"backlog_normal"];
    
    self.window.rootViewController = self.tabbarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]){
        UIAlertView*aler=[[UIAlertView alloc] initWithTitle:@"手机已经越狱，app使用环境有风险！" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [aler show];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
