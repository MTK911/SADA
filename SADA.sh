#!/bin/bash
#set -xv
##~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#
#                                        #
#    SADA Web Application Testing tool   #
#             Written by MTK             #
#               Ver {0.8}                #
#----------------------------------------#
#     Created by Open Source shared      #
#            as Open source              #
#             www.mtk911.cf		 #
#                                        #
#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~##

#MIT License
#
#Copyright (c) 2018 Muhammad Talha Khan
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

#DISCLAIMER 

#This software/script/application/thing is provided as is, without warranty of any kind. Use of this software/script/application/thing is entirely at #your own risk. Scanning/Sending traffic somewhere where you shouldn't be or without permission of the owner is illegal. Creator of this software/script/application/thing is not responsible for any direct or indirect damage to your own or defiantly someone else's property resulting from the use of this software/script/application/thing.

#because colors
R='\033[0;31m'
G='\033[0;32m'
B='\033[0;34m'
Y='\033[1;33m'
LG='\033[1;32m'
BW='\033[1;37m'
UW='\033[4;37m'
RB='\033[41m'
NC='\033[0m'

#stdout_is_temporary_variables_are_forever
ver="0.8"
user_agent="SADA-$ver(https://github.com/MTK911/SADA)"
t_o="2"
$prox_y=""
control_c()
# Catch the ctrl+c
{
  echo ''
  echo -ne "Ctrl+c detected falling back\\n"
  exec "$0"
  main_man
}
 
# trap keyboard interrupt (control-c)
trap control_c SIGINT



#subdomain scan tester
sub_sc () {
clear
#dead_or_alive
echo -ne "Enter domain name {${Y}xyz.com${NC}}: "
read -r dom
echo ''
if curl -Iks$prox_y -m "$t_o" -A "$user_agent" -w "%{http_code}\n" -o /dev/null "$dom" | grep -q '[1-9]' 
then
sub_men
else
sub_cho
fi
}

#don't be lazy
sub_cho () {
echo -ne ${R}"Domain down or doesn't exists"${NC}
echo ''
echo -ne "Do you still want to proceed with scan ${Y}{Y|N}: "${NC}
read -r go_no
if [ "$go_no" == "N" ] || [ "$go_no" == "n" ]; then
main_man
elif [ $go_no == "Y" ] || [ $go_no == "y" ]; then
sub_men
else
echo -ne ${R}"Wrong entry please use {Y or N}\\n"${NC}
sub_cho
#Yey
fi

}

#list_selection_menu
sub_men () {
echo -ne "${Y}[1]${NC} Use built-in subdomain list\\n${Y}[2]${NC} Use custom subdomain list \\n${Y}[3]${NC} Enter subdomain names to scan \\n${Y}[4]${NC} Bruteforce Subdomains [Experimental] \\n${Y}[5]${NC} Change target domain \\n${R}[6]${NC} Go back to menu \\nChoose scan option ${Y}[1-6]${NC}: "
read -r sel
if [ "$sel" = '1' ]; then
sub_aut
elif [ "$sel" = '2' ]; then
sub_cust
elif [ "$sel" = '3' ]; then
sub_man
elif [ "$sel" = '4' ]; then
sub_br
elif [ "$sel" = '5' ]; then
sub_sc
elif [ "$sel" = '6' ]; then
main_man
else
echo -ne ${RB}${UW}"\"$sel\"${NC} is not a valid choice\\n"
echo ""
echo ""
sleep 2
sub_men
fi
}

#All mine lists
sub_aut () {
cat names.txt | while read -r LINE
do
if curl -Iks$prox_y -m "$t_o" -A "$user_agent" -w "%{http_code}\n" -o /dev/null "$LINE.$dom" | grep -q '[1-9]'
then
echo -ne ${G}"$LINE.$dom"${NC}
echo ''
echo -ne "$LINE.$dom\\n" >> subdomains
fi
done
sleep 3
main_man
}

