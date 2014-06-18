//
//  Y6ProgressiveScrollView.h
//
//
//  Created by Ysix on 28/05/2014.
//
//

#import <UIKit/UIKit.h>


@protocol Y6ProgressiveScrollViewDelegate <NSObject>

- (void)updateObject:(id)object withUserInfos:(id)userInfos forFlag:(unsigned int)flag;
- (void)updateObject:(id)object fromPreviousUserInfos:(id)previousUserInfos atProgressionPercent:(float)percent toNextUserInfos:(id)nextUserInfos forFlag:(unsigned int)flag;

@end

@interface Y6ProgressiveScrollView : UIScrollView
{
	id<Y6ProgressiveScrollViewDelegate>	progressionDelegate;
	NSMapTable		*objectsDict;

	BOOL	referenceOffsetIsY;

	NSMutableDictionary *extensionBlocks;
}

@property (nonatomic, strong)	id<Y6ProgressiveScrollViewDelegate>	progressionDelegate;
@property (nonatomic) BOOL	referenceOffsetIsY;

@property (nonatomic, strong, readonly) UIPageControl *pageControl;

- (BOOL)addExtensionBlocksForSoloOffset:(void (^)(id object, id userInfos))soloBlock andBetweenOffset:(void (^)(id object, id previousUserInfos, float progressionPercent, id nextUserInfos))betweenBlock forFlag:(unsigned int)flag;

- (BOOL)setUserInfos:(id)userInfos forObject:(id)object withFlag:(unsigned int)flag atOffsetValue:(CGFloat)offset;

@end
