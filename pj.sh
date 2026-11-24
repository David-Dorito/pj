#!/usr/bin/env bash

add() {
	projects=$(awk -v proj_name=$1 -F ',' ' $1 == proj_name { print $1 }' ${pj_projects_file})

	if [[ ! -z ${projects} ]]; then
		echo "project already exists"
		return 1
	fi

	echo "$1,${2:-$(pwd)}" 1>> ${pj_projects_file}

	return 0
}

delete() {
	project=$(awk -v proj_name=$1 -F ',' ' $1 == proj_name { print $1 }' ${pj_projects_file})

	sed -i "/${project}/d" ${pj_projects_file}
}

jump() {
	path=$(awk -v proj_name=$1 -F ',' ' $1 == proj_name { print $2 }' ${pj_projects_file})

	if [[ -z ${path} ]]; then
		echo "project doesn't exist"
		return 1
	fi

	cd ${path}
}

list() {
	awk -v proj_name=$1 -F ',' '{ print $1 ": " $2 }' ${pj_projects_file}
}

rename() {
	echo ""
}

help() {
	echo "pj - project jump"
	echo "usage: source pj <function> <function args>"
	echo "available functions:"
	echo "1. jump <project name>"
	echo "2. add <project name> <path>"
	echo "3. delete <project name>"
	echo "4. list"
	echo "5. rename <project name> <new project name>"
	echo "6. help"
}

if (( $# < 1 )); then
	echo "error: no function given"
	return 1
fi

pj_data_dir="${XDG_DATA_HOME:-"${HOME}/.local/share"}/pj"
pj_projects_file="${pj_data_dir}/projects.csv"

if [[ ! -e ${pj_data_dir} ]]; then
	mkdir "${pj_data_dir}"
fi

if [[ ! -e ${pj_projects_file} ]]; then
	touch "${pj_projects_file}"
fi

case "$1" in
	"add")
		if (( $# != 2 && $# != 3 )); then
			echo "error: add expects 1 or 2 arguments"
			return 1
		fi
		add $2 $3
		;;
	"delete")
		if (( $# != 2 )); then
			echo "error: delete expects 1 argument"
			return 1
		fi
		delete $2
		;;
	"jump")
		if (( $# != 2 )); then
			echo "error: jump expects 1 argument"
			return 1
		fi
		jump $2
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
