//
//  Shader.fsh
//  ShaderManagerDemo
//
//  Created by Simeon Nasilowski on 29/05/11.
//  Copyright 2011 Developer. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
