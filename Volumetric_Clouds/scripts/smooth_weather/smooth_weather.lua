local transitionTimeSecs=300
local cloudheightMod=2
cldDR_cloud_base_datarefs = find_dataref("volumetric_clouds/weather/cloud_base_msl_m")
cldDR_cloud_type_datarefs = find_dataref("volumetric_clouds/weather/cloud_type")
cldDR_cloud_height_datarefs = find_dataref("volumetric_clouds/weather/height")
cldDR_cloud_density_datarefs = find_dataref("volumetric_clouds/weather/density")
cldDR_cloud_coverage_datarefs = find_dataref("volumetric_clouds/weather/coverage")

simDR_sun_tint_red_dataref = find_dataref("sim/graphics/misc/outside_light_level_r");
simDR_sun_tint_green_dataref = find_dataref("sim/graphics/misc/outside_light_level_g");
simDR_sun_tint_blue_dataref = find_dataref("sim/graphics/misc/outside_light_level_b");
simDR_sun_pitch = find_dataref("sim/graphics/scenery/sun_pitch_degrees");
cldDR_sun_tint_red_dataref = find_dataref("volumetric_clouds/outside_light_level_r");
cldDR_sun_tint_green_dataref = find_dataref("volumetric_clouds/outside_light_level_g");
cldDR_sun_tint_blue_dataref = find_dataref("volumetric_clouds/outside_light_level_b");	

simDR_override_clouds=find_dataref("sim/operation/override/override_clouds")
cldDR_sun_gain = find_dataref("volumetric_clouds/sun_gain")
simDR_cloud_base_datarefs={}
simDR_cloud_base_datarefs[0] = find_dataref("sim/weather/cloud_base_msl_m[0]")
simDR_cloud_base_datarefs[1] = find_dataref("sim/weather/cloud_base_msl_m[1]")
simDR_cloud_base_datarefs[2] = find_dataref("sim/weather/cloud_base_msl_m[2]")
simDR_cloud_tops_datarefs={}
simDR_cloud_tops_datarefs[0] = find_dataref("sim/weather/cloud_tops_msl_m[0]")
simDR_cloud_tops_datarefs[1] = find_dataref("sim/weather/cloud_tops_msl_m[1]")
simDR_cloud_tops_datarefs[2] = find_dataref("sim/weather/cloud_tops_msl_m[2]")
simDR_cloud_type_datarefs={}
simDR_cloud_type_datarefs[0] = find_dataref("sim/weather/cloud_type[0]")
simDR_cloud_type_datarefs[1] = find_dataref("sim/weather/cloud_type[1]")
simDR_cloud_type_datarefs[2] = find_dataref("sim/weather/cloud_type[2]")

simDR_cloud_coverage_datarefs={}
simDR_cloud_coverage_datarefs[0] = find_dataref("sim/weather/cloud_coverage[0]")
simDR_cloud_coverage_datarefs[1] = find_dataref("sim/weather/cloud_coverage[1]")
simDR_cloud_coverage_datarefs[2] = find_dataref("sim/weather/cloud_coverage[2]")




simDR_whiteout = find_dataref("sim/private/controls/skyc/white_out_in_clouds")
simDR_fog = find_dataref("sim/private/controls/fog/fog_be_gone")
simDR_dsf_min = find_dataref("sim/private/controls/skyc/min_dsf_vis_ever")
simDR_dsf_max = find_dataref("sim/private/controls/skyc/max_dsf_vis_ever")
simDRTime=find_dataref("sim/time/total_running_time_sec")
simDR_VR=find_dataref("sim/graphics/VR/enabled")
cloud_tint_dataref = find_dataref("volumetric_clouds/cloud_tint");
atmosphere_tint_dataref = find_dataref("volumetric_clouds/atmosphere_tint")
cldDR_blue_noise_scale = find_dataref("volumetric_clouds/blue_noise_scale");--defined in the xpl

cldI_cloud_base_datarefs = {};
--cldI_cloud_type_datarefs = {};
cldI_cloud_height_datarefs = {};
cldI_cloud_density_datarefs = {};
cldI_cloud_coverage_datarefs = {};
cldI_sun_gain = 2.25;
cldT_cloud_base_datarefs = {};
--cldT_cloud_type_datarefs = {};
cldT_cloud_height_datarefs = {};
cldT_cloud_density_datarefs = {};
cldT_cloud_coverage_datarefs = {};
cldT_sun_gain = 2.25;
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
local lastUpdate=0;

