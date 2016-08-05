

*This document was made by Mithru on 04-02-2016 based on methods that worked but a full test of this guide step by step has not been done. This work is based heavily on [http://fabmodules.org/](http://fabmodules.org/), and the references/links available there.*

--

###1.Circuit Design

1. Design your circuit on Fritzing.  You might need to give your circuit a wide margin (ned to figure out an appropriate size for this). File > Export > for production > PDF.
2.  Fritzing exports a bunch of PDFs this way. We only need **\*\_etch\_copper\_top.pdf** and **\*\_etch\_mask\_top.pdf**
3. Open the above two files in Adobe Illustrator. Merge them as part of one document and export as PNG with white background (and black fill for the circuit). The dpi should be 500.

###2.Fab Modules
4. Open [http://fabmodules.org/](http://fabmodules.org/)
5. Click **input format**. Select **image (.png)**, and load the png that you just exported.
6. Click **invert image** on the right to make the background black and circuit white. Ensure the dpi is 500.
7. Click **output format** and **Roland mill (.rml)**. 
8. On the right, click **machine** and select **MDX-20**.
9. **Speed** can be 3 (but can be fine-tuned - thinner drill bits might require lower speeds, but this will need testing)
10. Set **x0** and **y0** to 0.
11. **z0** corresponds to the home position of the surface to be drilled. It should be set based on the vertical distance between the tip of the drill bit at rest postion and upper surface of the material (copper plate). This value is always negative since in the z axis here, the drill bit goes downward. For example, say your plate is about 1mm below the drill bit, z0 should be -1. If the plate is 3cm (30mm) below the drill bit, z0 should be -30. Decimals can also be added (eg. -1.3 and -1.4 do show a noticable change on the drilled copper plate, so try to be precise). 
12. **zjog** is set automatically to (z0+2). No change needed here.
13.  **xhome, yhome** and **zhome** can be set to 0.
14. Click **process** and **PCB traces (1/64)**
15. The default settings should be fine but you'll need to make sure of it (in the next step) 
16. Click **calculate**. You'll notice the program try to plot out paths. This process shouldn't take more than 5 seconds or so for simple ciruits. Once done plotting, make sure the plotted paths work for your circuit (i.e.  for two points to not be connected by copper, the drill bit should pass between them - ensure this for all relevant points that have other points nearby). If there are points, you might need to reduce **tool diameter (mm)** and (might) need to use a thinner drill bit.
17. Once done checking, click **save**.

###3.Editing the RML
18. The program saves the RML file, but this will need one final edit before you can send it to the roland machine. Open up your RML file in any text editor (say Sublime text). 
19. On the first line of the rml file, find **!PZ**. The numbers following this command are swapped. For example: **!PZ0,-1400;**. Swap this to **!PZ-1400,0;**. If your two numbers are 0,0 you don't need to worry - no change is required. Just ensure the first number is lower than the second (and negative). The reason for this can be found in the RML programming guide, and it's likely a bug with fab modules (or I misunderstood fab modules' intention).
20. Hit save, and the rml file is ready to be sent to the machine.

###4.Sending RML to the machine
21. Sending the file via the terminal was painful, so I wrote a processing sketch to run it. Open **rolandWrite.pde**. 
22. Hit cmd+K to open up the folder than holds the processing sketch. Place your rml into this sketch. 
23. Change the first line of the sketch to point to your rml file. 
24. Run the sketch. Hit spacebar to send it over. 

The processing sketch can be smarter - eg. there's currently a 2 second delay between each line sent from the rml file to ensure we don't flood the roland machine with all commands at once. The processing sketch can also be used to drill holes. I haven't yet figured out if fab modules helps us drill holes as well, so once the drilling from the rml file is done, I usually position the drill bit manually from within the processing sketch using the arrow keys and hitting D to drill (but do check what the drill() method does). These parts were written quickly just for testing and might not be very user-friendly. 

	
--
	  	

###Troubleshooting

1. *Nothing happens when I send the rml over.*  

	* Make sure the transparent cover is placed properly on the roland machine - there's a sensor/switch that prevents the drill from spinning if the cover is not placed properly.   
	* Also make sure the light next to the VIEW button on the roland machine is off. Press the button to toggle it. 
	* If the green VIEW light is on, it anything you send will be stored in buffer and it will execute when set right (this can be annoying).
2. One of the LEDs is blinking angrily
	* If one of the LEDs blink very fast it's likely that something went wrong and you might have to stop sending RML, turn off and on the machine and re-send the RML file. If it persists, something isn't being done right - check the guide carefully.
	* A known cause for this is the roland machine is receiving too many messages before being able to execute (each line in the RML file is sent every two seconds by the processing sketch - if the drill cannot keep up, the LED blinks really fast).
	
	
--

###Tools Needed
1. *Drill Bits*
	* DATRON Fish tail End Mills for PCB Milling (Art. No. 0068106.  0.6mm flute diameter. 3mm shank diameter and Art. No. 0068110 for 1.0mm flute diameter)
[Link](https://www.datron.com/shop/6mmdia-pcbfishtailmillx3mmshk.html)


--

###References

 - [Fab modules](http://fab.cba.mit.edu/content/processes/PCB/modela.html), how to make circuits on the Modela milling machine, also a good resource to setup and problem shoot the Modela.
 - [Media Lab Helsinki](http://mlab.taik.fi/paja/?p=1874), making PCB with Roland Modela MDX-20 (Eagle version). The website including rml guidelines and more are available as [.zip](http://mlab.taik.fi/paja/wp-content/uploads/2011/01/eagle_files4roland_modela.zip) file for download. The tutorial uses the [Eagle layout editor](http://www.cadsoftusa.com/eagle-pcb-design-software/) to design PCBs. If you're using Fritzing, [this](http://mlab.taik.fi/paja/?p=2768) is the guide.
 - [bringing a 12 year old Roland MDX-20 up to date](http://vonkonow.com/wordpress/2012/08/bringing-a-12-year-old-roland-mdx-20-up-to-date/)
 - .rml or .rml-1 format to instruct a Modela milling machine. [RML-1 Programming Guide](http://mlab.taik.fi/paja/wp-content/uploads/2011/01/RML1_Command_GuideENVer100.pdf)
 - [sending rml to mdx-20 on unix](http://fab.cba.mit.edu/classes/MIT/961.04/topics/pcb_modela.html)
 - [Roland circuit board milling](http://shop.itp.nyu.edu/PCBStation/roland-modela/roland-circuitboard-milling)
 - [Roland Command guide](http://altlab.org/d/content/m/pangelo/ideas/rml_command_guide_en_v100.pdf)