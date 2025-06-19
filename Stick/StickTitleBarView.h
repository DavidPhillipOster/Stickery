//  StickTitleBarView.h
//  Stick
//
//  Created by David Phillip Oster on 3/25/24. Apache License.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// Custom titlebar - close box, window dragging. Color derived from the color palette.
@interface StickTitleBarView : NSView
@property(nonatomic, nullable) NSColor *backColor;
@end

NS_ASSUME_NONNULL_END
