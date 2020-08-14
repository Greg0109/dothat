#line 1 "Tweak.x"
#import "NSTask.h"
#import <UIKit/UIKit.h>

@interface PCSimpleTimer : NSObject
@property(assign, nonatomic) BOOL disableSystemWaking;
-(instancetype)initWithTimeInterval:(double)arg1 serviceIdentifier:(NSString *)arg2 target:(id)arg3 selector:(SEL)arg4 userInfo:(id)arg5;
-(void)scheduleInRunLoop:(id)arg1;
-(void)invalidate;
-(BOOL)isValid;
@end

@interface SpringBoard
-(void)_simulateHomeButtonPress;
-(NSString *)checkDay:(int)fix;
-(BOOL)check;
-(void)dothatalert:(int)mode;
@end

@interface SBApplication
@property (nonatomic,readonly) NSString * bundleIdentifier;                                                                                     
@property (nonatomic,readonly) NSString * iconIdentifier;
@property (nonatomic,readonly) NSString * displayName;
@end

PCSimpleTimer *timer;
int timeinterval;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class PCSimpleTimer; @class SpringBoard; 
static void (*_logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, SBApplication *); static void _logos_method$_ungrouped$SpringBoard$frontDisplayDidChange$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, SBApplication *); static void _logos_method$_ungrouped$SpringBoard$timerFinished(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SpringBoard$dothatalert$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, int); static NSString * _logos_method$_ungrouped$SpringBoard$checkDay$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, int); static BOOL _logos_method$_ungrouped$SpringBoard$check(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$PCSimpleTimer(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("PCSimpleTimer"); } return _klass; }
#line 28 "Tweak.x"

static void _logos_method$_ungrouped$SpringBoard$frontDisplayDidChange$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, SBApplication * arg1) {
  
  if ([self check]) {
    if (timer) {
      
      [timer invalidate];
      timer = nil;
    }
    NSMutableDictionary *applist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.greg0109.dothatapplist"];
    if ([[applist valueForKey:arg1.bundleIdentifier] boolValue]) {
      timer = [[_logos_static_class_lookup$PCSimpleTimer() alloc] initWithTimeInterval:timeinterval serviceIdentifier:@"com.greg0109.dothattimer" target:self selector:@selector(timerFinished) userInfo:nil];
      timer.disableSystemWaking = NO;
      [timer scheduleInRunLoop:[NSRunLoop mainRunLoop]];
      _logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$(self, _cmd, arg1);
    } else if ([arg1.bundleIdentifier length] == 0) {
      _logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$(self, _cmd, arg1);
    } else if ([arg1.bundleIdentifier isEqualToString:@"com.apple.Preferences"]) { 
      _logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$(self, _cmd, arg1);
    } else {
      [self dothatalert:0];
    }
  } else {
    _logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$(self, _cmd, arg1);
  }
}


static void _logos_method$_ungrouped$SpringBoard$timerFinished(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  
  if (timer) {
    [timer invalidate];
    timer = nil;
  }
  [self dothatalert:1];
  [[NSUserDefaults standardUserDefaults] setValue:[self checkDay:0] forKey:@"DoThat-Date"];
  [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"DoThat-Status"];
}


static void _logos_method$_ungrouped$SpringBoard$dothatalert$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int mode) {
  NSString *message;
  if (mode == 0) {
    message = @"Please, do what you are supposed to do";
  } else {
    message = @"Timer finished";
  }
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DoThat" message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    if (mode == 0) {
      [self _simulateHomeButtonPress];
    }
  }];
  [alertController addAction:cancelAction];
  [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:^{}]; 
}


static NSString * _logos_method$_ungrouped$SpringBoard$checkDay$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, int fix) {
  
  NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
  NSDate *currDate = [NSDate date];
  NSDateComponents *comp = [calendar components:( NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay ) fromDate:currDate];
  int dayInt = 0;
  if (fix == 0) {
    dayInt = [comp day];
  } else {
    dayInt = [comp day] + fix;
  }
  return [NSString stringWithFormat:@"%i", dayInt];
}


static BOOL _logos_method$_ungrouped$SpringBoard$check(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  
  if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DoThat-Date"] length]  == 0) {
    [[NSUserDefaults standardUserDefaults] setValue:[self checkDay:-1] forKey:@"DoThat-Date"];
  }
  if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DoThat-Status"] length]  == 0) {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"DoThat-Status"];
  }
  if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DoThat-Status"] isEqual:@"1"] && ![[[NSUserDefaults standardUserDefaults] stringForKey:@"DoThat-Date"] isEqualToString:[self checkDay:0]]) {
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"DoThat-Status"];
    return TRUE;
  } else {
    return FALSE;
  }
}


static __attribute__((constructor)) void _logosLocalCtor_165a0459(int __unused argc, char __unused **argv, char __unused **envp) {
  NSMutableDictionary *prefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.greg0109.dothatprefs.plist"];
  BOOL enabled = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : NO;
  CGFloat timeintervalfloat = prefs[@"timeinterval"] ? [prefs[@"timeinterval"] floatValue] : 10;
  timeinterval = ceil(timeintervalfloat) * 60;
  if (timer) {
    [timer invalidate];
    timer = nil;
  }
  [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"DoThat-Status"];
  if (enabled) {
    {Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); { MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(frontDisplayDidChange:), (IMP)&_logos_method$_ungrouped$SpringBoard$frontDisplayDidChange$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$frontDisplayDidChange$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(timerFinished), (IMP)&_logos_method$_ungrouped$SpringBoard$timerFinished, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = 'i'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(dothatalert:), (IMP)&_logos_method$_ungrouped$SpringBoard$dothatalert$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = 'i'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(checkDay:), (IMP)&_logos_method$_ungrouped$SpringBoard$checkDay$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(check), (IMP)&_logos_method$_ungrouped$SpringBoard$check, _typeEncoding); }}
  }
}
