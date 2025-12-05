# windows-ssh-signing-key-loader
PowerShell helper to load a Git SSH signing key into the Windows OpenSSH agent at startup.  
Edit `ssh_signing_key_comment.env.example` (e.g., replace the email/comment), save it as `ssh_signing_key_comment.env`, then place `run-ssh-signing-startup.cmd` and the `ssh-signing-startup` folder in your Windows Startup folder.