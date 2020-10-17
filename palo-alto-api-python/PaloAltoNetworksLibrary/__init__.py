from .paloalto import PaloAlto


class PaloAltoNetworksLibrary(PaloAlto):
    def __init__(self):
        for base in PaloAltoNetworksLibrary.__bases__:
            base.__init__(self)
