valhalla
========
monorepo for all personal projects

blackbox
--------
This repository uses [StackExchange's BlackBox](https://github.com/StackExchange/blackbox) to encrypt secrets to safely allow secrets to live in Git.  
> See [BLACKBOX.md](BLACKBOX.md) for instructions on how to use BlackBox.

ansible
-------
Before running any ansible playbooks, run `blackbox_decrypt_all_files` as most playbooks require the secrets to be accessible.  
Once finished running playbooks, it is recommended to run `blackbox_shred_all_files` to securely delete all decrypted secrets files.

All playbooks expect the target hosts to be supplied through the command line:  
> Example: (Single host)  
> `ansible-playbook playbook__example.yml -v --extra-vars "host=nocix"`  
> Example: (Multiple hosts)  
> `ansible-playbook playbook__example.yml -v --extra-vars "host=nocix:local:aws"`