#Not all mine lists
sub_cust () {
echo -ne "Enter custom subdomain list location [${Y}/path/to/my/list.txt${NC}]: "
read -r  culist
if [ ! -f "$culist" ]; then
echo -ne ${R}"File not found!\\n"${NC}
sub_cust
else
cat "$culist" | while read -r LINE
do
if curl -Iks$prox_y -m "$t_o" -A "$user_agent" -w "%{http_code}\n" -o /dev/null "$LINE.$dom" | grep -q '[1-9]'
then
echo -ne ${G}"$LINE.$dom"${NC}
echo ''
echo -ne "$LINE.$dom\\n" >> subdomains
fi
done
sleep 3
main_man
fi
}


#I'll tell ye name
sub_man () {

echo -ne "Enter subdomain names separated by space [${Y}www mail support${NC}]: "
read -a catch
for LINE in ${catch[@]}
do
if curl -Iks$prox_y -m "$t_o" -A "$user_agent" -w "%{http_code}\n" -o /dev/null "$LINE.$dom" | grep -q '[1-9]'
then
echo -ne ${G}"$LINE.$dom"${NC}
echo ''
echo -ne "$LINE.$dom\\n" >> subdomains
fi
done
sleep 3
main_man
}

#When_everything_fails_BRUTEFORCE_it_LAME
sub_br () {
echo -ne "Enter Size of Bruteforce Characher: [1-*]: "
read -r sie
echo ''
Z="[a-z]"
for (( i=1; i<="$sie"; i++ ))
do
curl -Iks$prox_y -m "$t_o" -A "$user_agent" -w "%{http_code}\n%{url_effective}\n" -o /dev/null "$Z.$dom"| grep -A 1 [1-9]| sed 's/[0-9]*//g' | sed '/^$/d' >> subdomains
Z="$Z[a-z]"
done
cat subdomains
sleep 3
main_man
}


#Host_Header_Attack_Scan_Selection
hha_s () {
clear
echo -ne "${Y}[1]${NC} Host Header Attack Scan (Located subdomains)\\n${Y}[2]${NC} Host Header Attack Scan (Manual Single) \\n${Y}[3]${NC} Host Header Attack Scan (Manual List)\\n${R}[4]${NC} Go back to menu \\nChoose scan option ${Y}[1-4]${NC}: "
read -r sel
if [ "$sel" = '1' ]; then
hha_asc
elif [ "$sel" = '2' ]; then
hha_msc
elif [ "$sel" = '3' ]; then
hha_mli
elif [ "$sel" = '4' ]; then
main_man
else
echo -ne ${RB}${UW}"\"$sel\"${NC} is not a valid choice"
sleep 2
hha_s
fi
}


#Automagical Host_Header_Attack_Scan
hha_asc () {
cat subdomains | while read -r dom
do
echo ''
echo -ne ${Y}" Testing "$dom" "${NC}
echo ''
echo -ne ${B}"X-Forwaded-Host link pollution test"${NC}
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H 'X-Forwarded-Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"X-Forwaded-Host header test"${NC}
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -q 'evil'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H 'X-Forwarded-Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Host header attack link pollution test"${NC}
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H 'Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi

echo -ne ${B}"Host Header attack header test"${NC}
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H 'Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi 
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Trace method test (XST)"${NC}
echo ''
if curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom" | grep -q '200 OK'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom""
echo ''
curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
sleep 3

done
main_man
}

#Muggle Host_Header_Attack_Scan
hha_msc () {
echo -ne "Enter domain name {${Y}http^s://www.xyz.com/${NC}}: "
read -r dom
echo -ne ${B}"X-Forwaded-Host link pollution test"${NC}
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H 'X-Forwarded-Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"X-Forwaded-Host header test"${NC}
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -q 'evil'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H 'X-Forwarded-Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Host header attack link pollution test"${NC}
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H 'Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Host Header attack header test"${NC}
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H 'Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi

echo -ne ${B}"Trace method test (XST)"${NC}
echo ''
if curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom" | grep -q '200 OK'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom""${NC}
echo ''
curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
sleep 3
echo ''
main_man
}

