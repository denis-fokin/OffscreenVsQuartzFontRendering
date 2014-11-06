//
// Created by Denis S. Fokin on 05/11/14.
// Copyright (c) 2014 Denis S. Fokin. All rights reserved.
//

#import "MyOGLView.h"
#import <OpenGL/gl.h>



CGContextRef MyCreateBitmapContext (int pixelsWide, int pixelsHigh);

@implementation MyOGLView {
    NSTimer *timer;
}

- (void)prepareOpenGL
{
    // Synchronize buffer swaps with vertical refresh rate
    GLint swapInt = 1;
    [[self openGLContext]
            setValues:&swapInt
         forParameter:NSOpenGLCPSwapInterval];

}

- (void)drawRect:(NSRect)bounds {

    // Prepare glyphs first

    size_t glyphCount = 1;
    CGGlyph glyphs[glyphCount];
    glyphs[0] = 41;

    CGContextRef myBitmapContext = MyCreateBitmapContext (50, 50);

    //Let's draw an off-screen image

    // Preparing a font to draw in an off-screen image

    CGContextSelectFont(myBitmapContext, "American Typewriter", 20.0f, kCGEncodingMacRoman);
    CGContextSetFontSize(myBitmapContext, 20.0f);

    CGContextSetRGBFillColor (myBitmapContext, 1, 1, 1, 1);
    CGContextFillRect (myBitmapContext, CGRectMake(0, 0, 50, 50));

    CGContextSetRGBFillColor(myBitmapContext, 0, 0, 0, 1);
    CGContextSetRGBStrokeColor(myBitmapContext, 0, 0, 0, 1);


    CGContextShowGlyphsAtPoint(myBitmapContext, 0, 0, glyphs, glyphCount);

    CGImageRef myImage = CGBitmapContextCreateImage (myBitmapContext);

    char *bitmapData = CGBitmapContextGetData(myBitmapContext);

    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);


    {
        glEnable(GL_TEXTURE_RECTANGLE_EXT);

        GLuint tex;
        glGenTextures(1, &tex);
        glBindTexture(GL_TEXTURE_RECTANGLE_EXT, tex);
        glTexImage2D(GL_TEXTURE_RECTANGLE_EXT,
                0,
                GL_RGBA,
                self.frame.size.width,
                self.frame.size.height,
                0,
                GL_BGRA,
                GL_UNSIGNED_INT_8_8_8_8_REV,
                bitmapData);

        glBegin(GL_QUADS);

        glTexCoord2f(0, 0);
        glVertex2f(-1, 1);

        glTexCoord2f(((GLfloat)self.frame.size.width), 0);
        glVertex2f(1, 1);


        glTexCoord2f(((GLfloat)self.frame.size.width), ((GLfloat)self.frame.size.height));
        glVertex2f(1, -1);

        glTexCoord2f(0.0f, ((GLfloat)self.frame.size.height));
        glVertex2f(-1, -1);

        glEnd();

        glDisable(GL_TEXTURE_RECTANGLE_EXT);

        glDeleteTextures(1, &tex);
        glFlush();


        CGContextRelease (myBitmapContext);
        if (bitmapData) {
            CGImageRelease(myImage);
            free(bitmapData);
        }

    }
}

@end