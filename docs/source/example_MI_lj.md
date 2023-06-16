# Mold integration for 100 plane of Lennard-Jones crystal

````{note}
In this section `/` is the package's root folder.
````

Here we provide a detailed instructions to reproduce the crystal fluid interfacial free energy using the BG and `square/well pair_style` available in LAMMPS. 

The data file (`mold_100.lmp`) and LAMMPS script (`lj_moldint.in`) is provided in the directory `/examples/lj_mold/`, but in this work example we will navigate through those files to explain them in detail.

The mold integration technique consists of different steps and here we only discuss the last two steps to obtain the interfacial energy of the 100 plane for the LJ particles at $T^\ast=0.617$ and $p^\ast=-0.02$. All the steps can be found in {footcite:t}`espinosa2014mold`, and they can be summarized as: 

1. Preparation of the configuration by embedding the mold coordinates (from a crystal configuration) into the fluid at coexistence conditions.
2. Choice of the [optimal well radius](#optimal-radius-calculation) $r_{0w}$ to extrapolate the interfacial energy.
3. Calculation of the interfacial energy for different well radii above the optimal radius
  $\gamma(r_{0w}>r_w)$. 
4. Extrapolation of the interfacial energy to the optimal radius $r_{0w}$.

The configuration (step 1) can be created easily using the liquid and crystal configuration at the corresponding $(p,T)$ conditions. In this example, we provide the system data file for the plane 100 of a LJ particles at $T^\ast=0.617$ and $p^\ast=-0.02$:

![Step-1](../figs/Fig1.png "Conf_MI")


## Optimal radius calculation 

The calculation of the optimal radius for extrapolation of the interfacial energy includes the following steps:

1. Create a directory sweeping different radii ($r_w=0.27,\ 0.28,\ \ldots,0.33,0.34\sigma$).
2. For each radius one needs to run different independent velocity seeds. Create 10 directories for each radius directory.
3. Copy the LAMMPS script file (`lj_mold.in`) in each subdirectory along with the configuration file (`mold_100.lmp`).
4. The LAMMPS script contains several variables that it is important to know to properly perform the simulations:
```
# ---------------------------- Define variables --------------------------------
variable  nts          equal  400000     # production number of time-steps
variable  ts           equal  0.001      # length of the ts (in lj units)
variable  siglj        equal  1.0        # sigma coefficient for BG pair-style
variable  epslj        equal  1.0        # epsilon coefficient for BG pair-style
variable  cut1         equal  2.3        # internal cut-off for BG pair-style
variable  cut2         equal  2.5        # external cut-off for BG pair-style
variable  rw           equal  0.33       # (reduced) width of the square well potential
variable  alpha        equal  0.005      # exponent of the square well potential
variable  nkT          equal  8.0        # well depth (reduced units) 
variable  seed         equal  23782      # velocity seed
variable  Tsyst        equal  0.617      # (reduced) temperature of the system
variable  Psyst        equal  -0.02      # (reduced) press of the system
variable  NtsTdamp     equal  100        # Number of ts to damp temperature
variable  NtsPdamp     equal  100        # Number of ts to damp pressure
variable  thermoSteps  equal  1000       # Number of ts to write properties on screen
variable  restartSteps equal  30000      # Number of ts before write restart file
variable  dumpSteps    equal  5000       # Number of ts before write dump file

# --------------------- Derivate variables -------------------------------------
variable cutoff1     equal  ${siglj}*${cut1}
variable cutoff2     equal  ${siglj}*${cut2}
variable cutoff_well equal  ${rw}*4.0
variable D           equal  ${nkT}*${Tsyst} # Depth of well
variable Tdamp       equal  ${NtsTdamp}*${ts}
variable Pdamp       equal  ${NtsPdamp}*${ts}


####  Define mold  ####
read_data       mold_100.lmp
group melt type 1
group mold type 2

```
For this step, the typical run must be approximately 200000 time-steps (with dt=1e-3), and that can be controlled by the parameter `nts`. 
Regarding the interaction potential, the parameter `rw` stands for the well radius so this must be changed for the different studies radii during this step `rw`=$0.27,\ 0.28,\ \ldots,0.33,0.34\sigma$. 
The parameter `nkT` gives the well depth in $k_{B}T$ units and for this step must be kept to 8 or bigger. 
Regarding the velocity seed, the variable `seed` controls this aspect and thus, it must be changed with a random integer number for each simulation. 
Also, there are some variables that might be interesting to know:
- `thermoSteps` gives the number of timesteps to print the thermo
- `restartSteps` indicates the frequency of saving the restart files
- `dumpSteps` is the number of steps to save the trajectory in the dump file and for this step it is recommended to be set to 2000.

5. Launch the simulation for each radius and seed. That means a total of 80 simulations, but they are quite short. 

6. The analysis of this step consists in determining if there is induction time, *i.e.* if that radius can be thermodynamically integrated. To do so, the resulting trajectory must be analyzed using the order parameter ${\bar{q}}_6$ to determine the number of particles on the cluster. 
The recommended values for such analysis is a threshold of ${\bar{q}}_6=0.34$, and a cutoff of $1.35\sigma$. As a result, one obtains different curves for the order parameter as a function of time for the different well radii:

![Step-1\label{kk}](../figs/Fig2.png "q6_time")

A system can be considered to be integrated if the order parameter remains close to the total number of molds within the system (98 wells for this example). Therefore, in this case we can consider $r_w=0.32\sigma$ as the greatest radius with not sufficiently long induction time so it is chosen as our optimal radius to extrapolate.

## Thermodynamic integration 

Once the optimal radius is estimated, the next step consists in thermodynamic integration of different radii above the optimal value of $r_w$. The calculation of the interfacial energy for the different well radii includes the following steps:

1. Create a directory for each radius to be integrated ($r_w=0.33,0.34,0.35\sigma$) and in each directory, create a for each well depth considered for the calculation.
```
\frac{\epsilon}{k_BT}=
0.00001
0.1
0.2
...
1.9
2.0
2.3
2.6
3
3.5
4
4.5
5
6
7
8
```

```{footbibliography}

```