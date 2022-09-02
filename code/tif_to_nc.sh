# Descarga toda la información de ERA5 para una variable.

# Stop at first error.
set -e

# Default options for conda and user.
RES='10m'
# Read arguments.
while getopts r flag
do
    case '${flag}' in
        r) RES=${OPTARG};;
    esac
done

# Cambiar al folder local!!!
CONDA_SOURCE='/opt/homebrew/Caskroom/miniforge/base'
source $CONDA_SOURCE'/etc/profile.d/conda.sh'
# Cambiar por el nombre del environment local!!!
conda activate gv

#FTYPE=( 'Historical' 'Future' )
FTYPE=( 'Historical' )
VARS=( 'tavg' 'tmax' 'tmin' 'prec' 'vapr' 'srad' )
MONTH=( '01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' )

PATH_D='../data/WC/'
FHEAD='wc2.1_'
TIF='.tif'
NC='.nc'

echo 'Begin processing files.'

for f in ${FTYPE[@]}
do
    for v in ${VARS[@]}
    do

        FNAME=$FHEAD$RES'_'$v
        DIR_D=$PATH_D'TIFF/'$f'/'$FNAME'/'
        
        echo ''
        echo 'Processing '$FNAME'...'

        for m in ${MONTH[@]}
        do

            FILE_D=$DIR_D$FNAME'_'$m$TIF
            DIR_R=$PATH_D'NC/'$FTYPE'/'$FNAME'/'
            FILE_R=$DIR_R$FNAME'_'$m$NC

            mkdir -p $DIR_R
            gdal_translate -q -of NetCDF $FILE_D $FILE_R

    done

    echo $FNAME' processed.'

    done

    v='elev'
    FNAME=$FHEAD$RES'_'$v
    DIR_D=$PATH_D'TIFF/'$f'/'
    FILE_D=$DIR_D$FNAME$TIF
    DIR_R=$PATH_D'NC/'$FTYPE'/'
    FILE_R=$DIR_R$FNAME$NC

    echo ''
    echo 'Processing '$FNAME'...'

    mkdir -p $DIR_R
    gdal_translate -q -of NetCDF $FILE_D $FILE_R

    echo ''
    echo $FNAME' processed.'
done

echo ''
echo 'All files processed.'