# -*- coding: utf-8 -*-
import numpy as np
def winkler_score(y_true, y_pred, conf, p):
    ln_y_true = np.log(y_true).reshape(-1,1)
    ln_y_pred = np.log(y_pred).reshape(-1,1)
    # ln_y_true = y_true.reshape(-1,1)
    # ln_y_pred = y_pred.reshape(-1,1)
    ln_err =  ln_y_true-ln_y_pred
    std_list = []
    for i in range(10,ln_y_true.shape[0]):
        std_list.append(np.std(ln_err[:i+1,]))
    std_array = np.array(std_list).reshape(-1,1)
    
    L = ln_y_pred[10:] - std_array*conf
    U = ln_y_pred[10:] + std_array*conf
    W = U-L
    
    
    error = abs(ln_err[10:])
    j=0
    for q in range(error.shape[0]):
        if error[q]<W[q]/2:
            j=j+1
    acc = j/error.shape[0]
    
    
    W1 = W + 2*(L-ln_y_true[10:])/(1-p)
    W2 = W + 2*(ln_y_true[10:]-U)/(1-p)
    result = np.zeros(ln_y_true[10:].shape)
    for i in range(result.shape[0]):
        result[i,:] = np.max([W[i,:], W1[i,:], W2[i,:]])
        c = np.where(np.max([W[i,:], W1[i,:], W2[i,:]]))
        #print(c)
    return np.mean(result),np.mean(W),acc

#%%
# gj = 'Phi_Com'
# file = gj+'.xlsx'
# import pandas as pd
# datax = pd.read_excel(file,sheet_name ='sheet3',header = None) 
# datax_x = np.asarray(datax.iloc[:-1,:],'int64')
# data = pd.read_excel('常态期数据.xlsx',index_col=0) 
# datai = data.iloc[-datax_x.shape[0]:]
# y_true = np.array(datai[gj])
# y_true = y_true/10000
# #
# Wink = []
# Wid = []
# Accu = []
# for i in range(datax_x.shape[1]):
#     y_pred = np.array(datax_x[:,i])
#     a,W,acc = winkler_score(y_true, y_pred, 1.28, 0.8)
#     Wink.append(a)
#     Wid.append(W)
#     Accu.append(acc)
# #
# Winkx = pd.DataFrame(np.array(Wink).reshape(7,6)).T
# Widx = pd.DataFrame(np.array(Wid).reshape(7,6)).T
# Accux = pd.DataFrame(np.array(Accu).reshape(7,6)).T

# Int_zb = pd.concat([Winkx,Widx])
# Int_zb = pd.concat([Int_zb,Accux])

#%%
gj_t = ['Aus_Com']#['China_Com','Phi_Com','Sin_Com','Jap_Com','Kor_Com','USA_Com','Eng_Com','Aus_Com']#
for i in gj_t:
    
    gj = i
    file = gj+'.xlsx'
    import pandas as pd
    datax = pd.read_excel(file,sheet_name ='sheet3',header = None) 
    datax_x = np.asarray(datax.iloc[:,:],'float64')
    data = pd.read_excel('常态期数据.xlsx',index_col=0) 
    datai = data.iloc[-datax_x.shape[0]:]
    y_true = np.array(datai[gj])
    y_true = y_true/10000
    #
    Wink = []
    Wid = []
    Accu = []
    for i in range(datax_x.shape[1]):
        y_pred = np.array(datax_x[:,i])
        a,W,acc = winkler_score(y_true, y_pred, 1.28, 0.8)
        Wink.append(a)
        Wid.append(W)
        Accu.append(acc)
    #
    Winkx = pd.DataFrame(np.array(Wink).reshape(7,6)).T
    Widx = pd.DataFrame(np.array(Wid).reshape(7,6)).T
    Accux = pd.DataFrame(np.array(Accu).reshape(7,6)).T
    
    Int_zb = pd.concat([Winkx,Widx])
    Int_zb = pd.concat([Int_zb,Accux])
    #
    # writer = pd.ExcelWriter('区间指标.xlsx', mode="a", engine="openpyxl")
    # Int_zb.to_excel(writer, sheet_name=gj)#,columns= ['Naive','Snaive','ES','Sarima','SVR','ELM','BP']
    # writer.save()
    # writer.close()























