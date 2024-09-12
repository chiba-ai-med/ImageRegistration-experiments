# -*- coding: utf-8 -*-
import sys
import ants
import matplotlib.pyplot as plt
import numpy as np

# Arguments
args = sys.argv
infile1 = args[1]
infile2 = args[2]
infile3 = args[3]
outfile1 = args[4]
outfile2 = args[5]
outfile3 = args[6]
outfile4 = args[7]

# Loading
fixed_image = ants.image_read(infile1)
moving_image = ants.image_read(infile2)
warped = ants.from_numpy(np.loadtxt(infile3))

# Plot
def save_ants_plot(image, filename, overlay=None):
    ants.plot(image, overlay=overlay)
    plt.savefig(filename)
    plt.close()

save_ants_plot(fixed_image, outfile1)
save_ants_plot(moving_image, outfile2)
save_ants_plot(warped, outfile3)
save_ants_plot(warped, outfile4, overlay=warped > warped.mean())
