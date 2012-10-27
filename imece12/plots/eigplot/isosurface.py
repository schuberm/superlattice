import numpy as np
from mayavi import mlab

x, y, z = np.ogrid[-10:10:20j, -10:10:20j, -10:10:20j]
s = np.sin(x*y*z)/(x*y*z)

src = mlab.pipeline.scalar_field(s)
mlab.pipeline.iso_surface(src, contours=[s.min()+0.1*s.ptp(), ], opacity=0.3)
mlab.pipeline.iso_surface(src, contours=[s.max()-0.1*s.ptp(), ],)

#mlab.show()
