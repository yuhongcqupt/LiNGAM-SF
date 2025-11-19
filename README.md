# Project Readme

## Implementation Environment
The method is implemented using **MATLAB**.

## Project Structure

- **`/details`**: Contains essential modules for the core method.
- **`/tools`**: Contains necessary utility modules for the method.
- **`/generateData`**: Used for generating synthetic data.

## Data Generation Process

1.  Run `generateData.m`.
2.  Key parameters in the code:
    - `testNum`: Number of datasets to generate.
    - `data/dname`: The underlying structure `XX` used for data generation.
        - **Note**: The causal structures are defined in `getDAGXX.m`. Users can define their own causal structures by using the provided files as a template.
    - `num`: Number of feature variables.
    - `groupPart`: Number of variables observed at each time step.
3.  The generated results (including observed data `.dat` and the order of streaming features `.txt`) are saved in the corresponding folder XX (e.g., `sachs`, `pigs`).
- **Note**: You should create a new folder named XX.

## Method Execution Process

1.  Run `test_MyMethod.m`.
2.  Key parameters in the code:
    - `rootFile`: Location of the input data (should match the output location from `generateData.m`).
    - `RSFile`: Location for storing the final results.
    - `RStemp`: Location for storing intermediate results.
