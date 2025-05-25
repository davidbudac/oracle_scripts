if [ $# -eq 0 ]; then
  echo "Usage: copy_sshkey <host_inventory_name> <sshport>"
  exit
fi

ansible-playbook setup_new_host.yml -e "inventory_file=inventory.ini" \
  -e "new_host_alias=$1" \
  -e "new_hostname=localhost" \
  -e "ssh_port=$2" \
  -e "remote_user=oracle" \
  -e "local_ssh_key_path=/home/db/.ssh/id_rsa.pub"
