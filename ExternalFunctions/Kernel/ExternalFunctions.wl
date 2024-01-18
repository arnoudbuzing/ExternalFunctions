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
KeplerLightCurves;
Degrees;
Radians;
UnicodeName;
UnicodeLookup;
TextWrap;
KhatriRaoProduct;
KroghInterpolation;
NewtonCotes;
BirchClusterPredict;
OlivettiFaces;
CaliforniaHousing;
ForestCoverTypes;
FashionPersonImageSynthesize;
CelebrityFaceImageSynthesize;
GeometricStandardDeviation;
EppsSingletonTestStatistic;


Begin["`Private`"];

PythonSessionGet[id_String, deps_List, prolog_String : ""] := SelectFirst[
  ExternalSessions[],
  #["ID"] === id &,
  StartExternalSession[{
    {"Python","StandardErrorFunction"->Null},
    "ID" -> id,
    "Evaluator" -> <|
      "Dependencies" -> Complement[deps,{"math","unicodedata","textwrap"}] /. { "sklearn" -> "scikit-learn" },
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
Get[ FileNameJoin[{DirectoryName[$InputFileName], "TextProcessing.wl"}]];
Get[ FileNameJoin[{DirectoryName[$InputFileName], "MachineLearning.wl"}]];

End[];
EndPackage[];