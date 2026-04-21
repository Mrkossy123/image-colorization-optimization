# Image Colorization using Optimization

A MATLAB/Octave implementation of **user-guided grayscale image colorization** based on sparse optimization.

This project reconstructs the chrominance channels of a grayscale image from a small number of user-provided color scribbles. The method is based on the idea that **neighboring pixels with similar luminance should have similar colors**, and formulates color propagation as a **sparse linear system**.

## Overview

The pipeline takes as input:

- a grayscale image
- the same image with user-added color scribbles

The image is converted to the **YUV color space**, where:

- **Y** represents luminance
- **U, V** represent chrominance

The luminance channel is kept from the original grayscale image, while the missing chrominance channels are estimated by solving an optimization problem over local neighborhoods.

## Method

The implementation follows the core idea of:

**Levin, A., Lischinski, D., Weiss, Y.**  
*Colorization using Optimization*, SIGGRAPH 2004.

Main steps:

1. Load the original grayscale image and the scribbled version.
2. Convert both images from RGB to YUV.
3. Keep the luminance channel **Y** from the grayscale image.
4. Detect pixels constrained by user color scribbles.
5. For unconstrained pixels, compute local affinity weights based on luminance similarity in a **3x3 neighborhood**.
6. Build a **sparse matrix** representing the neighborhood constraints.
7. Solve two sparse linear systems to reconstruct the **U** and **V** channels.
8. Combine **Y, U, V** and convert the result back to RGB.

## Technical Highlights

- MATLAB/Octave implementation
- RGB → YUV color space conversion
- Local luminance-based affinity modeling
- Sparse matrix construction using triplet form
- Linear system solution for chrominance propagation
- User-guided interactive colorization through scribbles

Author
Kostantinos-Andrianos Kossyvakis
