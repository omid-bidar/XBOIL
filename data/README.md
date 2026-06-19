# Data

This directory should contain the experimental dataset(s) used to run the examples.

## Required file

**`Phillips.mat`** — Flow boiling dataset from:

> Phillips, T.E. et al. (see Table 2 of the associated publication for full reference).

The `.mat` file should be a MATLAB struct with fields `Phillips.case1`, `Phillips.case2`, ..., each containing the following fields:

| Field | Description | Units |
|---|---|---|
| `fluid` | Working fluid name | — |
| `pressure` | System pressure | bar |
| `massFlux` | Mass flux | kg/m² s |
| `velocity` | Bulk velocity | m/s |
| `subcooling` | Liquid subcooling | K |
| `hydraulicDiameter` | Channel hydraulic diameter | m |
| `referenceLength` | Reference length scale | m |
| `contactAngle` | Static contact angle | degrees |
| `heaterMaterial` | Heater material name | — |
| `heaterDensity` | Heater density | kg/m³ |
| `heaterSpecificHeatCapacity` | Heater specific heat capacity | J/kg K |
| `heaterThermalDiffusivity` | Heater thermal diffusivity | m²/s |
| `heaterThermalConductivity` | Heater thermal conductivity | W/m K |
| `totalHeatFluxExperiment` | Two-column matrix: [wall superheat (K), heat flux (W/m²)] | — |

## Usage

Place `Phillips.mat` in this directory, then run the example from the XBOIL root:

```matlab
startupXBOIL
cd examples
runSweepPhillips
```
