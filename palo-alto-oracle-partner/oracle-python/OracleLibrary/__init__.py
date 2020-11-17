from .oracle import Oracle

class OracleLibrary(Oracle):
    def __init__(self):
        for base in OracleLibrary.__bases__:
            base.__init__(self)