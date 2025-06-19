//  StickWindow.m
//  Stick
//
//  Created by David Phillip Oster on 3/25/24. Apache License.
//

#import "StickWindow.h"

#import "StickTitleButton.h"

@interface StickWindow ()
@property (nonatomic) StickTitleButton *closeButton;
@property (nonatomic) StickTitleButton *minButton;
@property (nonatomic) NSButton *dockIconButton;
@end

@implementation StickWindow

- (StickTitleButton *)closeButton {
  if (nil == _closeButton) {
    _closeButton = [[StickTitleButton alloc] initWithFrame:CGRectMake(0, 0, 12, 11)];
    _closeButton.target = self;
    _closeButton.action = @selector(close);
  }
  return _closeButton;
}

- (StickTitleButton *)minButton {
  if (nil == _minButton) {
    _minButton = [[StickTitleButton alloc] initWithFrame:CGRectMake(0, 0, 12, 11)];
    _minButton.target = self;
    _minButton.action = @selector(miniaturize:);
  }
  return _minButton;
}

- (NSButton *)dockIconButton {
  if (nil == _dockIconButton) {
    // found by examining other apps.
    Class buttonClass = NSClassFromString(@"NSThemeDocumentButton");
    if ([buttonClass respondsToSelector:@selector(buttonWithImage:target:action:)]) {
      NSImage *placeHolder = [[NSImage alloc] initWithSize:NSMakeSize(12, 11)];
      _dockIconButton = [buttonClass buttonWithImage:placeHolder target:self action:nil];
      _dockIconButton.bordered = NO;
      _dockIconButton.bounds = CGRectMake(0, 0, 12, 11);
    }
  }
  return _dockIconButton;
}

- (BOOL)canBecomeKeyWindow { return YES; }
- (BOOL)canBecomeMainWindow { return YES; }

- (nullable NSButton *)standardWindowButton:(NSWindowButton)b {
  switch (b) {
    case NSWindowCloseButton: return self.closeButton;
    case NSWindowMiniaturizeButton: return self.minButton;
    case NSWindowDocumentIconButton: return self.dockIconButton;
    default: return nil;
  }
}

- (void)setRepresentedURL:(NSURL *)representedURL {
  [super setRepresentedURL:representedURL];
  if ([self.dockIconButton respondsToSelector:@selector(setRepresentedURL:)]) {
    [(id)self.dockIconButton setRepresentedURL:representedURL];
  }
}

- (void)setDocumentEdited:(BOOL)documentEdited {
  [super setDocumentEdited:documentEdited];
  if ([self.dockIconButton respondsToSelector:@selector(setDocumentEdited:)]) {
    [(id)self.dockIconButton setDocumentEdited:documentEdited];
  }
}

@end
