#!/bin/bash -e 
logfile=${2:-/tmp/stashtog.log}
self_dir=$(dirname $0)
ns_bak=$self_dir/namespacedbackup.sh
nonns_bak=$self_dir/nonnamespacebackup.sh
timestamp=$(date +%m-%d_%H:%M)
message="Stashed by $0 $@"
repo_dir=$1

err(){
	echo -e $1
	exit 1
}

[ -z $repo_dir ] && err "Git repodir doesn't defined, please run:\n $0 <repodir>"

[ -d $repo_dir ] && rm -rf $repo_dir/*

$ns_bak $repo_dir > $logfile
$nonns_bak $repo_dir >$logfile

cd $repo_dir

git add . 
git commit -am "$message"
git push 

