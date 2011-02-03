//
//  CoreTextViewController.h
//  CoreText
//
//  Created by Matthys Strydom on 2011/01/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTCardView.h"

@interface CoreTextViewController : UIViewController {
	CTCardView *cardView;
}

@property (nonatomic, retain) IBOutlet CTCardView *cardView;

@end

