#!/usr/bin/env bash

add() {
	echo ""
}

if (( $# < 1 )); then
	echo "error: no function given"
	exit 1
fi

pj_data_dir="${XDG_DATA_HOME:-"${HOME}/.local/share"}/pj"
pj_projects_file="${pj_data_dir}/projects.txt"

if [[ ! -e ${pj_data_dir} ]]; then
	mkdir "${pj_data_dir}"
fi

if [[ ! -e ${pj_projects_file} ]]; then
	touch "${pj_projects_file}"
fi

case "$1" in
	"add")
		add
		;;
	"delete")
		delete
		;;
	"jump")
		jump
		;;
	"list")
		list
		;;
	"rename")
		rename
		;;
	"help")
		help
		;;
esac
