import pandas as pd

labels = [3,2,1,0]
data = ['A','B','C','D']
series = pd.Series(data,index=labels)
print(series.iloc[0])


