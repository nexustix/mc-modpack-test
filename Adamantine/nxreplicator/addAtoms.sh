#packName=Adamantine_0
packName=AdamantineAlpha
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
appendAtom actually-additions               # TECH
#appendAtom charset
#appendAtom correlated-potentialistics
appendAtom ender-io                         # TECH
appendAtom ender-zoo                        # MOBS
appendAtom enderthing                       # STORAGE (Enderchest)
appendAtom extra-utilities                  # TEC
appendAtom ftb-utilities                    # MANAGEMENT
#dependency (ftblib)
appendAtom giacomos-foundry                 # RECYCLING
#appendAtom industrial-craft
appendAtom inventory-tweaks                 # HELPER
appendAtom journeymap-32274                 # MAP
appendAtom just-enough-items-jei            # HELPER
appendAtom just-enough-resources-jer        # HELPER
appendAtom openglasses                      # COMPUTER
appendAtom opencomputers                    # COMPUTER
#appendAtom openfm
appendAtom openprinter                      # COMPUTER
appendAtom openradio                        # COMPUTER
appendAtom ore-control                      # OREGEN
#appendAtom redstone-paste
appendAtom rftools                          # TECH
appendAtom rftools-dimensions               # ???
appendAtom roguelike-dungeons               # RECYCLING
appendAtom simpleoregen                     # OREGEN
appendAtom storage-drawers                  # STORAGE
appendAtom the-one-probe                    # HELPER
appendAtom tis-3d                           # COMPUTER
appendAtom vending-block                    # SOCIAL
appendAtom water-strainer                   # BALANCE

appendAtom immersive-engineering            # TECH

appendAtom refined-storage                  # TECH
appendAtom tinkers-construct                # RECYCLING


appendAtom endercore
appendAtom chameleon
appendAtom mcjtylib
appendAtom ftblib

appendAtom mantle


#appendAtom biomes-o-plenty
#appendAtom botania-unofficial
#appendAtom baubles


#addAtom custom adm-ic2-cfg
addAtom custom adm-simpleoregen-cfg
addAtom custom adm-wstrain-cfg
addAtom custom adm-wstrain-loot-cfg
#COMMENT0

addAtom custom adm-orecontrol-cfg

addAtom custom adm-simpleoregen-oregen-cfg
addAtom custom adm-simpleoregen-cmd-cfg

addAtom custom adm-actuallyadditions-cfg

addAtom custom adm-immersiveengineering-cfg

addAtom custom adm-mekanism
addAtom custom adm-mekanism-generators
addAtom custom adm-mekanism-cfg

#addAtom custom adm-baubles

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