function interpolate_value(initial_value, target)
    local diff=simDRTime-lastUpdate
    local percent_complete=diff/transitionTimeSecs
    
    if percent_complete>=1.0 then return target end
   
    retVal = initial_value+(target-initial_value)*percent_complete
    --print(target .. " " .. percent_complete .. " "..retVal)
    return retVal
end


function getDensity(i)
  if simDR_cloud_type_datarefs[i]==1 then return 0.1
  elseif simDR_cloud_type_datarefs[i]==4 then return 0.5
  elseif simDR_cloud_coverage_datarefs[i] <=2 then return 0.1
  else
    return 0.1
  end
  
end


function newWeather()
  for i = 0, 2, 1 do
    cldI_cloud_base_datarefs[i] = cldDR_cloud_base_datarefs[i];
    --cldI_cloud_type_datarefs[i] = cldDR_cloud_type_datarefs[i];
    cldI_cloud_height_datarefs[i] = cldDR_cloud_height_datarefs[i];
    cldI_cloud_density_datarefs[i] = cldDR_cloud_density_datarefs[i];
    cldI_cloud_coverage_datarefs[i] = cldDR_cloud_coverage_datarefs[i];
    cldI_sun_gain=cldDR_sun_gain
    
    cldT_cloud_base_datarefs[i]=simDR_cloud_base_datarefs[i]
    if cldDR_cloud_type_datarefs[i]>1 then 
	  cldT_cloud_height_datarefs[i]=(simDR_cloud_tops_datarefs[i]-simDR_cloud_base_datarefs[i])*cloudheightMod
	  cldT_cloud_coverage_datarefs[i]=math.min(((simDR_cloud_coverage_datarefs[i]-1) /5),1.0)
	  
	  cldT_sun_gain=2.25
      elseif cldDR_cloud_type_datarefs[i]>0 then --scattered few and cirrus
	  cldT_cloud_height_datarefs[i]=500
	  cldT_cloud_coverage_datarefs[i]=math.min(((simDR_cloud_coverage_datarefs[i]-1) /5),1.0)
	  cldT_sun_gain=3
      else
	cldI_cloud_base_datarefs[i] = cldDR_cloud_base_datarefs[0]
	cldI_cloud_height_datarefs[i] = cldDR_cloud_height_datarefs[0]
	cldI_cloud_density_datarefs[i] = cldDR_cloud_density_datarefs[0]
	cldI_cloud_coverage_datarefs[i] = cldDR_cloud_coverage_datarefs[0]

	cldT_cloud_coverage_datarefs[i]=0
      end
      cldT_cloud_density_datarefs[i]=getDensity(i)
  end
  cldI_sun_gain=cldDR_sun_gain
  lastUpdate=simDRTime
  print("New Weather")
end
function isNewWeather()
    local retVal=false
    for i = 0, 2, 1 do
      if cldT_cloud_base_datarefs[i]~=simDR_cloud_base_datarefs[i] then retVal=true end
      if cldDR_cloud_type_datarefs[i]>1 and cldT_cloud_height_datarefs[i]~=(simDR_cloud_tops_datarefs[i]-simDR_cloud_base_datarefs[i])*cloudheightMod then retVal=true end
    end
    
    
    return retVal
end


