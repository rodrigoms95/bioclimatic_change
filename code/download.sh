# Descarga la información futura e histórica de WorldClim para una
# resolución dada.

# Parar al primer error.
set -e

# Valores default.
RES="10m"
# Leer argumentos.
while getopts r flag; do
    case "${flag}" in
        r) RES="${OPTARG}";;
    esac
done

PATH_D="../data/WC/TIFF/Global/"
FTYPE=( "Historical" "Future" )

# Archivos Futuros.
VARS=( "tmax" "tmin" "prec" "bioc" )
SSP=( "126" "245" "370" "585" )
DIR="$PATH_D${FTYPE[1]}/$RES/"
mkdir -p $DIR
cd $DIR
# Descargamos.
URL="https://geodata.ucdavis.edu/cmip6/$RES/"
wget -r -np -nH -nd --cut-dirs=3 -R index.html -e robots=off $URL
rm -r "index.html"*
rm -r "wget-log"
# Organizamos en carpetas.
for v in ${VARS[@]}; do
    for s in ${SSP[@]}; do
        mkdir -p "$v/ssp$s/"
        for n in "wc2.1_$RES""_""$v"*"$s"*; do
            mv -f $n "$v/ssp$s/$n"
        done
    done
done
# Limpiamos.
rm -r bioc

# Archivos históricos.
VARS=( "tmax" "tmin" "prec" "tavg" "srad" "wind" "vapr" "elev" )
DIR="$PATH_D${FTYPE[0]}/$RES/"
mkdir -p $DIR
cd $DIR
# Descargamos.
for v in ${VARS[@]}; do
    URL="https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_$RES""_$v.zip"
    wget $URL
done
# Descomprimimos y limpiamos.
for f in *.zip; do
    FOLDER=${f%.*}
    unzip -q -d $FOLDER $f -x "*.txt"
    cd F
done
rm -r *.zip