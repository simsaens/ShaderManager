//
//  Shader.m
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

#import "Shader.h"
#import "ShaderManager.h"

@implementation Shader

@synthesize programHandle;

#pragma mark - Shader compiling and linking

- (BOOL)compileShader:(GLuint *)shader file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    GLenum type = GL_VERTEX_SHADER;
    
    NSString *extension = [file pathExtension];
    if( [extension isEqualToString:@"vsh"] )
    {
        type = GL_VERTEX_SHADER;
    }
    else if( [extension isEqualToString:@"fsh"] )
    {
        type = GL_FRAGMENT_SHADER;
    }
    else 
    {
        NSLog(@"Unknown shader file extension");
        return FALSE;
    }
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;    
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

#pragma mark - Initialization

- (id) initWithShaderSettings:(NSDictionary*)settings
{    
    self = [super init];
    if( self )
    {
        NSArray *shaderFiles = [settings objectForKey:@"Files"];
        NSArray *attributes = [settings objectForKey:@"Attributes"];
        NSArray *uniforms = [settings objectForKey:@"Uniforms"];
        
        attributeHandles = [[NSMutableDictionary dictionary] retain];
        uniformHandles = [[NSMutableDictionary dictionary] retain];
        
        programHandle = glCreateProgram();
                         
        NSMutableArray *shaderList = [NSMutableArray array];
        
        for( NSString *file in shaderFiles )
        {
            GLuint shader;
            
            if( ![self compileShader:&shader file:[[NSBundle mainBundle] pathForResource:file ofType:@""]] )
            {
                NSLog(@"Failed to compile shader: %@", file);
            }
            
            [shaderList addObject:[NSNumber numberWithInt:shader]];
        }
        
        for( NSNumber *shader in shaderList )
        {
            //Attach each shader to the program
            glAttachShader( programHandle, [shader unsignedIntValue] );
        }        
        
        GLuint attribLoc = 1;
        for( NSString *attribute in attributes )
        {
            glBindAttribLocation(programHandle, attribLoc, [attribute UTF8String]);            
            
            [attributeHandles setObject:[NSNumber numberWithInt:attribLoc] forKey:attribute];
            
            attribLoc += 1;
        }
        
        if( ![self linkProgram:programHandle] )
        {
            NSLog(@"Failed to link program: %d", programHandle);
            
            for( NSNumber *shader in shaderList )
            {
                if( [shader unsignedIntValue] )
                {
                    glDeleteShader([shader unsignedIntValue]);
                }
            }

            if (programHandle)
            {
                glDeleteProgram(programHandle);
                programHandle = 0;
            }            
        }    
        
        if( programHandle )
        {
            for( NSString *uniform in uniforms )
            {
                int uniformHandle = glGetUniformLocation(programHandle, [uniform UTF8String]);
                
                [uniformHandles setObject:[NSNumber numberWithInt:uniformHandle] forKey:uniform];
            }
        }
    }
    return self;
}

- (void) dealloc
{
    if( programHandle )
    {
        glDeleteProgram(programHandle);
        programHandle = 0;
    }
    
    [attributeHandles release];
    [uniformHandles release];
    
    [super dealloc];
}

#pragma mark - Using the shader

- (void) useShader
{
    [[ShaderManager sharedManager] useShaderObject:self];
}

#pragma mark - Access to uniforms and attributes

- (int) uniformLocation:(NSString*)name
{
    return [[uniformHandles objectForKey:name] intValue];
}

- (GLuint) attributeHandle:(NSString*)name
{
    return [[attributeHandles objectForKey:name] unsignedIntValue];    
}

@end
