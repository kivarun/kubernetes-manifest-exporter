#!/bin/bash -e 

base_dir=${1:-./}
ns_dir=$base_dir/namespaces

ns_api=$(kubectl api-resources -o name --namespaced=true | grep -v "^bindings$\|replicasets\|events\|metrics\|pods\|localsubjectaccessreviews")
namespaces=$(kubectl get namespaces -o name | sed 's/namespace\// /g')

echo Exporting namespaced resources

for ns in $namespaces; do
    for res in $ns_api; do
       names=$(kubectl get $res -n $ns -o name)
        dst_dir=$ns_dir/$ns/$res
        [ -d $dst_dir ] || mkdir -p $dst_dir

        if [ -n "$names" ]; then
            printf "Dumping $res in $ns \n\n"

            for name in $names; do
                dst_file=$dst_dir/${name#*/}.yaml
                
                kubectl get $name -n $ns -o yaml | kubectl neat > $dst_file
                echo "manifest saved to $dst_file"
            done
        fi
    done
done

find $ns_dir -type d -empty -delete
