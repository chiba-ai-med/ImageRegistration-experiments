# -*- coding: utf-8 -*-
import sys
import SimpleITK as sitk
import numpy as np
import pickle

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
outfile1 = args[3]
outfile2 = args[4]
outfile3 = args[5]
# infile1 = 'data/sma_neg_trs/source/exp_res_fix.nii'
# infile2 = 'data/sma_neg_trs/target/exp_res_fix.nii'

# Loading
moving_image = sitk.ReadImage(infile1)
fixed_image = sitk.ReadImage(infile2)

# Image Registration
rigid_transform = sitk.CenteredTransformInitializer(
    fixed_image, 
    moving_image, 
    sitk.Euler2DTransform(), 
    sitk.CenteredTransformInitializerFilter.GEOMETRY
)

registration_method = sitk.ImageRegistrationMethod()
registration_method.SetMetricAsMeanSquares()
registration_method.SetOptimizerAsRegularStepGradientDescent(
    learningRate=1.0, minStep=1e-4, numberOfIterations=200
)

registration_method.SetOptimizerScalesFromPhysicalShift()
registration_method.SetInitialTransform(rigid_transform, inPlace=False)
registration_method.SetInterpolator(sitk.sitkLinear)

mytx = registration_method.Execute(fixed_image, moving_image)

# Warping
warped = sitk.Resample(moving_image, fixed_image, mytx, sitk.sitkLinear, 0.0, moving_image.GetPixelID())

warped_np = sitk.GetArrayFromImage(warped)

# Save
np.savetxt(outfile1, warped_np, fmt="%d")

with open(outfile2, 'wb') as f:
    pickle.dump(warped, f)

with open(outfile3, 'wb') as f:
    pickle.dump(mytx, f)
