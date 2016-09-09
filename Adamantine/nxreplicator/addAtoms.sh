packName=Adamantine_0
doSearchAtoms=true

Atoms=()
UnresolvedAtoms=()

function appendAtom() {
    Atoms[${#Atoms[*]}]=$1
}

function appendUnresolvedAtom() {
    UnresolvedAtoms[${#UnresolvedAtoms[*]}]=$1
}

<<COMMENT00
if [ "$1" == "" ]
    then
        echo "<DS> NO SEARCH >$1<"
        doSearchAtoms=false
    else
        echo "<DS> SEARCH >$1<"
        doSearchAtoms=true
fi
COMMENT00

function atomKnown() {
    if nxatomize list | grep -q "$1"; then
        echo "<DS> FOUND >$1<"
        return 0
    fi
    return 1
    echo "<DS> MISSING >$1<"
}

function searchAtom() {
    atomKnown $2
    if test $? = 0; then
        echo "<S> Found -> Skipping search"
        return 0
    else
        if test $doSearchAtoms = true;then
            echo "<S> Searching $1 $2"
            nxatomize search $1 $2
            sleep 3
        else
            echo "<S> Skipping search"
        fi
    fi
}

function addAtom() {
    echo "<S> Adding atom $1 $2"
    if nxfusion add $packName $1 $2 | grep -q "<\!> ERROR"; then
        appendUnresolvedAtom $2
    fi
}

function searchAndAdd() {
    searchAtom $1 $2
    addAtom $1 $2
    echo ---
}

function processAtoms() {
    for item in ${Atoms[*]}
    do
        #printf "   %s\n" $item
        searchAndAdd curse $item
    done
}

#<<COMMENT0
appendAtom actually-additions
appendAtom chameleon
appendAtom charset
appendAtom correlated-potentialistics
appendAtom ender-io
appendAtom endercore
appendAtom enderthing
appendAtom extra-utilities
appendAtom ftb-utilities
#dependency (ftblib)
appendAtom giacomos-foundry
appendAtom industrial-craft
appendAtom inventory-tweaks
appendAtom journeymap-32274
appendAtom just-enough-items-jei
appendAtom just-enough-resources-jer
appendAtom openglasses
appendAtom opencomputers
#appendAtom openfm
appendAtom openprinter
appendAtom openradio
appendAtom ore-control
appendAtom redstone-paste
appendAtom rftools
appendAtom rftools-dimensions
appendAtom roguelike-dungeons
appendAtom simpleoregen
appendAtom storage-drawers
appendAtom the-one-probe
appendAtom tis-3d
appendAtom vending-block
appendAtom water-strainer

appendAtom immersive-engineering


appendAtom mcjtylib
appendAtom ftblib


addAtom custom adm-ic2-cfg
addAtom custom adm-simpleoregen-cfg
addAtom custom adm-wstrain-cfg
addAtom custom adm-wstrain-loot-cfg
#COMMENT0

#nxcrunch generate $packName $packName

processAtoms

x="\e[33m"  # opening ansi color code for yellow text
y="\e[0m"   # ending ansi code

for item in ${UnresolvedAtoms[*]}
do
    printf "<S!> MISSING:"
    printf "   $x%s$y\n" $item
done

while getopts ":g" opt; do
  case $opt in
    g)
      #echo "-g was triggered!" >&2
      nxcrunch generate $packName $packName
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
