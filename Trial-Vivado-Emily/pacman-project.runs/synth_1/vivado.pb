
{
Command: %s
53*	vivadotcl2J
6synth_design -top VGAController -part xc7a100tcsg324-12default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7a100t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7a100t2default:defaultZ17-349h px� 
W
Loading part %s157*device2$
xc7a100tcsg324-12default:defaultZ21-403h px� 
�
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
22default:defaultZ8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
`
#Helper process launched with PID %s4824*oasys2
189002default:defaultZ8-7075h px� 
�
%s*synth2�
wStarting RTL Elaboration : Time (s): cpu = 00:00:02 ; elapsed = 00:00:04 . Memory (MB): peak = 1022.520 ; gain = 0.000
2default:defaulth px� 
�
synthesizing module '%s'%s4497*oasys2!
VGAController2default:default2
 2default:default2�
yC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/VGAController.v2default:default2
22default:default8@Z8-6157h px� 
�
%s
*synth2t
`	Parameter FILES_PATH bound to: C:/Users/Emily Shao/Desktop/pacman-fpga/Memory/ - type: string 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter VIDEO_WIDTH bound to: 640 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter VIDEO_HEIGHT bound to: 480 - type: integer 
2default:defaulth p
x
� 
d
%s
*synth2L
8	Parameter BITS_PER_COLOR bound to: 12 - type: integer 
2default:defaulth p
x
� 
l
%s
*synth2T
@	Parameter SCREEN_PIXEL_COUNT bound to: 307200 - type: integer 
2default:defaulth p
x
� 
l
%s
*synth2T
@	Parameter SCREEN_PIXEL_ADR_WIDTH bound to: 20 - type: integer 
2default:defaulth p
x
� 
g
%s
*synth2O
;	Parameter SCREEN_COLOR_COUNT bound to: 8 - type: integer 
2default:defaulth p
x
� 
k
%s
*synth2S
?	Parameter SCREEN_COLOR_ADR_WIDTH bound to: 4 - type: integer 
2default:defaulth p
x
� 
i
%s
*synth2Q
=	Parameter PACMAN_PIXEL_COUNT bound to: 484 - type: integer 
2default:defaulth p
x
� 
l
%s
*synth2T
@	Parameter PACMAN_PIXEL_ADR_WIDTH bound to: 10 - type: integer 
2default:defaulth p
x
� 
g
%s
*synth2O
;	Parameter PACMAN_COLOR_COUNT bound to: 2 - type: integer 
2default:defaulth p
x
� 
k
%s
*synth2S
?	Parameter PACMAN_COLOR_ADR_WIDTH bound to: 1 - type: integer 
2default:defaulth p
x
� 
�
synthesizing module '%s'%s4497*oasys2&
VGATimingGenerator2default:default2
 2default:default2�
~C:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/VGATimingGenerator.v2default:default2
22default:default8@Z8-6157h px� 
]
%s
*synth2E
1	Parameter HEIGHT bound to: 480 - type: integer 
2default:defaulth p
x
� 
\
%s
*synth2D
0	Parameter WIDTH bound to: 640 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter H_FRONT_PORCH bound to: 16 - type: integer 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter H_SYNC_WIDTH bound to: 96 - type: integer 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter H_BACK_PORCH bound to: 48 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter H_SYNC_START bound to: 656 - type: integer 
2default:defaulth p
x
� 
a
%s
*synth2I
5	Parameter H_SYNC_END bound to: 752 - type: integer 
2default:defaulth p
x
� 
]
%s
*synth2E
1	Parameter H_LINE bound to: 800 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter V_FRONT_PORCH bound to: 11 - type: integer 
2default:defaulth p
x
� 
a
%s
*synth2I
5	Parameter V_SYNC_WIDTH bound to: 2 - type: integer 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter V_BACK_PORCH bound to: 31 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter V_SYNC_START bound to: 491 - type: integer 
2default:defaulth p
x
� 
a
%s
*synth2I
5	Parameter V_SYNC_END bound to: 493 - type: integer 
2default:defaulth p
x
� 
]
%s
*synth2E
1	Parameter V_LINE bound to: 524 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2&
VGATimingGenerator2default:default2
 2default:default2
