# XBOIL

<img src="assets/logo.svg" alt="XBOIL logo" width="400"/>

XBOIL is a MATLAB framework for the systematic evaluation of heat flux partitioning (HFP) models and associated bubble dynamics sub-models used in nucleate boiling modelling.

The framework evaluates HFP closures in a zero-dimensional (0-D), point-averaged setting, enabling exhaustive combinatorial sweeps across thousands of model configurations in minutes on a modern desktop.

## Associated publication

If you use XBOIL in your work, please cite:

> O. Bidar and M. Colombo,
> *Evaluations of boiling heat flux partitioning and bubble parameter models using a 0-D framework*,
> International Journal of Heat and Mass Transfer **269** (2026) 129059.
> [https://doi.org/10.1016/j.ijheatmasstransfer.2026.129059](https://www.sciencedirect.com/science/article/abs/pii/S0017931026007350)

## Requirements

- MATLAB R2020b or later
- [CoolProp](http://www.coolprop.org/) MATLAB wrapper (for fluid property lookups)
- MATLAB Parallel Computing Toolbox *(optional; required for parallel sweeps)*

## Repository structure

```
XBOIL/
├── startupXBOIL.m          % Path initialisation — run this first
├── modules/
│   ├── bubbleDynamicsParametersModels/   % Departure diameter, frequency,
│   │                                     % nucleation site density, growth
│   │                                     % and wait time sub-models
│   ├── heatFluxPartitioningModels/       % RPI, MIT/Kommajosyula, Kim & Kim
│   ├── postProcessing/                   % Error metrics, ranking, plotting
│   ├── dimensionlessNumbers/             % Jakob, Prandtl, Reynolds, Rayleigh
│   └── utilities/                        % Fluid properties, global params
├── data/                   % Experimental data (see data/README.md)
├── results/                % Sweep output (auto-created)
└── tutorials/
    ├── README.md                    % Full model reference and how-to guide
    ├── singleConfig/
    │   └── runSingleConfig.m        % Run one model configuration
    └── sweep/
        └── runSweepPhillips.m       % Combinatorial sweep (16,848 configs)
```

## Getting started

1. Install CoolProp for MATLAB and add it to your MATLAB path.
2. Place the experimental data file in `data/` (see `data/README.md`).
3. From the XBOIL root directory, initialise the module paths:

```matlab
startupXBOIL
```

4. Run the single-configuration tutorial:

```matlab
run('tutorials/singleConfig/runSingleConfig.m')
```

5. Or run the full combinatorial sweep:

```matlab
run('tutorials/sweep/runSweepPhillips.m')
```

Results are saved to `results/Phillips_case1/allModelResults.mat` and a
timestamped log file is written alongside them.

> ### 📖 [Full model reference and user guide → tutorials/README.md](tutorials/README.md)
> All available models, string keys, call signatures, caseDict fields, and extension instructions.

## Available models

Models evaluated in the associated publication are listed first. Models added after publication are marked †.

| Category | Models |
|---|---|
| Heat flux partitioning | RPI (Kurul & Podowski, 1990), MIT (Kommajosyula, 2020), KimAndKim (M. Kim & S.J. Kim, 2020) |
| Departure diameter | Bovard et al. (2016), Cole (1960), Cole & Rohsenow (1969), Colombo & Fairweather (2015), Fritz (1935), Golorin et al. (1978), Kocamustafaogullari (1983), MIT/Kommajosyula (2020), Nam et al. (2011), Phan et al. (2010), Ruckenstein (1964), Tolubinsky & Kostanchuk (1970), van Stralen & Zijl (1978); †Unal (1976), †Basu et al. (2002), †Du et al. (horizontal), †Du et al. (vertical) |
| Departure frequency | Exact (f = 1/(tg+tw)), Cole (1960), Peebles & Garber (1953), Sakashita & Ono (2009), Stephan (1992), Zuber (1963) |
| Nucleation site density | Hibiki & Ishii (2003), Hibiki-Ishii-MIT/Kommajosyula (2020), Lemmert & Chawla (1977), Li et al. (2018), Wang & Dhir (1993), Yang et al. (2014); †Basu et al. (2002), †Kocamustafaogullari & Ishii (1983) |
| Growth time | MIT/Kommajosyula (2020), Lee et al. (2003), van Stralen et al. (1975) |
| Wait time | MIT/Kommajosyula (2020), van Stralen et al. (1975) |
| Single-phase convection | Churchill & Chu (1975), Gnielinski (1976) |

## License

Copyright (C) 2026 Omid Bidar and Marco Colombo

XBOIL is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.

## Contact

Dr Omid Bidar, University of Sheffield

[o.bidar@sheffield.ac.uk](mailto:o.bidar@sheffield.ac.uk)

[omid-bidar.github.io](https://omid-bidar.github.io/)
