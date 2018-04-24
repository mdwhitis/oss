$!/bin/bash
a cron script that queries IAM every few minutes, and syncs users and public keys.
# Has a number of requirements including ansible.
# Version 0.2 on 4/24/2018 by Michael Whitis mdwhitis@gmail.com

AWSPublickey=[Your Key Here]
rm no-key.log
aws iam get-group --group-name authorized-ssh-users  | grep UserName | cut -d\" -f4 |
while IFS= read -r username
do
aws  iam get-ssh-public-key --ssh-public-key-id "$AWSPublickey" --user-name "$username" --encoding SSH
if [ $? -ne 0 ]
then echo "$username no SSH iam key">> no-key.log
else echo "     - $username">> iam_add.yml
ansible-playbook iam_add.yml
cat iam_add.yml | head -n -1 > new_file
mv new_file iam_add.yml
fi

done
