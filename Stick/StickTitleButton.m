//  StickTitleButton.m
//  CustomButtons
//
//  Created by David Phillip Oster on 3/26/24. Apache License.
//

#import "StickTitleButton.h"

@implementation StickTitleButton {
  BOOL _state;
}

- (void)drawRect:(NSRect)dirtyRect {
  // superclass draws some junk we don't want.
  CGRect bounds = self.bounds;
  [self.backColor set];
  NSFrameRect(bounds);
  if (self.state) {
    NSBezierPath *path = [[NSBezierPath alloc] init];
    [path moveToPoint:bounds.origin];
    [path lineToPoint:CGPointMake(bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height)];
    [path moveToPoint:CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height)];
    [path lineToPoint:CGPointMake(bounds.origin.x + bounds.size.width, bounds.origin.y)];
    [path stroke];
  }
}

- (void)mouseDown:(NSEvent *)event {
  CGPoint where = [self convertPoint:event.locationInWindow fromView:nil];
  if (CGRectContainsPoint(self.bounds, where)) {
    [self trackClose];
  }
}

- (void)trackClose {
  self.state = YES;
  while (YES) {
    NSEvent *theEvent = [[self window] nextEventMatchingMask: NSEventMaskLeftMouseUp | NSEventMaskLeftMouseDragged];
    CGPoint where = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    self.state = CGRectContainsPoint(self.bounds, where);
    if (NSEventTypeLeftMouseUp == [theEvent type]) {
      if (self.state) {
        self.state = NO;
        if (self.action) {
          [self sendAction:self.action to:self.target];
        }
      }
      break;
    }
  }
}

- (NSControlStateValue)state {
  return _state;
}

- (void)setState:(NSControlStateValue)state {
  if (_state != state){
    _state = state;
    [self setNeedsDisplay:YES];
  }
}

@end
