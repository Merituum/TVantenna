<?xml version="1.0" encoding="UTF-8"?>
<MetaResultFile version="20211011" creator="Solver HFTD - Field 3DFD Monitor">
  <MetaGeometryFile filename="model.gex" lod="1"/>
  <SimulationProperties fieldname="e-field (f=0.6) [1]" frequency="0.59999999999999998" encoded_unit="&amp;U:V^1.:m^-1" quantity="e-field" fieldtype="E-Field" fieldscaling="PEAK" dB_Amplitude="20">
    <SecondaryResults>
      <SecondaryResult name="power (f=0.6)_1.rex"/>
    </SecondaryResults>
  </SimulationProperties>
  <ResultDataType vector="1" complex="1" timedomain="0" frequencymap="0"/>
  <SimulationDomain min="-681.348511 -204.348511 -176.348511" max="681.348511 181.348511 1836.34851"/>
  <PlotSettings Plot="4" ignore_symmetry="0" deformation="0" enforce_culling="0" integer_values="0" combine="CombineNone" default_arrow_type="ARROWS" default_scaling="NONE"/>
  <Source type="SOLVER"/>
  <SpecialMaterials>
    <Background type="NORMAL"/>
    <Material name="Aluminum" type="FIELDFREE"/>
    <Material name="PEC" type="FIELDFREE"/>
  </SpecialMaterials>
  <AuxGeometryFile/>
  <AuxResultFile/>
  <FieldFreeNodes/>
  <SurfaceFieldCoefficients/>
  <UnitCell/>
  <SubVolume/>
  <Units/>
  <ProjectUnits/>
  <TimeSampling/>
  <LocalAxes/>
  <MeshViewSettings/>
  <ResultGroups num_steps="1" transformation="1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1" process_mesh_group="0">
    <SharedDataWith>
      <Result treepath="" rexname=""/>
    </SharedDataWith>
    <Frame index="0">
      <PortModeInfoFile/>
      <FieldResultFile filename="e-field (f=0.6)_1,1.m3d" type="m3d"/>
    </Frame>
  </ResultGroups>
  <AutoScale>
    <SmartScaling log_strength="1" log_anchor="0" log_anchor_type="0" db_range="40" phase="0"/>
  </AutoScale>
</MetaResultFile>
