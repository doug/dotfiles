# function __fish__complete_argparse_subcommnad -d 'Complete argparse subcommands' --argument-names cmd,subcommand
#
# end
#
# function __fish__complete_argparse -d 'Complete argparse commands' --argument-names cmd
#   $cmd --help | pipeset argparse
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -s a -d 'force rebuild'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -s n -d 'print the commands but do not run them'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -s p -r -d 'number parallel builds (default=#cpus)'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o race -d 'enable data race detection'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -s v -d 'print packages being built'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o work -d 'print and preserve work directory'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -s x -d 'print the commands'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o ccflags -r -d 'c compiler flags'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o compiler -r -d 'name of compiler to use, as in runtime.Compiler (gccgo or gc)'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o gccgoflags -r -d 'gccgo compiler/linker flags'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o gcflags -r -d 'go compiler flags'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o installsuffix -r -d 'suffix for installation directory'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o ldflags -r -d 'linker flags'
#         complete -c go -n "__fish_seen_subcommand_from $cmd" -o tags -r -d 'build tags '
# end
#
# # gcloud
# complete -c go -n '__fish_use_subcommand' -a build -d 'compile packages and dependencies'
# __fish__go_buildflags_completions build
# __fish_complete_go_files build
