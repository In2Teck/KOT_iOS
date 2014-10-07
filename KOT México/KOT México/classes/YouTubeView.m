//
//  YouTubeView.m
//  blogScratchApp
//
//  Created by John on 5/18/10.
//  Copyright 2010 iPhoneDeveloperTips.com. All rights reserved.
//

#import "YouTubeView.h"

@implementation YouTubeView

#pragma mark -
#pragma mark Initialization

- (YouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame;
{
  if (self = [super init]) 
  {
		// Create webview with requested frame size
    self = [[UIWebView alloc] initWithFrame:frame];
    
		// HTML to embed YouTube video
      NSString *youTubeVideoHTML = @"<html><header></header><body><iframe id='ytplayer' type='text/html' width='280' height='240' src='http://www.youtube.com/embed/%@?autoplay=1&origin=http://kot.mx' frameborder='0'/></body></html>";
      
    // Populate HTML with the URL and requested frame size
    NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString];

    // Load the html into the webview
    [self loadHTMLString:html baseURL:nil];
	}
  
  return self;  

}

#pragma mark -
#pragma mark Cleanup

/*---------------------------------------------------------------------------
*  
*--------------------------------------------------------------------------*/
- (void)dealloc 
{
	[super dealloc];
}

@end
