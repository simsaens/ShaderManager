//
//  ShaderManagerDemoAppDelegate.h
//  ShaderManagerDemo
//
//  Created by Simeon Nasilowski on 29/05/11.
//  Copyright 2011 Two Lives Left. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShaderManagerDemoViewController;

@interface ShaderManagerDemoAppDelegate : NSObject <UIApplicationDelegate> 
{

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ShaderManagerDemoViewController *viewController;

@end
