//
//  StickTextView.h
//  Stuckery
//
//  Created by david on 7/3/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface StickTextView : NSTextView

@end

NSAttributedString *_Nullable StickRemoveBackgroundColor(NSAttributedString *_Nullable sIn);

NS_ASSUME_NONNULL_END
