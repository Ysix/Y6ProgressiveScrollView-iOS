//
//  Y6ProgressiveScrollView+Alpha.m
//
//
//  Created by Ysix on 13/06/2014.
//
//

#import "Y6ProgressiveScrollView+Alpha.h"

@implementation Y6ProgressiveScrollView (Alpha)

- (BOOL)activeAlphaExtension
{
	return [self addExtensionBlocksForSoloOffset:^(id object, id userInfos) {

		[object setAlpha:[[userInfos objectForKey:@"alpha"] floatValue]];

	} andBetweenOffset:^(id object, id previousUserInfos, float progressionPercent, id nextUserInfos) {

		CGFloat previousAlpha = [[previousUserInfos objectForKey:@"alpha"] floatValue];
		CGFloat nextAlpha = [[nextUserInfos objectForKey:@"alpha"] floatValue];

		[object setAlpha:previousAlpha + (nextAlpha - previousAlpha) * progressionPercent / 100];

	} forFlag:FLAG_ALPHA];
}

- (BOOL)setAlpha:(CGFloat)alpha forObject:(id)object atOffsetValue:(CGFloat)offset
{
	if (![object isKindOfClass:[UIView class]])
		return NO;

	NSDictionary *userInfos = @{@"alpha" : [NSNumber numberWithFloat:alpha]};

	return [self setUserInfos:userInfos forObject:object withFlag:FLAG_ALPHA atOffsetValue:offset];
}

@end
