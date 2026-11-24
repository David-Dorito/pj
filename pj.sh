#!/usr/bin/env bash

add() {
	projects=$(awk -v proj_name=$1 -F ',' ' $1 == proj_name { print $1 }' ${pj_projects_file})

	if [[ ! -z ${projects} ]]; then
		echo "project already exists"
		return 1
	fi

	echo "$1,${2:-$(pwd)}" 1>> ${pj_projects_file}
}

delete() {
	project=$(awk -v proj_name=$1 -F ',' ' $1 == proj_name { print $1 }' ${pj_projects_file})

	if [[ -z ${project} ]]; then
		echo "project doesn't exist"
		return 1
	fi

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
	project=$(awk -v proj_name=$1 -F ',' ' $1 == proj_name { print $1 }' ${pj_projects_file})

	if [[ -z ${project} ]]; then
		echo "project doesn't exist"
		return 1
	fi

	sed -i "s/${project}/$2/" ${pj_projects_file}
}

help() {
	echo "pj - project jump"
	echo "usage: source pj <function> <function args>"
	echo "available functions:"
	echo "1. cd <project name>: jump into project"
	echo "2. touch <project name> <path, default current dir>: add project to registry"
	echo "3. rm <project name>: remove project from registry"
	echo "4. ls: list projects in registry"
	echo "5. mv <project name> <new project name>: rename a project in the registry"
	echo "6. help: i wonder what this could be"
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
	"touch")
		if (( $# != 2 && $# != 3 )); then
			echo "error: touch expects 1 or 2 arguments"
			return 1
		fi
		add $2 $3
		;;
	"rm")
		if (( $# != 2 )); then
			echo "error: rm expects 1 argument"
			return 1
		fi
		delete $2
		;;
	"cd")
		if (( $# != 2 )); then
			echo "error: cd expects 1 argument"
			return 1
		fi
		jump $2
		;;
	"ls")
		if (( $# != 1 )); then
			echo "error: ls doesn't expect any arguments"
			return 1
		fi
		list
		;;
	"mv")
		if (( $# != 3 )); then
			echo "error: mv expects 2 arguments"
			return 1
		fi
		rename $2 $3
		;;
	"help")
		if (( $# != 1 )); then
			echo "hint: help doesn't expect any arguments"
		fi
		help
		;;
esac
