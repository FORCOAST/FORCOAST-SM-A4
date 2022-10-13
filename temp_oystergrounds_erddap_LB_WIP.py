#!/usr/bin/env python2
# -*- coding: utf-8 -*-

#(C) Copyright FORCOAST H2020 project under Grant No. 870465. All rights reserved.

# Copyright notice
# --------------------------------------------------------------------
#  Copyright 2022 RBINS, Deltares
#   Léo Barbut, Gido Stoop
#
#   lbarbut@naturalsciences.be, gido.stoop@deltares.nl
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#
#        http://www.apache.org/licenses/LICENSE-2.0
# --------------------------------------------------------------------
"""
Created on Mon Aug 24 18:59:04 2020
pythonscript for /home/optos/new_postprocessing/procs/westdiep.pl
@author: kbaetens lbarbut
""" 


from datetime import datetime,timedelta
import numpy as np
import xarray as xr
import requests
import sys
import pandas as pd
import df2img

#Input
#===========================================================
variable = "sea_surface_temperature"
#grounds = np.loadtxt("/home/kbaetens/" )
#definition of spawning groud where temperature will be assess
grounds = np.loadtxt(r"/usr/src/app/SG_oyster.dat")
ground_id =[3,4,5,6,7]
ndays = 3

#Biological input
#switch temperaturethreshold (0) or cumulative Temperature (1)
Param_threshold_methods = float(sys.argv[1])

#Temperature threshold in C
Threshold_temperature = float(sys.argv[2])


#variable to define threshold of temperature for gonade devellopement in C (default  = 0)
Gonade_dev_threshold = float(sys.argv[3])
#variable to define threshold of cumulative temperature  (default  oyster 576)
Threshold_temperature_cumulative_sum = float(sys.argv[4])

#Information relative to pelagic larval duration of the selected species (swarming should be includ)
Pld_min = int(sys.argv[5])
Pld_max = int(sys.argv[6])

#Duration of spawning period
Spawning_duration = int(sys.argv[7])


#Subroutines and functions
#=============================================================================
def extractlist(lst):
    return [item[3] for item in lst] 

def extracttemp(daystart,dayend,lonlat,npos,ndays,var):
    
    cumstart = "{}-01-01".format(datetime.now().strftime("%Y"))
    inputfile="erddap.nc"
    #make the area to download as small as possible:
    maxlon = np.max(lonlat[:,0])
    minlon =np.min(lonlat[:,0])
    maxlat =np.max(lonlat[:,1])
    minlat =np.min(lonlat[:,1])
    #get data from the erddap server as a netcdf file
    #from jan 1 of the current year till ndays ahead
    #KB: you can also open this file with xarray!!!!!, I'm leaving it for now, but will change it in the future
    url = "https://erddap.naturalsciences.be/erddap/griddap/NOS_HydroState_V1.nc?"\
             +var+\
                 "[("+cumstart+"T00:00:00Z"+"):1:("+dayend+"T23:00:00Z)]"+\
                     "[("+str(minlat)+"):1:("+str(maxlat)+")]"+\
                         "[("+str(minlon)+"):1:("+str(maxlon)+")]"
                       
    r = requests.get(url)
    with open(inputfile,'wb') as f:
        f.write(r.content)
    #open the datafile as an object
    datafile = xr.open_dataset(inputfile)
    #give the variable a generic name (generalization of this function)
    new_datafile = datafile.rename({var:'variable'})
    #resample the file to days 
    resample_data = new_datafile.resample(time="24H").mean()
    
    #make sure lonlat are sorted in ascending order (KB:check if really necessary!)
    lonlat=lonlat[np.lexsort(lonlat[:,::-2].T)]
       
    #select the positions needed with nearest neighbor method
    ##
    lats=lonlat[:,1]
    lats_1 = xr.DataArray(lats, dims='points') #'z' is an arbitrary name placeholder
    lons=lonlat[:,0]
    lons_1 = xr.DataArray(lons, dims='points') #'z' is an arbitrary name placeholder
    result = resample_data["variable"].sel(longitude=lons_1,latitude=lats_1, method='nearest')
    ##in case you want to make a 2D plot of this (to check results), you have to reindex and unstack the dataset object:
      #result2=result.set_index(points=["latitude","longitude"])
      #result1=result2.unstack()
      #result1[0,:,:].plot()
        
    #calculate the average daily temp for today and n days ahead
    daily_result = result.mean(dim="points",skipna=True)
    temp_forecast=daily_result.loc[daystart:dayend]
    #temp_forecast.plot.line(add_legend=True)
        
    #calculate cumulative temperatures from jan 1st till n days ahead (in K though!)
    # The value was compute upper the temperature threshold for gonade maturation
    cum_result = daily_result.cumsum()
    #cum_result.plot.line()
    
    #close datasets to prevent unexpected behaviour
    datafile.close()
    lats_1.close()
    lons_1.close()
    #remove the inputfile to prevent unexpected behaviour
    del inputfile
      
    #return the output values
    return temp_forecast,cum_result,daily_result
  
