def Settings(**kwargs):
    if kwargs['language'] == 'rust':
        return {
            'ls': {
                'rust-analyzer': {
                    'cargo': {
                        'allFeatures': False,
                        'loadOutDirsFromCheck': False
                    },
                    'checkOnSave': {
                        'allTargets': False
                    },
                    'procMacro': {
                        'enable': False 
                    },
                    'diagnostics': {
                        'disabled': ['unresolved-proc-macro']
                    },
                }
            }
        }

