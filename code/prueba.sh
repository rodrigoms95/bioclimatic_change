# Convierte de TIFF a netCDF y corta el área de México.

# Stop at first error.
set -e

# Default options for conda and user.
RES="10m"
# Read arguments.
while getopts r flag; do
    case "${flag}" in
        r) RES="${OPTARG}";;
    esac
done

# Cambiar al folder local!!!
CONDA_SOURCE="/opt/homebrew/Caskroom/miniforge/base"
source "$CONDA_SOURCE/etc/profile.d/conda.sh"
# Cambiar por el nombre del environment local!!!
conda activate gv

# Datos generales.
FTYPE=( "Historical" "Future" )
EXTENT=( "Global" "Mexico" )
FEXT=( "TIFF" "NC" )
PATH_D="../data/WC/"
FHEAD="wc2.1_"
TIF=".tif"
NC=".nc"

# Límites de México.
mlon1="-118.390"
mlon2="-86.660"
mlat1="14.566"
mlat2="32.737"


echo "Begin processing files."

# Historical.
VARS=( "tavg" "tmax" "tmin" "prec" "vapr" "srad" "elev" )
echo ""
echo "Historical variables"
# Para todas las variables.
for v in ${VARS[@]}; do

    DIR_D="$PATH_D${FEXT[0]}/${EXTENT[0]}/${FTYPE[0]}/$RES/$v/"
        
    echo ""
    echo "Processing $v..."

    # Para todos los meses.
    for FILE_D in $DIR_D*.tif; do

        NAME="${FILE_D##*/}"
        NAME="${NAME%.*}"

        # Convertimos a netCDF.
        DIR_R_1="$PATH_D${FEXT[1]}/${EXTENT[0]}/${FTYPE[0]}/$RES/$v/"
        FILE_R_1=$DIR_R_1$NAME$NC
        mkdir -p $DIR_R_1
        gdal_translate -q -of NetCDF $FILE_D $FILE_R_1

        # Recortamos el contorno de México.
        DIR_R_2="$PATH_D${FEXT[1]}/${EXTENT[1]}/${FTYPE[0]}/$RES/$v/"
        FILE_R_2="$DIR_R_2""mexico_$NAME$NC"
        mkdir -p $DIR_R_2
        cdo -s sellonlatbox,$mlon1,$mlon2,$mlat1,$mlat2 $FILE_R_1 $FILE_R_2
    
    done

    echo "$v processed."

done

# Future.
VARS=( "tmax" )
SSP=( '126' '245' '370' '585' )
echo ""
echo "Future variables"
# Para todas las variables.
for v in ${VARS[@]}; do
# Para todos los RCP.
    for s in ${SSP[@]}; do

        DIR_D="$PATH_D${FEXT[0]}/${EXTENT[0]}/${FTYPE[1]}/$RES/$v/ssp$s/"
        
        echo ""
        echo "Processing $v/ssp$s..."

        # Para todos los periodos.
        for FILE_D in $DIR_D*.tif; do

            NAME="${FILE_D##*/}"
            NAME="${NAME%.*}"

            # Convertimos a netCDF.
            DIR_R_1="$PATH_D${FEXT[1]}/${EXTENT[0]}/${FTYPE[1]}/$RES/$v/ssp$s/"
            FILE_R_1=$DIR_R_1$NAME$NC
            mkdir -p $DIR_R_1
            gdal_translate -q -of NetCDF $FILE_D $FILE_R_1

            # Recortamos el contorno de México.
            DIR_R_2="$PATH_D${FEXT[1]}/${EXTENT[1]}/${FTYPE[1]}/$RES/$v/ssp$s/"
            FILE_R_2="$DIR_R_2""mexico_$NAME$NC"
            mkdir -p $DIR_R_2
            cdo -s sellonlatbox,$mlon1,$mlon2,$mlat1,$mlat2 $FILE_R_1 $FILE_R_2
    
    done

    echo "$v/ssp$s processed."

    done
done

echo ""
echo "All files processed."