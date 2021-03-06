void main()
{
    vec4 defaultShading = SKDefaultShading();
    float defaultBW = (defaultShading.r + defaultShading.g + defaultShading.b) / 5.0;
    gl_FragColor = v_tex_coord.y < aPos ?
        defaultShading :
		vec4(defaultBW, defaultBW, defaultBW, defaultShading.a);
}

