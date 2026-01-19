// ****************************************************************************************************************
// Script to perform the LTE analysis of a molecule in a datacube
// ****************************************************************************************************************
// ****************************************************************************************************************
// README information (please read!)
// ****************************************************************************************************************

// To execute it, this scripts needs:
// Cubes to be analyzed: MAD_CUB_CROP_G318.9480-00.1969A_spw0_7MTM2TM1_jointdeconv.image.fits and MAD_CUB_CROP_G318.9480-00.1969A_spw1_7MTM2TM1_jointdeconv.image.fits
// Moment 0, 1 and 2 of the CH2(OH)CHO transition at 220.055 GHz: moment0.fits, moment1.fits, moment2.fits

// The script performs the analysis pixel by pixel in a selected region of interest (ROI) defined below.
// The analysis is done only in those pixels with intensity in the moment0 map above a threshold level of the signa-to-noise ratio (>3 reccommended).
// It uses the Rotational Diagram to obtain good seeds for the values of logN and Tex.
// It used the values of the velocity and FWHM from the moment1 and moement2 maps, respectively.
// AUTOFIT is applied to those pixels with t signa-to-noise ratio > threshold.

// The script generates as output a SLIM product that contain the fits of the pixels and it encapsulates also 4 cubes (logN, Tex, velocity, and FWHM) with two channels.
// Channel 1 includes the values of the parameters, channel 2 includes the values of the uncertainties of each parameter.

// The resulting SLIM product and the 4 datacubes are saved.

// ****************************************************************************************************************
// IMPORTANT !!!!!! 
// ****************************************************************************************************************
// Before running the script, open SLIM and tick on:
// SLIM>View>Param Cubes, with tick active on LogN, Tex, VLSR and FWHM.

// ****************************************************************************************************************
// ****************************************************************************************************************


// Indicate the molecule you want to analyze

molecule="CH2(OH)CHO,v=0";

// Indicate the path to the directory when the datacube to be analyzed is:

path="YOUR PATH";

// Indicate here the path to the cube you want to analyze

cube1=""+path+"MAD_CUB_CROP_G318.9480-00.1969A_spw0_7MTM2TM1_jointdeconv.image.fits";
cube2=""+path+"MAD_CUB_CROP_G318.9480-00.1969A_spw1_7MTM2TM1_jointdeconv.image.fits";

// ****************************************************************************************************************
// ****************************************************************************************************************

call('MADCUBA_IJ.setActiveInformationMADCUBA',false);

// Clear the log window
print("\\Clear")



             print (" ****** START *******************************************************");  

// It prints the date and time of when the scripts starts:
getTime ();


// Open the cube to analyze:

run("Open Virtual Cube", "select="+cube1);
run("Open Virtual Cube", "select="+cube2);

// Associate SLIM to the cube
run("Synchronize Select Cube", "name_cube=ALL");

// Search the molecule of interest, in this example CH3CHO from JPL.

run("SLIM Search", " range='selected_data' axislabel='Frequency' axisunit='Hz' molecules='CDMS$"+molecule+"$Any$Any$Any$#' searchtype=add datafile='synchro_cubes.cub' datatype=CUBE_SYN");

// Uncheck all transitions
run("SLIM Check Transitions", "molecules='"+molecule+"|1' type='ALL' check='false'");
// Check the transitions you want to use to perform the fit
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='220463.8977' check='true'");
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='220196.65' check='true'");
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='217830.6967' check='true'");
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='217626.1272' check='true'");
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='218260.5847' check='true'");
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='219122.9189' check='true'");
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='217271.6106' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='217053.7441' check='true'");
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='217603.7471' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='217608.054' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='217611.047' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='218344.1003' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='219094.9389' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='219123.6639' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='219230.2337' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='219303.2158' check='true'");
run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='220055.2262' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='220196.6583' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='220196.8526' check='true'");
//run("SLIM Check Transitions", "molecules='CH2(OH)CHO,v=0|1' freq='220204.0574' check='true'");

