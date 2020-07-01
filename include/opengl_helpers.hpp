#pragma once

#include <GL/glew.h>

#define SHADER_INVALID 0
#define TEXTURE_INVALID 0

GLuint load_shader(char* shader_path, GLenum shader_type);

int create_texture(GLsizei texture_width, GLsizei texture_height, GLsizei mipmap_count, GLint internal_format, GLenum data_format, void* texture_data);
int create_texture(GLsizei texture_width, GLsizei texture_height, GLsizei texture_depth, GLsizei mipmap_count, GLint internal_format, GLenum data_format, void* texture_data);

int load_png_texture(char* texture_path, bool create_3d_texture, GLsizei mipmap_count);