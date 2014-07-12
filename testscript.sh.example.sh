export USER_PASS=12345678
export EMAIL=musashi.ph
export OS_USERNAME=admin
export OS_PASSWORD=klnm12
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://mactan-mc:35357/v2.0

# SCENARIO A
for i in `seq 0 500`
do
keystone tenant-create --name=proj"${i}" --description='test'
keystone user-create --name=pa"${i}" --pass="$USER_PASS" --email=qa_musashi+pa"${i}"@"$EMAIL"
keystone user-role-add --user pa"${i}" --tenant proj"${i}" --role project_admin
done

for i in `seq 1 500`
do
keystone user-create --name=pm"${i}" --pass="$USER_PASS" --email=qa_musashi+pm"${i}"@"$EMAIL" --tenant proj0
done

# SCENARIO C
keystone tenant-create --name=proj0c --description='test'
keystone user-create --name=pa0c --pass="$USER_PASS" --email=qa_musashi+pa0c@"$EMAIL"
keystone user-role-add --user pa0c --tenant proj0c --role project_admin

for i in `seq 1 500`
do
keystone user-create --name=pm"${i}"c --pass="$USER_PASS" --email=qa_musashi+pm"${i}"c@"$EMAIL" --tenant proj0c
done

# SCENARIO D
keystone tenant-create --name=proj0d --description='test'
keystone user-create --name=pa0d --pass="$USER_PASS" --email=qa_musashi+pa0d@"$EMAIL"
keystone user-role-add --user pa0d --tenant proj0d --role project_admin
keystone user-create --name=pm1d --pass="$USER_PASS" --email=qa_musashi+pm1d@"$EMAIL" --tenant proj0d