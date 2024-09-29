import argparse
import pickle
import importlib
import sys
from pathlib import Path
from types import SimpleNamespace
from common import *

def load_or_reload(name):
    if name in sys.modules:
        return importlib.reload(sys.modules[name])
    return importlib.import_module(name)

def run(model, impl, extra, name=None):
    stem = Path(model).stem
    with open(model, 'rb') as f:
        m = pickle.load(f)
    args = SimpleNamespace(**{
        'rgb': m['rgb'],
        'quant': m['quant'],
        'quant_8': m['quant-8'],
        'size': m.get('size', 0),
        'stem': name if name else stem,
        'name': name if name else stem[:stem.rfind('-')],
        'extra': extra
    })
    init()
    return load_or_reload(impl).main(m, args, False)

def help(impl):
    return load_or_reload(impl).main(None, None, True)

if not sys.platform == 'emscripten':
    parser = argparse.ArgumentParser()
    parser.add_argument('impl', type=str)
    parser.add_argument('-m', '--model', action='append', type=str, required=True)
    args, extra = parser.parse_known_args()
    extra = []
    for model in args.model:
        fp, shader = run(model, args.impl, extra)
        with open(f'test/{fp}', 'w') as f:
            f.write(shader)
