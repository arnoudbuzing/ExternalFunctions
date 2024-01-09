BirchClusterPredict[x_] := Module[{session},
    session = PythonSessionGet["sklearn", {"scikit-learn"}, "import sklearn"];
    ExternalEvaluate[session,"
from sklearn.cluster import Birch    
birch = Birch(n_clusters=None)
    "];
    Normal @ ExternalFunction[session,"birch.fit_predict"][x]
]

OlivettiFaces[] := Dataset @ LoadExternalFunction["Python", "sklearn.datasets.fetch_olivetti_faces"][]
CaliforniaHousing[] := Dataset @ LoadExternalFunction["Python", "sklearn.datasets.fetch_california_housing"][]
ForestCoverTypes[] := Dataset @ LoadExternalFunction["Python", "sklearn.datasets.fetch_covtype"][]



FashionPersonImageSynthesize[n_Integer] := Module[{session},
  session = PythonSessionGet["torch", {"torch", "matplotlib", "torchvision"}, "import torch"];
  ExternalEvaluate[session, "import matplotlib.pyplot as plt"];
  ExternalEvaluate[session, "import torchvision"];
  ExternalEvaluate[session, "import os"];
  ExternalEvaluate[session, "import contextlib"];
  ExternalEvaluate[session, "use_gpu = True if torch.cuda.is_available() else False"];
  ExternalEvaluate[session, "with open(os.devnull, 'w') as f, contextlib.redirect_stdout(f):
      model = torch.hub.load('facebookresearch/pytorch_GAN_zoo:hub', 'DCGAN', pretrained=True, useGPU=use_gpu)"];
  ExternalEvaluate[session, "noise, _ = model.buildNoiseData(" <> ToString[n] <> ")"];
  ExternalEvaluate[session, "with torch.no_grad(): generated_images = model.test(noise)"];
  ImageRotate[Image[#], -\[Pi]/2] & /@ Normal[Transpose[ExternalEvaluate[session, "generated_images.numpy()"], {1, 4, 3, 2}]]
  ]