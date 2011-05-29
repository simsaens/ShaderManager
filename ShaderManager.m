//
//  ShaderManager.m
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

#import "ShaderManager.h"

@implementation ShaderManager

static ShaderManager *sharedShaderManager;

#pragma mark - Singleton

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedShaderManager = [[ShaderManager alloc] init];
    }
}

+ (id)allocWithZone:(NSZone *)zone 
{ 
	@synchronized(self) 
	{ 
		if (sharedShaderManager == nil) 
		{ 
			sharedShaderManager = [super allocWithZone:zone]; 
			return sharedShaderManager; 
		} 
	} 
  
	return nil; 
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
	return self; 
} 

+ (ShaderManager*) sharedManager
{
    return sharedShaderManager;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)retain
{
    return sharedShaderManager;
}

- (id)autorelease
{
    return sharedShaderManager;
}

#pragma mark - Initialization

- (id) init
{
    self = [super init];
    if(self)
    {
        shaderPrograms = [[NSMutableDictionary dictionary] retain];
        activeProgram = 0;
    }
    return self;
}

#pragma mark - Memory

- (void) dealloc
{
    [shaderPrograms release];
    [super dealloc];
}

#pragma mark - Shader management

- (Shader*) currentShader
{
    return currentShader;
}

- (Shader*) useShader:(NSString*)name
{
    currentShader = [self shaderForName:name];
    
    if( activeProgram != currentShader.programHandle )
    {
        glUseProgram(currentShader.programHandle);
    
        activeProgram = currentShader.programHandle;    
    }
    
    return currentShader;
}

- (Shader*) shaderForName:(NSString *)name
{
    return [shaderPrograms objectForKey:name];
}

- (Shader*) createShader:(NSString*)name withSettings:(NSDictionary *)settings
{
    Shader *shader = [[[Shader alloc] initWithShaderSettings:settings] autorelease];
    
    Shader *existingShader = [self shaderForName:name];
    if( existingShader != nil )
    {
        [self removeShader:name];
    }
    
    [shaderPrograms setObject:shader forKey:name];
    
    return shader;
}

- (Shader*) createShader:(NSString*)name withFile:(NSString*)file
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@""]];
    
    return [self createShader:name withSettings:dict];
}

- (void) removeAllShaders
{
    [shaderPrograms removeAllObjects];
}

- (void) removeShader:(NSString*)name
{
    Shader *shader = [self shaderForName:name];
    
    if( shader )
    {
        if( shader.programHandle == activeProgram )
        {
            glUseProgram(0);
        }
        
        [shaderPrograms removeObjectForKey:name];
    }
}

@end
