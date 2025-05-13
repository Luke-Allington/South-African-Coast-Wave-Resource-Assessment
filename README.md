# South African Coast Wave Resource Assessment

Welcome to a wave energy resource assessment project focused on six coastal sites in South Africa. This work was completed as part of the Advanced Marine Energy module at the University of Exeter, and aims to explore the energy potential of ocean waves at each location.

The analysis is built using MATLAB and follows methods based on the IEC TS 62600-101 Class 3 wave assessment standards, as closely as possible.

---

## Sites Included

- Durban  
- East London  
- Mossel Bay  
- Ngqura  
- Richards Bay  
- Slangkop

Each site has its own dataset, but they all go through the same script for consistency and easy comparison. (Supplied upon request)

---

## What’s in the Data?

- Significant Wave Height (HMO) – in meters  
- Peak Wave Period (TP) – in seconds  
- Wave Direction (DIR) – in degrees  
- Time Resolution – 3-hour intervals

---

## What the Script Does

The main script, `wave_analysis_main.m`, is designed to:

1. Load and clean wave data from any of the site files  
2. Calculate summary statistics (mean, max, etc.)  
3. Plot various graphs:
   - Time series for wave height, period, and direction
   - Histograms and polar plots
   - A 3D plot showing how wave height varies over time and period
   - Monthly mean wave height trends
4. Export a CSV report with key metrics for each site

Just change the file name at the top of the script to switch between sites.

---

## How to Use It

1. Open the script in MATLAB (Live Editor works best)
2. Make sure the `.csv` file for the site you want to analyze is in the same folder
3. Hit Run
4. Results will appear as plots, and a summary CSV will be saved automatically

---

## Presentation Included

This repo also includes a PowerPoint presentation summarizing the results and methodology (currently under review but will be re-attached or provided on request). It’s a good way to quickly understand the outcomes without running the full script.
Contact via: lukeallington@outlook.com 

---

## Project Aim

The goal here is to better understand South Africa’s wave energy potential — to see where the ocean offers the most promising opportunities for marine energy developemnt using NOAA database.

---

## Project Info

- Module: Advanced Marine Energy  
- Institution: University of Exeter  
- Author: Luke Allington  
- Year: 2025

---

## Notes

This project is shared for educational and portfolio purposes. Feel free to explore or adapt the script, and let me know if you have questions or feedback.