// Simulate a LTE spectrum (applying the checks), with reasonable seeds parameters (this depends on the source).
run("SLIM Select Tab", "tab='SET'");
run("SLIM Select Molecule", "molecule='"+molecule+"' component=1 ");  
run("SLIM Load Transition", "load");
run("SLIM Select Rows", "rows='ALL' component='1#'");
run("SLIM Get Spectrum", "molecules='"+molecule+"|1#' sort='Intensity' lines='Mol.-sel' range=60.0 ");
run("SLIM SIMULATE", "molecules='"+molecule+"|1#' logn=16.0 flogn=false tex=200.0 velo=-34.4 fvelo=false fwhm=5.0 ffwhm=false sourcesize=0.0 fsourcesize=true continuum=false threshold=2.74E-4 typethreshold=noise ");
//run("SLIM Get Spectrum", "molecules='"+molecule+"|1#' sort='Intensity' lines='Mol.-sel' range=60.0 ");


// Measure of the RMS in the moment0 map. Define a ROI with no emission.


run("Open Virtual Cube Background", "select='"+path+"moment0.fits'");
run("Synchronize Select Cube", "name_cube=ALL");

makeRectangle(9.0,188.0,26.0,15.0);
run("UPDATE SIGMA CUBE", "roi=true");
rms = call("UPDATE_SIGMA_CUBE.getSigma");
//rms = 0.000005;
print('rms='+rms+'  mJy km/s');


// Open moment1 and moment72 maps of the reference transition, in this case the CH3CHO transition at 95.580 GHz

run("Open Virtual Cube Background", "select='"+path+"moment1.fits'");
run("Open Virtual Cube Background", "select='"+path+"moment2.fits'");


// To define the region to analyze, indicate the starting pixel (w,h) and the number of pixels in RA (x) and DEC (y)

w=90;  
h=90;
steps_x = 40;
steps_y = 40;

count=0;
count_pixels=0;
count_no_autofit=0;

// Print in the log window the information about the starting pixel and region size
print (" **************************************************************");  
print("The region chosen starts in the pixel ("+w+","+h+"),");
print("and it has a size of "+steps_x+" x "+steps_y+" pixels");
print (" **************************************************************");  


// Define the threshold in SNR in the moment0 map. 

snr_threshold = 3;

// Print in the log window the signal-to-noise threshold
//print (" **************************************************************");  
print("The signal-to-noise threshold used is "+snr_threshold);
print (" **************************************************************");  


// Start the loop of pixels

