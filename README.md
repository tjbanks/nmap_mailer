# nmap_mailer
Schedule and send automatic nmap scan results via email.

`nmap_mail.sh` is a simple tool I built at work to audit for any unauthorized firewall changes. Targets are scanned an a full report (with diff from last report) is sent to the specified email address. 

The script is completely customizable and serves as a decent base for similar implementations.

Pull requests are welcome.

## Getting started

To run this script you'll need `mail` installed on your machine. I've only tested this on Ubuntu but this should work on any other Linux distro.

Change the following variables in the script to fit your needs:
* MAILTO
* MAILFROM
* SENDER - signature in the emails
* TARGETS - space separated list of ips to scan
* OPTIONS - nmap parameters
* SCAN_FOLDER - location to store previous scan results for diff comparison
* INTERFACE - ifconfig interface name (useful for multiple NIC devices)


## Example Emailed Report

```
Dear security team member,

An Nmap scan was initiated Wed May 26 00:00:01 CDT 2021 for the following targets:
127.0.0.1/32

https://github.com/tjbanks/nmap_mailer

SCANNER INFO

Nmap Scanner Host: crimson
Crontab: 0 0 * * 3 /root/nmap_scans/nmap_mailer.sh
Script last updated: 6/1/2021
Local IP: 127.0.0.1
External IP: 127.0.0.1
DIFFERENCES SINCE LAST SCAN

-Nmap 7.01 scan initiated Wed May 19 00:00:01 2021 as: nmap -e ens192 -v -T4 -F -sV -oA scan-2021-05-19 127.0.0.1
+Nmap 7.01 scan initiated Wed May 26 00:00:01 2021 as: nmap -e ens192 -v -T4 -F -sV -oA scan-2021-05-26 127.0.0.1

127.0.0.1:
PORT STATE SERVICE VERSION
-443/tcp open ssl/http Microsoft IIS httpd 8.5
+443/tcp open ssl/https

COMPLETE SCAN OUTPUT

# Nmap 7.01 scan initiated Wed May 26 00:00:01 2021 as: nmap -e ens192 -v -T4 -F -sV -oA scan-2021-05-26 127.0.0.1

Nmap scan report for 127.0.0.1
Host is up (0.00032s latency).
Not shown: 97 filtered ports
PORT STATE SERVICE VERSION
80/tcp open http
113/tcp closed ident
443/tcp open ssl/https? 

```
