//
//  Y6ProgressiveScrollView+Y6HighlightSpotView.m
//
//
//  Created by Ysix on 12/06/2014.
//
//

#import "Y6ProgressiveScrollView+Y6HighlightSpotView.h"

@implementation Y6ProgressiveScrollView (Y6HighlightSpotView)

- (BOOL)activeHighlightSpotViewExtension
{
	return [self addExtensionBlocksForSoloOffset:^(id object, id userInfos) {

		[(Y6HighlightSpotView *)object	highlightPoint:CGPointFromString([userInfos objectForKey:@"point"]) withCirleRadius:[[userInfos objectForKey:@"radius"] floatValue] coveringRect:CGRectFromString([userInfos objectForKey:@"frame"])];

	} andBetweenOffset:^(id object, id previousUserInfos, float progressionPercent, id nextUserInfos) {

		Y6HighlightSpotView *spotView = object;

		CGPoint previousPoint = CGPointFromString([previousUserInfos objectForKey:@"point"]);
		CGPoint nextPoint = CGPointFromString([nextUserInfos objectForKey:@"point"]);

		CGFloat previousRadius = [[previousUserInfos objectForKey:@"radius"] floatValue];
		CGFloat nextRadius = [[nextUserInfos objectForKey:@"radius"] floatValue];

		CGRect previousFrame = CGRectFromString([previousUserInfos objectForKey:@"frame"]);
		CGRect nextFrame = CGRectFromString([nextUserInfos objectForKey:@"frame"]);

		[spotView highlightPoint:CGPointMake(previousPoint.x + (nextPoint.x - previousPoint.x) * progressionPercent / 100,
											 previousPoint.y + (nextPoint.y - previousPoint.y) * progressionPercent / 100)
				 withCirleRadius:previousRadius + (nextRadius - previousRadius) * progressionPercent / 100
					coveringRect:CGRectMake(previousFrame.origin.x + (nextFrame.origin.x - previousFrame.origin.x) * progressionPercent / 100,
											previousFrame.origin.y + (nextFrame.origin.y - previousFrame.origin.y) * progressionPercent / 100,
											previousFrame.size.width + (nextFrame.size.width - previousFrame.size.width) * progressionPercent / 100,
											previousFrame.size.height + (nextFrame.size.height - previousFrame.size.height) * progressionPercent / 100)];

	} forFlag:FLAG_HIGHLIGHT_SPOT_VIEW];
}

- (BOOL)sethighlightPoint:(CGPoint)highlightedPoint withCirleRadius:(CGFloat)radius coveringRect:(CGRect)frame forHighlightSpot:(Y6HighlightSpotView *)spotView atOffsetValue:(CGFloat)offset
{
	if (![spotView isKindOfClass:[Y6HighlightSpotView class]])
		return NO;

	NSDictionary *userInfos = @{@"point" : NSStringFromCGPoint(highlightedPoint), @"radius" : [NSNumber numberWithFloat:radius], @"frame" : NSStringFromCGRect(frame)};

	return [self setUserInfos:userInfos forObject:spotView withFlag:FLAG_HIGHLIGHT_SPOT_VIEW atOffsetValue:offset];
}


@end