//print("START OF THE LOOP");
call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_LogN.fits',3,0,0,NaN);
call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_Tex.fits',3,0,0,NaN);
call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_VLSR.fits',3,0,0,NaN);
call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_FWHM.fits',3,0,0,NaN);
//print (w+" , "+h);
  for ( i=w; i<w+steps_x; i++) {
        for ( j=h; j<h+steps_y; j++) {


 //            print (" *****************************");  
 //            print ("Starting pixel "+i+" , "+j);  
             run("SLIM Change Pixel", "pixel="+i+","+j);  // load the spectrum in that pixel

 // Calculate the SNR in the pixel
             int = parseFloat(call('Cube_Functionalities.getPixelFits', 'CUBE moment0.fits', i-0.5, j+0.5)); 
 //            print('intensity='+int);
             SNR = int/rms;     
//             print('signal-to-noise='+SNR);


// If the thresehold in SNR is fulfilled:

   if (SNR > snr_threshold) { 

           // To obtain a good seed for velocity
          velo = parseFloat(call('Cube_Functionalities.getPixelFits', 'CUBE moment1.fits', i-0.5, j+0.5))/1000; 

          // To obtain a good seed for linewidth
          fwhm = parseFloat(call('Cube_Functionalities.getPixelFits', 'CUBE moment2.fits', i-0.5, j+0.5))*2.355/1000; 


         // Insert the velocity and fwhm values into SLIM BEFORE appling the Rotational Diagram

          //run("SLIM SIMULATE", "molecules='"+molecule+"|1#'  velo="+velo+" fvelo=false fwhm="+fwhm+" ffwhm=false");
          run("SLIM SIMULATE", "molecules='"+molecule+"|1#'  velo="+velo+" fvelo=false fwhm=5 ffwhm=false");  


// To obtain a good seed for Tex and logN, the Rotational Diagram is used

            run("SLIM Rotational", "action='new' molecules='"+molecule+"|1#' type=peak apply=true");
            tex =  parseFloat(call('SLIM_Parameters.getValue','Tex'));
            logN =  parseFloat(call('SLIM_Parameters.getValue','logN'));
 

// To avoid bad results of the Rotational Diagram  

                   print ("*******************************"); 
                   // print ("Tex que viene del primer RD: "+tex); 
                         if (tex < 5.0) {  
                                           run("SLIM SIMULATE", "molecules='"+molecule+"|1#'  tex=20.0 ");
                                           tex =  call('SLIM_Parameters.getValue','Tex');

                          } else if (tex > 500.0) { 
                                          run("SLIM SIMULATE", "molecules='"+molecule+"|1#'  tex=20.0 ");
                                          run("SLIM Rotational", "action='new' molecules='"+molecule+"|1#' type=peak apply=true");
                                          tex =  call('SLIM_Parameters.getValue','Tex');
                          } else { 
                                          tex=tex;
                           }         


 if (logN < 0.0) { 
                                         run("SLIM SIMULATE", "molecules='"+molecule+"|1#'  logn=14.0 ");
                                         run("SLIM Rotational", "action='new' molecules='"+molecule+"|1#' type=peak apply=true");
                                               logN =  call('SLIM_Parameters.getValue','logN');
                          } else if (logN > 20.0) { 

                                         run("SLIM SIMULATE", "molecules='"+molecule+"|1#'  logn=14.0 ");
                                         run("SLIM Rotational", "action='new' molecules='"+molecule+"|1#' type=peak apply=true");
                                          logN = call('SLIM_Parameters.getValue','logN');
                          } else { 
                                                logN=logN;
                           } 

                   //print ("Tex que sale de los checks de N y Tex: "+tex); 
     
// To obtain a good seed for logN (NOT USED, it works better with the Rotational Diagram)
//             run("SLIM Estimate LogN", "molecule='"+molecule+"|1' setcolumn=true allspecies=false check=true ");  
//            logN =  call('SLIM_Parameters.getValue','logN');


             // The LTE spectrum with the parameter seeds is done.
             run("SLIM SIMULATE", "molecules='"+molecule+"|1#' logn="+logN+" flogn=false tex="+tex+" velo="+velo+" fvelo=false fwhm=5 ffwhm=false sourcesize=0.0 fsourcesize=true continuum=false threshold=2.74E-4 typethreshold=noise "); 

            // AUTOFIT is applied.
             run("SLIM AUTOFIT", "molecules='"+molecule+"|1#'  check=true ");

	// Check for convergence of AUTOFIT

               	 auto_flag = call('SLIM_AUTOFIT.isConverged',molecule+'|1'); 


// If AUTOFIT converges, save the parameters and uncertainties in the ouput cubes.

                 	if (auto_flag=='true') { 
                 
// Write the resulting parameters into the output cubes of parameters.

               logN =  call('SLIM_Parameters.getValue','logN');
               delta_logN =  call('SLIM_Parameters.getValue','delta logN|EM');
               tex =  call('SLIM_Parameters.getValue','Tex');
               delta_tex =  call('SLIM_Parameters.getValue','delta Tex|Te*');
               velo =  call('SLIM_Parameters.getValue','VLSR');
               delta_velo =  call('SLIM_Parameters.getValue','delta VLSR');
               fwhm =  call('SLIM_Parameters.getValue','FWHM');            
               delta_fwhm =  call('SLIM_Parameters.getValue','delta FWHM');


	// print ("logN:"+logN);
	// print ("delta logN:"+delta_logN);
                           call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_LogN.fits',1,i,j,logN);
                           call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_LogN.fits',2,i,j,delta_logN);

	// print ("Tex:"+tex);
                        // print ("delta Tex:"+delta_tex);
                           call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_Tex.fits',1,i,j,tex);
                           call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_Tex.fits',2,i,j,delta_tex);

	// print ("velocity:"+velo);
                        // print ("delta velocity:"+delta_velo);
                           call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_VLSR.fits',1,i,j,velo);
                           call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_VLSR.fits',2,i,j,delta_velo);

	// print ("FWHM:"+fwhm);
                        // print ("delta FWHM:"+delta_fwhm);
                           call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_FWHM.fits',1,i,j,fwhm);
                           call('Cube_Functionalities.setPixelFits','CUBE '+molecule+'_1_FWHM.fits',2,i,j,delta_fwhm);

// if AUTOFIT does not converge, do nothing (the pixels in the cube will be NaN), and count the number of failed pixels.

 	} else {
                        count_no_autofit=count_no_autofit+1;
                  	print ("AUTOFIT did not converge");
                   	}

 //            print ("End of pixel "+i+" , "+j); 
 //            print (" *****************************");   

count_pixels=count_pixels+1;

} else {

              print("pixel with signal-to-noise below threshold, AUTOFIT not applied"); 
}
             count = count+1;
             done = 100-((steps_x*steps_y-count)/(steps_x*steps_y)*100);
             print (" Completed: "+done+" % ");  

             fraction_pixels= count_pixels/(steps_x*steps_y)*100;
             print (" Pixels analyzed: "+fraction_pixels+" % ");  
    
}
}

             print (" **************************************************************");  

             print (" Pixels analyzed in which AUTOFIT did not converge: "+count_no_autofit); 

             print (" **************************************************************");  

