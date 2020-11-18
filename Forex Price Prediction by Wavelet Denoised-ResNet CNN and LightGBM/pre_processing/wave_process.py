import pywt
import matplotlib.pyplot as plt

def wavelet_denoising(data):


    # db4
    db1 = pywt.Wavelet('sym15')
    # print(db1)
    
    # Decompose
    coeffs = pywt.wavedec(data, db1,level=2)


    # # print(len(coeffs),coeffs)
    # for item in coeffs:
    #     plt.plot(item)
    #     plt.show()


    coeffs[len(coeffs)-1] *= 0
    coeffs[len(coeffs)-2] *= 0


    # reconstruct
    meta = pywt.waverec(coeffs, db1)

    return meta[:len(data)]

def denoising(list_):
    output=[]
    for item in list_:
        output.append(wavelet_denoising(item))
    return output