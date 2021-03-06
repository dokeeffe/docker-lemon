docker-lemon is a docker image which makes it easy to run [LEMON, the differential photometry pipeline](https://github.com/vterron/lemon)

## Building the image

`docker build -t lemondoc .`

## Starting container

Assuming you have fits files in ~/Pictures on your PC, the following command will make them available at /data in the container

`docker run -v ~/Pictures:/data -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY -it lemondoc bash`

## Reducing fits files

The example below I already have the calibrated and plate solved fits files in a directory on my PC called ~/Pictures/xo-2b

### Running mosaic

An example of running against all fits files in my xo-2b dir

`lemon mosaic /data/xo-2b/*.fits xo-2b.fits`

### Run photometry

`lemon photometry /data/xo-2b.fits /data/xo-2b/*.fits phot.LEMONdB`

### Create the differential photometry data

This command will take data from the phot.LEMONdB and create a new database called curves.LEMONdB

`lemon diffphot /data/phot.LEMONdB /data/curves.LEMONdB`

### Run the jucier browser app

`lemon juicer phot.LEMONdB`

![screenshot](https://raw.githubusercontent.com/dokeeffe/docker-lemon/master/docs/juicer-screenshot.png)

