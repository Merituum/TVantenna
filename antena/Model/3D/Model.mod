'# MWS Version: Version 2024.1 - Oct 16 2023 - ACIS 33.0.1 -

'# length = mm
'# frequency = GHz
'# time = ns
'# frequency range: fmin = 0.15 fmax = 0.7
'# created = '[VERSION]2024.1|33.0.1|20231016[/VERSION]


'@ use template: TVPL.cfg

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
'set the units
With Units
    .SetUnit "Length", "mm"
    .SetUnit "Frequency", "GHz"
    .SetUnit "Voltage", "V"
    .SetUnit "Resistance", "Ohm"
    .SetUnit "Inductance", "nH"
    .SetUnit "Temperature",  "degC"
    .SetUnit "Time", "ns"
    .SetUnit "Current", "A"
    .SetUnit "Conductance", "S"
    .SetUnit "Capacitance", "pF"
End With

ThermalSolver.AmbientTemperature "0"

'----------------------------------------------------------------------------

'set the frequency range
Solver.FrequencyRange "0.15", "0.7"

'----------------------------------------------------------------------------

Plot.DrawBox True

With Background
     .Type "Normal"
     .Epsilon "1.0"
     .Mu "1.0"
     .XminSpace "0.0"
     .XmaxSpace "0.0"
     .YminSpace "0.0"
     .YmaxSpace "0.0"
     .ZminSpace "0.0"
     .ZmaxSpace "0.0"
End With

With Boundary
     .Xmin "expanded open"
     .Xmax "expanded open"
     .Ymin "expanded open"
     .Ymax "expanded open"
     .Zmin "expanded open"
     .Zmax "expanded open"
     .Xsymmetry "none"
     .Ysymmetry "none"
     .Zsymmetry "none"
End With

' switch on FD-TET setting for accurate farfields

FDSolver.ExtrudeOpenBC "True"

Mesh.FPBAAvoidNonRegUnite "True"
Mesh.ConsiderSpaceForLowerMeshLimit "False"
Mesh.MinimumStepNumber "5"
Mesh.RatioLimit "20"
Mesh.AutomeshRefineAtPecLines "True", "10"

With MeshSettings
     .SetMeshType "Hex"
     .Set "RatioLimitGeometry", "20"
     .Set "EdgeRefinementOn", "1"
     .Set "EdgeRefinementRatio", "10"
End With

With MeshSettings
     .SetMeshType "Tet"
     .Set "VolMeshGradation", "1.5"
     .Set "SrfMeshGradation", "1.5"
End With

With MeshSettings
     .SetMeshType "HexTLM"
     .Set "RatioLimitGeometry", "20"
End With

PostProcess1D.ActivateOperation "vswr", "true"
PostProcess1D.ActivateOperation "yz-matrices", "true"

With MeshSettings
     .SetMeshType "Srf"
     .Set "Version", 1
End With
IESolver.SetCFIEAlpha "1.000000"

With FarfieldPlot
	.ClearCuts ' lateral=phi, polar=theta
	.AddCut "lateral", "0", "1"
	.AddCut "lateral", "90", "1"
	.AddCut "polar", "90", "1"
End With

'----------------------------------------------------------------------------

Dim sDefineAt As String
sDefineAt = "0.15;0.2;0.3;0.4;0.425;0.5;0.6;0.7"
Dim sDefineAtName As String
sDefineAtName = "0.15;0.2;0.3;0.4;0.425;0.5;0.6;0.7"
Dim sDefineAtToken As String
sDefineAtToken = "f="
Dim aFreq() As String
aFreq = Split(sDefineAt, ";")
Dim aNames() As String
aNames = Split(sDefineAtName, ";")

Dim nIndex As Integer
For nIndex = LBound(aFreq) To UBound(aFreq)

Dim zz_val As String
zz_val = aFreq (nIndex)
Dim zz_name As String
zz_name = sDefineAtToken & aNames (nIndex)

' Define E-Field Monitors
With Monitor
    .Reset
    .Name "e-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Efield"
    .MonitorValue  zz_val
    .Create
End With

' Define H-Field Monitors
With Monitor
    .Reset
    .Name "h-field ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Hfield"
    .MonitorValue  zz_val
    .Create
End With

' Define Power flow Monitors
With Monitor
    .Reset
    .Name "power ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerflow"
    .MonitorValue  zz_val
    .Create
End With

' Define Power loss Monitors
With Monitor
    .Reset
    .Name "loss ("& zz_name &")"
    .Dimension "Volume"
    .Domain "Frequency"
    .FieldType "Powerloss"
    .MonitorValue  zz_val
    .Create
