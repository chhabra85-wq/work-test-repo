## How to connect to WFS SFTP

There are a few ways to access files in WFS SFTP location.
- [Access through Synapse pipeline dataset](#access-through-synapse-pipeline-dataset) - When you need access to WFS SFTP for HRDL interface.
- [Access through Azure Remote Desktop Protocol RDP](#access-through-azure-remote-desktop-protocol-rdp) - When you need access to other WFS SFTP locations.

### Access through Synapse pipeline dataset

**Note**:  This SFTP access is for HRDL interface, `msftdatalake<replace by env>ftp` is the ppk key we use to access this WFS SFTP location. For any other ppk keys, please refer to [Access through Azure Remote Desktop Protocol RDP](#access-through-azure-remote-desktop-protocol-rdp).

   ![WfsSftp Integration dataset](./screenshots/synapse-prod-wfssftp-dataset.png)

   1. Find the "Integration dataset" name "WfsSftp" in the Synapse workspace. 
   2. Under "Connection", click on "Browse". Here you will see all the folders and file paths. 
   3. Navigate to *prod/outgoing* or the file path specified there. For PPE, file path is *test/outgoing*. For DEV, file path is *dev/outgoing*.

#### If there is a need to drop a file in the SFPT location for testing, you can:

For DEV environment:
   1. Create a new branch, then set up a pipeline to copy the latest metadata file from the *wfs-metadata-archive* table located in Cartier storage to the WFS SFTP dataset.

For PPE and PROD environment:
   1. Ensure you have the correct SSH key and passphrase provided by WFS for either PPE or PROD. Store these in the DEV key vault.
   2. If the DEV key vault doesn't contain them, instructions for generating one can be found in OneNote.
   3. Create a new branch, then set up a pipeline to copy the latest metadata file from the *wfs-metadata-archive* table located in Cartier storage to the WFS SFTP dataset.
   4. Update the "WfsSftp" dataset with the new connection to WFS SFTP using the SSH key and passphrase from the key vault.
   5. Ensure the dataset connects successfully to WFS SFTP.
   6. You can now drop the file by executing the pipeline created in step 3.


### Access through Azure Remote Desktop Protocol RDP

**Note**: This guide assumes that you are in the PROD environment with "msftdatalakeprodftp" key. For any other keys, please adjust the key's name and file accordingly. For DEV or PPE, please ensure to use the correct Azure resources for your specific environment.

**Warning**: Accessing WFS SFTP this way can be a time-consuming process.

#### Step 1: Retrieve PPK key from Azure keyvault
**Note**: Please skip this step if you: 1. Already have the msftdatalakeprodftp.ppk key in your local machine. Or 2. You need to connect to DEV env. The DEV virtual machine already has the key.

   1. On your local machine, navigate to the appropriate environment's [Azure Key Vault resource](https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/f8a339ea-4445-4d69-a4bb-b7c77c9db241/resourceGroups/RG-Cartier-Prod/providers/Microsoft.KeyVault/vaults/Time-Cartier-ProdKV/secrets) and locate the "WFSSftpDatalakeSSHKey" and "WFSSftpDatalakeOpenSSHKey-Passphrase" secrets.
   2. The secret "WFSSftpDatalakeSSHKey" contains an SSH key encoded in Base64. You'll need to decode it back to PPK format. Copy the value, paste it into a notepad, and save it, naming it with the username. The username for PROD is *msftdatalakeprodftp*.

   ![Wfs Sftp Datalake SSH key secret prod](./screenshots/WfsSftpDatalake-ssh-key-secret-prod.png)

   3. Utilize the CLI to decode it. Here's how to do this via PowerShell: get the encoded file, decode it, and then save it with a .pem extension.
   The username for PROD is *msftdatalakeprodftp*.
   ```
   $encodedKey = Get-Content -Path "file\path\to\your\encoded\SSH\key\msftdatalakeprodftp.txt" -Raw
   $decodedKey = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedKey))
   Set-Content -Path "file\path\to\your\decoded\SSH\key\msftdatalakeprodftp.pem" -Value $decodedKey
   ```
   4. To verify the decoded key, you can open the msftdatalakeprodftp.pem file, or use the Powershell command: `Write-Output $decodedKey`. The decoded key should resemble the following:
   ```
   -----BEGIN RSA PRIVATE KEY-----
   [several lines of alphanumeric characters]
   -----END RSA PRIVATE KEY-----
   ```
   5. Convert the key with PuTTYgen: 
   - If you have "Putty Key Generator" on your local machine, launch it. 
   - If not, download the application [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) and then launch it.
   6. Click the "Load" button.

   ![PUTTY key generator](./screenshots/putty-key-load-pem-file.png)

   7. Change the file type dropdown from "PuTTY Private Key Files (.ppk)" to "All Files (.*)."
   8. Navigate to the location of your .pem SSH private key, select it, and click "Open".
   9. When prompted, enter the passphrase you retrieved from the "WFSSftpDatalakeOpenSSHKey-Passphrase" secret in step 1.
   10. Click "OK" to generate the PPK key.
   11. Select "Save private key" and save it on your local machine as a .ppk file. You will need this ppk key after step 2 below.

#### Step 2: Log in WinSCP
   12. The RDP might not function on the MSFT corp network. It's recommended to attempt this connection from a home office. 
   13. All environments use the same VM. And this VM is in located inside "MSFT - Payroll Connectors - 01" subscription. Elevate your PIM for access. And then, log in to [PayrollconnectorsVM](https://ms.portal.azure.com/https://ms.portal.azure.com/?feature.msaljs=true&feature.msaljslogin=false&msaljsscript=false#@microsoft.onmicrosoft.com/resource/subscriptions/59e3af93-26f8-4ceb-ada6-12cf15432917/resourceGroups/RG-PayrollConnectors-PROD/providers/Microsoft.Compute/virtualMachines/PayrollconnectorsVM/overview).

   ![Alt Text](./screenshots/configure-WinSCP.png)

   14. To connect to the VM, use JIT (Just-In-Time). Under the "Connect" tab, select "Native RDP". A right-side panel will appear; **The configure button will load after a few seconds**. Check the box to acknowledge the just-in-time policy and configure your local machine.
   15. Click the "Download RDP File" button to download the file. After downloading, launch it (double click on the PayrollconnectorsVM.rdp file that you just downloaded).
   16. Enter your credentials and follow the connection steps to log in. **Warning**: PayrollconnectorsVM VM might drop the connection, in this case you will need to reconnect, which means you need to locate the downloard PayrollconnectorsVM.rdp file in step 15 and launch it again.
   17. In default, PayrollconnectorsVM VM will try to log-in to your @microsoft account, do not log-in using your account. Instead, select "prcoprodvmadmin" user at the bottom left of the VM screen. If "prcoprodvmadmin" user not found, choose different sign-in option and enter the Username "prcoprodvmadmin". When prompted, the password is located in the [*time-cartier-devKV* key vault](https://ms.portal.azure.com/?feature.msaljs=true&feature.msaljslogin=false&msaljsscript=false#@microsoft.onmicrosoft.com/resource/subscriptions/f8a339ea-4445-4d69-a4bb-b7c77c9db241/resourceGroups/RG-Cartier-Dev/providers/Microsoft.KeyVault/vaults/Time-Cartier-DevKV/secrets) **this log-in value is for ALL environments - not just DEV**, with the secret name "prcoprodvmadmin".
   18. After logging in, open WinSCP. The DEV env should already be configured to access the DEV SFTP location.
   19. Connected: Select the connection. If everything is correct, you should now be connected to DEV SFTP server.

#### Step 3: Perform WFS SFTP access

   ![WinSCP](./screenshots/winscp-authenticate-ppk.png)

   20. Copy the .ppk file from your local machine from step 1 and paste it to the VM.
   21. With WinSCP application open in the VM from step 2, select "New Site" or "New Session" depends on your version, you can open a "New Tab" if some connections exists. Fill out the Host name and Port number. The connection site for DEV should be there and you can use the values from the DEV connection as a reference.
   22. For the Username:
      - Use *msftdatalakeprodftp* for PROD.
      - Use *msftdatalaketestftp* for PPE.
   23. For authentication using PPK, click on "Advanced..."
   24. Under "SSH", select "Authentication".
   25. In the "Private key file" field, click on the folder icon and navigate to your PPK key file from step 20, then select it.
   26. Click "OK" to return to the main connection window.
   27. Click "Login" to start the SFTP connection.
   28. Passphrase Prompt: Enter your passphrase from "WFSSftpDatalakeOpenSSHKey-Passphrase" secret in step 1 #1.
   29. Connected: If everything is correct, you should now be connected to the SFTP server.

#### Step 4: Clean up after you are done
**Important**: Before logging out, ensure you:
      - Delete the new profile in WinSCP.
      - Remove the PPK key file and then empty it from the Recycle Bin.