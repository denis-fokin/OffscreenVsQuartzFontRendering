//
//  MyDrawingView.m
//  OffscreenVsCocoaFontRendering
//
//  Created by Denis S. Fokin on 31/10/14.
//  Copyright (c) 2014 Denis S. Fokin. All rights reserved.
//

#import "MyDrawingView.h"

CGContextRef MyCreateBitmapContext (int pixelsWide, int pixelsHigh) {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void * bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    bitmapBytesPerRow = (pixelsWide * 4);
    bitmapByteCount = (bitmapBytesPerRow * pixelsHigh);
    colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    bitmapData = calloc(bitmapByteCount, 4);
    
    
    if (bitmapData == NULL) {
        fprintf(stderr, "Memory not allocated!");
        return NULL;
        
    }
    context = CGBitmapContextCreate(bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,      // bits per component
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    (CGBitmapInfo) (kCGImageAlphaPremultipliedFirst
                                                    | kCGBitmapByteOrder32Host));
    
    
    if (context == NULL) {
        free(bitmapData);
        fprintf(stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease(colorSpace);
    return context;
}



@implementation MyDrawingView

- (void) drawRect:(NSRect) dirtyRect {

    CGSize viewSize = self.frame.size;

    CGRect myBoundingBox = CGRectMake(50, viewSize.height - 50, 50, 50);
    CGContextRef myBitmapContext = MyCreateBitmapContext (50, 50);
    CGContextRef myContext = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];


    // Prepare glyphs first

    size_t glyphCount = 1;
    CGGlyph glyphs[glyphCount];
    glyphs[0] = 41;

    CGContextSaveGState(myContext);
    {
        // Preparing a font to draw on the view surface

        // Let's draw a String on the view

        CGContextSetRGBFillColor (myContext, 1, 1, 1, 1);
        CGContextFillRect (myContext, self.frame);

        CGContextSelectFont(myContext, "American Typewriter", 20.0f, kCGEncodingMacRoman);
        CGContextSetFontSize(myContext, 20.0f);

        CGContextSetRGBFillColor(myContext, 0, 0, 0, 1);
        CGContextSetRGBStrokeColor(myContext, 0, 0, 0, 1);


        CGContextShowGlyphsAtPoint(myContext, 20, viewSize.height - 50, glyphs, glyphCount);

    }
    CGContextRestoreGState(myContext);

    //Let's draw an off-screen image

    // Preparing a font to draw in an off-screen image

    CGContextSelectFont(myBitmapContext, "American Typewriter", 20.0f, kCGEncodingMacRoman);
    CGContextSetFontSize(myBitmapContext, 20.0f);

    CGContextSetRGBFillColor(myBitmapContext, 0, 0, 0, 1);
    CGContextSetRGBStrokeColor(myBitmapContext, 0, 0, 0, 1);


    CGContextShowGlyphsAtPoint(myBitmapContext, 0, 0, glyphs, glyphCount);

    CGContextSetRGBFillColor (myBitmapContext, 1, 1, 1, 1);
    CGContextFillRect (myBitmapContext, CGRectMake (0, 0, 50, 50));

    CGContextSetRGBFillColor(myBitmapContext, 0, 0, 0, 1);
    CGContextSetRGBStrokeColor(myBitmapContext, 0, 0, 0, 1);


    CGContextShowGlyphsAtPoint(myBitmapContext, 0, 0, glyphs, glyphCount);


    CGImageRef myImage = CGBitmapContextCreateImage (myBitmapContext);
    CGContextDrawImage(myContext, myBoundingBox, myImage);
    char *bitmapData = CGBitmapContextGetData(myBitmapContext);


    CGContextRelease (myBitmapContext);
    if (bitmapData) {
        CGImageRelease(myImage);
        free(bitmapData);
    }

}

@end
