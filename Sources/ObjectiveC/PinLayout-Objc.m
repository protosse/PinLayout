#import "PinLayout-Objc.h"

#if __has_include("PinLayout-Swift.h")
#import "PinLayout-Swift.h"
#else
#import <PinLayout/PinLayout-Swift.h>
#endif

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

@implementation PinLayoutModel

-(POValue)left {
    @weakify(self)
    return ^(CGFloat value){
        @strongify(self)
        [self.view.pinObjc left:value];
        return self;
    };
}

-(void)layout {
    [self.view.pinObjc layout];
}

-(void)layoutAndClear {
    [self layout];
    [self.view setOwnLayoutModel:nil];
}

@end

@implementation PView(Pin)

-(PinLayoutModel *)pinObj {
    PinLayoutModel *model = [self ownLayoutModel];
    if(!model){
        model = [PinLayoutModel new];
        model.view = self;
        [self setOwnLayoutModel:model];
    }
    return model;
}

- (PinLayoutModel *)ownLayoutModel{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOwnLayoutModel:(PinLayoutModel *)ownLayoutModel{
    objc_setAssociatedObject(self, @selector(ownLayoutModel), ownLayoutModel, OBJC_ASSOCIATION_RETAIN);
}

@end
