//
//  ShaderManager.h
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

#import "Shader.h"

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>	

@interface ShaderManager : NSObject 
{
    NSMutableDictionary *shaderPrograms;
    
    GLuint activeProgram;
    Shader *currentShader;
}

+ (ShaderManager*) sharedManager;

- (NSArray*) allShaders;

- (Shader*) currentShader;
- (Shader*) useShader:(NSString*)name;
- (Shader*) shaderForName:(NSString*)name;

- (Shader*) createShader:(NSString*)name withSettings:(NSDictionary*)settings;
- (Shader*) createShader:(NSString*)name withFile:(NSString*)file;

- (void) useShaderObject:(Shader*)shader;

- (void) removeShader:(NSString*)name;
- (void) removeAllShaders;

@end
