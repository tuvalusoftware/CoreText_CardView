//
//  CoreTextAppDelegate.h
//  CoreText
//
//  Created by Matthys Strydom on 2011/01/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreTextViewController;

@interface CoreTextAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CoreTextViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CoreTextViewController *viewController;

@end

