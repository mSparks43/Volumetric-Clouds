#version 410 core

layout(location = 0) in vec2 input_vertex;

uniform float near_clip_z;
uniform float far_clip_z;

uniform mat4 modelview_matrix;
uniform mat4 projection_matrix;

flat out mat4 inverse_modelview_matrix;
flat out mat4 inverse_projection_matrix;

out vec3 ray_start_position;
out vec3 ray_end_position;

out vec2 depth_texture_position;

void main()
{
	inverse_modelview_matrix = inverse(modelview_matrix);
	inverse_projection_matrix = inverse(projection_matrix);

	vec4 ray_start_vector = inverse_projection_matrix * vec4(input_vertex, near_clip_z, 1.0);
	ray_start_vector /= ray_start_vector.w;

	vec4 ray_end_vector = inverse_projection_matrix * vec4(input_vertex, far_clip_z, 1.0);
	ray_end_vector /= ray_end_vector.w;

	ray_start_position = vec3(inverse_modelview_matrix * ray_start_vector);
	ray_end_position = vec3(inverse_modelview_matrix * ray_end_vector);

	depth_texture_position = (input_vertex / 2.0) + 0.5;

	gl_Position = vec4(input_vertex, near_clip_z, 1.0);
}