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