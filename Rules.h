//
//  Rules.h
//  CoreText
//
//  Created by Matthys Strydom on 2011/02/07.
//  Copyright 2011 Polymorph Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

// This struct contains all the derived information required to draw the card.
struct DrawingParameters{
	float TextBoxHeight;
	float TextBoxWidth;
	int FontSize;
	CTFramesetterRef Framesetter;
};

// The protocol defines the methods required for a rule that can be used to change the decision making process
// for fitting all content onto the card.
@protocol IRule

// This method will adjust the parameter set in anyway that the rule requires
-(struct DrawingParameters) adjustParameters:(struct DrawingParameters)par;
// This method is queried to see if further adjustments can be made, or whether the maximum has been reached.
// This will be called AFTER adjust parameters (ie. adjust parameters will always be called at least once.)
-(bool) canMakeFurtherAdjustment:(struct DrawingParameters)par;

@end

@interface DefaultSettingRule : NSObject <IRule> {

}

@end

@interface ReduceFontSizeRule : NSObject <IRule>
{
    @private int MinFontSize;
	@private int FontReductionInterval;
}

-(ReduceFontSizeRule*) init:(int)minSize:(int)interval;

@end
