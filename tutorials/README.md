# XBOIL Tutorials

This directory contains three tutorials:

- **`singleConfig/runSingleConfig.m`** — run a single, hand-picked model
  configuration, inspect every predicted bubble parameter point-by-point, and
  compare to experiment. Start here if you are new to XBOIL or want to
  understand what a particular model combination predicts.

- **`singleConfig/runHFPDecomposition.m`** — decompose the total wall heat
  flux into its constituent components for all three HFP models side-by-side.
  RPI and KimAndKim have three components (evaporation, quenching, convection);
  MIT adds a fourth (sliding conduction). Each HFP uses its best-performing
  sub-model configuration identified by the sweep.

- **`sweep/runSweepPhillips.m`** — exhaustively evaluate every combination of
  all available models (16,848 configurations), rank them by error against
  experiment, and identify the best-performing combination. Use this for
  systematic model assessment or to reproduce the results in the associated
  publication.

```
tutorials/
├── README.md               ← this file: framework reference + model catalogue
├── singleConfig/
│   ├── runSingleConfig.m       ← run one configuration, inspect predictions
│   └── runHFPDecomposition.m  ← decompose q″ into components for all three HFP models
└── sweep/
    └── runSweepPhillips.m  ← sweep all 16,848 combinations in parallel
```

---

## Contents

