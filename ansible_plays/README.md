# jenkins_proj/ansible_plays
This repo provides an anisble role to support installation activities of Jenkins and provides a playbook to invoke the role.

It automates Jenkins installation as below to support
- install jenkins
- upgrade jenkins when stable upgrade available
- patch jenkins as needed
- backup jenkins repo and files before applying an upgrade/patch

The following variables are defaulted, and can be updated into the playbook to change them:

    jenkins_repo_download_dir: /var/jenkins_bkups/repo/
    jenkins_repo_name: jenkins.repo

    jenkins_repo_install_dir: /etc/yum.repos.d/
    jenkins_bkups_archive_dir: /var/jenkins_bkups/file_archives/
    jenkins_bkups_tar_name: jenkins_files_archive.tar

    jenkins_files_dir:  /var/lib/jenkins/

    jenkins_war_dir: /usr/share/java/
    jenkins_war_filename: jenkins.war

    jenkins_stable_repo_url: https://pkg.jenkins.io/redhat-stable/jenkins.repo
    jenkins_stable_key_url: https://pkg.jenkins.io/redhat-stable/jenkins.io.key

    jenkins_pacth_repo_url: https://pkg.jenkins.io/redhat/jenkins.repo
    jenkins_patch_key_url: https://pkg.jenkins.io/redhat/jenkins.io.key

    patch_jenkins: false


| var name |  Default Value  | Required | Description | Comments |
|:--------:|:---------------:|:-----------------:|:-----------:|:--------:|
| jenkins_repo_download_dir |  /var/jenkins_bkups/repo/ |  No  | This is the directory where the jenkins repo is downloaded into  |In order to do a reinstall, the jenkins repo file from this directory can be removed and run the play book again  |
| jenkins_repo_name |  jenkins.repo  |  No |  Name of the jenkins repo file    |          |
| jenkins_repo_install_dir |  /etc/yum.repos.d/  |  No  |   Name of the jenkins repo install dir by yum  | This the path where the jenkins repo file will be replaced after downloading into jenkins_repo_download_dir   |
| jenkins_bkups_archive_dir |  /var/jenkins_bkups/file_archives/  |  No |  Name of the jenkins backup archive directory    |  This the path where the jenkins backup files will be archived under a timestamped directory  |
| jenkins_bkups_tar_name |  jenkins_files_archive.tar  |  No |  Name of the tar file for the archive    |    |
| jenkins_files_dir |  /var/lib/jenkins/  |  No |  Name of the jenkins files directory    |  This the directory where jenkins creates and stores it files. This is used during archiving |
| jenkins_war_dir |  /usr/share/java/  |  No |  Name of the jenkins war file directory    |  This the directory where jenkins has its jenkins.war file. This is used during archiving |
| jenkins_war_filename |  jenkins.war  |  No |  Name of the jenkins war file    |   This is used during archiving |
| jenkins_stable_repo_url |  https://pkg.jenkins.io/redhat-stable/jenkins.repo  |  No |  URL of the jenkins stable repo   |   This is the url from where the stable repo is downloaded |
| jenkins_stable_key_url | https://pkg.jenkins.io/redhat-stable/jenkins.io.key  |  No |  URL of the jenkins stable repo key  |   This is the url from where the stable repo key is downloaded |
| jenkins_pacth_repo_url |  https://pkg.jenkins.io/redhat/jenkins.repo  |  No |  URL of the jenkins patches repo   |   This is the url from where the patches repo is downloaded. This is used when patch_jenkins is set to true |
| jenkins_patch_key_url |  https://pkg.jenkins.io/redhat/jenkins.io.key  |  No |  URL of the jenkins patches repo key    |   This is the url from where the patches repo key is downloaded. This is used when patch_jenkins is set to true |
| patch_jenkins |  false |  No |  A flag to indicate if to patch or not    |          |
| install_current_repo |  false |  No |  A flag to indicate if to install from the repo present in the backup dir without downloading    | This can be used when to rollback where the required repo file can be placed in the download dir and run the playbook to install without downlaoding a new one    |
| firewall_enable_rules_list |  [] |  No |  List of rich rules to be enabled    |   This list can be populated to enable any rich rules on firewalld      |
| firewall_disable_rules_list |  [] |  No |  List of rich rules to be disabled    |   This list can be populated to disable any rich rules on firewalld      |


## Sample Run and Output

Playbook:

```
- name: Insall Jenkins calling jenkins role
  hosts: jenkins_hosts
  become: true
  remote_user: ec2-user
  become_user: root
  gather_facts: yes

  vars:
     patch_jenkins: false
     install_current_repo: false

  roles:
        - role: jenkins_role
```

Output:

