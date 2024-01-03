KeplerLightCurve[obj_String] := Module[{session},
    session = PythonSessionGet["lightkurve", {"lightkurve"}, "import lightkurve"];
    ExternalFunction[session, "lambda obj: lightkurve.search_targetpixelfile(obj).download().to_lightcurve().to_pandas()"][obj]
]