#Host_header_lists belong to me
hha_mli () {

echo -ne "Enter custom subdomain list location [${Y}/path/to/my/list.txt${NC}]: "
read -r  culist
if [ ! -f "$culist" ]; then
echo -ne ${R}"File not found!\\n"${NC}
hha_mli
else
cat "$culist" | while read -r dom
do
echo ''
echo -ne ${Y}" Testing "$dom" "${NC}
echo ''
echo -ne ${B}"X-Forwaded-Host link pollution test"${NC}
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H 'X-Forwarded-Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"X-Forwaded-Host header test"${NC}
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -q 'evil'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H 'X-Forwarded-Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "X-Forwarded-Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Host header attack link pollution test"${NC}
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H 'Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi

echo -ne ${B}"Host Header attack header test"${NC}
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo "curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H 'Host: evil.com' "$dom""
echo ''
if curl -s -k$prox_y -I -m "$t_o" -A "$user_agent" -H "Host: evil.com" "$dom" | grep -qi 'cloudflare\|cloudfront'
then
echo -ne ${Y} "Domain protected with WAF it may result in false positive result\\n"${NC}
fi 
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Trace method test (XST)"${NC}
echo ''
if curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom" | grep -q '200 OK'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom""${NC}
echo ''
curl -s -I$prox_y -m "$t_o" -A "$user_agent" -X TRACE "$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
sleep 3

done
main_man
fi
}

# CRLF_Injection_Scan_Selection
crlf_s () {
clear
echo -ne "${Y}[1]${NC} CRLF Injection Scan (Located subdomains)\\n${Y}[2]${NC} CRLF Injection Scan (Manual Single) \\n${Y}[3]${NC} CRLF Injection Scan (Custom Domain List) \\n${R}[4]${NC} Go back to menu \\nChoose scan option ${Y}[1-4]${NC}: "
read -r sel
if [ "$sel" = '1' ]; then
crlf_asc
elif [ "$sel" = '2' ]; then
crlf_msc
elif [ "$sel" = '3' ]; then
crlf_mli
elif [ "$sel" = '4' ]; then
main_man
else
echo -ne ${RB}${UW}"\"$sel\"${NC} is not a valid choice"
sleep 2
crlf_s
fi
}


# CRLF_Injection_module_automagical
crlf_asc () {
cat subdomains | while read -r dom
do
echo ''
echo -ne ${B}"CRLF injection test"${NC}
echo ''
echo -ne ${Y}"Testing "$dom" "${NC}
echo ''
if curl -skIL$prox_y -m "$t_o" -A "$user_agent" "$dom/%0d%0acustom_header:so_evil" | grep -q '^[cC]ustom[_ ]\?[hH]eader: \?[sS]o[_ ]\?[eE]vil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}curl -IskL$prox_y -m "$t_o" -A "$user_agent" "$dom/%0d%0aCustom_Header:so_evil"${NC}
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''
fi
done

sleep 3
echo ''
main_man
}

# Muggle_CRLF_Injection_module
crlf_msc () {
echo -ne "Enter domain name {${Y}http^s://www.xyz.com/${NC}}: "
read -r dom
echo -ne ${B}"CRLF injection test"${NC}
echo ''
echo -ne ${Y}"Testing "$dom" "${NC}
echo ''
if curl -IskL$prox_y -m "$t_o" -A "$user_agent" "$dom/%0d%0acustom_header:so_evil" | grep -q '^[cC]ustom[_ ]\?[hH]eader: \?[sS]o[_ ]\?[eE]vil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}curl -IskL$prox_y -m "$t_o" -A "$user_agent" "$dom/%0d%0aCustom_Header:so_evil"${NC}
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
sleep 3
echo ''
main_man
}


#Me_list_Crlf
crlf_mli () {

echo -ne "Enter custom subdomain list location [${Y}/path/to/my/list.txt${NC}]: "
read -r  culist
if [ ! -f "$culist" ]; then
echo -ne ${R}"File not found!\\n"${NC}
crlf_mli
else
cat "$culist" | while read -r dom
do
echo ''
echo -ne ${B}"CRLF injection test"${NC}
echo ''
echo -ne ${Y}"Testing "$dom" "${NC}
echo ''
if curl -IskL$prox_y -m "$t_o" -A "$user_agent" "$dom/%0d%0acustom_header:so_evil" | grep -q '^[cC]ustom[_ ]\?[hH]eader: \?[sS]o[_ ]\?[eE]vil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}curl -IskL$prox_y -m "$t_o" -A "$user_agent" "$dom/%0d%0aCustom_Header:so_evil"${NC}
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''
fi
done

sleep 3
echo ''
main_man
fi
}


