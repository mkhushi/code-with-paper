import pandas as pd
import wave_process
import ta_feature

"""
This code use all the dataset USDJPY M5 dataset from 2004.1.1 to 2020.6.9,if you want
to change it,just slice the dataframe
"""

csv_file = "./data/USDJPY-5M-2004.1.1-2020.6.9.csv"
csv_data = pd.read_csv(csv_file, low_memory = False)
csv_df = pd.DataFrame(csv_data)
data=csv_df


# Label
data['label4'] = ''

for i in range(1,data.shape[0]-4):
    data['label4'][i]=(data['Close'][i+4]-data['Close'][i-1])/data['Close'][i-1]

# In case that the label is too small to affect the prediction, multiply by 1000 and it will be processed in the final result
data["label4"]=data["label4"]*1000
data=data[0:-4]


# Denoised
data['Close_wave'],data['High_wave'],data['Low_wave'],\
data['Open_wave']=wave_process.denoising([data['Close'],data['High'],data['Low'],data['Open']])


# Add technical indicators
data=ta_feature.add(data)


outputpath="./data/ProcessedUSDJPY-5M-2004.1.1-2020.6.9.csv"
data.to_csv(outputpath,sep=',',index=True,header=True)