End With

' Define Farfield Monitors
With Monitor
    .Reset
    .Name "farfield ("& zz_name &")"
    .Domain "Frequency"
    .FieldType "Farfield"
    .MonitorValue  zz_val
    .ExportFarfieldSource "False"
    .Create
End With

Next

'----------------------------------------------------------------------------

With MeshSettings
     .SetMeshType "Hex"
     .Set "Version", 1%
End With

With Mesh
     .MeshType "PBA"
End With

'set the solver type
ChangeSolverType("HF Time Domain")

'----------------------------------------------------------------------------

'@ define material: Aluminum

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Material
     .Reset
     .Name "Aluminum"
     .Folder ""
     .FrqType "static"
     .Type "Normal"
     .SetMaterialUnit "Hz", "mm"
     .Epsilon "1"
     .Mu "1.0"
     .Kappa "3.56e+007"
     .TanD "0.0"
     .TanDFreq "0.0"
     .TanDGiven "False"
     .TanDModel "ConstTanD"
     .KappaM "0"
     .TanDM "0.0"
     .TanDMFreq "0.0"
     .TanDMGiven "False"
     .TanDMModel "ConstTanD"
     .DispModelEps "None"
     .DispModelMu "None"
     .DispersiveFittingSchemeEps "General 1st"
     .DispersiveFittingSchemeMu "General 1st"
     .UseGeneralDispersionEps "False"
     .UseGeneralDispersionMu "False"
     .FrqType "all"
     .Type "Lossy metal"
     .MaterialUnit "Frequency", "GHz"
     .MaterialUnit "Geometry", "mm"
     .MaterialUnit "Time", "s"
     .MaterialUnit "Temperature", "Kelvin"
     .Mu "1.0"
     .Sigma "3.56e+007"
     .Rho "2700.0"
     .ThermalType "Normal"
     .ThermalConductivity "237.0"
     .SpecificHeat "900", "J/K/kg"
     .MetabolicRate "0"
     .BloodFlow "0"
     .VoxelConvection "0"
     .MechanicsType "Isotropic"
     .YoungsModulus "69"
     .PoissonsRatio "0.33"
     .ThermalExpansionRate "23"
     .ReferenceCoordSystem "Global"
     .CoordSystemType "Cartesian"
     .NLAnisotropy "False"
     .NLAStackingFactor "1"
     .NLADirectionX "1"
     .NLADirectionY "0"
     .NLADirectionZ "0"
     .Colour "1", "1", "0"
     .Wireframe "False"
     .Reflection "False"
     .Allowoutline "True"
     .Transparentoutline "False"
     .Transparency "0"
     .Create
End With

'@ new component: component1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Component.New "component1"

'@ define brick: component1:solid1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Brick
     .Reset 
     .Name "solid1" 
     .Component "component1" 
     .Material "Aluminum" 
     .Xrange "-d/2", "d/2" 
     .Yrange "-d/2", "d/2" 
     .Zrange "0", "L" 
     .Create
End With

'@ define cylinder: component1:#12

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#12" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l12" 
     .Ycenter "0" 
     .Zcenter "d12" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#11

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#11" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l11" 
     .Ycenter "0" 
     .Zcenter "d11" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#10

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#10" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l10" 
     .Ycenter "0" 
     .Zcenter "d10" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#9

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#9" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l9" 
     .Ycenter "0" 
     .Zcenter "d9" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#8

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#8" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l8" 
     .Ycenter "0" 
     .Zcenter "d8" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#7

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#7" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l7" 
     .Ycenter "0" 
     .Zcenter "d7" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#6

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#6" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l6" 
     .Ycenter "0" 
     .Zcenter "d6" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#5

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#5" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l5" 
     .Ycenter "0" 
     .Zcenter "d5" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#4

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#4" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l4" 
     .Ycenter "0" 
     .Zcenter "d4" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#3

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#3" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l3" 
     .Ycenter "0" 
     .Zcenter "d3" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#2" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l2" 
     .Ycenter "0" 
     .Zcenter "d2" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:#1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "#1" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l1" 
     .Ycenter "0" 
     .Zcenter "d1" 
     .Segments "0" 
     .Create 
End With

'@ paste structure data: 1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With SAT 
     .Reset 
     .FileName "*1.cby" 
     .SubProjectScaleFactor "0.001" 
     .ImportToActiveCoordinateSystem "True" 
     .ScaleToUnit "True" 
     .Curves "False" 
     .Read 
