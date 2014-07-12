export USER_PASS=12345678
export EMAIL=musashi.ph
export OS_USERNAME=admin
export OS_PASSWORD=klnm12
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://mactan-mc:35357/v2.0

for i in `seq 0 10`
do
keystone tenant-create --name=proj"${i}" --description='test'
keystone user-create --name=pa"${i}" --pass="$USER_PASS" --email=qa_musashi+pa"${i}"@"$EMAIL" --tenant proj"${i}"
keystone user-role-add --user pa"${i}" --tenant proj"${i}" --role project_admin
keystone user-role-remove --user pa"${i}" --tenant proj"${i}" --role _member_
done

for i in `seq 1 10`
do
keystone user-create --name=pm"${i}" --pass="$USER_PASS" --email=qa_musashi+pm"${i}"@"$EMAIL" --tenant proj0
done
