# SADA
SADA written in Bash for Kali Linux. A fun project for Webapplication vulnerability Scanning.

# Usage

chmod u+x SADA.sh

user@machine: ./SADA.sh

# License
MIT License

Copyright (c) 2018 Muhammad Talha Khan

Permission is hereby granted, free of charge, to any person obtaining a copy
Of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF INTERCHANGEABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

# DISCLAIMER
This software/script/application/thing is provided as is, without warranty of any kind. Use of this software/script/application/thing is entirely at your own risk. Scanning/Sending traffic somewhere where you shouldn't be or without permission of the owner is illegal. Creator of this software/script/application/thing is not responsible for any direct or indirect damage to your own or defiantly someone else's property resulting from the use of this software/script/application/thing.

# Changes
### Ver 0.2
+ Bug fixes
+ Dead or Alive host check before scan
+ Added timeout on scans
+ Changes in about
+ Main menu in separate function

### Ver 0.3
+ Trace method scan added
+ Save located subdomains in separate report

### Ver 0.4
+ Ask for report generation on exit
+ Bug fixes && improvements
+ CRLF injection scan added

### Ver 0.5
+ Menu optimization
+ Option Bleed scan added (Experimental)
+ Custom list and custom subdomain names scan added

### Ver 0.6
+ Bug fixes
+ Stupid fixes
+ Custom User Agent
+ Custom timeout
+ Beautified
+ HTTPS support added (partial)

### Ver 0.7
+ WAF detetion on host header results
+ Open Redirect Scan added
+ Stupid fixes
+ Scan optimization

### Ver 0.8
+ Proxy support added
+ Subdomain Bruteforce scan added
