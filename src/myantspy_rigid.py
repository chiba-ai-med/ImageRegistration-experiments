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

# Loading
moving_image = ants.image_read(infile1)
fixed_image = ants.image_read(infile2)

# Image Registration (SyN)
mytx = ants.registration(fixed=fixed_image, moving=moving_image, type_of_transform='Rigid')

# Warping
warped = mytx['warpedmovout']
warped_np = warped.numpy()

# Save
np.savetxt(outfile1, warped_np, fmt="%d")

with open(outfile2, 'wb') as f:
    pickle.dump(warped, f)

with open(outfile3, 'wb') as f:
    pickle.dump(mytx, f)