#OPTION_BLEED_SCAN {EXPERIMENTAL} (https://blog.fuzzing-project.org/60-Optionsbleed-HTTP-OPTIONS-method-can-leak-Apaches-server-memory.html)
op_bl () {
echo -ne "Enter domain name {${Y}http^s://www.xyz.com/${NC}}: "
read -r dom
echo -ne ${B}"Option Bleed test experimental"${NC}
echo ''

for i in {1..100}; do curl -sI$prox_y -m "$t_o" -A "$user_agent" -X OPTIONS $dom/|grep -i "allow:"; done

sleep 5
echo ''
main_man

}


#OpenRedirect_Scanning_Selection
oprd_sc () {
clear
echo -ne "${Y}[1]${NC} Open Redirect Scan (Located subdomains)\\n${Y}[2]${NC} Open Redirect Scan (Manual Single) \\n${Y}[3]${NC} Open Redirect Scan (Custom Domain List) \\n${R}[4]${NC} Go back to menu \\nChoose scan option ${Y}[1-4]${NC}: "
read -r sel

if [ "$sel" = '1' ]; then
op_rdl
elif [ "$sel" = '2' ]; then
op_rds
elif [ "$sel" = '3' ]; then
op_rdc
elif [ "$sel" = '4' ]; then
main_man
else
echo -ne ${RB}${UW}"\"$sel\"${NC} is not a valid choice"
sleep 2
oprd_sc
fi
}

#Automagical_located_subdomain_killin
op_rdl () {
cat subdomains | while read -r dom
do
echo ''
echo -ne ${B}"Open Redirect Scan"${NC}
echo ''
echo -ne ${Y}"Testing "$dom" "${NC}
echo ''
cat ORP.txt | while read -r ORT
do
if curl -k$prox_y -w "%{url_effective}\n" -I -L -s -m "$t_o" -A "$user_agent" "$dom/$ORT"  -o /dev/null | grep -q '^https\?://[a-zA-Z0-9]*\.\?evil.com/'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"$dom/$ORT"${NC}
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
done
done
sleep 3
echo ''
main_man

}

#Muggle_single_Open_redirect_domain_killin
op_rds () {
echo -ne "Enter domain name {${Y}http^s://www.xyz.com/${NC}}: "
read -r dom
echo ''
echo -ne ${B}"Open Redirect Scan"${NC}
echo ''
echo -ne ${Y}"Testing "$dom" "${NC}
echo ''
cat ORP.txt | while read -r ORT
do
if curl -k$prox_y -w "%{url_effective}\n" -I -L -s -m "$t_o" -A "$user_agent" "$dom/$ORT"  -o /dev/null | grep -q '^https\?://[a-zA-Z0-9]*\.\?evil.com/'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"$dom/$ORT"${NC}
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
done
sleep 3
echo ''
main_man

}

#Muggle_domain_list_Openredirect_scan
op_rdc () {
echo -ne "Enter custom subdomain list location [${Y}/path/to/my/list.txt${NC}]: "
read -r  culist
if [ ! -f "$culist" ]; then
echo -ne ${R}"File not found!\\n"${NC}
op_rdc
else
cat "$culist" | while read -r dom
do
echo ''
echo -ne ${B}"Open Redirect Scan"${NC}
echo ''
echo -ne ${Y}"Testing "$dom" "${NC}
echo ''
cat ORP.txt | while read -r ORT
do
if curl -k$prox_y -w "%{url_effective}\n" -I -L -s -m "$t_o" -A "$user_agent" "$dom/$ORT"  -o /dev/null | grep -q '^https\?://[a-zA-Z0-9]*\.\?evil.com/'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"$dom/$ORT"${NC}
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
done
done
sleep 3
echo ''
main_man
fi
}


