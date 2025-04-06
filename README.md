# Simulation Program with Control Charts

## Overview
This MATLAB project simulates an industrial production process, focusing on quality control using control charts. It incorporates the effects of wear and maintenance, allowing users to evaluate process performance and simulate real-world manufacturing conditions.

## Features
- **Control Chart Visualization**: Generates X-bar and R charts for process monitoring.
- **Wear Simulation**: Models the impact of wear on production targets over time.
- **Dynamic Adjustments**: Allows user interventions, such as maintenance or target adjustments, based on process performance.
- **Quality Metrics**: Calculates Cp and Cpk values to evaluate process capability and centering.

## How It Works
1. **User Input**: The program starts by prompting the user for:
   - `mu`: The initial target value (must be greater than 0).
   - `IT`: The tolerance interval (must be greater than 0).
2. **Initialization**:
   - Sets constants like sample size (`k`), wear rate, and control limits (`LSC`, `LIC`).
   - Loads initial sample data and calculates sample means.
3. **Control Chart Generation**:
   - Displays an initial control chart for the provided data.
4. **Simulation Loop**:
   - Simulates wear and updates target values.
   - Generates new sample data and updates control charts.
   - Calculates and displays quality metrics (Cp, Cpk).
   - Prompts the user for maintenance or process adjustments when thresholds are exceeded.
5. **Maintenance**:
   - Resets wear when maintenance is performed.
   - Stops the simulation if wear exceeds the maximum allowed threshold and no maintenance is performed.

## Usage
### Prerequisites
- MATLAB installed on your system.
- Basic understanding of MATLAB programming and statistical process control.

### Running the Program
1. Clone the repository:
   ```bash
   git clone https://github.com/espoupou/MSP_Pilotage.git
   ```
2. Open MATLAB and navigate to the project folder.
3. Run the script:
   ```matlab
   simulation.m
   ```
4. Follow the prompts to input the target value (`mu`) and tolerance (`IT`).
5. Observe the control charts and interact with the simulation as needed.

### User Inputs During Simulation
- Press `Enter` to continue production.
- Enter `R` to adjust the target value.
- Enter `S` to stop the simulation.
- Enter `C` to perform maintenance when prompted.

## File Structure
- **`simulation.m`**: Main script for the simulation.
- **`wear.m`**: Function to calculate wear over time.

## Example Output
- Control chart displaying sample means and ranges.
- Quality metrics (`Cp`, `Cpk`) printed for each cycle.
- Notifications for maintenance when wear exceeds the threshold.

## Customization
- Modify constants like `wear_rate`, `NQA_wear`, and sample size (`k`) to adapt the simulation to different scenarios.
- Replace the initial data array with your own sample data.

## License
This project is open-source and available under the MIT License. Feel free to use, modify, and distribute it as needed.

## Contributions
Contributions are welcome! If you have suggestions for improvement, please create a pull request or open an issue.

## Contact
For questions or support, please contact [espoirativon@gmail.com] & TALL ISSOUF [fstt000073@um5.ac.ma].