def Bilogical_function(groundresult_time_series_temp,groundresult_time_series_date,Param_threshold_methods,Gonade_dev_threshold,Threshold_temperature,Threshold_temperature_cumulative_sum,Pld_min,Pld_max,Spawning_duration):
    
    #choice of the methods used
    if Param_threshold_methods == 0:
        aaa = np.where(groundresult_time_series_temp > Threshold_temperature +  273.15)
        if len(aaa[0]) > 0:
            date_selected_index = np.min(aaa)
            date_selected = groundresult_time_series_date[np.array([date_selected_index])]
            ### computation of the period where spat are likely to arrive    
            First_arrival = date_selected + np.timedelta64(Pld_min, 'D')
            Last_arrival = date_selected + np.timedelta64(Pld_max, 'D') + np.timedelta64(Spawning_duration, 'D')
        else:
            First_arrival = ["no spawning detected yet"]
            Last_arrival = ["no spawning detected yet"]
       

    elif Param_threshold_methods == 1:
        daily_result_inC = groundresult_time_series_temp - 273.15 - Gonade_dev_threshold
        daily_result_inC[daily_result_inC < 0] = 0
        cum_result = daily_result_inC.cumsum()
        aaa = np.where(cum_result > Threshold_temperature_cumulative_sum)
        if len(aaa[0]) > 0:
            date_selected_index = np.min(aaa)
            date_selected = groundresult_time_series_date[np.array([date_selected_index])]
        ### computation of the period where spat are likely to arrive 
            First_arrival = date_selected + np.timedelta64(Pld_min, 'D')
            Last_arrival = date_selected + np.timedelta64(Pld_max, 'D') + np.timedelta64(Spawning_duration, 'D')
        else:
            First_arrival = ["no spawning detected yet"]
            Last_arrival = ["no spawning detected yet"]            
        
    else:
        print("wrong methods parameters")
            
       
    #return output value
    return First_arrival,Last_arrival
    
# #Central program
# #==========================================================
# noystergrounds= len(ground_id)
# outputfile=[]
# #1. Time 
# #-------------------
# ##get data in integer utc time and convert to string
# dateSST_start = datetime.utcnow()
# dateSST_str_start = dateSST_start.strftime("%Y-%m-%d")
# dateSST_end = datetime.utcnow()+timedelta(days=ndays)
# dateSST_str_end = dateSST_end.strftime("%Y-%m-%d")

# #2. body
# #-------------------
# ## loop over oystergrounds
# for x in range(len(ground_id)):
#     # 2.1 select lonlats only for relevant oysterground and create outputfile
#     ground = grounds[np.any(grounds==ground_id[x],axis=1),:]
#     outputfile="ground"+str(ground_id[x])+variable+"_results.txt"
    
        
#     #2.2 extract variable for current oysterground
#     groundresult = []
#     groundresult = extracttemp(dateSST_str_start,dateSST_str_end, ground, len(ground), ndays, variable)
#     groundresult_var = np.array(groundresult[0])
#     groundresult_cum = np.array(groundresult[1])
#     date=groundresult[0].time.dt.strftime("%d-%m-%y")                   
#     ground_time = np.array(date)
#     #2.3 write results to outputfile
#     with open(outputfile, 'w') as f:
#         f.write("results of oysterground "+str(ground_id[x])+"\n)")
#         f.write("\n")
#         f.write("daily average forecast: \n")
#         f.write("time(d-m-y), "+variable+"(K)\n")
#         f.write("==================================\n")
#         f.write(str(ground_time)+"\n")
#         f.write(str(groundresult_var)+"\n")
#         f.write("\n")
#         f.write("cumulative temperatures: \n")
#         f.write("time(d-m-y), "+variable+"(K)\n")
#         f.write("==================================\n")
#         start=-2-ndays
#         f.write(str(ground_time)+"\n")
#         f.write(str(groundresult_cum[start:-1])+"\n")

######## Main program
#outputfile=r"/usr/src/app/output/ground_results.txt"
#f = open(outputfile, 'w') 

noystergrounds= len(ground_id)
#outputfile=[]
#1. Time 
#-------------------
##get data in integer utc time and convert to string
dateSST_start = datetime.utcnow()
dateSST_str_start = dateSST_start.strftime("%Y-%m-%d")
dateSST_end = datetime.utcnow()+timedelta(days=ndays)
dateSST_str_end = dateSST_end.strftime("%Y-%m-%d")

