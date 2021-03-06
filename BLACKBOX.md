
BlackBox Flow
======
### Initial Blackbox Setup
1. `cd` into the Git repository
2. run `blackbox_initialize`
3. Follow steps from the output in step 2


## After Blackbox Setup
### Initial one-time setup:
1. `gpg --gen-key`
2. `blackbox_addadmin FINGERPRINT-OF-GPG-KEY`
   1. Example: `blackbox_addadmin 65B0E71268EEB8352033BC32D447A3013BB6665F`
3. Follow steps from the output in step 2

### Edit admins
`blackbox_addadmin <gpg-key>`
  - Add someone to the list of people that can encrypt/decrypt secrets

`blackbox_removeadmin <gpg-key>`
  - Remove someone from the list of people that can encrypt/decrypt secrets  

### Register file for encryption:
1. `blackbox_register_new_file <file>`
   - Encrypt a file for the first time

### Deregister file from encryption:
1. `blackbox_deregister_file <file>`
   - Remove a file from blackbox

### Editing file:
`blackbox_edit <file>`
  - Decrypts, runs $EDITOR, and re-encrypts <file>

Alternatively,

1. `blackbox_edit_start <file>`
   - Decrypt a file so it can be updated
2. `blackbox_edit_end <file>`
   - Encrypt a file after `blackbox_edit_start` was used

### Update file encryption with current keys
1. `blackbox_update_all_files`
   - Decrypt then re-encrypt all files. Useful after keys are changed

### Decrypt files
`blackbox_decrypt_file <file>`
  - Decrypt a file

`blackbox_decrypt_all_files`
  - Decrypt all managed files (INTERACTIVE)

`blackbox_postdeploy`
  - Decrypt all managed files (batch)

### Delete all decrypted files
`blackbox_shred_all_files`
  - Safely delete any decrypted files

## New Admin Flow
### Add admin keys
1. Run `gpg --list-keys` and `gpg --list-secret-keys`
2. Copy the correct fingerprint ID of your gpg key  
   This ID should be the same in the `--list-keys` and `--list-secret-keys` output
3. Run `blackbox_addadmin FINGERPRINT-OF-GPG-KEY`
4. Commit and push the `.blackbox/pubring.kbx` and `.blackbox/blackbox-admins.txt` files
5. A current admin must pull these changes, run `blackbox_update_all_files`, and commit/push the newly encrypted files
6. Test that the new admin and a current admin can successfully run `blackbox_decrypt_all_files`
