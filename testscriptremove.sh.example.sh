export USER_PASS=12345678
export EMAIL=musashi.ph
export OS_USERNAME=admin
export OS_PASSWORD=klnm12
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://mactan-mc:35357/v2.0

# SCENARIO A
for i in `seq 0 500`
do
keystone tenant-delete proj"${i}"
keystone user-delete pa"${i}"
done

for i in `seq 1 500`
do
keystone user-delete pm"${i}"
done

# SCENARIO C
keystone tenant-delete proj0c
keystone user-delete pa0c

for i in `seq 1 500`
do
keystone user-delete pm"${i}"c
done

# SCENARIO D
keystone tenant-delete proj0d
keystone user-delete pa0d
keystone user-delete pm1d