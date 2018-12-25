groupadd -g 500 hpbac
useradd -u 500 -g hpbac hpbac

#groupadd -g 501 oracle
#useradd -u 501 -g oracle oracle
# http://docs.oracle.com/cd/E11882_01/install.112/e41961.pdf
# 1.3.4 Create Groups and Users
groupadd -g 1000 oinstall
groupadd -g 1031 dba
useradd -u 1101 -g oinstall -G dba -s /bin/ksh oracle
mkdir -p /u01/app/11.2.0/grid
mkdir -p /u01/app/oracle
chown -R oracle:oinstall /u01
chmod -R 775 /u01/
echo "Welcome2014" | passwd --stdin oracle

groupadd -g 503 layhua
useradd -u 503 -g layhua layhua
usermod -aG 10 layhua
echo "Welcome2014" | passwd --stdin layhua


groupadd -g 504 wahkiak
useradd -u 504 -g wahkiak wahkiak
usermod -aG 10 wahkiak
echo "Welcome2014" | passwd --stdin layhua

groupadd -g 505 arutptr
useradd -u 505 -g arutptr arutptr
usermod -aG 10 arutptr

groupadd -g 506 linyi
useradd -u 506 -g linyi linyi

groupadd -g 507 kimcheow
useradd -u 507 -g kimcheow kimcheow

groupadd -g 508 yongkiat
useradd -u 508 -g yongkiat yongkiat
echo "Welcome2014" | passwd --stdin yongkiat

