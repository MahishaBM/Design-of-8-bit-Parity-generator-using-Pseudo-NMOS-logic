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





