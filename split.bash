#! /bin/bash

function test(){
    ESCAPED_COMMAND=$(printf "%q " "${@}")


    cat <<EOF
    {
        IFS= read -r -d '' STDOUT
        IFS= read -r -d '' STATUS
        IFS= read -r -d '' STDERR
    } < <( { { $ESCAPED_COMMAND ; } ; printf "\0%d\0" "\$?" ; } > >(cat -) 2> >(cat -) )
EOF
}


#perl -e '$n="";die$!if-1==syscall(279,$n,1);print`ls -l /proc/$$/fd`'

#exec 3<<<'#!/bin/bash
#echo "Hello from Bash via FD with no disk I/O!"
#'


function extract_wrap(){
    coproc stderr_holder { cat - ; }

    function extract(){
        coproc stdout_holder { cat - ; }
        { ( for i in {1..20}; do printf 'stdout\n' && printf; done && printf ) ; } 1> >( cat - >&"${stdout_holder[1]}") 2>&"${stderr_holder[1]}" 

        exec {stdout_holder[1]}>&-
        exec {stderr_holder[1]}>&-

        echo "---- out ----"
        cat <&"${stdout_holder[0]}"
        echo "-------------"

        echo "---- err ----"
        cat <&"${stderr_holder[0]}"
        echo "-------------"
    }

    extract

}

extract_wrap
#echo 'echo geeksforgeeks' >&"${gfg[1]}"
#coproc stdout_holder { cat - ; }

#coproc stderr_holder { cat - ; }

#coproc exit_code_holder { cat - ; }

#printf 'echo "This is written via FD 3" ' >&3

#{ ( for i in {1..10}; do printf "something\n" ; done ; ) ; } 1>&"${stdout_holder[1]}"

#exec {stdout_holder[1]}>&-
#cat <&${stdout_holder[0]}


# fd 0 => status code
# fd 1 => stdout
# fd 2 => stderr

