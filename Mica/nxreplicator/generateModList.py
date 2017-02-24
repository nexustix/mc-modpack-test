#mpc = open("ModPackConcept", "r")
#lines = mpc.readLines()

with open("ModPackConcept") as f:
    content = f.readlines()
    for i in content:
        for ii in i.split(" "):
            if ii.startswith("*"):
                print("appendAtom",ii[1:].strip())
