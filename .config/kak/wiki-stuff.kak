# custom autocomplete for wiki links
#
#
# copying the structure from jedi python completion
declare-option -hidden str wiki_link_tmp_dir
declare-option -hidden completions wiki_link_completions

# populate the `wiki_link_completions` option with files valid for linking-to
define-command wiki-link-autocomplete -docstring "Complete the current selection" %{
    echo -debug running the link completer now
    evaluate-commands %sh{
        printf %s\\n "echo -debug client is ${kak_client} "
    }
    evaluate-commands %sh{
        dir=$(mktemp -d "${TMPDIR:-/tmp}"/kak-wiki-link.XXXXXXXX)
        mkfifo ${dir}/fifo
        printf %s\\n "set-option buffer wiki_link_tmp_dir ${dir}"
        printf %s\\n "evaluate-commands -no-hooks write -sync ${dir}/buf"
    }
    evaluate-commands %sh{
        dir=${kak_opt_wiki_link_tmp_dir}
        printf %s\\n "evaluate-commands -draft %{ edit! -fifo ${dir}/fifo *wiki-link-autocomplete-output* }"
        ((
            cd $(dirname ${kak_buffile})
            header="${kak_cursor_line}.${kak_cursor_column}@${kak_timestamp}"
            compl=$(${kak_config}/bin/kakoune-wiki-link-find.sh $HOME/kak-wiki)
            printf %s\\n "evaluate-commands -client ${kak_client} %~echo completed; set-option %{buffer=${kak_buffile}} wiki_link_completions ${header} ${compl}~" | kak -p ${kak_session}
            rm -r ${dir}
        ) & ) > /dev/null 2>&1 < /dev/null
    }
    echo -debug done running the link completer
}

define-command wiki-link-enable-autocomplete -docstring "Add wiki-link completion candidates to the completer" %{
    echo -debug wiki-link-stuff-enabled
    set-option window completers option=wiki_link_completions %opt{completers}
    hook window -group wiki-link-autocomplete InsertIdle .* %{ try %{
        execute-keys -draft <a-h><a-k>\B@.\z<ret>
        echo 'wiki link completing...'
        wiki-link-autocomplete
    } }
    alias window complete wiki-link-autocomplete
}

define-command wiki-link-disable-autocomplete -docstring "Disable wiki-link completion" %{
    echo -debug wiki-link-stuff-disabled
    set-option window completers %sh{ printf %s\\n "'${kak_opt_completers}'" | sed -e 's/option=wiki_link_completions://g' }
    remove-hooks window wiki-link-autocomplete
    unalias window complete wiki-link-autocomplete
}

# add hooks for the above
evaluate-commands %sh{
    printf %s\\n "
    hook global WinCreate $HOME/kak-wiki/.+\.md %{
        change-directory $HOME/kak-wiki
        wiki-link-enable-autocomplete
    }
    "
}

# try disabling autocomplete in insert just for wikis
evaluate-commands %sh{
    printf %s\\n "
    hook global WinCreate $HOME/kak-wiki/.+\.md %{
        set global autocomplete prompt
    }
    "
}
define-command wiki-today -docstring "Open a file with today's date via kakoune-wiki" %{
    evaluate-commands %sh{
        # date fn on macos. might break on linux
        printf %s\\n "wiki $(date +%Y-%m-%d).md"
    }
}

define-command wiki-backlinks -docstring "search for all wiki pages that link to the currently open one" %{
    evaluate-commands %sh{
        printf "grep \]\(%s\)" $(basename ${kak_buffile})
    }
}

