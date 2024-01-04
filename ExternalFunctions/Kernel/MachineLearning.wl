BirchClusterPredict[x_] := Module[{session},
    session = PythonSessionGet["sklearn", {"scikit-learn"}, "import sklearn"];
    ExternalEvaluate[session,"
from sklearn.cluster import Birch    
birch = Birch(n_clusters=None)
    "];
    Normal @ ExternalFunction[session,"birch.fit_predict"][x]
]