```
[ec2-user@ip-172-31-29-125 ansible_plays]$ ansible-playbook -i inventory.txt jenkins-pbk.yml

PLAY [Insall Jenkins calling jenkins role] 

TASK [Gathering Facts] 
ok: [server1]

TASK [jenkins_role : <main> Set stable repo url] 
ok: [server1]

TASK [jenkins_role : <main> Set pacth repo url] 
skipping: [server1]

TASK [jenkins_role : <main> Init Dirs] 
included: /home/ec2-user/ansible_plays/roles/jenkins_role/tasks/initialize-dirs.yml for server1

TASK [jenkins_role : <initialize-dirs> Print dir names] 
ok: [server1] => (item=jenkins_repo_download_dir) => {
    "ansible_loop_var": "item",
    "item": "jenkins_repo_download_dir",
    "jenkins_repo_download_dir": "/var/jenkins_bkups/repo/"
}
ok: [server1] => (item=jenkins_bkups_archive_dir) => {
    "ansible_loop_var": "item",
    "item": "jenkins_bkups_archive_dir",
    "jenkins_bkups_archive_dir": "/var/jenkins_bkups/file_archives/"
}

TASK [jenkins_role : <initialize-dirs> Create init dirs if doesnt exist] 
ok: [server1] => (item=/var/jenkins_bkups/repo/)
ok: [server1] => (item=/var/jenkins_bkups/file_archives/)

TASK [jenkins_role : <main> Download and import repo key file] 
ok: [server1]

TASK [jenkins_role : <main> Download repo file to bkup dir] 
changed: [server1]

TASK [jenkins_role : <main> backup and update the repo with new one downloaded] 
included: /home/ec2-user/ansible_plays/roles/jenkins_role/tasks/backup-update-repo.yml for server1

TASK [jenkins_role : <backup-update-repo> Check if the repo file already exists in yum install dir] 
ok: [server1]

TASK [jenkins_role : <backup-update-repo> Create backup archive timestamp dir] 
changed: [server1]

TASK [jenkins_role : <backup-update-repo> backup if the file exists with a timestamp as example 20230224T091933-bkup-jenkins.repo] 
changed: [server1]

TASK [jenkins_role : <backup-update-repo> Replace the donloaded file to repo dir] 
ok: [server1]

TASK [jenkins_role : <main> Install/Upgrade Jenkins] 
included: /home/ec2-user/ansible_plays/roles/jenkins_role/tasks/install-start-jenkins.yml for server1

TASK [jenkins_role : <install-start-jenkins> update yum] 
ok: [server1]

TASK [jenkins_role : <install-start-jenkins> Install java] 
ok: [server1]

TASK [jenkins_role : <install-start-jenkins> Stop jenkins] 
changed: [server1]

TASK [jenkins_role : <install-start-jenkins> Perform backups of Jenkins dir] 
included: /home/ec2-user/ansible_plays/roles/jenkins_role/tasks/perform-backups.yml for server1

TASK [jenkins_role : <perform-backups> Check if the jenkins files dir exists] 
ok: [server1]

TASK [jenkins_role : <perform-backups> Check if the jenkins war file exists] 
ok: [server1]

TASK [jenkins_role : <perform-backups> Create backup archive timestamp dir] 
ok: [server1]

TASK [jenkins_role : <perform-backups> Generate jenkins files archive] 
changed: [server1]

TASK [jenkins_role : <perform-backups> Generate Jenkins war gz file] 
changed: [server1]

TASK [jenkins_role : <install-start-jenkins> Install jenkins] 
ok: [server1]

TASK [jenkins_role : <install-start-jenkins> perform daemon-reload] 
ok: [server1]

TASK [jenkins_role : <install-start-jenkins> Start jenkins] 
changed: [server1]

TASK [jenkins_role : <install-start-jenkins> Enable to start on reboot] 
ok: [server1]

TASK [jenkins_role : Flush handlers] 

TASK [jenkins_role : <main> Enabler/Disable firewall rules] 
included: /home/ec2-user/ansible_plays/roles/jenkins_role/tasks/handle-firewall-rules.yml for server1

TASK [jenkins_role : <handle-firewall-rules> Enable firewalld] 
ok: [server1]

TASK [jenkins_role : <handle-firewall-rules> Enable firewalld rich rules] 
ok: [server1] => (item=rule port port=8080 protocol=tcp limit value=300/m accept)

TASK [jenkins_role : <handle-firewall-rules> Disable firewalld rich rules] 
ok: [server1] => (item=rule port port=8080 protocol=tcp limit value=200/m accept)

TASK [jenkins_role : <main> Check Jenkins Running] 
included: /home/ec2-user/ansible_plays/roles/jenkins_role/tasks/check-jenkins-status.yml for server1

TASK [jenkins_role : Check if local host URL is up and running] 
ok: [server1]

TASK [jenkins_role : Check if public host URL is up and running] 
ok: [server1]

PLAY RECAP 
server1                    : ok=33   changed=7    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

[ec2-user@ip-172-31-29-125 ansible_plays]$

```