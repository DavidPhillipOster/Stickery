//  StickColoredView.m
//  Stick
//
//  Created by David Phillip Oster on 3/24/24. Apache License.
//

#import "StickColoredView.h"

@implementation StickColoredView

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  if (self.backColor) {
    [self.backColor set];
    NSRectFill(dirtyRect);
  }
}

- (void)setBackColor:(NSColor *)backColor {
  _backColor = backColor;
  [self setNeedsDisplay:YES];
}

@end
