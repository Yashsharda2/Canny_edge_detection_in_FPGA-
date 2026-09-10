# Canny_edge_detection_in_FPGA
Canny Edge Detection pipeline written in Verilog for ICE40UP5K or resource constraint baords 

## In Progress

Simulation done 



###mThe core consists of a 5-stage unrolled pipeline:
* **Gaussian Blur:** Smooths noise using a 3x3 convolution kernel.
* **Sobel Operator:** Computes spatial intensity gradients and edge magnitude.
* **Non-Maximum Suppression (NMS):** Thins edges to a single pixel wide.
* **Double Thresholding:** Categorizes pixels into strong, weak, or background.
* **Edge Tracking (Hysteresis):** Connects weak edge candidates to strong edges.


## Simulation Resource Utilization


Info: Device utilisation:
Info: 	         ICESTORM_LC:  1658/ 5280    31%
Info: 	        ICESTORM_RAM:     9/   30    30%
Info: 	               SB_IO:     6/   96     6%
Info: 	               SB_GB:     6/    8    75%
Info: 	        ICESTORM_PLL:     0/    1     0%
Info: 	         SB_WARMBOOT:     0/    1     0%
Info: 	        ICESTORM_DSP:     2/    8    25%
Info: 	      ICESTORM_HFOSC:     1/    1   100%
Info: 	      ICESTORM_LFOSC:     0/    1     0%
Info: 	              SB_I2C:     0/    2     0%
Info: 	              SB_SPI:     0/    2     0%
Info: 	              IO_I3C:     0/    2     0%
Info: 	         SB_LEDDA_IP:     0/    1     0%
Info: 	         SB_RGBA_DRV:     0/    1     0%
Info: 	      ICESTORM_SPRAM:     0/    4     0%

Max frequency for clock 'clk': 48.76 MHz


## To-Do
- [ ] **Host I/O:** Build an SPI target interface for streaming frames from MCU.
- [ ] **Hardware Validation:** Test on actual hardware.
