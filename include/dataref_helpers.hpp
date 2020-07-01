#pragma once

#include <XPLMDataAccess.h>

#include <vector>

XPLMDataRef export_float_dataref(char* dataref_name, float initial_value);
XPLMDataRef export_float_vector_dataref(char* dataref_name, std::vector<float> initial_values);