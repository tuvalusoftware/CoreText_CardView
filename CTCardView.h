//
//  CTCardView.h
//  CoreText
//
//  Created by Matthys Strydom on 2011/01/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardDefinition.h"

@interface CTCardView : UIView {
	@private NSString* Message;
	@private CardDefinition *CardDefinition;
    @private NSArray *RuleList;
}

@property (retain) NSString* Message;
@property (retain) CardDefinition* CardDefinition;

@end
