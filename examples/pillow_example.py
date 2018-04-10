from PIL import Image, ImageFilter
import numpy as np
import io

def julia(c, n):
    x = np.linspace(-2, 2, 640)
    y = np.linspace(-2, 2, 640)
    z = x + y[:,None]*1j

    for i in range(n):
        z = z*z + c

    return ((abs(z) <= 2)*255).astype('uint8')

if __name__ == '__main__':
    data = julia(-0.4+0.6j, 100)
    im = Image.fromarray(data, 'L')
    im.save('julia.jpg')

    im2 = im.filter(ImageFilter.BLUR)
    im2.save('julia_blur.jpg')
