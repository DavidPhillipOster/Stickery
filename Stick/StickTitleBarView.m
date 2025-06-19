//  StickTitleBarView.m
//  Stick
//
//  Created by David Phillip Oster on 3/25/24. Apache License.
//

#import "StickTitleBarView.h"
#import "StickTitleButton.h"

static NSColor *AdjustColor(NSColor *c){
  if (c) {
    NSColor *result = [c blendedColorWithFraction:0.2 ofColor:NSColor.grayColor];
    return result;
  }
  return nil;
}

@interface StickTitleBarView ()
@property StickTitleButton *closeButton;
@property StickTitleButton *minButton;
@property NSButton *documentButton;
@end

@implementation StickTitleBarView

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
  if (self.backColor) {
    if (self.window.isKeyWindow) {
      [AdjustColor(self.backColor) set];
    } else {
      [self.backColor set];
    }
    NSRectFill(dirtyRect);
  }
  self.documentButton.hidden = !self.window.isKeyWindow;
}

- (void)setBackColor:(NSColor *)backColor {
  _backColor = backColor;
  self.closeButton.backColor = backColor;
  self.minButton.backColor = backColor;
  [self setNeedsDisplay:YES];
}

- (void)viewDidMoveToWindow {
  [super viewDidMoveToWindow];
  NSWindow *window = self.window;
  if (window) {
    NSButton *button = [window standardWindowButton:NSWindowCloseButton];
    if ([button isKindOfClass:[StickTitleButton class]]){
      self.closeButton = (StickTitleButton *)button;
      self.closeButton.frame = CGRectMake(12, 2, 12, 11);
      self.closeButton.backColor = self.backColor;
      [self addSubview:self.closeButton];
    }
    button = [window standardWindowButton:NSWindowMiniaturizeButton];
    if ([button isKindOfClass:[StickTitleButton class]]){
      self.minButton = (StickTitleButton *)button;
      self.minButton.frame = CGRectMake(32, 2, 12, 11);
      self.minButton.backColor = self.backColor;
      [self addSubview:self.minButton];
    }
    button = [window standardWindowButton:NSWindowDocumentIconButton];
    if (button){
      self.documentButton = button;
      self.documentButton.translatesAutoresizingMaskIntoConstraints = NO;
      [self addSubview:self.documentButton];
      [NSLayoutConstraint activateConstraints:@[
        [self.documentButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:2],
        [self.documentButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor]
      ]];
    }
  }
}

- (CGRect)dragRect {
  CGRect bounds = self.bounds;
  CGRect closeBox, remainder;
  CGRectDivide(bounds, &closeBox, &remainder, 36, CGRectMinXEdge);
  return remainder;
}


- (void)mouseDown:(NSEvent *)event {
  CGPoint where = [self convertPoint:event.locationInWindow fromView:nil];
  if (CGRectContainsPoint(self.dragRect, where)) {
    [self.window performWindowDragWithEvent:event];
  }
}

@end
