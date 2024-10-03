# -*- coding: utf-8 -*-
import sys
import ants
import numpy as np
import pickle

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
outfile1 = args[3]
outfile2 = args[4]
outfile3 = args[5]
outfile4 = args[6]

# Loading
moving_image = ants.image_read(infile1)
fixed_image = ants.image_read(infile2)

# Image Registration (SyN)
mytx = ants.registration(fixed=fixed_image, moving=moving_image, type_of_transform='Rigid')

# Warping
warped = mytx['warpedmovout']
warped_np = warped.numpy()
warped_np_vec = warped_np.T.flatten()

# Save
np.savetxt(outfile1, warped_np, fmt="%d")
np.savetxt(outfile2, warped_np_vec, fmt="%d")

with open(outfile3, 'wb') as f:
    pickle.dump(warped, f)

with open(outfile4, 'wb') as f:
    pickle.dump(mytx, f)
