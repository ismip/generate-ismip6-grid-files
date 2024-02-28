% Generate a number of ISM grid files based on the same projection
% at different resolutions. Checks if integer subdivision for chosen base grid
% and resolution
% For ice masks https://github.com/chadagreene/greenland-icemask

clear all
close all

% for checking 
isaninteger = @(x) mod(x, 1) == 0;

%% Specify mapping information. This is EPSG 3413
proj_info.earthradius=6378137.0;
proj_info.eccentricity=0.081819190842621;
proj_info.standard_parallel=70.;
proj_info.longitude_rot=315.;
% offset of grid node centers
proj_info.falseeasting=699907.5;
proj_info.falsenorthing=3400012.5;

%% Specify output angle type (degrees or radians)
%output_data_type='radians';
output_data_type='degrees';

%% Specify ISM grid resolution
rk = 480;
nx_base=3334;
ny_base=5834;

%rk = 240;
%nx_base=6667;
%ny_base=11667;

%rk = 120;
%nx_base=13333;
%ny_base=23334;

% choose which output file to write
flag_nc = 1;
flag_txt = 0;
flag_xy = 1;

index=0;
for r=rk
% For any resolution but check integer grid numbers
    nx = (nx_base);
    ny = (ny_base);
    if(isaninteger(nx) & isaninteger(ny))
        index=index+1;
        grid(index).dx=r*1.;
        grid(index).dy=r*1.;
        grid(index).nx_centers=(nx);
        grid(index).ny_centers=(ny);
        grid(index).LatLonOutputFileName=['grid_IceMask_GrIS_' sprintf('%05d',r*1) 'm.nc'];
        grid(index).CDOOutputFileName=['grid_IceMask_GrIS_' sprintf('%05d',r*1) 'm.txt'];
        grid(index).xyOutputFileName=['xy_IceMask_GrIS_' sprintf('%05d',r*1) 'm.nc'];
    else
        disp(['Warning: resolution ' num2str(r) ' m is not comensurable, skipped.'])
    end
end

% Create grids and write out
for g=1:length(grid)
    success = generate_CDO_files_nc(grid(g),proj_info,output_data_type,flag_nc,flag_txt,flag_xy);
end
