--cldDR_cloud_base_datarefs={}
cldDR_cloud_base_datarefs = find_dataref("volumetric_clouds/weather/cloud_base_msl_m");
--cldDR_cloud_base_datarefs[1] = find_dataref("volumetric_clouds/weather/cloud_base_msl_m[1]");
--cldDR_cloud_base_datarefs[2] = find_dataref("volumetric_clouds/weather/cloud_base_msl_m[2]");

--cldDR_cloud_type_datarefs={}
cldDR_cloud_type_datarefs = find_dataref("volumetric_clouds/weather/cloud_type");
--cldDR_cloud_type_datarefs[1] = find_dataref("volumetric_clouds/weather/cloud_type[1]");
--cldDR_cloud_type_datarefs[2] = find_dataref("volumetric_clouds/weather/cloud_type[2]");

simDR_cloud_base_datarefs={}
simDR_cloud_base_datarefs[0] = find_dataref("sim/weather/cloud_base_msl_m[0]");
simDR_cloud_base_datarefs[1] = find_dataref("sim/weather/cloud_base_msl_m[1]");
simDR_cloud_base_datarefs[2] = find_dataref("sim/weather/cloud_base_msl_m[2]");
simDR_cloud_tops_datarefs={}
simDR_cloud_tops_datarefs[0] = find_dataref("sim/weather/cloud_tops_msl_m[0]");
simDR_cloud_tops_datarefs[1] = find_dataref("sim/weather/cloud_tops_msl_m[1]");
simDR_cloud_tops_datarefs[2] = find_dataref("sim/weather/cloud_tops_msl_m[2]");
simDR_cloud_type_datarefs={}
simDR_cloud_type_datarefs[0] = find_dataref("sim/weather/cloud_type[0]");
simDR_cloud_type_datarefs[1] = find_dataref("sim/weather/cloud_type[1]");
simDR_cloud_type_datarefs[2] = find_dataref("sim/weather/cloud_type[2]");


cldDR_cloud_height_datarefs = find_dataref("volumetric_clouds/weather/height");
cldDR_cloud_density_datarefs = find_dataref("volumetric_clouds/weather/density");
cldDR_cloud_coverage_datarefs = find_dataref("volumetric_clouds/weather/coverage");


function animate_value(current_value, target, min, max, speed)

    local fps_factor = math.min(0.1, speed * SIM_PERIOD)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
       return min
    else
        return current_value + ((target - current_value) * fps_factor)
    end

end

function after_physics()
    for i = 0, 2, 1 do
      cldDR_cloud_base_datarefs[i]=animate_value(cldDR_cloud_base_datarefs[i],simDR_cloud_base_datarefs[i],0,30000,1)
      cldDR_cloud_type_datarefs[i]=simDR_cloud_type_datarefs[i]
      local tartget_top=animate_value(cldDR_cloud_base_datarefs[i],simDR_cloud_base_datarefs[i],0,30000,1)
      cldDR_cloud_height_datarefs[i]=animate_value(cldDR_cloud_height_datarefs[i],simDR_cloud_tops_datarefs[i]-cldDR_cloud_base_datarefs[i],0,30000,1)
      cldDR_cloud_density_datarefs[i]=1.5
      cldDR_cloud_coverage_datarefs[i]=0.25
    end
end