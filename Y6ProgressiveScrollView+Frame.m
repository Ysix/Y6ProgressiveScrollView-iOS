//
//  Y6ProgressiveScrollView+Frame.m
//
//
//  Created by Ysix on 12/06/2014.
//
//

#import "Y6ProgressiveScrollView+Frame.h"

@implementation Y6ProgressiveScrollView (Frame)

- (BOOL)activeFrameExtension
{
	return [self addExtensionBlocksForSoloOffset:^(id object, id userInfos) {

		[object	setFrame:CGRectFromString([userInfos objectForKey:@"frame"])];

	} andBetweenOffset:^(id object, id previousUserInfos, float progressionPercent, id nextUserInfos) {

		if (([[previousUserInfos objectForKey:@"options"] integerValue] & FRAME_OPTION_PIN_AFTER) == 0)
		{
			CGRect previousFrame = CGRectFromString([previousUserInfos objectForKey:@"frame"]);
			CGRect nextFrame = CGRectFromString([nextUserInfos objectForKey:@"frame"]);

			[object setFrame:CGRectMake(previousFrame.origin.x + (nextFrame.origin.x - previousFrame.origin.x) * progressionPercent / 100,
										previousFrame.origin.y + (nextFrame.origin.y - previousFrame.origin.y) * progressionPercent / 100,
										previousFrame.size.width + (nextFrame.size.width - previousFrame.size.width) * progressionPercent / 100,
										previousFrame.size.height + (nextFrame.size.height - previousFrame.size.height) * progressionPercent / 100)];
		}

	} forFlag:FLAG_FRAME];
}

- (BOOL)setFrame:(CGRect)frame forObject:(id)object withOptions:(int)frameOptions atOffsetValue:(CGFloat)offset
{
	if (![object isKindOfClass:[UIView class]])
		return NO;

	NSDictionary *userInfos = @{@"frame" : NSStringFromCGRect(frame), @"options" : [NSNumber numberWithInt:frameOptions]};

	return [self setUserInfos:userInfos forObject:object withFlag:FLAG_FRAME atOffsetValue:offset];
}



@end
