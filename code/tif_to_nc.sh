# Descarga toda la información de ERA5 para una variable.

# Stop at first error.
set -e

# Default options for conda and user.
FTYPE='Historical'
RES='10m'
VAR='elev'

# Read arguments.
while getopts f:r:v flag
do
    case '${flag}' in
        f) FTYPE=${OPTARG};;
        r) RES=${OPTARG};;
        v) VAR=${OPTARG};;
    esac
done

# Cambiar al folder local!!!
CONDA_SOURCE='/opt/homebrew/Caskroom/miniforge/base'
source $CONDA_SOURCE'/etc/profile.d/conda.sh'
# Cambiar por el nombre del environment local!!!
conda activate gv

PATH_D='../data/WC/'
FHEAD='wc2.1_'
TIF='.tif'
NC='.nc'
FNAME=$FHEAD$RES'_'$VAR
DIR_D=$PATH_D'TIFF/'$FTYPE'/'$FNAME'/'
FILE_D=$DIR_D$FNAME$TIF
DIR_R=$PATH_D'NC/'$FTYPE'/'$FNAME'/'
FILE_R=$DIR_R$FNAME$NC

mkdir -p $DIR_R
gdal_translate -of NetCDF $FILE_D $FILE_R