#2. body
#-------------------
for x in range(len(ground_id)):
    # 2.1 select lonlats only for relevant oysterground and create outputfile
    ground = grounds[np.any(grounds==ground_id[x],axis=1),:]
 
        
    #2.2 extract variable for current oysterground
    groundresult = []
    groundresult = extracttemp(dateSST_str_start,dateSST_str_end, ground, len(ground), ndays, variable)
    groundresult_var = np.array(groundresult[0])
    groundresult_cum = np.array(groundresult[1])
    date=groundresult[0].time.dt.strftime("%d-%m-%y")                       
    ground_time = np.array(date)
    groundresult_time_series_temp = np.array(groundresult[2])
    groundresult_time_series_date = groundresult[2].time

    try:
        Bio_res = Bilogical_function(groundresult_time_series_temp,groundresult_time_series_date,Param_threshold_methods,Gonade_dev_threshold,Threshold_temperature,Threshold_temperature_cumulative_sum,Pld_min,Pld_max,Spawning_duration)
        First_arrival_timestamp = pd.Timestamp(np.datetime64(str(Bio_res[0].values[0]))).strftime("%d-%m-%y")
        Last_arrival_timestamp = pd.Timestamp(np.datetime64(str(Bio_res[1].values[0]))).strftime("%d-%m-%y")
        
        if x == 0:
            surf_temp_df = pd.DataFrame((float(groundresult_var[0]),float(groundresult_var[1]),float(groundresult_var[2]),float(groundresult_var[3])), index=[ground_time[0], ground_time[1], ground_time[2], ground_time[3]], columns=['Oysterground 4 (K)'])
            arrival_data = {'First arrival': [First_arrival_timestamp], 'Last arrival': [Last_arrival_timestamp]}
            arrival_df = pd.DataFrame(data=arrival_data, index=[3])
        else: 
            surf_temp_df.insert((x), 'Oysterground {} (K)'.format(x+4), (float(groundresult_var[0]),float(groundresult_var[1]),float(groundresult_var[2]),float(groundresult_var[3])))
            arrival_data = {'First arrival': [First_arrival_timestamp], 'Last arrival': [Last_arrival_timestamp]}
            arrival_df_temporary = pd.DataFrame(data=arrival_data, index=[x+3])
            arrival_df = pd.concat([arrival_df, arrival_df_temporary])
    except:
        if x == 0:
            surf_temp_df = pd.DataFrame((float(groundresult_var[0]),float(groundresult_var[1]),float(groundresult_var[2]),float(groundresult_var[3])), index=[ground_time[0], ground_time[1], ground_time[2], ground_time[3]], columns=['Oysterground 4 (K)'])
            arrival_data = {'First arrival': ["No spawning events"], 'Last arrival': ["No spawning events"]}
            arrival_df = pd.DataFrame(data=arrival_data, index=[3])
        else: 
            surf_temp_df.insert((x), 'Oysterground {} (K)'.format(x+4), (float(groundresult_var[0]),float(groundresult_var[1]),float(groundresult_var[2]),float(groundresult_var[3])))
            arrival_data = {'First arrival': ["No spawning events"], 'Last arrival': ["No spawning events"]}
            arrival_df_temporary = pd.DataFrame(data=arrival_data, index=[x+3])
            arrival_df = pd.concat([arrival_df, arrival_df_temporary])
    

    #2.3 write results to outputfile

#    f.write("results of oysterground "+str(ground_id[x])+"\n")
#    f.write("\n")
#    f.write("daily average forecast: \n")
#    f.write("time(d-m-y), "+variable+"(K)\n")
#    f.write("==================================\n")
#    f.write(str(ground_time)+"\n")
#    f.write(str(groundresult_var)+"\n")
#    f.write("\n")
#    f.write("likely arrival: \n")
#    f.write("time(d-m-y)\n")
#    f.write("==================================\n")
#    f.write("from "+str(First_arrival_timestamp)+" until "+str(Last_arrival_timestamp)+"\n")
 
#f.close()

#3. Export output
# export dataframes to png
#surf_temp_df = surf_temp_df.round(decimals=1)
#surf_temp_df = surf_temp_df.rename_axis("Date")
#surf_temp_fig = df2img.plot_dataframe(surf_temp_df, title=dict(text="Sea surface temperature of the Oystergrounds in Kelvin"), fig_size=(800, 200))
arrival_df = arrival_df.rename_axis("Spawning ground")
arrival_df = arrival_df.rename(index={3:'Western Scheldt', 4:'Belgian North Sea', 5:'French North Coast', 6:'English South Coast', 7:'English South-East Coast'})
arrival_fig = df2img.plot_dataframe(arrival_df, title=dict(text="                    First and last arrivals per Oysterground"), fig_size=(800, 200))


#df2img.save_dataframe(fig=surf_temp_fig, filename=r"/usr/src/app/output/surf_temp.png")
df2img.save_dataframe(fig=arrival_fig, filename=r"/usr/src/app/output/arrival.png")
print(datetime.now())




