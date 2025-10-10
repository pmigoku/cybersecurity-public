## SSH Master Control Sockets Primer
SSH master control sockets allow you to reuse a single TCP connection for multiple SSH sessions. Think of it like a carpool lane for your connections. The first connection does the hard work of authenticating, and all subsequent sessions can hop into that fast lane, skipping the authentication process entirely. This makes opening new shells, transferring files (SCP/SFTP), and managing port forwards significantly faster.

> [!NOTE]
> Some definitions:
> - **Master Connection:** The first SSH session you establish that handles authentication.
> - **Control Socket** Special file created on your linux system used to connect to existing master connection.
> - **Multiplexing:** Process of sending multiple, separate SSH sessions through a master connection (socket file).

### Step 1: Create the master connection
Fist, establish the initial "master" connection. You can do this with an interactive shell or have it run in the background.
```bash
# -M puts SSH in Master mode
# -S specifies the path for the Control Socket file
ssh -MS /tmp/<SOCKET_NAME> <USER>@<TGT>
```

To create a **master socket** that runs in the background (OPTIONAL): This is useful when you just want to set up the connection for other sessions or port forwards to use, without needing an active terminal.
```bash
# -f forks the process to the background
# -N tells SSH not to execute a remote command
ssh -fN -MS /tmp/my_socket <USER>@<TGT>
```

You can verify the socket (OPTIONAL)
```bash
ssh -S /tmp/SOCK -O check <USER>@<TGT>
# Expected output: Master running (pid=XXXXX)
```

### Step 2: Reuse the connection (Mulitplexing)
To open a new session, just point ssh to your scoket file.
reuse exisitng connection to get a new session
```bash
ssh -S /tmp/SOCK a@1
```
> [!TIP]
> Wait, why `a@1`?
>
>Since the master connection has already authenticated, the user and host (`a@1`) for subsequent sessions are just placeholders to satisfy the command's syntax. They are ignored for authentication, so you can put anything there!

### Step 3: Manage Port Forwards On-the-Fly
You can now add or remove port forwards (tunnels) without tearing down your connection.
```bash
# open a port forward over an existing session
ssh -S /tmp/<SOCK> -O forward -L 2222:<TGT>:22 a@1

# Remove a port forward over an existing session
ssh -S /tmp/<SOCK> -O cancel -L 2222:<TGT>:22 a@1

# Add a dynamic port forward (SOCKS)
ssh -S /tmp/<SOCK> -O forward -D 9050 a@1

# Remove the dynamic port forward
ssh -S /tmp/<SOCK> -O cancel -D 9050 a@1
```

### Step 4: Use Sockets Through Existing tunnels.
We can also use master control sockets through existing tunnels!
```bash
# Use an existing control socket to tunnel 
ssh -p <PORT> -S /tmp/T1 <USER>@127.0.0.1 -L <LOCAL_PORT>:<TGT_IP>:<DEST_PORT>

# Create a new Master Connection over an existing tunnel
ssh -p <PORT> -MS /tmp/T2 <USER>@127.0.0.1
```

Here is an example 
```bash
#      NIX                  T1                  T2                  T3
# +------------+      +------------+      +------------+      +------------+      
# |            |      |            |      |            |      |            |   
# |            ------->22          |      |            |      |            |   
# |        2222>====================------>22          |      |            |    
# |        3333>========================================------>80          |     
# |            |      |            |      |            |      |            |    
# +------------+      +------------+      +------------+      +------------+  

# create master connection to t1 and forward tunnel to t2
ssh -MS /tmp/t1 user@t1 -L 2222:T2:22

# create a master connection to t2 and forward tunnel to t3
ssh -p 2222 -MS /tmp/t2 user@127.0.0.1 -L 3333:T3:80

# use tunnel to hit T3 web server
wget http://127.0.0.1:3333

# open another terminal on T2
ssh -S /tmp/t2 a@1
```



