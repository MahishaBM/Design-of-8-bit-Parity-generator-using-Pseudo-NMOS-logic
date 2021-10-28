# Design of 8 bit Parity generator using sky130nm technology<br/>
---
*In this project 8-bit odd and even parity generator is implemented using google skywater130 PDK (Process Design Kit). This project give a detailed view in generating a final layout to print photomasks used in the fabrication of a behavioral RTL (Register-Transfer Level) of an 8-bit parity generator, using SkyWater 130 nm PDK*<br/>
# Design overview<br/>
![mahisha_parity_spec](https://user-images.githubusercontent.com/88282645/132097774-655d7bea-6908-47c8-b729-905fca33a39d.png)<br/>
---
# IP Spec
![mahisha_parity_spec (1)](https://user-images.githubusercontent.com/88282645/132097853-529caac9-0d8f-4c44-a95e-208ff0bad131.png)<br/>

# RTL to GDSII Introduction
From conception to product, the ASIC design flow is an iterative process that is not static for every design. The details of the flow may change depending on ECO’s, IP requirements, DFT insertion, and SDC constraints, however the base concepts still remain. The flow can be broken down into 11 steps:<br/>

Architectural Design – A system engineer will provide the VLSI engineer with specifications for the system that are determined through physical constraints. The VLSI engineer will be required to design a circuit that meets these specification at a microarchitecture modeling level.<br/>
RTL Design/Behavioral Modeling – RTL design and behavioral modeling are performed with a hardware description language (HDL). EDA tools will use the HDL to perform mapping of higher-level components to the transistor level needed for physical implementation. HDL modeling is normally performed using either Verilog or VHDL. One of two design methods may be employed while creating the HDL of a microarchitecture:<br/>

a. RTL Design – Stands for Register Transfer Level. It provides an abstraction of the digital circuit using:<br/>

i. Combinational logic<br/>
ii. Registers<br/>
iii. Modules (IP’s or Soft Macros)<br/>
b. Behavioral Modeling – Allows the microarchitecture modeling to be performed with behavior-based modeling in HDL. This method bridges the gap between C and HDL allowing HDL design to be performed<br/>
# RTL Verification - Behavioral verification of design

DFT Insertion - Design-for-Test Circuit Insertion<br/>

Logic Synthesis – Logic synthesis uses the RTL netlist to perform HDL technology mapping. The synthesis process is normally performed in two major steps:<br/>

GTECH Mapping – Consists of mapping the HDL netlist to generic gates what are used to perform logical optimization based on AIGERs and other topologies created from the generic mapped netlist.<br/>

Technology Mapping – Consists of mapping the post-optimized GTECH netlist to standard cells described in the PDK<br/>

Standard Cells – Standard cells are fixed height and a multiple of unit size width. This width is an integer multiple of the SITE size or the PR boundary. Each standard cell comes with SPICE, HDL, liberty, layout (detailed and abstract) files used by different tools at different stages in the RTL2GDS flow.<br/>

Post-Synthesis STA Analysis: Performs setup analysis on different path groups.<br/>

Floorplanning – Goal is to plan the silicon area and create a robust power distribution network (PDN) to power each of the individual components of the synthesized netlist. In addition, macro placement and blockages must be defined before placement occurs to ensure a legalized GDS file. In power planning we create the ring which is connected to the pads which brings power around the edges of the chip. We also include power straps to bring power to the middle of the chip using higher metal layers which reduces IR drop and electro-migration problem.<br/>

Placement – Place the standard cells on the floorplane rows, aligned with sites defined in the technology lef file. Placement is done in two steps: Global and Detailed. In Global placement tries to find optimal position for all cells but they may be overlapping and not aligned to rows, detailed placement takes the global placement and legalizes all of the placements trying to adhere to what the global placement wants.<br/>

CTS – Clock tree synteshsis is used to create the clock distribution network that is used to deliver the clock to all sequential elements. The main goal is to create a network with minimal skew across the chip. H-trees are a common network topology that is used to achieve this goal.<br/>

Routing – Implements the interconnect system between standard cells using the remaining available metal layers after CTS and PDN generation. The routing is performed on routing grids to ensure minimal DRC errors.<br/>

The Skywater 130nm PDK uses 6 metal layers to perform CTS, PDN generation, and interconnect routing. Shown below is an example of a base RTL to GDS flow in ASIC design:<br/>
<br/>
![image](https://user-images.githubusercontent.com/88282645/132116591-a4512337-b1f5-46e2-9950-c842e5e04907.png)<br/>
# Behavioral Design <br/>
*yosys synthesies*<br/>
*Command to be used in yosys*<br/> 
![Screenshot from 2021-09-05 11-27-45](https://user-images.githubusercontent.com/88282645/132117124-8b118010-cfd9-4e6a-9c51-4b2d61288c1c.png)<br/>
--
*YOSYS is an opensource FPGA*<br/>
![132098571-702370d5-bfe0-4eab-931a-ea0b7f0b2dff](https://user-images.githubusercontent.com/88282645/132116236-789d0c61-60a5-42ca-974a-16202a0df76c.png)<br/>
# Prelayout<br/>
Commands to be used:<br/>
![Screenshot from 2021-09-05 11-20-08](https://user-images.githubusercontent.com/88282645/132116949-bef39d9a-463c-4e67-9479-b0f96152559d.png)<br/>
 Prelayout GTKwave<br/>
![Screenshot from 2021-09-05 11-21-37](https://user-images.githubusercontent.com/88282645/132116952-1f979da6-02c0-4ca4-b05d-2423042c92dc.png)<br/>
# OpenLane design stages
- Synthesis<br/>
1.yosys - Performs RTL synthesis<br/>
2.abc - Performs technology mapping<br/>
3.OpenSTA - Performs static timing analysis on the resulting netlist to generate timing reports<br/>
- Floorplan and PDN<br/>
1.init_fp - Defines the core area for the macro as well as the rows (used for placement) and the tracks (used for routing)<br/>
2.ioplacer - Places the macro input and output ports<br/>
3.pdn - Generates the power distribution network<br/>
4.tapcell - Inserts welltap and decap cells in the floorplan<br/>
- Placement<br/>
1.RePLace - Performs global placement<br/>
2.Resizer - Performs optional optimizations on the design<br/>
3.OpenDP - Perfroms detailed placement to legalize the globally placed components<br/>
- CTS<br/>
1.TritonCTS - Synthesizes the clock distribution network (the clock tree)<br/>
- Routing<br/>
1.FastRoute - Performs global routing to generate a guide file for the detailed router<br/>
2.CU-GR - Another option for performing global routing.<br/>
3.TritonRoute - Performs detailed routing<br/>
4.SPEF-Extractor - Performs SPEF extraction<br/>
- GDSII Generation<br/>
1.Magic - Streams out the final GDSII layout file from the routed def<br/>
2.Klayout - Streams out the final GDSII layout file from the routed def as a back-up<br/>
- Checks<br/>
1.Magic - Performs DRC Checks & Antenna Checks<br/>
2.Klayout - Performs DRC Checks<br/>
3.Netgen - Performs LVS Checks<br/>
4.CVC - Performs Circuit Validity Checks<br/>
# Installation
Prerequisites<br/>
 1.Preferred Ubuntu OS)<br/>
2.Docker 19.03.12+<br/>
3.GNU Make<br/>
4.Python 3.6+ with PIP<br/>
5.Click, Pyyaml: pip3 install pyyaml click<br/>
```
git clone https://github.com/The-OpenROAD-Project/OpenLane.git<br/>
cd OpenLane/<br/>
make openlane<br/>
make pdk<br/>
make test # This a ~5 minute test that verifies that the flow and the pdk were properly installed
```
# Running OpenLane
```
make mount
```

Note<br/>
- Default PDK_ROOT is $(pwd)/pdks. If you have installed the PDK at a different location, run the following before make mount:<br/>
- Default IMAGE_NAME is efabless/openlane:current. If you want to use a different version, run the following before make mount:<br/>
The following is roughly what happens under the hood when you run make mount + the required exports:<br/>
```
export PDK_ROOT=<absolute path to where skywater-pdk and open_pdks will reside>
export IMAGE_NAME=<docker image name>
docker run -it -v $(pwd):/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) $IMAGE_NAME
```
For verification:<br/>

![image](https://user-images.githubusercontent.com/88282645/133581918-ae2e4988-f672-4cb6-8919-783c8ddd0636.png)<br/>
![image](https://user-images.githubusercontent.com/88282645/133583431-5e2f6e2b-0a65-4ab1-93f4-d7ea45486ec0.png)<br/>
![image](https://user-images.githubusercontent.com/88282645/133583512-af525464-8154-46cc-bbdb-8312446ea3c6.png)<br/>
![image](https://user-images.githubusercontent.com/88282645/133583623-86c42261-0235-49e9-8060-78c8a88e3d91.png)<br/>
![image](https://user-images.githubusercontent.com/88282645/133585421-6142c84b-1308-4d32-9302-12f986c80fa4.png)<br/>
```
# User config
set ::env(DESIGN_NAME) paritygen_8bit

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# turn off clock
set ::env(CLOCK_TREE_SYNTH) 0
set ::env(CLOCK_PORT) ""

set ::env(PL_SKIP_INITIAL_PLACEMENT) 1
set ::env(PL_RANDOM_GLB_PLACEMENT) 0

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 34.165 54.885"
set ::env(PL_TARGET_DENSITY) 0.75

set ::env(FP_HORIZONTAL_HALO) 6
set ::env(FP_VERTICAL_HALO) $::env(FP_HORIZONTAL_HALO)

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}
```

# Yosys symthesis strategies
![image](https://user-images.githubusercontent.com/88282645/139223014-90f8045e-39fe-443f-9467-6170da6f78b0.png)<br/>
![image](https://user-images.githubusercontent.com/88282645/139222870-5b1aeb3a-decb-4120-9573-80f80f9d839f.png)<br/>
# Floorplan
![image](https://user-images.githubusercontent.com/88282645/134843945-5945f1ef-1bd3-4a96-bba7-f9d992635f24.png)<br/>
# Final Layout<br/>
![image](https://user-images.githubusercontent.com/88282645/134844070-30cfa12c-455c-46bf-a059-d36702fc916a.png)<br/>







