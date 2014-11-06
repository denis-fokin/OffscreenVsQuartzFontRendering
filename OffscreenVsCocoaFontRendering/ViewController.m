//
//  ViewController.m
//  OffscreenVsCocoaFontRendering
//
//  Created by Denis S. Fokin on 31/10/14.
//  Copyright (c) 2014 Denis S. Fokin. All rights reserved.
//

#import "ViewController.h"
#import "MyOGLView.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyOGLView * oglView = [[MyOGLView alloc] initWithFrame:CGRectMake(100, self.view.frame.size.height - 50, 50, 50)];
    [self.view addSubview:oglView];
    [oglView setNeedsDisplay:true];

}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
