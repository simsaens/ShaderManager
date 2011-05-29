ShaderManager
=============

ShaderManager is a simple singleton and class designed to wrap the OpenGL ES shader API. It is intended to provide the simplest API possible to keep track of shader programs, their attributes and uniforms.

It is not intended to remove the need to interact with OpenGL directly, but as a convenient location to store and access shader data.

Defining a Shader
-----------------
Shaders are defined as plist files (in addition to the regular vsh/fsh files). The plist is structured as follows:

    Files
        -- array containing the vsh and fsh files to be compiled and linked
    Attributes
        -- array of strings specifying each attribute in the shader
    Uniforms
        -- array of strings specifying each uniform in the shader

Using a Shader
--------------
ShaderManager consists of a singleton class (ShaderManager) and shader class (Shader)

### Loading a shader from plist
`[[ShaderManager sharedManager] createShader:@"MyShader" withSettingsFile:@"MyShader.plist"]`

Note that the plist file is looked up in the main bundle

### Using a shader
`[[ShaderManager sharedManager] useShader:@"MyShader"]`

### Getting the currently active shader
`Shader *myShader = [[ShaderManager sharedManager] currentShader]`

### Setting attributes and uniforms on a shader

    //Uses "MyShader" and returns its shader object
    Shader *myShader = [[ShaderManager sharedManager] userShader:@"MyShader"];

    //Setting a uniform
    float translation = 10.0f;
    glUniform1f( [myShader uniformLocation:@"translation"], translation );

    GLuint positionAttribute = [myShader attributeHandle:@"position"];
    glVertexAttribPointer( positionAttribute, 2, GL_FLOAT, 0, 0, vertices );
    glEnableVertexAttribArray( positionAttribute );

Sample Project
--------------
The included sample project is simply Apple's OpenGL template modified to use ShaderManager.