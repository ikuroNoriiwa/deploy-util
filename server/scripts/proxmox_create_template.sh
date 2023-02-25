#!/bin/bash

help()
{
    echo "Usage: $0 [ -u | --url ]
               [ -m | --memory ]
               [ -n | --name  ]
               [ -c | --core  ]
               [ -s | --storage  ]
               [ -d | --description  ]
               [ -h | --help  ]"
    exit 2
}

SHORT=u:,m:,n:,c:,s:,d:,h
LONG=url:,memory:,name:,core:,storage:,description:,help
OPTS=$(getopt -a -n $0 --options $SHORT --longoptions $LONG -- "$@")

if [ "$#" -eq 0 ]; then
  help
fi

eval set -- "$OPTS"


while :
do
  case "$1" in
  -u | --url)
      url="$2"
      shift 2
      ;;
  -m | --memory)
      memory="$2"
      shift 2
      ;;
  -n | --name)
      name="$2"
      shift 2
      ;;
  -c | --core)
      core="$2"
      shift 2
      ;;
  -s | --storage)
      storage="$2"
      shift 2
      ;;
  -d | --description)
      description="$2"
      shift 2
      ;;
  -h | --help)
      help
      ;;
  --)
      shift;
      break
      ;;
  *)
      echo "Unexpected option: $1"
      help
      ;;
  esac
done

short_link=$(echo $url | grep -o '[^/]*$')

if [ -z "$memory" ]
then
  memory=1024
fi

if [ -z "$core" ]
then
  core=1
fi

if [ -z "$storage" ]
then
  storage="data"
fi

if [ -z "$name" ]
then

  name="$(echo "$short_link" | cut -d'.' -f1)-template"
fi


if [ `id -u` -ne 0 ]
  then echo "Run this script as root"
  exit
fi

max_qm_id=$(($(sudo qm list | awk '{print $1}' | sort -nr | head -n1) + 1))
echo $max_qm_id

echo " template id : $max_qm_id"
echo " URL : $url"
echo " memory : $memory"
echo " name : $name"
echo " core : $core"
echo " storage : $storage"
echo " description : $description"

curl -o /var/lib/vz/template/iso/$short_link $url -L

qm create $max_qm_id --memory $memory --core $core --name $name --net0 virtio,bridge=vmbr1 --description "$description"
qm importdisk $max_qm_id /var/lib/vz/template/iso/$short_link $storage
qm set $max_qm_id --scsihw virtio-scsi-pci --scsi0 "$storage:$max_qm_id/vm-$max_qm_id-disk-0.raw"
qm set $max_qm_id --boot c --bootdisk scsi0
qm set $max_qm_id --ide2 "$storage:cloudinit"
qm set $max_qm_id --serial0 socket --vga serial0
qm template $max_qm_id