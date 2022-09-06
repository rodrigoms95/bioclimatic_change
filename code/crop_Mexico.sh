# Default options for conda and user.
user="rodrigo"
conda="miniconda"

# Read arguments.
while getopts n:c: flag; do
    case "${flag}" in
        n) user=${OPTARG};;
        c) conda=${OPTARG};;
    esac
done

# Establish home directory.
HOME="/home/$user"
case $conda in
    # For use with anaconda.
    anaconda|anaconda3)
        # Directory for environments.
        CONDA_DIR="$HOME/anaconda3"
        # Directory for source in shell scripts.
        CONDA_SOURCE="$HOME/anaconda3";;
    # For use with miniconda.
    miniconda|conda|*)
        CONDA_DIR="$HOME/.conda"
        CONDA_SOURCE="$HOME/miniconda";;
esac

# Activate conda in this script.
source $CONDA_SOURCE/etc/profile.d/conda.sh

conda activate gdal

mlon1="-118.390"
mlon2="-86.660"
mlat1="14.566"
mlat2="32.737"

mkdir -p CHIRTS
cd CHIRTS

# Variables to download.
var=('Tmin' 'Tmax')
for name in  "${var[@]}"; do
    mkdir $name
    cd $name
    # Years to download.
        for filename in *.tif; do
            # Avoid errors.
            shopt nullglob
            # Convert from GeoTiff to NetCDF.
            gdal_translate -of NetCDF $filename "${filename##*/}.nc"
            # Crop within the borders of Mexico.
            cdo sellonlatbox,$mlon1,$mlon2,$mlat1,$mlat2 "${filename##*/}.nc" "mexico_${filename##*/}.nc"
    	    # Remove original file.
            rm $filename
            rm "${filename##*/}.nc"
        done
        for filename in index.html*; do
            # Avoid errors.
            shopt nullglob
            # Remove indexes.
            rm $filename
        done
        cd ..
    done
    cd ..
done