#Adjusting_Scanning_Options_because_not_everybody_is_a_fan_of_curl
sc_op () {
clear
echo -ne "${Y}[1]${NC} Change User-Agent \\n${Y}[2]${NC} Change request Time-out time \\n${Y}[3]${NC} Use Proxy \\n${R}[4]${NC} Go back to menu \\nChoose scan option ${Y}[1-3]${NC}: "
read -r sel

if [ "$sel" = '1' ]; then
ch_ua
elif [ "$sel" = '2' ]; then
ch_to
elif [ "$sel" = '3' ]; then
pro_xy
elif [ "$sel" = '4' ]; then
main_man
else
echo -ne ${RB}${UW}"\"$sel\"${NC} is not a valid choice"
sleep 2
sc_op
fi
}

#User_agent_man
ch_ua () {
echo -ne "Current User-Agent: ${G} $user_agent ${NC} \\n"
echo -ne "Would you like to change that? ${Y}{Y|N}${NC}: " 
read -r agask
if [ "$agask" == "N" ] || [ "$agask" == "n" ]; then
sc_op
elif [ $agask == "Y" ] || [ $agask == "y" ]; then
read -r -p "Please enter your custom User-Agent: " user_agent
echo -ne "New User-Agent: ${G} $user_agent ${NC} \\n"
sleep 3
sc_op
else
echo -ne ${R}"Wrong entry please use {Y or N}\\n"${NC}
ch_ua
#yay
fi
clear
}

#it's_TIME
ch_to () {
echo -ne "Current Time out time: ${G} $t_o Second ${NC} \\n"
echo -ne "Would you like to change that? ${Y}{Y|N}${NC}: " 
read -r agask
if [ "$agask" == "N" ] || [ "$agask" == "n" ]; then
sc_op
elif [ $agask == "Y" ] || [ $agask == "y" ]; then
echo -ne "${R}Note:${NC}\\n${Y}More time means best results at slow speed \\nless time means unreliable results at fast speed. \\n"${NC}
echo ''
read -r -p "Please enter new Time out time in Seconds: " t_o
echo -ne "New Time out is ${G}$t_o ${NC}seconds"
sleep 3
sc_op
else
echo -ne ${R}"Wrong entry please use {Y or N}\\n"${NC}
ch_to
fi
clear
}

#Proxy_Moxy
pro_xy () {
echo -ne "Current Proxy: ${G} $proxycatch ${NC} \\n"
echo -ne "Would you like to change that? ${Y}{Y|N}${NC}: " 
read -r agask
 if [ "$agask" == "N" ] || [ "$agask" == "n" ]; then
 sc_op
 elif [ $agask == "Y" ] || [ $agask == "y" ]; then
 echo -ne "Please enter your proxy in format ${Y}[protocol://]host[:port]${NC}: "
 read -r proxycatch
 prox_y=" --proxy $proxycatch"
 echo -ne "Proxy added as: ${G} $proxycatch ${NC} \\n"
 sleep 2
 echo -ne "Checking added proxy \\n"
  if curl -Iks$prox_y -m "$t_o" -A "$user_agent" -w "%{http_code}\n" -o /dev/null "google.com"| grep -q [1-9]
  then
  echo -ne ${G}"Proxy server is up and running \\n"${NC}
  sleep 2
  sc_op
  else
  echo -ne ${R}"Proxy server is down or wrong input \\n"${NC}
  echo -ne "Would you still like to use the same proxy? ${Y}{Y|N}${NC}:"
  read -r ques
   if [ "$ques" == "N" ] || [ "$ques" == "n" ]; then
   pro_xy
   elif [ $agask == "Y" ] || [ $agask == "y" ]; then
   sc_op
   else
   echo -ne ${R}"Wrong entry please use {Y or N}\\n"${NC}
  fi
 fi
sleep 3
else
echo -ne ${R}"Wrong entry please use {Y or N}\\n"${NC}
pro_xy
fi
clear

}


