# thanks vim
OPENBR = '{'
CLOSEBR = '}'

def flush():
    global shader_src, shader_buf
    shader_src += [shader_buf]
    shader_buf = ''
    
def S(txt, end='\n', t=0):
    global shader_src, shader_buf, indent_lvl
    if t < 0:
        indent_lvl += t
    tabs = indent_lvl * '\t'
    shader_buf += tabs + ('\n' + tabs).join(txt.split('\n')) + end
    if t > 0:
        indent_lvl += t
    if len(shader_buf) > 1024:
        flush()

def fmt(v, n=3):
    return f'{v:.{n}e}' # enough for fp16

def gen_iter(m):
    n_conv = 1
    for k_ in m:
        suf = 'weight'
        if not k_.endswith(suf):
            continue
        k_ = k_[:-len(suf)]
        name = k_
        pref = '_orig_mod.'
        if name.startswith(pref):
            name = name[len(pref):-1]
        yield (name, k_, n_conv)
        if name.startswith('conv'):
            n_conv += 1

def get_shader():
    flush()
    return shader_src

def init():
    global shader_src, shader_buf, indent_lvl
    shader_src = []
    shader_buf = ''
    indent_lvl = 0