1. [Prerequisites](#1-prerequisites)
2. [Repository layout](#2-repository-layout)
3. [Quick start](#3-quick-start)
4. [How XBOIL works: the call stack](#4-how-xboil-works-the-call-stack)
5. [Global state: `getGlobalParams`](#5-global-state-getglobalparams)
6. [The public API: `calc*` functions](#6-the-public-api-calc-functions)
7. [Available models and their string keys](#7-available-models-and-their-string-keys)
8. [Providing experimental data (`caseDict`)](#8-providing-experimental-data-casedict)
9. [Running a full combinatorial sweep](#9-running-a-full-combinatorial-sweep)
10. [Post-processing results](#10-post-processing-results)
11. [Extending XBOIL](#11-extending-xboil)

---

## 1. Prerequisites

| Requirement | Notes |
|---|---|
| MATLAB R2020b or later | Earlier versions may work but are untested |
| [CoolProp](http://www.coolprop.org/) MATLAB wrapper | Required for saturation fluid property lookups |
| MATLAB Parallel Computing Toolbox | Optional — only needed for parallel sweeps |

**Installing CoolProp.**
Download the MATLAB wrapper from http://www.coolprop.org/coolprop/wrappers/MATLAB/index.html
and place `CoolProp.dll` (or `.so` / `.dylib`) together with the wrapper
file on your MATLAB path. Verify with:

```matlab
py.CoolProp.CoolProp.PropsSI('T', 'P', 101325, 'Q', 0, 'Water')
% Expected output: ~373.12 K
```

---

## 2. Repository layout

```
XBOIL/
├── startupXBOIL.m                          ← run this before anything else
├── modules/
│   ├── utilities/
│   │   ├── getGlobalParams.m               ← global state store
│   │   └── getFluidProperties.m            ← CoolProp wrapper
│   ├── heatFluxPartitioningModels/
│   │   ├── calcTotalHeatFlux.m             ← top-level HFP dispatcher
│   │   ├── RPI/                            ← Kurul & Podowski (1990)
│   │   ├── MITKommajosyula/                ← Kommajosyula (2020) and Pham et al. (2023)
│   │   └── KimAndKim/                      ← M. Kim & S.J. Kim (2020)
│   └── bubbleDynamicsParametersModels/
│       ├── calcDepartureDiameter.m         ← Dd dispatcher
│       ├── calcDepartureFrequency.m        ← f  dispatcher
│       ├── calcNucleationSiteDensity.m     ← Nb dispatcher
│       ├── calcGrowthTime.m                ← tg dispatcher
│       ├── calcWaitTime.m                  ← tw dispatcher
│       ├── departureDiameterModels/        ← Dd model files
│       ├── departureFrequencyModels/       ← f  model files
│       ├── nucleationSiteDensityModels/    ← Nb model files
│       ├── growthTimeModels/               ← tg model files
│       └── waitTimeModels/                 ← tw model files
├── data/                                   ← experimental data (.mat files)
├── results/                                ← sweep output (auto-created)
└── tutorials/
    ├── README.md                           ← this file
    ├── singleConfig/
    │   ├── runSingleConfig.m
    │   └── runHFPDecomposition.m
    └── sweep/
        └── runSweepPhillips.m
```

---

## 3. Quick start

**Step 1.** `cd` to the XBOIL root directory (the folder containing
`startupXBOIL.m`) and initialise the module paths:

```matlab
startupXBOIL
```

This calls `addpath(genpath('modules'))`, making every `calc*` function and
model file available on the MATLAB path.

**Step 2.** Place `Phillips.mat` in the `data/` directory
(see `data/README.md`).

**Step 3 — single configuration.** Open
`tutorials/singleConfig/runSingleConfig.m`, edit the model strings in
**Section 1**, then run from anywhere:

```matlab
run('tutorials/singleConfig/runSingleConfig.m')
```

You will see a point-by-point prediction table, MAPE and MSE, and an
optional boiling curve plot.

**Step 4 — HFP decomposition.** To visualise how the total heat flux is
split across components for all three HFP models simultaneously:

```matlab
run('tutorials/singleConfig/runHFPDecomposition.m')
```

This produces a 1×3 subplot figure — one panel per HFP model — showing
evaporation, quenching, convection (and sliding conduction for MIT)
against the total prediction and experimental data.

**Step 5 — full sweep.** Once you are comfortable with the framework, run
the combinatorial sweep to rank all model combinations:

```matlab
run('tutorials/sweep/runSweepPhillips.m')
```

The sweep evaluates all 16,848 configurations in parallel, saves results to
`results/Phillips_case1/`, and writes a ranked summary to the log file. It
can be interrupted and resumed — already-computed configurations are skipped.

---

## 4. How XBOIL works: the call stack

XBOIL evaluates the nucleate boiling curve at one or more wall superheats
ΔT = T_wall − T_sat. For each ΔT, the calculation proceeds top-down:

```
calcTotalHeatFlux(dT)
 └─ totalHeatFluxRPI(dT)               (or MIT / KimAndKim)
     ├─ evaporationHeatFluxRPI(dT)
     │   ├─ calcDepartureDiameter(dT)      → departureDiameterRuckenstein(dT)
     │   ├─ calcDepartureFrequency(dT)     → departureFrequencyExact(dT)
     │   └─ calcNucleationSiteDensity(dT)  → nucleationSiteLemmertChawla(dT)
     ├─ quenchingHeatFluxRPI(dT)
     │   └─ (same Dd, f, Nb as above)
     └─ convectionHeatFluxRPI(dT)
         └─ calcNusseltNumber(dT)          → NusseltNumberChurchillAndChu(dT)
```

Every `calc*` function is a **dispatcher**: it reads the active model name
from global state and calls the corresponding model function. You never
call model functions directly — always go through the dispatcher. This lets
you swap any model by changing a single string.

**Heat flux components per HFP model:**

| HFP model | Components |
|---|---|
| **RPI** | single-phase convection + quenching + evaporation |
| **MIT** | forced convection + sliding conduction + quenching + evaporation |
| **KimAndKim** | convection + quenching + evaporation (area-weighted, accounting for bubble coalescence) |

---

## 5. Global state: `getGlobalParams`

`getGlobalParams` is a persistent-variable store with two modes:

```matlab
% --- (A) INITIALISE — call with a struct ---
getGlobalParams(struct( ...
    'caseDict',                caseDict, ...         % flow/heater conditions (see §8)
    'HFPModel',                "RPI", ...
    'convectiveModel',         "ChurchillAndChu", ...
    'nucleationSiteModel',     "LemmertChawla", ...
    'departureFrequencyModel', "Exact", ...
    'departureDiameterModel',  "Ruckenstein", ...
    'waitTimeModel',           "VanStralen", ...
    'growthTimeModel',         "MIT", ...
    'growthConstantModel',     "Pham"));

% --- (B) READ — call with no arguments ---
gp = getGlobalParams();
gp.HFPModel           % "RPI"
gp.caseDict.pressure  % 1.05  (bar)
```

Key points:

- The struct persists until you call `getGlobalParams` again with a new
  struct. Calling any `calc*` function without initialising first throws:
  `Error: Global parameters have not been initialised`.
- In a `parfor` loop each worker has its own copy of the persistent
  variable, so you must initialise inside the loop body (as
  `runSweepPhillips.m` does via `runSingleSimulation`).
- `caseDict` is the only non-string field — it carries all flow and heater
  conditions (see Section 8).
- `growthConstantModel` should always be set to `"Pham"` — this selects
  the bubble growth constant closure used by several sub-models.

---

## 6. The public API: `calc*` functions

Once `getGlobalParams` is initialised, call any of the following at a
single wall superheat value `dT` (in K):

| Function | Returns | Units |
|---|---|---|
| `calcTotalHeatFlux(dT)` | Total wall heat flux q″ | W/m² |
| `calcDepartureDiameter(dT)` | Bubble departure diameter D_d | m |
| `calcDepartureFrequency(dT)` | Bubble departure frequency f | Hz |
| `calcNucleationSiteDensity(dT)` | Active nucleation site density N_b | sites/m² |
| `calcWaitTime(dT)` | Bubble wait time t_w | s |
| `calcGrowthTime(dT)` | Bubble growth time t_g | s |

**Typical usage — looping over wall superheats:**

```matlab
wallSuperheats = [5, 10, 15, 20, 25];   % K

for i = 1:numel(wallSuperheats)
    dT    = wallSuperheats(i);
    q(i)  = calcTotalHeatFlux(dT);
    Dd(i) = calcDepartureDiameter(dT);
    f(i)  = calcDepartureFrequency(dT);
    Nb(i) = calcNucleationSiteDensity(dT);
    tw(i) = calcWaitTime(dT);
    tg(i) = calcGrowthTime(dT);
end
```

**Calling a single sub-model in isolation** (e.g. to plot how departure
diameter varies with superheat without computing heat flux):

```matlab
startupXBOIL
getGlobalParams(struct('caseDict', caseDict, ...
    'departureDiameterModel',  "Fritz", ...
    'HFPModel',                "RPI", ...          % required even if unused
    'convectiveModel',         "Gnielinski", ...
    'nucleationSiteModel',     "LemmertChawla", ...
    'departureFrequencyModel', "Cole", ...
    'waitTimeModel',           "VanStralen", ...
    'growthTimeModel',         "MIT", ...
    'growthConstantModel',     "Pham"));

dT_range = linspace(1, 30, 100);
Dd = arrayfun(@calcDepartureDiameter, dT_range);
plot(dT_range, Dd * 1e3);
xlabel('\DeltaT_{wall} (K)'); ylabel('D_d (mm)');
```

**Important dependency:** `calcDepartureFrequency` with model `"Exact"`
computes f = 1/(t_g + t_w) and therefore internally calls `calcGrowthTime`
and `calcWaitTime`. You must set `growthTimeModel` and `waitTimeModel` even
when requesting only departure frequency.

---

## 7. Available models and their string keys

Pass these strings exactly (case-sensitive) when initialising `getGlobalParams`.

These are the models evaluated in the associated publication (Bidar & Colombo,
Int. J. Heat Mass Transfer, 2026). Additional models have been added to the
codebase since publication; see comments in the `calc*` dispatcher files for
the complete current list.

### Heat flux partitioning (`HFPModel`)

| String | Authors | Year | Notes |
|---|---|---|---|
| `"RPI"` | Kurul & Podowski | 1990 | Canonical HFP model; splits q″ into convection, quenching, evaporation |
| `"MIT"` | Kommajosyula | 2020 | Physics-based; adds sliding conduction; developed for subcooled flow boiling |
| `"KimAndKim"` | M. Kim & S.J. Kim | 2020 | Extension of RPI accounting for bubble coalescence via area correction factors |

### Departure diameter (`departureDiameterModel`)

| String | Authors | Year | Notes |
|---|---|---|---|
| `"Bovard"` | Bovard et al. | 2016 | Force-balance; fit to pool boiling data on horizontal cylindrical heaters |
| `"Cole"` | Cole | 1960 | Dimensional analysis; buoyancy–surface tension balance |
| `"ColeAndRohsenow"` | Cole & Rohsenow | 1969 | Extension of Cole; adds Jakob number dependence for subcooled and saturated pool boiling |
| `"ColomboAndFairweather"` | Colombo & Fairweather | 2015 | Mechanistic; force balance including microlayer evaporation; validated to 5 bar |
| `"Fritz"` | Fritz | 1935 | Earliest departure diameter correlation; buoyancy–surface tension balance |
| `"GolorinAndKolchugin"` | Golorin et al. | 1978 | Empirical; pool boiling of ethyl alcohol and benzene at 1–15 bar |
| `"Kocamastafaogullari"` | Kocamustafaogullari | 1983 | Extends Fritz to include pressure dependence; valid 0.067–141.87 bar |
| `"MIT"` | Kommajosyula | 2020 | Fit to subcooled flow boiling; accounts for superheat, subcooling, velocity |
| `"Nam"` | Nam et al. | 2011 | Pool boiling on superhydrophilic surfaces; contact-angle dependent |
| `"Phan"` | Phan et al. | 2010 | Contact-angle dependent; macro- and micro-contact angles; horizontal surfaces |
| `"Ruckenstein"` | Ruckenstein | 1964 | Modified Cole model; adds thermal diffusivity and Jakob number dependence |
| `"TolubinskyAndKostanchuk"` | Tolubinsky & Kostanchuk | 1970 | Subcooled flow boiling; empirical exponential dependence on subcooling |
| `"VanStralenAndZijl"` | van Stralen & Zijl | 1978 | Modified Cole model; includes thermal diffusivity and Jakob number |

### Departure frequency (`departureFrequencyModel`)

| String | Authors | Year | Notes |
|---|---|---|---|
| `"Exact"` | — | — | **f = 1/(t_g + t_w) by definition**; requires `growthTimeModel` and `waitTimeModel` |
| `"Cole"` | Cole | 1960 | Dimensional analysis; buoyancy–inertia scaling |
| `"PeeblesAndGarber"` | Peebles & Garber | 1953 | One of the earliest models; correlates f to growth and wait times |
| `"SakashitaAndOno"` | Sakashita & Ono | 2009 | High-pressure pool boiling of water; force-balance approach |
| `"Stephan"` | Stephan | 1992 | Relates f to departure diameter, liquid density, surface tension, gravity |
| `"Zuber"` | Zuber | 1963 | Buoyancy–inertia scaling; f·D_d product held constant at a nucleation site |

> **Note on `"Exact"` frequency:** labelled *Exact (by definition)* in the paper (Table 1).
> It computes f = 1/(t_g + t_w) directly from the growth and wait time sub-models,
> making departure frequency internally consistent with bubble timing.

### Nucleation site density (`nucleationSiteModel`)

| String | Authors | Year | Notes |
|---|---|---|---|
| `"HibikiIshii"` | Hibiki & Ishii | 2003 | Mechanistic; function of superheat, pressure, contact angle; valid 0–886 kg/m²s, 1–198 bar |
| `"HibikiIshiiMIT"` | Kommajosyula (mod. Hibiki & Ishii) | 2020 | MIT modification using statistical spatial randomness theory to limit N_b at high values |
| `"LemmertChawla"` | Lemmert & Chawla | 1977 | Simple power-law in wall superheat; widely used in CFD |
| `"Li"` | Li et al. | 2018 | Includes effects of contact angle variation with wall temperature and pressure |
| `"WangDhir"` | Wang & Dhir | 1993 | Pool boiling of water at atmospheric pressure; contact-angle and cavity-size dependent |
| `"Yang"` | Yang et al. | 2014 | Empirical; subcooled upflow boiling in narrow rectangular channel at atmospheric pressure |

### Growth time (`growthTimeModel`)

| String | Authors | Year | Notes |
|---|---|---|---|
| `"MIT"` | Kommajosyula | 2020 | Based on bubble growth rate model accounting for bulk flow and microlayer evaporation |
| `"Lee"` | Lee et al. | 2003 | Dimensional analysis and scaling; fit to saturated pool boiling of R11 and R113 at 1 bar |
| `"VanStralen"` | van Stralen et al. | 1975 | First-principles; couples momentum and energy conservation in a liquid–vapour system |

### Wait time (`waitTimeModel`)

| String | Authors | Year | Notes |
|---|---|---|---|
| `"MIT"` | Kommajosyula | 2020 | Regression on departure frequency data from literature; fit for subcooled flow boiling |
| `"VanStralen"` | van Stralen et al. | 1975 | Approximate analytical result: t_w ≈ 3 t_g |

### Single-phase convection (`convectiveModel`)

| String | Authors | Year | Notes |
|---|---|---|---|
| `"ChurchillAndChu"` | Churchill & Chu | 1975 | Empirical; laminar and turbulent free convection from a vertical plate |
| `"Gnielinski"` | Gnielinski | 1976 | Empirical; fully developed turbulent pipe/channel flow; 2300 < Re < 10⁶, 0.6 < Pr < 10⁵ |

---

## 8. Providing experimental data (`caseDict`)

`caseDict` is a MATLAB struct carrying all flow conditions, heater
properties, and experimental data for a test case. It is stored in the
`getGlobalParams` state and read by every model function via
`getFluidProperties(globalParams.caseDict)`.

**Minimum required fields:**

```matlab
caseDict.fluid          = 'Water';       % CoolProp fluid name (string)
caseDict.pressure       = 1.05;          % system pressure (bar)
caseDict.velocity       = 0.157;         % bulk liquid velocity (m/s)
caseDict.massFlux       = 150;           % mass flux (kg/m²/s)
caseDict.subcooling     = 5.0;           % bulk liquid subcooling (K)
caseDict.hydraulicDiameter  = 0.01;      % channel hydraulic diameter (m)
caseDict.referenceLength    = 0.02;      % heater reference length (m)
caseDict.contactAngle       = 86.5;      % static contact angle (degrees)

% Heater thermal properties
caseDict.heaterMaterial                = 'ITO';
caseDict.heaterDensity                 = 6800;          % kg/m³
caseDict.heaterSpecificHeatCapacity    = 379;           % J/kg/K
caseDict.heaterThermalConductivity     = 10.2;          % W/m/K
caseDict.heaterThermalDiffusivity      = 3.9535e-6;     % m²/s

% Experimental boiling curve
% Column 1: wall superheat ΔT_w (K) — negative values = sub-boiling points
% Column 2: measured total heat flux q″ (W/m²)
caseDict.totalHeatFluxExperiment = [ ...
    -2.0,  85000; ...
     0.0,  95000; ...
    12.7, 120000; ...
    18.4, 180000; ...
    25.1, 310000; ...
    31.5, 580000];
```

`getFluidProperties` calls CoolProp to compute saturation properties
(densities, viscosities, thermal conductivities, latent heat, surface
tension) at the saturation temperature for the given `pressure`. The
`fluid` string must be a valid CoolProp backend name, e.g. `'Water'`,
`'R134a'`, `'Nitrogen'`. The special value `'FC-72'` uses hard-coded
manufacturer datasheet properties (no CoolProp call needed).

**Loading the Phillips dataset:**

```matlab
load('data/Phillips.mat', 'Phillips');
caseDict = Phillips.case1;
```

---

## 9. Running a full combinatorial sweep

`tutorials/sweep/runSweepPhillips.m` evaluates all 16,848 model
combinations (3 × 2 × 6 × 6 × 13 × 2 × 3) in parallel and saves results
to `results/Phillips_case1/allModelResults.mat`.

```matlab
run('tutorials/sweep/runSweepPhillips.m')
```

Edit `nCores` at the top to match your machine. The sweep resumes
automatically if interrupted — already-computed configurations are skipped.
If model names in an existing results file no longer match the current
codebase (e.g. after a rename), the script detects the mismatch at startup
and prompts to either delete the stale results or redirect to a new folder.

A timestamped `.log` file is written alongside the results, recording flow
conditions, model lists, progress and the top-10 ranked configurations.

---

## 10. Post-processing results

`examples/postProcessPhillips.m` reads sweep output and produces:

- A ranked top-10 table (by MSE) printed to the Command Window
- A 1 × 3 boiling curve figure (one subplot per HFP) saved as a PNG

```matlab
cd examples
postProcessPhillips
```

You can also query results programmatically:

```matlab
load('results/Phillips_case1/allModelResults.mat', 'existingData');

% Load experimental data for the same case
load('data/Phillips.mat', 'Phillips');
expHeatFlux = Phillips.case1.totalHeatFluxExperiment;
expHeatFlux = expHeatFlux(expHeatFlux(:,1) >= 0, 2);

nConfigs = numel(existingData.results);
mse  = zeros(nConfigs, 1);
mape = zeros(nConfigs, 1);

for i = 1:nConfigs
    q       = existingData.results{i}.totalHeatFlux(:);
    mse(i)  = mean((q - expHeatFlux).^2);
    mape(i) = 100 * mean(abs(q - expHeatFlux) ./ abs(expHeatFlux));
end

[~, best] = min(mse);
bestCfg = existingData.configurations{best}
fprintf('Best MAPE: %.1f%%\n', mape(best));
```

---

## 11. Extending XBOIL

### Adding a new sub-model

The same pattern applies to every sub-model category. Illustrated here for
departure diameter:

**Step 1.** Create the model file:

```matlab
% modules/bubbleDynamicsParametersModels/departureDiameterModels/
%   departureDiameterMyModel.m

function Dd = departureDiameterMyModel(wallSuperheatI)
    globalParams    = getGlobalParams();
    fluidProperties = getFluidProperties(globalParams.caseDict);

    % ... your formula using fluidProperties fields ...
    Dd = ...;
end
```

Key `fluidProperties` fields: `liquidDensity`, `gasDensity`,
`liquidViscosity`, `liquidThermalConductivity`, `liquidThermalDiffusivity`,
`liquidSpecificHeatCapacity`, `latentHeat`, `surfaceTension`,
`saturationTemperature`.

**Step 2.** Register it in `calcDepartureDiameter.m`:

```matlab
elseif departureDiameterModel == "MyModel"
    departureDiameter = departureDiameterMyModel(wallSuperheatI);
```

**Step 3.** To include it in sweeps, add `"MyModel"` to
`defaultConfig.departureDiameterModels` in `tutorials/sweep/runSweepPhillips.m`.

### Adding a new fluid

If CoolProp supports your fluid, set `caseDict.fluid` to the correct
CoolProp string (e.g. `'R245fa'`) — no code changes are needed.

For fluids not in CoolProp, add an `elseif` branch in
`modules/utilities/getFluidProperties.m`, following the `'FC-72'` block
as a template (hard-coded saturation properties).

### Using your own experimental data

Build a `caseDict` struct as described in Section 8 and pass it to
`getGlobalParams`. No modifications to the XBOIL source are required.
A minimal example:

```matlab
startupXBOIL

caseDict.fluid         = 'Water';
caseDict.pressure      = 1.0;      % bar
caseDict.velocity      = 0.2;      % m/s
caseDict.massFlux      = 200;      % kg/m²/s
caseDict.subcooling    = 10.0;     % K
caseDict.hydraulicDiameter = 0.01;
caseDict.referenceLength   = 0.02;
caseDict.contactAngle  = 40;       % degrees

caseDict.heaterMaterial              = 'Stainless steel';
caseDict.heaterDensity               = 7900;
caseDict.heaterSpecificHeatCapacity  = 500;
caseDict.heaterThermalConductivity   = 16;
caseDict.heaterThermalDiffusivity    = 4.05e-6;

caseDict.totalHeatFluxExperiment = [5, 120000; 10, 250000; 15, 450000];

getGlobalParams(struct( ...
    'caseDict',                caseDict, ...
    'HFPModel',                "MIT", ...
    'convectiveModel',         "Gnielinski", ...
    'nucleationSiteModel',     "LemmertChawla", ...
    'departureFrequencyModel', "Exact", ...
    'departureDiameterModel',  "VanStralenAndZijl", ...
    'waitTimeModel',           "MIT", ...
    'growthTimeModel',         "Lee", ...
    'growthConstantModel',     "Pham"));

dT_values = [5, 10, 15];
for i = 1:numel(dT_values)
    fprintf('dT = %g K  =>  q = %.3e W/m^2\n', ...
        dT_values(i), calcTotalHeatFlux(dT_values(i)));
end
```

---

*XBOIL — O. Bidar & M. Colombo, University of Sheffield*
*Int. J. Heat Mass Transfer 269 (2026) 129059*
*https://doi.org/10.1016/j.ijheatmasstransfer.2026.129059*
