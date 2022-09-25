#!/usr/bin/python

class FilterModule(object):
    def filters(self):
        return {'text_to_dict': self.unique_base_paths}

    def text_to_dict(self, keys):

        # Sets aren't handled by ansible so convert to list
        return list(base_paths)
