print("start directory loop");

dir = getDirectory("Choose input Original Directory ");      // prompts the user to select the folder to be processed, 

list = getFileList(dir);                                    // gives ImageJ a list of all files in the folder to work through
print("number of files in dir1 Segments",list.length);      // optional prints the number of files in the folder

dir2 = getDirectory("Choose input Output Directory "); // promts user to select folder to be saved in
list2 = getFileList(dir2);                 // gives ImageJ a list of all files in the folder to work through for directory2 
extension2 = ".tif";   //defines file type  variable 
print("number of files in dir2 Image",list2.length);                       // optional prints the number of files in the folder

dir3= getDirectory("Choose output Directory"); //promts user to select folder on Images for Results

setBatchMode(true);          // runs up to 6 times faster, without showing images onscreen.  Turn off during troubleshooting steps??
run("Set Measurements...", "area mean min centroid center bounding shape display redirect=None decimal=3");
 
 dbugp = 1;							// verbose print for debug 
 
 // Note that the above processes are outside the loop brackets {  }, 
// so they will only be called once at the beginning of the macro
// list compare checker
// DIR and DIR2 must contain files for the same images in the same order

listerrs=0;

for (f=0; f<list.length; f++) 
{
imageID = substring( list[f], 0,13);
print ("imageID",imageID);

Imdx= indexOf( list2[f],imageID);
print("value of Index",Imdx);

	if (Imdx <0 )
	{ // if list2[f] does not contain same imageID as list[f]
		print("List Compare Error:");
		print ( "   dir  file#",f," = ", list[f] );
		print ( "   dir2 file#",f," = ", list2[f] );
		listerrs++;  // count the errors
	}
}
if(listerrs > 0 ) { exit(); }

print("START...");   // main files loop   (process every image until you get to the bottom of the list) 

for (f=0; f<list.length; f++) 
    {
    path = dir+list[f];                       // creates the filepath for reading Segmentation files
     if(dbugp>0) 
     {	 // optional prints the path & file name to a log window
	    print("Name of path reading file from dir1",path); 
	 }
    showProgress(f, list.length);     // optional progress monitor displayed at top of Fiji
    if (!endsWith(path,"/")) open(path);  // if subdirectory, push down into it Still have to open Path
    t=getTitle();    // gets the name of the image being processed   

    if(dbugp>0)
    {
		print("getTitle got t=", t ); 
	}	
    tt = substring(t,0,13); // Shortens title from start to X characters (t,0,X)
			
			
	if(dbugp>0) 
	{
		print("attempt to truncate t=", tt ); 
	}
				
    run("Enhance Contrast...", "saturated=1 normalize");
    print("Enhance contracst");
    run("Convert to Mask");
    print("Mask");
    run("Gaussian Blur...", "sigma=10");
    print("Gaussianblurr");
    run("Make Binary");
	print("Make binary");
	if (roiManager("count")>0)
	{
		roiManager("Deselect");
		print("Ran Deselect complete");
		roiManager("Delete");
		print("roi delete");
	}
				
	run("Analyze Particles...", "size=4000-Infinity,show=Overlay  display summarize add");
	n=roiManager("count");
	print("ROI_number=" + n);
	i=0;
	if (roiManager("count")==0)
	{
		print("No Glomeruli");
	}
	else if(i<=roiManager("count"))
	{
		roiManager("Save", dir3 + tt +"roi" +".zip");
		roiManager("select",i);
		path2=dir2+list2[f]; 
		print("Name of path reading files from dir2",path2);   
        open(path2); 
		run("RGB Color");
		print("name of filefor dir2RGBrun step",tt);
		run("HSB Stack");
		run("Stack to Images");
		selectWindow("Saturation");
		rename(t+ "Saturation");
		setThreshold(80, 255);
		roiManager("Select",i );
		run("Measure");
		open(path2);
		roiManager("Select",i );
		roiManager("Set Color", "red");
		roiManager("Set Line Width", 5);
		run("Flatten");
		saveAs("Tiff",dir3+tt+"roi"+i+".tif");
		print("Ran Measure");
		i= i+1;
      }
}
    
selectWindow("Results");
saveAs(dir3+"EH.txt");
selectWindow("Log");
saveAs(dir3+"log1.txt");
selectWindow("Summary");
saveAs(dir3+"sumamry1.txt");
