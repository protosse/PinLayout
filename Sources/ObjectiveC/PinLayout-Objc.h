#import <Foundation/Foundation.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#if TARGET_OS_IOS || TARGET_OS_TV
#define PView UIView
#else
#define PView NSView
#endif

NS_ASSUME_NONNULL_BEGIN

@class PinLayoutModel;

typedef PinLayoutModel * _Nonnull (^POValue)(CGFloat value);
typedef PinLayoutModel * _Nonnull (^POVoid)(void);

@interface PinLayoutModel : NSObject

@property(nonatomic, weak) PView *view;

@property (nonatomic, copy, readonly) POValue left;

-(void)layout;
-(void)layoutAndClear;;

@end

@interface PView(Pin)

- (nonnull PinLayoutModel *)pinObj;

@property (nonatomic) PinLayoutModel * _Nullable ownLayoutModel;

@end

NS_ASSUME_NONNULL_END
