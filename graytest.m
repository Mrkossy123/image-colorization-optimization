imag=imread('Tragos.png');
grayscale_imag=rgb2gray(imag);
imshow(grayscale_imag);
grayscale_imag=cat(3,grayscale_imag,grayscale_imag,grayscale_imag);
imwrite(grayscale_imag,"Tragos_grayscale.png");

