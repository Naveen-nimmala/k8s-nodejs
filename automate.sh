# #/bin/bash
#Deleting failed pods before creating
#We can use same command for Evicted Pending too when it required
kubectl get po --all-namespaces --field-selector 'status.phase==Failed' -o json | kubectl delete -f - >/dev/null

# hard coded all the names since we dont change the app and label names apart from versions
# Still if we want dynamic we can use Varibles

APPS_ALL="database database-service nodejsapp nodejs-service redis redis-service"
YAML_FILES="mysql mysql-service nodejs redis nodejs-service"

#Used case, to add or delete dynamically
INPUT_STRING=${1}
case $INPUT_STRING in
    apply |  -a )
        for object in $YAML_FILES
        do
           kubectl apply -f ${object}.yml
           if [[ ${?} != 0 ]];then
             echo "${object} creation failed"
           fi
        done
        ;;
    delete | -d )
        for object in $APPS_ALL
        do
            kubectl delete deploy ${object} 2>/dev/null
            if [[ ${?} != 0 ]]
            then
                kubectl delete pod ${object} 2>/dev/null
                if [[ ${?} != 0 ]]
                then
                    kubectl delete svc ${object} 2>/dev/null
                fi
            fi
        done
        ;;
    *)
        echo "Pass vaild Args"
        ;;
  esac

# creating or applying objects on kube

# for object in mysql mysql-service nodejs redis nodejs-service
# do
#    kubectl apply -f ${object}.yml
#    if [[ ${?} != 0 ]];then
#      echo "${object} creation failed"
#    fi
# done

# Deleting objects



