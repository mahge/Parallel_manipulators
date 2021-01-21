within DeltaRobot.ReferenceSignals;

model SpeedCommand "The outputs are three speed reference signals defined through interpolation of table's elements"
  extends DeltaRobot.Icons.SpeedCommand; // Icon

  // Parameters
  parameter Integer n(min=1,max=3) = 1 "The reference speeds are repeted 'n' times";
  parameter SI.Time startTime = 0 "speedRef = 0, for time<startTime";
  parameter SI.Time deltaTime = 0 "Time between two repetitions of the reference speeds";
  parameter Real k = 1000*7.11/1500 "Gain";
  parameter String tableName = "Speeds";
  parameter String fileName = "D:/Dev/Modelica/GitHub_ParallelManipulators/Parallel_manipulators/Modelica_models/DeltaRobot/DataTables/SpeedCommand.txt";

  // Variables
  SI.AngularVelocity speed[3];

  // Models
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable1(
      table=fill(0.0, 0, 5),
      tableOnFile=true,
      tableName=tableName,
      columns=2:4,
      fileName=fileName,
      startTime=startTime) 
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Modelica.Blocks.Interfaces.RealOutput speedRef[3] "reference speeds in rad/s" annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Math.Gain gain[3](each k=k) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable2(
      table=fill(0.0, 0, 5),
      tableOnFile=true,
      tableName=tableName,
      columns=2:4,
      fileName=fileName,
      startTime=startTime + combiTimeTable1.t_max + deltaTime)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable3(
      table=fill(0.0, 0, 5),
      tableOnFile=true,
      tableName=tableName,
      columns=2:4,
      fileName=fileName,
      startTime=startTime + combiTimeTable1.t_max + combiTimeTable2.t_max + 2*deltaTime)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Modelica.Blocks.Math.Sum sumX(nin=3) annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Math.Sum sumY(nin=3) annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Sum sumZ(nin=3) annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  speed[1] = speedRef[1];
  speed[2] = speedRef[2];
  speed[3] = speedRef[3];

  connect(gain.y, speedRef) annotation (Line(points={{61,0},{110,0}}, color={0,0,127}));

  connect(combiTimeTable1.y[1], sumX.u[1]) annotation (Line(points={{-59,30},{-26,30},{-26,28.6667},{-22,28.6667}}, color={0,0,127}));
  connect(combiTimeTable2.y[1], sumX.u[2]) annotation (Line(points={{-59,0},{-34,0},{-34,30},{-22,30}}, color={0,0,127}));
  connect(combiTimeTable3.y[1], sumX.u[3]) annotation (Line(points={{-59,-30},{-32,-30},{-32,31.3333},{-22,31.3333}}, color={0,0,127}));
  connect(combiTimeTable1.y[2], sumY.u[1]) annotation (Line(points={{-59,30},{-50,30},{-50,18},{-22,18},{-22,-1.33333}}, color={0,0,127}));
  connect(combiTimeTable2.y[2], sumY.u[2]) annotation (Line(points={{-59,0},{-22,0}}, color={0,0,127}));
  connect(combiTimeTable3.y[2], sumY.u[3]) annotation (Line(points={{-59,-30},{-42,-30},{-42,1.33333},{-22,1.33333}}, color={0,0,127}));
  connect(combiTimeTable1.y[3], sumZ.u[1]) annotation (Line(points={{-59,30},{-42,30},{-42,-31.3333},{-22,-31.3333}}, color={0,0,127}));
  connect(combiTimeTable2.y[3], sumZ.u[2]) annotation (Line(points={{-59,0},{-42,0},{-42,-30},{-22,-30}}, color={0,0,127}));
  connect(combiTimeTable3.y[3], sumZ.u[3]) annotation (Line(points={{-59,-30},{-40,-30},{-40,-28.6667},{-22,-28.6667}}, color={0,0,127}));
  connect(sumX.y, gain[1].u) annotation (Line(points={{1,30},{38,30},{38,0}}, color={0,0,127}));
  connect(sumY.y, gain[2].u) annotation (Line(points={{1,0},{38,0}}, color={0,0,127}));
  connect(sumZ.y, gain[3].u) annotation (Line(points={{1,-30},{38,-30},{38,0}}, color={0,0,127}));
  annotation (
    Diagram(graphics={Text(
          extent={{-100,100},{106,84}},
          lineColor={28,108,200},
          textString="The tables must start with time = 0 and it's better if they represent an integer number of periods of a periodic signal (signal(0) = signal(t_max))")}));
end SpeedCommand;
