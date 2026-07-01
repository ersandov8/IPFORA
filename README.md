# Isotope Plots for Organic Residue Analysis-(IPFORA)
The IPFORA R shiny app creates plots for isotope data from organic residue analysis using modern reference fats to compare against archaeological fats.
This app was designed to produce two types of plots. The ellipse plots (called small delta plot) uses the major fatty acid components of modern reference fats (C16:0 and C18:0) to calculate P=0.684 confidence ellipses for reference fats. The plot also includes an optional mixing model line to estimate where mixed fats would appear on the plot using the equation from Woodbury (1995) (See References below). The second plot (called big delta plot) uses the Δ13C value (calculated by using the difference in the δ13C values of the C16:0 and C18:0) from modern reference fats to create 1 SD estimates of major fat groups (ruminant diary, ruminant adipose, etc). The app will use any modern reference fats that are supplied to the csv file and automatically calculate the ellipses and SDs needed.   

To use, download the instructions (.doc) and copy the R code into a RMD file in R studio or download the RMD file directly. 

If you prefer an online-only application with no need to download and use R, follow this link to the app that is hosted online https://ersandov8.github.io/IPFORA/
The online app functions the same as the one in R, so the intruction manual remains the same. Download the .doc file to follow along. 

References:

Woodbury, S.E., Evershed, R.P., Rossell, J.B. Griffith, R.E. and Famell, P. (1995) Detection of vegetable oil adulteration using gas chromatographic combustion/isotope mass spectrometry. Anal. Chem. 67, 2685-2690
