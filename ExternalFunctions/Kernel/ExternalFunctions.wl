ClearAll["ArnoudBuzing`ExternalFunctions`*"];

BeginPackage["ArnoudBuzing`ExternalFunctions`"];

LoadExternalFunction;
PythonSessionGet;

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
KeplerLightCurve;


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

(* Load external functions *)
Get[ FileNameJoin[{DirectoryName[$InputFileName], "Mathematics.wl"}]];
Get[ FileNameJoin[{DirectoryName[$InputFileName], "Chemistry.wl"}]];
Get[ FileNameJoin[{DirectoryName[$InputFileName], "Astronomy.wl"}]];

End[];
EndPackage[];