// SAVE THE SLIM PRODUCT

print (" SAVING THE SLIM PRODUCT");  

run("SLIM Save", "namefile='"+path+"glycolaldehyde.cub.slim'");


// It prints the date and time of when the scripts ends:
getTime ();

// Close SLIM
run("SLIM Close", "");
// Close the Cube Container (and the datacubes)
run("Cube Container", "asksave=false close ");



print (" ****** END ********************************************************");  

// It saves the log window as an output file logfile.txt
selectWindow("Log");
saveAs("Text", path+"logfile.txt");


//****************************************************************************

function getTime () {
     MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
     DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     TimeString ="Date: "+DayNames[dayOfWeek]+" ";
     if (dayOfMonth<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+dayOfMonth+"-"+MonthNames[month]+"-"+year+"\nTime: ";
     if (hour<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+hour+":";
     if (minute<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+minute+":";
     if (second<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+second;
 //    showMessage(TimeString);
     print (" **************************************************************");  
     print (TimeString);
     }



// The help of several of the plugins used can be read using the following commands:
// run("SLIM Get Spectrum", "help");
// run("SLIM Select Molecule", "help");
// run("SLIM Parameters", "help");
// run("SLIM Rotational", "help");
// run("Open Virtual Cube", "help");
// run("Open Virtual Cube Background", "help");
// run("Cube Container", "help");
// run("Cube Functionalities", "help");
// run("CALCULATE SIGMA", "help");
// run("UPDATE SIGMA CUBE", "help");
// run("selectWindow", "help");
// run("SLIM Rotational", "help");
// run("SLIM AUTOFIT", "help");
// run("SLIM Check Transitions", "help");

// To see ImageJ functions: https://imagej.net/ij/developer/macro/functions.html#S

