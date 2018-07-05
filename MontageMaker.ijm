dir = getDirectory("Choose input Original Directory ");      // prompts the user to select the folder to be processed, 

list = getFileList(dir);                                    // gives ImageJ a list of all files in the folder to work through
print("number of files in dir1 Segments",list.length);
extension = ".tif"

setBatchMode(true); 

for (f=0; f<list.length; f++)
{
	path = dir+list[f];   

      open(path);
}       

	run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use");
    run("Make Montage...");
    saveAs("Tiff",dir+"Montage.tiff");
