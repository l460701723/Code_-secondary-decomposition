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