End With

'@ transform: translate component1:solid1_1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Transform 
     .Reset 
     .Name "component1:solid1_1" 
     .Vector "0", "-K", "W" 
     .UsePickedPoints "False" 
     .InvertPickedPoints "False" 
     .MultipleObjects "False" 
     .GroupObjects "False" 
     .Repetitions "1" 
     .MultipleSelection "False" 
     .AutoDestination "True" 
     .Transform "Shape", "Translate" 
End With

'@ define cylinder: component1:12

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "12" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l12" 
     .Ycenter "-K" 
     .Zcenter "d12" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:11

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "11" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l11" 
     .Ycenter "-K" 
     .Zcenter "d11" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:10

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "10" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l10" 
     .Ycenter "-K" 
     .Zcenter "d10" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:9

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "9" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l9" 
     .Ycenter "-K" 
     .Zcenter "d9" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:8

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "8" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l8" 
     .Ycenter "-K" 
     .Zcenter "d8" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:7

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "7" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l7" 
     .Ycenter "-K" 
     .Zcenter "d7" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:6

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "6" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l6" 
     .Ycenter "-K" 
     .Zcenter "d6" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:5

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "5" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l5" 
     .Ycenter "-K" 
     .Zcenter "d5" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:4

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "4" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l4" 
     .Ycenter "-K" 
     .Zcenter "d4" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:3

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "3" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l3" 
     .Ycenter "-K" 
     .Zcenter "d3" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:2

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "2" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "-d/2", "-d/2-l2" 
     .Ycenter "-K" 
     .Zcenter "d2" 
     .Segments "0" 
     .Create 
End With

'@ define cylinder: component1:1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Cylinder 
     .Reset 
     .Name "1" 
     .Component "component1" 
     .Material "Aluminum" 
     .OuterRadius "r" 
     .InnerRadius "r" 
     .Axis "x" 
     .Xrange "d/2", "d/2+l1" 
     .Ycenter "-K" 
     .Zcenter "d1" 
     .Segments "0" 
     .Create 
End With

'@ clear picks

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.ClearAllPicks

'@ pick center point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickCenterpointFromId "component1:solid1", "1"

'@ pick center point

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Pick.PickCenterpointFromId "component1:solid1_1", "1"

'@ define discrete port: 1

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With DiscretePort 
     .Reset 
     .PortNumber "1" 
     .Type "SParameter"
     .Label ""
     .Folder ""
     .Impedance "75"
     .Voltage "1.0"
     .Current "1.0"
     .Monitor "True"
     .Radius "0.0"
     .SetP1 "False", "0", "0", "L"
     .SetP2 "False", "0", "-K", "L"
     .InvertDirection "False"
     .LocalCoordinates "False"
     .Wire ""
     .Position "end1"
     .Create 
End With

'@ define time domain solver acceleration

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
With Solver 
     .UseParallelization "True"
     .MaximumNumberOfThreads "1024"
     .MaximumNumberOfCPUDevices "2"
     .RemoteCalculation "False"
     .UseDistributedComputing "False"
     .MaxNumberOfDistributedComputingPorts "64"
     .DistributeMatrixCalculation "True"
     .MPIParallelization "False"
     .AutomaticMPI "False"
     .ConsiderOnly0D1DResultsForMPI "False"
     .HardwareAcceleration "True"
     .MaximumNumberOfGPUs "1"
End With
UseDistributedComputingForParameters "False"
MaxNumberOfDistributedComputingParameters "2"
UseDistributedComputingMemorySetting "False"
MinDistributedComputingMemoryLimit "0"
UseDistributedComputingSharedDirectory "False"
OnlyConsider0D1DResultsForDC "False"

'@ define time domain solver parameters

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Mesh.SetCreator "High Frequency" 

With Solver 
     .Method "Hexahedral"
     .CalculationType "TD-S"
     .StimulationPort "All"
     .StimulationMode "All"
     .SteadyStateLimit "-40"
     .MeshAdaption "False"
     .AutoNormImpedance "True"
     .NormingImpedance "75"
     .CalculateModesOnly "False"
     .SParaSymmetry "False"
     .StoreTDResultsInCache  "False"
     .RunDiscretizerOnly "False"
     .FullDeembedding "False"
     .SuperimposePLWExcitation "False"
     .UseSensitivityAnalysis "False"
End With

'@ set PBA version

'[VERSION]2024.1|33.0.1|20231016[/VERSION]
Discretizer.PBAVersion "2023101624"
