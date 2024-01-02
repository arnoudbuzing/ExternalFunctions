ClearAll["ArnoudBuzing`ExternalFunctions`*"];

BeginPackage["ArnoudBuzing`ExternalFunctions`"];

LoadExternalFunction;

FastFourierTransform;
InverseFastFourierTransform;
DiscreteCosineTransform;
InverseDiscreteCosineTransform;
DiscreteSineTransform;
InverseDiscreteSineTransform;

MatrixBandwidth;

AcentricFactor;
StielPolarFactor;
LeeKeslerOmega;


Begin["`Private`"];

PythonSessionGet[id_String, deps_List, prolog_String : ""] := SelectFirst[
  ExternalSessions[],
  #["ID"] === id &,
  StartExternalSession[{
    "Python",
    "ID" -> id,
    "Evaluator" -> <|
      "Dependencies" -> deps,
      "EnvironmentName" -> id,
      "PythonRuntime" -> "3.11"
      |>,
    "SessionProlog" -> prolog
    }]
  ]

LoadExternalFunction["Python", fun_String, extra_String : ""] := Module[{components, pkg, ctx, ef, wl},
  components = StringSplit[fun, "."];
  pkg = First[components];
  ctx = StringRiffle[Most[components], "."];
  ExternalEvaluate[PythonSessionGet[pkg, {pkg}],"import " <> ctx];
  ExternalEvaluate[PythonSessionGet[pkg, {pkg}], extra];
  ef = ExternalFunction[PythonSessionGet[pkg, {pkg}], fun];
  wl = StringReplace["ArnoudBuzing`ExternalFunctions`" <> fun, {"." -> "˘", "_" -> "˘"}];
  With[{s = wl}, Quiet[Remove[s]]];
  With[{s = Symbol[wl], rhs = ef}, OwnValues[s] = {HoldPattern[s] :> rhs}];
  Symbol[wl]
  ]

(*****
  
  SciPy

*****)

(* Fourier Transforms *)
FastFourierTransform := ( FastFourierTransform = LoadExternalFunction["Python", "scipy.fft.fft"] );
InverseFastFourierTransform := ( InverseFastFourierTransform = LoadExternalFunction["Python", "scipy.fft.ifft"] );
DiscreteCosineTransform := ( DiscreteCosineTransform = LoadExternalFunction["Python", "scipy.fft.dct"] );
InverseDiscreteCosineTransform := ( InverseDiscreteCosineTransform = LoadExternalFunction["Python", "scipy.fft.idct"] );
DiscreteSineTransform := ( DiscreteSineTransform = LoadExternalFunction["Python", "scipy.fft.dst"] );
InverseDiscreteSineTransform := ( InverseDiscreteSineTransform = LoadExternalFunction["Python", "scipy.fft.idst"] );

(* Linear Algebra *)
MatrixBandwidth := (
  ExternalEvaluate[ PythonSessionGet["scipy",{"scipy"}], "import numpy"]; 
  MatrixBandwidth = LoadExternalFunction["Python", "lambda x: scipy.linalg.bandwidth(numpy.array(x))"] 
  );

(*****

  Chemicals

*****)

AcentricFactor[cas_String] := LoadExternalFunction["Python", "chemicals.acentric.omega"][cas];
AcentricFactor[ei_ExternalIdentifier] := LoadExternalFunction["Python", "chemicals.acentric.omega"][ei["ExternalID"]];
AcentricFactor[e_Entity] := LoadExternalFunction["Python", "chemicals.acentric.omega"][First[e[EntityProperty["Chemical","CASRegistryNumber"]]]["ExternalID"]];

StielPolarFactor[psat_, pc_, omega_ ] := LoadExternalFunction["Python", "chemicals.acentric.Stiel_polar_factor"][psat,pc,omega];
StielPolarFactor[psat_Quantity, pc_Quantity, omega_ ] := LoadExternalFunction["Python", "chemicals.acentric.Stiel_polar_factor"][QuantityMagnitude[UnitConvert[psat,"Pascals"]],QuantityMagnitude[UnitConvert[pc,"Pascals"]],omega];

LeeKeslerOmega[Tb_, Tc_, Pc_] := LoadExternalFunction["Python", "chemicals.acentric.LK_omega"][Tb,Tc,Pc];
LeeKeslerOmega[Tb_Quantity, Tc_Quantity, Pc_Quantity] := LoadExternalFunction["Python", "chemicals.acentric.LK_omega"][QuantityMagnitude[UnitConvert[Tb,"Kelvins"]],QuantityMagnitude[UnitConvert[Tc,"Kelvins"]],QuantityMagnitude[UnitConvert[Pc,"Pascals"]]];

End[];
EndPackage[];