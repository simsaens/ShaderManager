//
//  Shader.h
//  TwoLivesLeft.com
//
//  Created by Simeon Nasilowski on 29/05/11.
//  Copyright 2011 Two Lives Left. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>	

@interface Shader : NSObject 
{
    GLuint programHandle;
    
    NSMutableDictionary *attributeHandles;
    NSMutableDictionary *uniformHandles;
}

@property (nonatomic,readonly) GLuint programHandle;

- (id) initWithShaderSettings:(NSDictionary*)settings;

- (int) uniformLocation:(NSString*)name;
- (GLuint) attributeHandle:(NSString*)name;

@end
