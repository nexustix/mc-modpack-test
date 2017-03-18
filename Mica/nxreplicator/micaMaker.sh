#packName=Adamantine_0
packName=MicaAlpha
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
appendAtom opencomputers
appendAtom openprinter
appendAtom ender-io
appendAtom ender-zoo
appendAtom actually-additions
appendAtom immersive-engineering
appendAtom refined-storage
appendAtom rftools
appendAtom rftools-dimensions
appendAtom railcraft
appendAtom deep-resonance
appendAtom forestry
appendAtom thermalexpansion
appendAtom thermal-foundation
appendAtom openglasses
appendAtom tis-3d
appendAtom openradio
appendAtom flux-networks
appendAtom blood-magic
appendAtom botania
appendAtom psi
appendAtom extra-utilities
appendAtom tinkers-construct
appendAtom giacomos-foundry
appendAtom just-enough-items-jei
appendAtom just-enough-resources-jer
appendAtom gravestone-mod
appendAtom better-builders-wands
appendAtom iron-backpacks
appendAtom bibliocraft
appendAtom enderthing
appendAtom ftb-utilities
appendAtom light-level-overlay-reloaded ---#
appendAtom storage-drawers
appendAtom cooking-for-blockheads
appendAtom natura
appendAtom roguelike-dungeons
appendAtom pams-harvestcraft
appendAtom journeymap-32274
appendAtom biomes-o-plenty
appendAtom fastleafdecay
appendAtom chisels-bits
appendAtom mystical-agriculture
appendAtom unidict
appendAtom appleskin
appendAtom the-spice-of-life
appendAtom funky-locomotion
appendAtom inventory-tweaks
appendAtom ftblib
appendAtom tesla
appendAtom infinitylib
appendAtom guide-api
appendAtom baubles
appendAtom eleccore-rendering-library
appendAtom mcjtylib
appendAtom mantle
appendAtom endercore
appendAtom mcmultipart
appendAtom chameleon
appendAtom wanionlib
appendAtom cofhcore
appendAtom codechicken-lib-1-8
appendAtom compatlayer
#COMMENT0

#addAtom custom mca-eleccore


addAtom custom adm-mekanism
addAtom custom adm-mekanism-generators
addAtom custom mca-computronics

addAtom custom mca-mekanism-cfg
addAtom custom mca-forestry-common-cfg
addAtom custom mca-railcraft-cfg
addAtom custom mca-unidict-cfg
addAtom custom mca-computronics-cfg
addAtom custom mca-railcraft-items-cfg

addAtom custom mca-theoneprobe

addAtom custom mca-cofh-cfg

addAtom custom mca-natura-cfg
addAtom custom mca-natura-modules-cfg


processAtoms

x="\e[33m"  # opening ansi color code for yellow (?) text
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
