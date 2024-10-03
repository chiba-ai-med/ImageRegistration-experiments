# -*- coding: utf-8 -*-
import sys
import SimpleITK as sitk
import numpy as np
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from src.functions import csv2img3
import pickle

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
infile3 = args[3]
infile4 = args[4]
infile5 = args[5]
infile6 = args[6]
outfile1 = args[7]
outfile2 = args[8]
outfile3 = args[9]
outfile4 = args[10]

# Loading
source_exp = np.loadtxt(infile1)
target_exp = np.loadtxt(infile2)
source_x_corrdinate = np.loadtxt(infile3, dtype='int')
target_x_corrdinate = np.loadtxt(infile4, dtype='int')
source_y_corrdinate = np.loadtxt(infile5, dtype='int')
target_y_corrdinate = np.loadtxt(infile6, dtype='int')

# Numpy => SimpleITK Object
moving_image = sitk.GetImageFromArray(csv2img3(source_x_corrdinate, source_y_corrdinate, source_exp))
fixed_image = sitk.GetImageFromArray(csv2img3(target_x_corrdinate, target_y_corrdinate, target_exp))

# Image Registration
# BSpline Registration
transform_domain_mesh_size = [8] * fixed_image.GetDimension()
bspline_transform = sitk.BSplineTransformInitializer(fixed_image, transform_domain_mesh_size)

registration_method = sitk.ImageRegistrationMethod()
registration_method.SetMetricAsMattesMutualInformation(numberOfHistogramBins=50)
registration_method.SetOptimizerAsLBFGSB(gradientConvergenceTolerance=1e-5, numberOfIterations=200)
registration_method.SetInitialTransform(bspline_transform, inPlace=False)
registration_method.SetInterpolator(sitk.sitkLinear)

initial_transform = sitk.CenteredTransformInitializer(
    fixed_image, 
    moving_image, 
    sitk.Euler2DTransform(),  # または適切な次元数のTransform
    sitk.CenteredTransformInitializerFilter.GEOMETRY
)
registration_method.SetInitialTransform(initial_transform, inPlace=False)

final_transform = registration_method.Execute(fixed_image, moving_image)


# rigid_transform = sitk.CenteredTransformInitializer(
#     fixed_image, 
#     moving_image, 
#     sitk.Euler2DTransform(), 
#     sitk.CenteredTransformInitializerFilter.GEOMETRY
# )

# registration_method = sitk.ImageRegistrationMethod()
# registration_method.SetMetricAsMeanSquares()
# registration_method.SetOptimizerAsRegularStepGradientDescent(
#     learningRate=1.0, minStep=1e-4, numberOfIterations=200
# )

# registration_method.SetOptimizerScalesFromPhysicalShift()
# registration_method.SetInitialTransform(rigid_transform, inPlace=False)
# registration_method.SetInterpolator(sitk.sitkLinear)

# mytx = registration_method.Execute(fixed_image, moving_image)

# Warping
warped = sitk.Resample(moving_image, fixed_image, mytx, sitk.sitkLinear, 0.0, moving_image.GetPixelID())
warped_np = sitk.GetArrayFromImage(warped)
warped_np_vec = warped_np.T.flatten()

# Save
np.savetxt(outfile1, warped_np, fmt="%d")
np.savetxt(outfile2, warped_np_vec, fmt="%d")

with open(outfile3, 'wb') as f:
    pickle.dump(warped, f)

with open(outfile4, 'wb') as f:
    pickle.dump(mytx, f)
