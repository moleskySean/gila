###UTILITY LOADING
include("./tests/preamble.jl")
###SETTINGS
# number of cells in volume 
cells = [128,128,128]
# size of cells relative to wavelength
sclS = (0.01, 0.01, 0.01)
# center position of volume
coord = (0.00, 0.00, 0.00)
# computation settinungs
cmpInfHst = GlaKerOpt(false)
cmpInfDev = GlaKerOpt(true)
###PREP 
# create volume
slfVol = GlaVol(cells, sclS, coord)
## generate circulant green function if not serialized. 
println("Green function construction started.")
gSlfOprMemHst = GlaOprMemGenSlf(cmpInfHst, slfVol)
gSlfOprMemDev = GlaOprMemGenSlf(cmpInfDev, slfVol, gSlfOprMemHst.egoFur)
# serialize("./tmp/gFourSlf256x3_64", gSlfOprMemHst.egoFur)
# gFurX = deserialize("./tmp/gFourSlf256x3_64")
# gSlfOprMemHst = GlaOprMemGenSlf(cmpInfHst, slfVol, gFurX)
# gSlfOprMemDev = GlaOprMemGenSlf(cmpInfDev, slfVol, gFurX)
println("Green function construction completed.")
###TEST
## integral convergence 
# println("Integral convergence test started.")
# include("./tests/intConTest.jl")
# println("Integral convergence test completed.")
## analytic agreement
# println("Analytic test started.")
# include("./tests/anaTest.jl")
# println("Analytic test completed.")
## positive  semi-definite test
# test becomes very slow for domains larger than [16,16,16]
# println("Semi-definiteness test started.")
# include("./tests/posDefTest.jl")
# println("Semi-definiteness test completed.")
## single operator actions
# set .actVec prior to use
# CPU
@btime egoOpr!($gSlfOprMemHst)
# GPU
@btime egoOpr!($gSlfOprMemDev)