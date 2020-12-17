let g:promptline_preset = {
        \'a' : [ promptline#slices#host( {'only_if_ssh': 1 }) ],
        \'b' : [ promptline#slices#user() ],
        \'c' : [ promptline#slices#cwd() ],
        \'x' : [ promptline#slices#python_virtualenv() ],
        \'y' : [ promptline#slices#vcs_branch() ],
        \'z' : [ promptline#slices#git_status() ],
        \'warn' : [ promptline#slices#last_exit_code(), promptline#slices#battery() ]}
