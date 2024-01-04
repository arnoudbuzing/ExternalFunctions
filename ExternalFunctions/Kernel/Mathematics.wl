(* Angular conversion *)

Degrees[radians_] := LoadExternalFunction["Python","math.degrees"][N[radians]];
Radians[degrees_] := LoadExternalFunction["Python","math.radians"][N[degrees]];

(* Fourier Transforms *)
FastFourierTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.fft"][args];
InverseFastFourierTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.ifft"][args];
DiscreteCosineTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.dct"][args];
InverseDiscreteCosineTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.idct"][args];
DiscreteSineTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.dst"][args];
InverseDiscreteSineTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.idst"][args];

KhatriRaoProduct[a_,b_] := Normal @ LoadExternalFunction["Python","scipy.linalg.khatri_rao"][a,b];

KroghInterpolation[x_,y_,xe_] := Normal @ LoadExternalFunction["Python", "scipy.interpolate.krogh_interpolate"][x,y,xe];

NewtonCotes[order_] := Module[{w,e},
    {w,e} = LoadExternalFunction["Python", "scipy.integrate.newton_cotes"][order];
    <| "Weights" -> Normal[w], "ErrorCoefficient" -> e |>
    ]