function flight_start()
  simDR_whiteout=1
  simDR_fog=0.2
  simDR_dsf_min=500000
  simDR_dsf_max=200000
  cloud_tint_dataref[0]=0.9
  cloud_tint_dataref[1]=0.9
  cloud_tint_dataref[2]=1.0
  atmosphere_tint_dataref[0]=0.35
  atmosphere_tint_dataref[1]=0.575
  atmosphere_tint_dataref[2]=1.0
  for i = 0, 2, 1 do
    cldT_cloud_height_datarefs[i]=(simDR_cloud_tops_datarefs[0]-simDR_cloud_base_datarefs[0])*cloudheightMod
    cldT_cloud_coverage_datarefs[i]=math.min((simDR_cloud_coverage_datarefs[0]-1 /5),1.0)
  end
  newWeather()
  for i = 0, 2, 1 do
    cldDR_cloud_type_datarefs[i]=simDR_cloud_type_datarefs[i]
    cldI_cloud_base_datarefs[i] = cldT_cloud_base_datarefs[i]
    cldI_cloud_height_datarefs[i] = cldT_cloud_height_datarefs[i]
    cldI_cloud_density_datarefs[i] = cldT_cloud_density_datarefs[i]
    cldI_cloud_coverage_datarefs[i] = cldT_cloud_coverage_datarefs[i]
   
  end
  lastUpdate=simDRTime+transitionTimeSecs-5
  cldDR_sun_gain=cldT_sun_gain
  cldI_sun_gain=cldDR_sun_gain
  after_physics()
  newWeather()
end

function setCloudTinting()
  
  
  if simDR_sun_pitch>8 then
    cldDR_sun_tint_red_dataref = simDR_sun_tint_red_dataref
    cldDR_sun_tint_green_dataref =simDR_sun_tint_green_dataref*simDR_sun_tint_red_dataref/0.75
    cldDR_sun_tint_blue_dataref =simDR_sun_tint_blue_dataref*simDR_sun_tint_red_dataref/0.75
  else
    cldDR_sun_tint_red_dataref = simDR_sun_tint_red_dataref
    cldDR_sun_tint_green_dataref =simDR_sun_tint_green_dataref
    cldDR_sun_tint_blue_dataref =simDR_sun_tint_blue_dataref
  end
end
function refreshSIMDRs()
  
end

function after_physics()
  if simDR_VR==1 then 
    cldDR_blue_noise_scale=0
  else
    cldDR_blue_noise_scale=0.01
  end
  
  
  setCloudTinting()
  local diff=simDRTime-lastUpdate
  if diff>transitionTimeSecs or isNewWeather()==true then newWeather() end
  
  
  
  local targetSungain=2.25
  local cirrusOnly=0
  for i = 0, 2, 1 do
    --[[make sure these are always fresh
    local a=simDR_cloud_base_datarefs[i]
    local b=simDR_cloud_tops_datarefs[i]
    local c=simDR_cloud_coverage_datarefs[i]
    ]]
    cirrusOnly=cirrusOnly+simDR_cloud_type_datarefs[i]
    if simDR_cloud_coverage_datarefs[i] > 1 then --few scattered
      cirrusOnly=cirrusOnly+1
    end
  end
  
  if cirrusOnly~=1 then --not cirrus
    simDR_override_clouds=1
  else
    simDR_override_clouds=0
   end
    for i = 0, 2, 1 do
      --print(i .. " " ..cldDR_cloud_base_datarefs[i])
      cldDR_cloud_base_datarefs[i]=interpolate_value(cldI_cloud_base_datarefs[i],cldT_cloud_base_datarefs[i])
      cldDR_cloud_height_datarefs[i]=interpolate_value(cldI_cloud_height_datarefs[i],cldT_cloud_height_datarefs[i])
      
      cldDR_cloud_coverage_datarefs[i]=interpolate_value(cldI_cloud_coverage_datarefs[i],cldT_cloud_coverage_datarefs[i])
      cldDR_cloud_density_datarefs[i]=interpolate_value(cldI_cloud_density_datarefs[i],cldT_cloud_density_datarefs[i])  
      --print(i .. " b=" .. cldDR_cloud_base_datarefs[i] .." h=" ..cldDR_cloud_height_datarefs[i] .. " d="..diff)
      if simDR_cloud_type_datarefs[i] >0 and cirrusOnly~=1 then
	cldDR_cloud_type_datarefs[i]=simDR_cloud_type_datarefs[i]
      elseif cldDR_cloud_coverage_datarefs[i]<0.05 then
	cldDR_cloud_type_datarefs[i]=0
      end
      --if simDR_cloud_type_datarefs[i]==4 then targetSungain=1 end
    end
  
  
    --cldDR_sun_gain=animate_value(cldDR_sun_gain,targetSungain,1,2.25,1)
    cldDR_sun_gain=interpolate_value(cldI_sun_gain,cldT_sun_gain)
end

