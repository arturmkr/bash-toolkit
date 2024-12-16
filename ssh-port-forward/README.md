# SSH Port Forward Utility

This utility creates an SSH tunnel to forward a local port to a target host's port via an intermediate SSH server.

## Files

- **`ssh_tunnel.sh`**: The main script that reads configuration and establishes the SSH tunnel.
- **`ssh_tunnel_config.txt.example`**: An example configuration file showing the required fields.

---

## How to Use

1. **Prepare the Configuration File**:
   - Copy the example configuration file to a working configuration file:
     ```bash
     cp ssh_tunnel_config.txt.example ssh_tunnel_config.txt
     ```
   - Open `ssh_tunnel_config.txt` and fill in the required values (one per line):
     ```
     ssh_username
     path_to_ssh_key
     ssh_host
     target_host_name
     target_host_port
     local_port
     ```

2. **Run the Script**:
   - Make the script executable:
     ```bash
     chmod +x ssh_tunnel.sh
     ```
   - Execute the script:
     ```bash
     ./ssh_tunnel.sh
     ```
   - The script will establish an SSH tunnel based on the provided configuration. It runs in the foreground, and you can stop it by pressing `Ctrl+C`.

---

## Example

For a configuration file (`ssh_tunnel_config.txt`):
```
user123
~/.ssh/id_rsa
ssh.example.com
db.example.com
3306
8080
```

Running the script will forward local port `8080` to port `3306` on `db.example.com`, routed through `ssh.example.com`.

---

## Notes

- Ensure the `ssh_tunnel_config.txt` file has proper permissions to secure sensitive information:
  ```bash
  chmod 600 ssh_tunnel_config.txt
  ```
- The script will print an error if the configuration file is missing or incomplete.
