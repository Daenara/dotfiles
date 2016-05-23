" source all settings in .vim/config
for fpath in split(globpath('~/.vim/config', '*.vim'), '\n')
  exe 'source' fpath
endfor
