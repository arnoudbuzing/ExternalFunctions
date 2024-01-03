(* Fourier Transforms *)
FastFourierTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.fft"][args];
InverseFastFourierTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.ifft"][args];
DiscreteCosineTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.dct"][args];
InverseDiscreteCosineTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.idct"][args];
DiscreteSineTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.dst"][args];
InverseDiscreteSineTransform[args___] := Normal @ LoadExternalFunction["Python", "scipy.fft.idst"][args];