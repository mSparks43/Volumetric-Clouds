--cldDR_cloud_base_datarefs={}
cldDR_cloud_base_datarefs = find_dataref("volumetric_clouds/weather/cloud_base_msl_m");
--cldDR_cloud_base_datarefs[1] = find_dataref("volumetric_clouds/weather/cloud_base_msl_m[1]");
--cldDR_cloud_base_datarefs[2] = find_dataref("volumetric_clouds/weather/cloud_base_msl_m[2]");
cldDR_sun_gain = find_dataref("volumetric_clouds/sun_gain");
--cldDR_cloud_type_datarefs={}
cldDR_cloud_type_datarefs = find_dataref("volumetric_clouds/weather/cloud_type");
--cldDR_cloud_type_datarefs[1] = find_dataref("volumetric_clouds/weather/cloud_type[1]");
--cldDR_cloud_type_datarefs[2] = find_dataref("volumetric_clouds/weather/cloud_type[2]");
simDR_override_clouds=find_dataref("sim/operation/override/override_clouds");

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

simDR_cloud_coverage_datarefs={}
simDR_cloud_coverage_datarefs[0] = find_dataref("sim/weather/cloud_coverage[0]");
simDR_cloud_coverage_datarefs[1] = find_dataref("sim/weather/cloud_coverage[1]");
simDR_cloud_coverage_datarefs[2] = find_dataref("sim/weather/cloud_coverage[2]");


cldDR_cloud_height_datarefs = find_dataref("volumetric_clouds/weather/height");
cldDR_cloud_density_datarefs = find_dataref("volumetric_clouds/weather/density");
cldDR_cloud_coverage_datarefs = find_dataref("volumetric_clouds/weather/coverage");


function animate_value(current_value, target, min, max, speed)

    local fps_factor = math.min(0.001, speed * SIM_PERIOD)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
       return min
    else
        return current_value + ((target - current_value) * fps_factor)
    end

end
function getDensity(i)
  if simDR_cloud_type_datarefs[i]==1 then return 1.250 
  else
    return 1.5
  end
  
end
function after_physics()
  local targetSungain=2.25
  local cirrusOnly=0
  for i = 0, 2, 1 do
    cirrusOnly=cirrusOnly+simDR_cloud_type_datarefs[i]
  end
  
  if cirrusOnly~=1 then
    simDR_override_clouds=1
    for i = 0, 2, 1 do
      cldDR_cloud_base_datarefs[i]=animate_value(cldDR_cloud_base_datarefs[i],simDR_cloud_base_datarefs[i],0,30000,0.1)
      
      if simDR_cloud_type_datarefs[i]>1 then 
	  cldDR_cloud_height_datarefs[i]=animate_value(cldDR_cloud_height_datarefs[i],simDR_cloud_tops_datarefs[i]-cldDR_cloud_base_datarefs[i],0,30000,0.1)
      else
	  cldDR_cloud_height_datarefs[i]=animate_value(cldDR_cloud_height_datarefs[i],200,0,30000,0.1)
	  targetSungain=100
      end
      cldDR_cloud_density_datarefs[i]=getDensity(i)
      if simDR_cloud_type_datarefs[i] >1 then
	cldDR_cloud_coverage_datarefs[i]=animate_value(cldDR_cloud_coverage_datarefs[i],(simDR_cloud_coverage_datarefs[i] / 4),0,0.98,0.1)
      else
	cldDR_cloud_coverage_datarefs[i]=animate_value(cldDR_cloud_coverage_datarefs[i],0.05,0,0.98,0.1)
      end
      if simDR_cloud_type_datarefs[i] >0 then
	cldDR_cloud_type_datarefs[i]=simDR_cloud_type_datarefs[i]
      elseif cldDR_cloud_coverage_datarefs[i]<0.05 then
	cldDR_cloud_type_datarefs[i]=0
      end
      if simDR_cloud_type_datarefs[i]==4 then targetSungain=1 end
    end
  else
    simDR_override_clouds=0
    for i = 0, 2, 1 do
      cldDR_cloud_type_datarefs[i]=0
      cldDR_cloud_base_datarefs[i]=animate_value(cldDR_cloud_base_datarefs[i],simDR_cloud_base_datarefs[i],0,30000,0.1)
      
      if simDR_cloud_type_datarefs[i]>1 then 
	  cldDR_cloud_height_datarefs[i]=animate_value(cldDR_cloud_height_datarefs[i],simDR_cloud_tops_datarefs[i]-cldDR_cloud_base_datarefs[i],0,30000,0.1)
      else
	  cldDR_cloud_height_datarefs[i]=animate_value(cldDR_cloud_height_datarefs[i],200,0,30000,0.1)
	  targetSungain=100
      end
    end
    
  end
    cldDR_sun_gain=animate_value(cldDR_sun_gain,targetSungain,1,2.25,1)
end

