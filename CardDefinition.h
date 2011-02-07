//
//  CardDefinition.h
//  CoreText
//
//  Created by Matthys Strydom on 2011/01/25.
//  Copyright 2011 Polymorph Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CardDefinition : NSObject {
	@private int PageHeight;
	@private int PageWidth;
	@private CGColorRef CardColor;
	@private CGColorRef BackgroundColor;
	@private int MaxCardHeight;
	@private int MinCardHeight;
	@private int DefaultCardHeight;
	@private int DistanceToMid;
	@private int RightMargin;
	@private int LeftMargin;
    @private int TopMargin;
    @private int BottomMargin;
	@private int CardWidth;
	@private NSString* TextOverflow;
	@private CTFontDescriptorRef Font;
	@private CGColorRef FontColor;
	@private int MaxFontSize;
	@private int MinFontSize;
	
}

@property int PageHeight;
@property int PageWidth;
@property CGColorRef CardColor;
@property CGColorRef BackgroundColor;
@property int MaxCardHeight;
@property int MinCardHeight;
@property int DefaultCardHeight;
@property int DistanceToMid;
@property int RightMargin;
@property int LeftMargin;
@property int TopMargin;
@property int BottomMargin;
@property int CardWidth;
@property (retain) NSString* TextOverflow;
@property CTFontDescriptorRef Font;
@property CGColorRef FontColor;
@property int MaxFontSize;
@property int MinFontSize;

/* Things to add still
 @property image CardBackgroundImage;
  @property image BackgroundImage;
 
 */

@end
