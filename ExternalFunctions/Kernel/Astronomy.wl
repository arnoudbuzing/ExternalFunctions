KeplerLightCurve[obj_String] := Module[{session, result},
    session = PythonSessionGet["lightkurve", {"lightkurve"}, "import lightkurve"];
    result = ExternalEvaluate[session, "
result = lightkurve.search_lightcurve('" <> obj <> "')
curves = result.download_all()
map( lambda x: [x.time.value,x.flux.value], curves )

# stitch = curves.stitch()
# [ stitch.time.value , stitch.flux.value ]
"
    ];
    Map[ TimeSeries[Transpose[Normal[#]]]&, result]
]
    