//
//  JLViewController.m
//  JamieLidellMobile
//
//  Created by Marshall Moutenot on 2/24/13.
//  Copyright (c) 2013 Marshall Moutenot. All rights reserved.
//

#import "JLViewController.h"
#import <QuartzCore/QuartzCore.h>

#define STROBE_RATE_1 0.56f
#define STROBE_RATE_2 0.28f
#define STROBE_RATE_3 0.14f
#define STROBE_RATE_4 0.07f

@interface JLViewController ()

@end

@implementation JLViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _fc = [[FlashController alloc] init];
  _nextLightState = ls_on;
  _lightOn = NO;
  _strobeActivated = NO;
  _strobeFlashOn = NO;
  _strobeRate = STROBE_RATE_1;
  
  
  _buttonImage = [_jamieButton imageForState:UIControlStateNormal];
  _currentHue = [NSNumber numberWithFloat:0.2f];
}

- (void)strobeTimerCallback:(id)sender {
	if (_strobeActivated) {
		_lightOn = !_lightOn;
		[self startStopStrobe:_lightOn];
	} else {
		[self startStopStrobe:NO];
	}
}

- (void)startStopStrobe:(BOOL)strobeOn {
	if (strobeOn && _strobeActivated) {
		[_fc toggleStrobe:YES];
	} else {
		[_fc toggleStrobe:NO];
	}
}

- (void)performHueShiftOnButtonImage{
  CIImage *inputImage = [[CIImage alloc] initWithImage:_buttonImage];
  CIContext *context = [CIContext contextWithOptions:nil];
  
  CIFilter *hueAdjust = [CIFilter filterWithName:@"CIHueAdjust"];
  [hueAdjust setValue: inputImage forKey: @"inputImage"];
  [hueAdjust setValue: _currentHue forKey: @"inputAngle"];
  CIImage *outputImage = [hueAdjust valueForKey: @"outputImage"];
  
  //  return resultImage;
  CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
  UIImage *newImage = [UIImage imageWithCGImage:cgimg];
  
  [_jamieButton setImage:newImage forState:UIControlStateNormal];
  CGImageRelease(cgimg);
  _currentHue = [NSNumber numberWithFloat:_currentHue.floatValue + 0.4f];
  
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
  
  [_flasher_title setTextColor:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.f]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)buttonDown:(id)sender {
  [_hueTimer invalidate];
  [_strobeTimer invalidate];
  switch ((int)_nextLightState) {
    case ls_off:
      _nextLightState = ls_on;
      _strobeActivated = NO;
      break;
    case ls_on:
      _hueTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(performHueShiftOnButtonImage) userInfo:nil repeats:YES];
      _nextLightState = ls_strobe_1;
      _strobeActivated = YES;
      break;
    case ls_strobe_1:
      _strobeRate = STROBE_RATE_1;
      _hueTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeRate/2 target:self selector:@selector(performHueShiftOnButtonImage) userInfo:nil repeats:YES];
      _strobeTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeRate target:self selector:@selector(strobeTimerCallback:) userInfo:nil repeats:YES];
      _nextLightState = ls_strobe_2;
      break;
    case ls_strobe_2:
      _strobeRate = STROBE_RATE_2;
      _hueTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeRate/2 target:self selector:@selector(performHueShiftOnButtonImage) userInfo:nil repeats:YES];
      _strobeTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeRate target:self selector:@selector(strobeTimerCallback:) userInfo:nil repeats:YES];
      _nextLightState = ls_strobe_3;
      break;
    case ls_strobe_3:
      _strobeRate = STROBE_RATE_3;
      _hueTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeRate/2 target:self selector:@selector(performHueShiftOnButtonImage) userInfo:nil repeats:YES];
      _strobeTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeRate target:self selector:@selector(strobeTimerCallback:) userInfo:nil repeats:YES];
      _nextLightState = ls_strobe_4;
      break;
    case ls_strobe_4:
      _strobeRate = STROBE_RATE_4;
      _hueTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeRate/2 target:self selector:@selector(performHueShiftOnButtonImage) userInfo:nil repeats:YES];
      _strobeTimer = [NSTimer scheduledTimerWithTimeInterval:_strobeRate target:self selector:@selector(strobeTimerCallback:) userInfo:nil repeats:YES];
      _nextLightState = ls_off;
      break;
    default:
      break;
  }
	[self startStopStrobe:_strobeActivated];
}

-(IBAction)websiteButtonClick:(id)sender {
  NSString* launchUrl = @"http://www.jamielidell.com/";
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

-(IBAction)explainButtonClick:(id)sender {
  NSString* launchUrl = @"http://snppi.com/jamie";
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}

- (void)viewDidUnload {
  [self setFlasher_title:nil];
  [super viewDidUnload];
}
@end
