#!/bin/bash -e

base_dir=${1:-./}
cluster_dir=$base_dir/cluster

non_ns_api=$(kubectl api-resources -o name --namespaced=false | grep -v "tokenreviews\|selfsubjectaccessreviews\|selfsubjectrulesreviews\|subjectaccessreviews")


[ -d $cluster_dir ] || mkdir -p $cluster_dir

echo Exporting cluster resources

for res in $non_ns_api; do
    names=$(kubectl get $res -o name )
    dst_dir=$cluster_dir/$res
    [ -d $dst_dir ] || mkdir -p $dst_dir

    if [ -n "$names" ]; then
        echo "Drumping $res"

        for name in $names; do
            dst_file=$dst_dir/${name#*/}.yaml

            kubectl get $name -o yaml | kubectl neat > $dst_file

            echo "manifest saved to $dst_file"
        done
    fi
done



