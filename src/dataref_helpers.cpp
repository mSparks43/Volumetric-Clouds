#include <dataref_helpers.hpp>

float read_float_callback(void* data_pointer)
{
	return *static_cast<float*>(data_pointer);
}

void write_float_callback(void* data_pointer, float input_value)
{
	*static_cast<float*>(data_pointer) = input_value;
}

int read_float_vector_callback(void* data_pointer, float* output_values, int read_offset, int read_size)
{
	std::vector<float>& float_vector = *static_cast<std::vector<float>*>(data_pointer);

	if (output_values != nullptr)
	{
		int read_start = read_offset % float_vector.size();
		int read_end = read_start + read_size;

		if (read_end < read_start) read_end = read_start;
		else if (read_end > float_vector.size()) read_end = float_vector.size();

		for (int index = read_start; index < read_end; index++) output_values[index] = float_vector[index];

		return read_end - read_start;
	}
	else return float_vector.size();
}

void write_float_vector_callback(void* data_pointer, float* input_values, int write_offset, int write_size)
{
	std::vector<float>& float_vector = *static_cast<std::vector<float>*>(data_pointer);

	int write_start = write_offset % float_vector.size();
	int write_end = write_start + write_size;

	if (write_end < write_start) write_end = write_start;
	else if (write_end > float_vector.size()) write_end = float_vector.size();

	for (int index = write_start; index < write_end; index++) float_vector[index] = input_values[index];
}

XPLMDataRef export_float_dataref(char* dataref_name, float initial_value)
{
	float* float_pointer = new float(initial_value);

	return XPLMRegisterDataAccessor(dataref_name, xplmType_Float, 1, NULL, NULL, read_float_callback, write_float_callback, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, float_pointer, float_pointer);
}

XPLMDataRef export_float_vector_dataref(char* dataref_name, std::vector<float> initial_values)
{
	std::vector<float>* vector_pointer = new std::vector<float>(initial_values);
	
	return XPLMRegisterDataAccessor(dataref_name, xplmType_FloatArray, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, read_float_vector_callback, write_float_vector_callback, NULL, NULL, vector_pointer, vector_pointer);
}