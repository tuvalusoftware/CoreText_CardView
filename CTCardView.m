//
//  CTCardView.m
//  CoreText
//
//  Created by Matthys Strydom on 2011/01/24.
//  Copyright 2011 Polymporph Systems. All rights reserved.
//

#import "CTCardView.h"
#import <CoreText/CoreText.h>
#import "CardDefinition.h"
#import "Rules.h"

@implementation CTCardView

@synthesize Message;
@synthesize CardDefinition;
@synthesize RuleList;

-(void)fillRuleList {
	// The first rule does nothing to any parameters and sees if the text fits.
	id defaultRule = [[DefaultSettingRule alloc] init];
	// The second rule is to reduce the font until the text fits.
	id fontRule = [[ReduceFontSizeRule alloc] init:self.CardDefinition.MinFontSize:1];
	self.RuleList = [NSArray arrayWithObjects:defaultRule, fontRule, nil];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder {
    if ((self = [super initWithCoder:coder])) {
        // Initialization code
		self.contentMode = UIViewContentModeRedraw;
	}
    return self;
}

// Creates a framesetter, using the given font size.
-(CTFramesetterRef)createFrameSetter:(int)fontSize{
	CTFontRef realFont = CTFontCreateWithFontDescriptor(self.CardDefinition.Font, fontSize, NULL);
	CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(NULL, [Message length]);
	CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), (CFStringRef) Message);
	CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, realFont);
	CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTForegroundColorAttributeName, self.CardDefinition.FontColor);
	return CTFramesetterCreateWithAttributedString(attrStr);
}

// Goes through the list of rules, until it the text finally fits into the given parameters.
// IMPLICIT LOGIC WARNING: The initial width and height that the method is called with
// is taken to be the maximum bounds.
- (struct DrawingParameters)AdaptParametersAccordingToRules:(struct DrawingParameters)par{
	float maxHeight = par.TextBoxHeight;
	float maxWidth = par.TextBoxWidth;
	CGSize constraints = CGSizeMake(maxWidth, maxHeight);
	int messageLength = [Message length];
	CFRange fullRange = CFRangeMake(0, messageLength);
	
	NSLog(@"Starting to loop through rules: Number of rules: %i", [self.RuleList count]);
	// Go through the rules and see what adjustments can be made.
	for (id object in self.RuleList) {
	    id <IRule> rule = (<IRule>)object;
		CFRange range;
		bool canMakeAdjustment = YES;
		while (canMakeAdjustment) {
			par = [rule adjustParameters:par];
			par.Framesetter = [self createFrameSetter:par.FontSize];
			CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(par.Framesetter, fullRange, nil, constraints, &range);
			if (range.length >= messageLength)
			{
				NSLog(@"Rule succeeded!");
				par.TextBoxHeight = coreTextSize.height;
				par.TextBoxWidth = coreTextSize.width;
				return par;
			}
			canMakeAdjustment = [rule canMakeFurtherAdjustment:par];
			NSLog(@"Rule did not succeed. Making further adjustments? %i", canMakeAdjustment);
		}
	}
	[NSException raise:@"Got to end of rule set. Temp setback" format:@"blah"];
	return par;
	

	/*
	// Rule one: Try the framesetter as is, and see if it fits.
	CFRange range;
	CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(par.Framesetter, CFRangeMake(0, messageLength), nil, constraints, &range);
	if (range.length >= messageLength) {
		par.TextBoxHeight = coreTextSize.height;
		par.TextBoxWidth = coreTextSize.width;
	}
	else {
		[NSException raise:@"Got to end of rule set. Temp setback" format:@"blah"];
	}

	return par;
	*/
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Init the rule list if it has not been done
	if (RuleList == nil) {
		[self fillRuleList];
	}
	
	[[UIColor whiteColor] set];
	CGContextRef context = (CGContextRef)UIGraphicsGetCurrentContext();
	
	// Fill in the initial parameters of the card to be checked for fitting by the rule system.
	struct DrawingParameters par;
	par.TextBoxHeight = self.CardDefinition.MaxCardHeight-self.CardDefinition.TopMargin - self.CardDefinition.BottomMargin;
	par.TextBoxWidth = self.CardDefinition.CardWidth-self.CardDefinition.LeftMargin - self.CardDefinition.RightMargin;
	par.FontSize = self.CardDefinition.MaxFontSize;
	par.Framesetter = [self createFrameSetter:self.CardDefinition.MaxFontSize];
	
	// We then pass the drawing parameters to the rules system, getting the final result back.
	par = [self AdaptParametersAccordingToRules:par];

	float cardHeight = par.TextBoxHeight;
	if (self.CardDefinition.MinCardHeight - self.CardDefinition.TopMargin - self.CardDefinition.BottomMargin > cardHeight) {
		cardHeight = self.CardDefinition.MinCardHeight - self.CardDefinition.TopMargin - self.CardDefinition.BottomMargin;
	}
	
	// Work out the dimentions of all the elements involved.
	float totalHeight= rect.size.height; 
	float totalWidth = rect.size.width;
	CGRect pageSize = CGRectMake(0, 0, totalWidth, totalHeight);
	
	float cardDeltaX = (totalWidth - par.TextBoxWidth - self.CardDefinition.LeftMargin - self.CardDefinition.RightMargin) / 2;
	float cardDeltaY = (totalHeight - cardHeight - self.CardDefinition.TopMargin - self.CardDefinition.BottomMargin) / 2;
	CGRect cardSize = CGRectInset(pageSize, cardDeltaX, cardDeltaY);

	float minCardDeltaX = (totalWidth - par.TextBoxWidth - self.CardDefinition.LeftMargin - self.CardDefinition.RightMargin) / 2;
	float minCardDeltaY = (totalHeight - par.TextBoxHeight - self.CardDefinition.TopMargin - self.CardDefinition.BottomMargin) / 2;
	CGRect minCardSize = CGRectInset(pageSize, minCardDeltaX, minCardDeltaY);
	
	CGRect textRect = CGRectMake(minCardSize.origin.x+self.CardDefinition.LeftMargin,
								 minCardSize.origin.y+self.CardDefinition.BottomMargin,
								 par.TextBoxWidth, par.TextBoxHeight);
	
	/*
	float textDeltaX = (totalWidth - par.TextBoxWidth) / 2;
	float textDeltaY = (totalHeight - par.TextBoxHeight) / 2;
	CGRect textRect = CGRectInset(pageSize, textDeltaX, textDeltaY);
	*/

	// Translate the coordinates to work for text drawing. Google this :)
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
	
	//Draw a rectangle
	CGContextSetFillColorWithColor(context, self.CardDefinition.CardColor);
	//Define a rectangle
	CGContextAddRect(context, cardSize);
	//Draw it
	CGContextFillPath(context);

	// Comment this back in to see where the min card rectangle ends up. In other words check if margins are correct.
	CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
	CGContextAddRect(context, minCardSize);
	CGContextFillPath(context);
	
	// Comment this back in to see where the text rectangle ends up.
	CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
	CGContextAddRect(context, textRect);
	CGContextFillPath(context);
	 
	// Draw the text.
    [UIBezierPath bezierPathWithRect:[self bounds]];
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, textRect);
	CTFrameRef frame = CTFramesetterCreateFrame(par.Framesetter, CFRangeMake(0, 0), path, NULL);
	CTFrameDraw(frame, context);

	//CFRelease(frame);
    //CFRelease(finalPath);
}

- (void)dealloc {
	[CardDefinition release];
	[Message release];
	
    [super dealloc];
}


@end