#Say_something_smart
abo_ut () {
clear
echo ""
echo ""
echo -ne "               
	 ${G}      _${LG}// //       ${G}_${LG}/       ${G}_${LG}/////        ${G}_${LG}/       ${NC}
	 ${G}    _${LG}//    ${G}_${LG}//    ${G}_${LG}/ //     ${G}_${LG}//   ${G}_${LG}//    ${G}_${LG}/ //     ${NC}
	 ${G}     _${LG}//         ${G}_${LG}/  ${G}_${LG}//    ${G}_${LG}//    ${G}_${LG}//  ${G}_${LG}/  ${G}_${LG}//   ${NC} 
	 ${G}       _${LG}//      ${G}_${LG}//   ${G}_${LG}//   ${G}_${LG}//    ${G}_${LG}// ${G}_${LG}//   ${G}_${LG}//  ${NC} 
	 ${G}          _${LG}//  ${G}_${LG}////// ${G}_${LG}//  ${G}_${LG}//    ${G}_${LG}//${G}_${LG}////// ${G}_${LG}//  ${NC}
	 ${G}    _${LG}//    ${G}_${LG}//${G}_${LG}//       ${G}_${LG}// ${G}_${LG}//   ${G}_${LG}//${G}_${LG}//       ${G}_${LG}//${NC} 
	 ${G}      _${LG}// // ${G}_${LG}//         ${G}_${LG}//${G}_${LG}/////  ${G}_${LG}//         ${G}_${LG}//${NC}
                                                     ${BW}${UW}Ver "$ver"${NC}             
                             
       ${G}SADA${NC} created as fun project to support web vulnerability scanning.
            Valuable feedback and suggestions are always welcome 
                 @ ${R}root@mtk911.cf${NC} or ${R}http://fb.com/MTK911${NC}"

echo ""
echo ""
echo ""
echo ""
echo ""
sleep 5
main_man
}

banner () {
echo -ne "


${R}                          MTKMTKMTKMTKMTKMTKMTKMTKMTKM${NC}
                            010011010101010001001011
${R}                          MTKMTKMTKMTKMTKMTKMTKMTKMTKM${NC}

                                                                          
${B}    M${NC}T${B}K                                  ${Y}M${NC}T${Y}K          ${NC}
${B}    M${NC}T${B}K M${NC}T${B}KM                        MT${NC}K${B}  ${Y}M${NC}T${Y}K          ${NC}   
${B}    M${NC}T${B}K M${NC}T${B}KMT                     MT${NC}K${B}MT  ${Y}M${NC}T${Y}K          ${NC}   
${B}    M${NC}T${B}K   M${NC}T${B}KMK                  MT${NC}K${B}MT   ${Y}M${NC}T${Y}K     M${NC}T${Y}K  ${NC}  
${B}    M${NC}T${B}K    M${NC}T${B}KMM                MT${NC}K${B}MT    ${Y}M${NC}T${Y}K    M${NC}T${Y}K   ${NC} 
${B}    M${NC}T${B}K     M${NC}T${B}KMT              MT${NC}K${B}MT     ${Y}M${NC}T${Y}K  M${NC}T${Y}KM    ${NC} 
${B}    M${NC}T${B}K       M${NC}T${B}KK            MT${NC}K${B}M       ${Y}M${NC}T${Y}K M${NC}T${Y}KMT    ${NC} 
${B}    M${NC}T${B}K         M${NC}T${B}K          M${NC}T${B}K         ${Y}M${NC}T${Y}K   M${NC}T${Y}KMT  ${NC} 
${B}    M${NC}T${B}K          M${NC}T${B}K        M${NC}T${B}K          ${Y}M${NC}T${Y}K      M${NC}T${Y}K ${NC}  
${B}    M${NC}T${B}K            M${NC}T${B}K    M${NC}T${B}K            ${Y}M${NC}T${Y}K          ${NC}
${B}    M${NC}T${B}K                                  ${Y}M${NC}T${Y}K          ${NC}   
${B}    M${NC}T${B}K                                  ${Y}M${NC}T${Y}K          ${NC}   
                                                            
                                                                                         
"
echo "SWYgeW91IGNhbiBzZWUgdGhpcyB0aGF0IG1lYW5zIHlvdSBhY3R1YWxseSBjYXJlIHdoYXQgeW91J3JlIHJ1bm5pbmcgb24geW91ciBjb21wdXRlciB3aGF0IHNlZW1zIHRvIGJlIHNvbWV0aGluZyB5b3UganVzdCBkb3dubG9hZGVkIGZyb20gYSByYW5kb20gZ3V5cyByZXBvc2l0b3J5IG92ZXIgdGhlIGludGVybmV0LiBGb3IgdGhhdCB5b3UgaGF2ZSBlYXJuZWQgbXkgcmVzcGVjdC4=" | base64 --decode
exit
}

