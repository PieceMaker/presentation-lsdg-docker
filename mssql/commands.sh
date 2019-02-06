docker volume create mssql_data

# Run MSSQL 2017 CU 10
sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=MyAwS0M3P4SsW0Rd!' -p 1433:1433 --mount source=mssql_data,target=/var/opt/mssql -v /Users/jadams/GitLab/docker-presentation/mssql/backup:/var/opt/backup --name mssql --rm -d mcr.microsoft.com/mssql/server:2017-CU10-ubuntu

# Upgrade to CU 12
sudo docker run -p 1433:1433 --mount source=mssql_data,target=/var/opt/mssql -v /Users/jadams/GitLab/docker-presentation/mssql/backup:/var/opt/backup --name mssql --rm -d mcr.microsoft.com/mssql/server:2017-CU12-ubuntu

# Bad things happened! Can we ever go back!?!
sudo docker run -p 1433:1433 --mount source=mssql_data,target=/var/opt/mssql -v /Users/jadams/GitLab/docker-presentation/mssql/backup:/var/opt/backup --name mssql --rm -d mcr.microsoft.com/mssql/server:2017-CU10-ubuntu

# Hmm, 2019 looks cool but I don't want to spend an entire day rebuilding the box, patching, installing, and restoring!!!!!
sudo docker run -p 1433:1433 --mount source=mssql_data,target=/var/opt/mssql -v /Users/jadams/GitLab/docker-presentation/mssql/backup:/var/opt/backup --name mssql --rm -d mcr.microsoft.com/mssql/server:2019-CTP2.0-ubuntu

# Oh noes! 2019 has much worse performance than 2017! MUST GO BACK!
sudo docker run -p 1433:1433 --mount source=mssql_data,target=/var/opt/mssql -v /Users/jadams/GitLab/docker-presentation/mssql/backup:/var/opt/backup --name mssql --rm -d mcr.microsoft.com/mssql/server:2017-CU10-ubuntu

# *cries in developer*

# Show LVM snapshotting in Linux

# Discuss availability groups and Kubernetes

# Download AdventureWorks database backup onto Ubuntu box
mkdir backup
cd backup
wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak

# Run instance using new loopback
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=MyAwS0M3P4SsW0Rd!' -p 1433:1433 -v /mnt/mssql_data:/var/opt/mssql -v /home/ubuntu/backup:/var/opt/backup --name mssql --rm mcr.microsoft.com/mssql/server:latest

# After restoring, turn off and create snapshot
sudo lvcreate -s --name thin_volume_1_snapshot docker/thin_volume_1

# And when ready to revert
sudo umount /mnt/mssql_data
sudo lvconvert --merge docker/thin_volume_1_snapshot
sudo mount /dev/docker/thin_volume_1 /mnt/mssql_data