12default:default2
12default:default2�
~C:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/VGATimingGenerator.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
ROM2default:default2
 2default:default2�
oC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/ROM.v2default:default2
22default:default8@Z8-6157h px� 
_
%s
*synth2G
3	Parameter DATA_WIDTH bound to: 4 - type: integer 
2default:defaulth p
x
� 
c
%s
*synth2K
7	Parameter ADDRESS_WIDTH bound to: 20 - type: integer 
2default:defaulth p
x
� 
_
%s
*synth2G
3	Parameter DEPTH bound to: 307200 - type: integer 
2default:defaulth p
x
� 
�
%s
*synth2�
�	Parameter MEMFILE bound to: 496'b0100001100111010001011110101010101110011011001010111001001110011001011110100010101101101011010010110110001111001001000000101001101101000011000010110111100101111010001000110010101110011011010110111010001101111011100000010111101110000011000010110001101101101011000010110111000101101011001100111000001100111011000010010111101001101011001010110110101101111011100100111100100101111011011000110010101110110011001010110110000101101011010010110110101100001011001110110010100101110011011010110010101101101 
2default:defaulth p
x
� 
�
,$readmem data file '%s' is read successfully3426*oasys2R
>C:/Users/Emily Shao/Desktop/pacman-fpga/Memory/level-image.mem2default:default2�
oC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/ROM.v2default:default2
112default:default8@Z8-3876h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
ROM2default:default2
 2default:default2
22default:default2
12default:default2�
oC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/ROM.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2'
ROM__parameterized02default:default2
 2default:default2�
oC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/ROM.v2default:default2
22default:default8@Z8-6157h px� 
`
%s
*synth2H
4	Parameter DATA_WIDTH bound to: 12 - type: integer 
2default:defaulth p
x
� 
b
%s
*synth2J
6	Parameter ADDRESS_WIDTH bound to: 4 - type: integer 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	Parameter DEPTH bound to: 8 - type: integer 
2default:defaulth p
x
� 
�
%s
*synth2�
�	Parameter MEMFILE bound to: 504'b010000110011101000101111010101010111001101100101011100100111001100101111010001010110110101101001011011000111100100100000010100110110100001100001011011110010111101000100011001010111001101101011011101000110111101110000001011110111000001100001011000110110110101100001011011100010110101100110011100000110011101100001001011110100110101100101011011010110111101110010011110010010111101101100011001010111011001100101011011000010110101100011011011110110110001101111011100100111001100101110011011010110010101101101 
2default:defaulth p
x
� 
�
error in $readmem data: %s273*oasys21
non-binary digit to $readmemb2default:default2�
oC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/ROM.v2default:default2
112default:default8@Z8-273h px� 
�
,$readmem data file '%s' is read successfully3426*oasys2S
?C:/Users/Emily Shao/Desktop/pacman-fpga/Memory/level-colors.mem2default:default2�
oC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/ROM.v2default:default2
112default:default8@Z8-3876h px� 
�
!failed synthesizing module '%s'%s4496*oasys2'
ROM__parameterized02default:default2
 2default:default2�
oC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/ROM.v2default:default2
22default:default8@Z8-6156h px� 
�
!failed synthesizing module '%s'%s4496*oasys2!
VGAController2default:default2
 2default:default2�
yC:/Users/Emily Shao/Desktop/pacman-fpga/Trial-Vivado-Emily/pacman-project.srcs/sources_1/imports/lab6_kit/VGAController.v2default:default2
22default:default8@Z8-6156h px� 
�
%s*synth2�
xFinished RTL Elaboration : Time (s): cpu = 00:00:03 ; elapsed = 00:00:09 . Memory (MB): peak = 1106.195 ; gain = 83.676
2default:defaulth px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
142default:default2
02default:default2
02default:default2
42default:defaultZ4-41h px� 
N

%s failed
30*	vivadotcl2 
synth_design2default:defaultZ4-43h px� 
�
Command failed: %s
69*common2Y
ESynthesis failed - please see the console or run log file for details2default:defaultZ17-69h px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Sat Dec  2 23:21:17 20232default:defaultZ17-206h px� 


End Record