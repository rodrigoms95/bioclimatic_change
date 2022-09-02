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

PATH_D='../data/WC/TIFF/Global/'
#FTYPE=( 'Historical' 'Future' )
#FTYPE=( 'Historical' )
VARS=( 'tmax' 'tmin' 'prec' 'bioc' )
SSP=( '126' '245' '370' '585' )
FTYPE='Future'

DIR=$PATH_D$FTYPE'/'$RES'/'

#URL='https://data.biogeo.ucdavis.edu/data/worldclim/v2.1/base/'
URL='https://geodata.ucdavis.edu/cmip6/'$RES'/'

mkdir -p $DIR
cd $DIR

wget -r -np -nH -nd --cut-dirs=3 -R index.html -e robots=off $URL

rm -r 'index.html'*

for v in ${VARS[@]}
do
    for s in ${SSP[@]}
    do
        mkdir -p $v'/ssp'$s'/'
        for n in 'wc2.1_'$RES'_'$v*$s* 
        do
            mv -f $n $v'/'$s'/'$n
        done
    done
done


#URL='https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_10m_tmin.zip'
#wget $URL