#Emergency exit here
sh_exit () {
echo -ne "Do you want to save Located subdomains${Y}[y|n]${NC}: "
read -r ask
if [ "$ask" == "N" ] || [ "$ask" == "n" ]; then
echo '' > subdomains
elif [ $ask == "Y" ] || [ $ask == "y" ]; then
cat subdomains > report_$(date +%F-%H:%M).txt
echo '' > subdomains
else
echo -ne ${R}"Wrong entry please use {Y or N}\\n"${NC}
sh_exit
fi
clear
echo "        Bringing simplicity back"
echo -ne "
##~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#
#                                        #
#    SADA Web Application Testing tool   #
#             Written by ${LG}MTK${NC}             #
#               Ver {${Y}"$ver"${NC}}                #
#----------------------------------------#
#     Created by Open Source shared      #
#            as Open source              #
#    ${R}www.mtk911.cf${NC} | ${R}root[at]mtk911.cf${NC}   #
#                                        #
#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~##

"

exit
}
while getopts ':^' catch; do
 case "$catch" in

  ^)
   banner 
   ;;

 esac
done



#FRONT_END
main_man(){
clear
echo ""
echo ""
echo -ne "



	 ${G}      _${LG}// //       ${G}_${LG}/       ${G}_${LG}/////        ${G}_${LG}/       ${NC}
	 ${G}    _${LG}//    ${G}_${LG}//    ${G}_${LG}/ //     ${G}_${LG}//   ${G}_${LG}//    ${G}_${LG}/ //     ${NC}
	 ${G}     _${LG}//         ${G}_${LG}/  ${G}_${LG}//    ${G}_${LG}//    ${G}_${LG}//  ${G}_${LG}/  ${G}_${LG}//   ${NC} 
	 ${G}       _${LG}//      ${G}_${LG}//   ${G}_${LG}//   ${G}_${LG}//    ${G}_${LG}// ${G}_${LG}//   ${G}_${LG}//  ${NC} 
	 ${G}          _${LG}//  ${G}_${LG}////// ${G}_${LG}//  ${G}_${LG}//    ${G}_${LG}//${G}_${LG}////// ${G}_${LG}//  ${NC}
	 ${G}    _${LG}//    ${G}_${LG}//${G}_${LG}//       ${G}_${LG}// ${G}_${LG}//   ${G}_${LG}//${G}_${LG}//       ${G}_${LG}//${NC} 
	 ${G}      _${LG}// // ${G}_${LG}//         ${G}_${LG}//${G}_${LG}/////  ${G}_${LG}//         ${G}_${LG}//${NC}
                                                     ${BW}${UW}Ver "$ver"${NC}             
                             
     ${R} +-----------------------------------------------------------+${NC}
     ${R} |${NC}  ${Y}1${NC}.  Subdomain finder                                     ${R}|${NC}
     ${R} |${NC}  ${Y}2${NC}.  Host Header Attack Scan                              ${R}|${NC}
     ${R} |${NC}  ${Y}3${NC}.  CRLF Injection Scan                                  ${R}|${NC}
     ${R} |${NC}  ${Y}4${NC}.  Open Redirect Scan                                   ${R}|${NC}
     ${R} |${NC}  ${Y}5${NC}.  Option Bleed Scan (Experimental)                     ${R}|${NC}
     ${R} |${NC}  ${Y}6${NC}.  Scanning Option                                      ${R}|${NC}
     ${R} |${NC}  ${Y}0${NC}.  About SADA                                           ${R}|${NC}
     ${R} |${NC}  ${R}q${NC}.  Quit                                                 ${R}|${NC}
     ${R} +-----------------------------------------------------------+${NC}
"

read -r -p "[-] (Your choice?):" choice
case $choice in
1) sub_sc ;;
2) hha_s ;;
3) crlf_s;;
4) oprd_sc;;
5) op_bl;;
6) sc_op;;
0) abo_ut ;;
q|Q) sh_exit ;;
*) echo -ne ${RB}${UW}"\"$choice\"${NC} is not a valid choice"\\n; sleep 2; clear ;;
esac
main_man
}
main_man
