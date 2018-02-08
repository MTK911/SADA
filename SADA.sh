#!/bin/bash
#set -xv
##~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#
#                                        #
#    SADA Web Application Testing tool   #
#             Written by MTK             #
#               Ver {0.5}                #
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

ver="0.5"

control_c()
# Catch the ctrl+c
{
  echo ''
  echo -ne "Ctrl+c detected falling back\\n"
  main_man
}
 
# trap keyboard interrupt (control-c)
trap control_c SIGINT



#subdomain scan tester
sub_sc () {
clear
#dead_or_alive
read -r -p "Enter domain name {xyz.com}: " dom
echo ''
if ping -w 2 -q -c 1 "$dom" 2>/dev/null | grep -q 'bytes' 
then
sub_men
else
echo -ne ${R}"Domain down or doesn't exists"${NC}
sleep 2
sub_sc
fi

}

#list_selection_menu
sub_men () {
echo -ne "${Y}[1]${NC} Use built-in subdomain list\\n${Y}[2]${NC} Use custom subdomain list \\n${Y}[3]${NC} Enter subdomain names to scan \\n${Y}[4]${NC} Go back to menu \\nChoose scan option [1-4]: "
read -r sel
if [ "$sel" = '1' ]; then
sub_aut
elif [ "$sel" = '2' ]; then
sub_cust
elif [ "$sel" = '3' ]; then
sub_man
elif [ "$sel" = '4' ]; then
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
if ping -w 2 -q -c 1 "$LINE.$dom" 2>/dev/null | grep -q 'bytes'
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
echo -ne "Enter custom subdomain list location [/path/to/my/list.txt]: "
read -r  culist
if [ ! -f "$culist" ]; then
echo -ne ${R}"File not found!\\n"${NC}
sub_cust
else
cat "$culist" | while read -r LINE
do
if ping -w 2 -q -c 1 "$LINE.$dom" 2>/dev/null | grep -q 'bytes'
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

echo "Enter subdomain names seprated by space [www mail support]: "
read -a catch
for LINE in ${catch[@]}
do
if ping -w 2 -q -c 1 "$LINE.$dom" 2>/dev/null | grep -q 'bytes'
then
echo -ne ${G}"$LINE.$dom"${NC}
echo ''
echo -ne "$LINE.$dom\\n" >> subdomains
fi
done
sleep 3
main_man
}


#Host_Header_Attack_Scan_Selection
hha_s () {
clear
echo -ne "${Y}[1]${NC} Host Header Attack Scan (Located subdomains)\\n${Y}[2]${NC} Host Header Attack Scan (Manual) \\n${Y}[3]${NC} Go back to menu \\nChoose scan option [1-3]: "
read -r sel
if [ "$sel" = '1' ]; then
hha_asc
elif [ "$sel" = '2' ]; then
hha_msc
elif [ "$sel" = '3' ]; then
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
if curl -s -k -m 2 -H "Host: "$dom"" -H "X-Forwarded-Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -k -m 2 -H 'Host: "$dom"' -H 'X-Forwarded-Host: evil.com' "$dom""${NC}
echo ''
curl -s -k -m 2 -H "Host: "$dom"" -H "X-Forwarded-Host: evil.com" "$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"X-Forwaded-Host header test"${NC}
echo ''
if curl -s -k -I -m 2 -H "Host: "$dom"" -H "X-Forwarded-Host: evil.com" "$dom" | grep -q 'evil'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -k -I -m 2 -H 'Host: "$dom"' -H 'X-Forwarded-Host: evil.com' "$dom""${NC}
echo ''
curl -s -k -I -m 2 -H "Host: "$dom"" -H "X-Forwarded-Host: evil.com" "$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Host header attack link pollution test"${NC}
echo ''
if curl -s -k -m 2 -H "Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -k -m 2 -H 'Host: evil.com' "$dom""${NC}
echo ''
curl -s -k -m 2 -H "Host: evil.com" "$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi

echo -ne ${B}"Host Header attack header test"${NC}
echo ''
if curl -s -k -I -m 2 -H "Host: evil.com" "$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -k -I -m 2 -H 'Host: evil.com' "$dom""${NC}
echo ''
curl -s -k -I -m 2 -H "Host: evil.com" "$dom" 
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Trace method test (XST)"${NC}
echo ''
if curl -s -I -m 2 -X TRACE "$dom" | grep -q '200 OK'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -I -m 2 -X TRACE "$dom""${NC}
echo ''
curl -s -I -m 2 -X TRACE "$dom"
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
read -r -p "Enter domain name {xyz.com}: " dom
read -r -p "Enter Sub-domain name {www}: " sub
if [ "$sub" = '' ]; then
sub=''
else
subdot=$(echo -ne $sub.)
fi

echo -ne ${B}"X-Forwaded-Host link pollution test"${NC}
echo ''
if curl -s -k -m 2 -H "Host: "$subdot$dom"" -H "X-Forwarded-Host: evil.com" "$subdot$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -k -m 2 -H 'Host: "$subdot$dom"' -H 'X-Forwarded-Host: evil.com' "$subdot$dom""${NC}
echo ''
curl -s -k -m 2 -H "Host: "$subdot$dom"" -H "X-Forwarded-Host: evil.com" "$subdot$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"X-Forwaded-Host header test"${NC}
echo ''
if curl -s -k -I -m 2 -H "Host: "$subdot$dom"" -H "X-Forwarded-Host: evil.com" "$subdot$dom" | grep -q 'evil'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -k -I -m 2 -H 'Host: "$subdot$dom"' -H 'X-Forwarded-Host: evil.com' "$subdot$dom""${NC}
echo ''
curl -s -k -I -m 2 -H "Host: "$subdot$dom"" -H "X-Forwarded-Host: evil.com" "$subdot$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Host header attack link pollution test"${NC}
echo ''
if curl -s -k -m 2 -H "Host: evil.com" "$subdot$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -k -m 2 -H 'Host: evil.com' "$subdot$dom""${NC}
echo ''
curl -s -k -m 2 -H "Host: evil.com" "$subdot$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi


echo -ne ${B}"Host Header attack header test"${NC}
echo ''
if curl -s -k -I -m 2 -H "Host: evil.com" "$subdot$dom" | grep -q 'evil'
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -k -I -m 2 -H 'Host: evil.com' "$subdot$dom""${NC}
echo ''
curl -s -k -I -m 2 -H "Host: evil.com" "$subdot$dom" 
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi

echo -ne ${B}"Trace method test (XST)"${NC}
echo ''
if curl -s -I -m 2 -X TRACE "$subdot$dom" | grep -q '200 OK'
then
echo ''
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}"curl -s -I -m 2 -X TRACE "$subdot$dom""${NC}
echo ''
curl -s -I -m 2 -X TRACE "$subdot$dom"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
sleep 3
echo ''
main_man
}

# CRLF_Injection_Scan_Selection
crlf_s () {
clear
echo -ne "${Y}[1]${NC} CRLF Injection Scan (Located subdomains)\\n${Y}[2]${NC} CRLF Injection Scan (Manual) \\n${Y}[3]${NC} Go back to menu \\nChoose scan option [1-3]: "
read -r sel
if [ "$sel" = '1' ]; then
crlf_asc
elif [ "$sel" = '2' ]; then
crlf_msc
elif [ "$sel" = '3' ]; then
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
echo -ne ${Y}" Testing "$dom" "${NC}
echo ''
echo -ne ${B}"CRLF injection test"${NC}
echo ''
if curl -s -k -I -m 2 "$dom/%0d%0acustom_header:so_evil" | grep -q "\<custom_header: so_evil\>\|\<custom_header:so_evil\>"
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}curl -I -s -k -m 2 "$dom/%0d%0aCustom_Header:so_evil"${NC}
echo ''
curl -I -s -k -m 2 "$dom/%0d%0aCustom_Header:so_evil"
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
read -r -p "Enter domain name {xyz.com}: " dom
read -r -p "Enter Sub-domain name {www}: " sub
if [ "$sub" = '' ]; then
sub=''
else
subdot=$(echo -ne $sub.)
fi

echo -ne ${B}"CRLF injection test"${NC}
echo ''
if curl -I -s -k -m 2 "$subdot$dom/%0d%0acustom_header:so_evil" | grep -q "\<custom_header: so_evil\>\|\<custom_header:so_evil\>"
then
echo -ne ${R}"Vulnerable"${NC}
echo ''
echo -ne ${Y}curl -I -s -k -m 2 "$subdot$dom/%0d%0aCustom_Header:so_evil"${NC}
echo ''
curl -I -s -k -m 2 "$subdot$dom/%0d%0aCustom_Header:so_evil"
echo ''
else
echo -ne ${G}"Not Vulnerable"${NC}
echo ''   
fi
sleep 3
echo ''
main_man
}

#OPTION_BLEED_SCAN {EXPERIMENTAL} (https://blog.fuzzing-project.org/60-Optionsbleed-HTTP-OPTIONS-method-can-leak-Apaches-server-memory.html)
op_bl () {
read -r -p "Enter domain name {xyz.com}: " dom
read -r -p "Enter Sub-domain name {www}: " sub
if [ "$sub" = '' ]; then
sub=''
else
subdot=$(echo -ne $sub.)
fi

echo -ne ${B}"Option Bleed test experimental"${NC}
echo ''

for i in {1..100}; do curl -sI -X OPTIONS $subdot$dom/|grep -i "allow:"; done

sleep 5
echo ''
main_man

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
                 @ ${R}mtk_911@yahoo.com${NC} or ${R}http://fb.com/MTK911${NC}"
echo ""
echo ""
echo ""
echo ""
echo ""
sleep 5
main_man
}

#Emergency exit here
sh_exit () {

read -r -p "Do you want to save Located subdomains?[y|n]: " ask
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
echo -ne "        Bringing simplicity back"
echo -ne "
##~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#
#                                        #
#    SADA Web Application Testing tool   #
#             Written by MTK             #
#               Ver {"$ver"}                #
#----------------------------------------#
#     Created by Open Source shared      #
#            as Open source              #
#    www.mtk911.cf | mtk_911@yahoo.com	 #
#                                        #
#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~##

"
exit
}
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
     ${R} |${NC}  1.  Subdomain finder                                     ${R}|${NC}
     ${R} |${NC}  2.  Host Header Attack Scan                              ${R}|${NC}
     ${R} |${NC}  3.  CRLF Injection Scan                                  ${R}|${NC}
     ${R} |${NC}  4.  Option Bleed Scan (Experimental)                     ${R}|${NC}
     ${R} |${NC}  0.  About SADA                                           ${R}|${NC}
     ${R} |${NC}  q.  Quit                                                 ${R}|${NC}
     ${R} +-----------------------------------------------------------+${NC}
"

read -r -p "[-] (Your choice?):" choice
case $choice in
1) sub_sc ;;
2) hha_s ;;
3) crlf_s;;
4) op_bl;;
0) abo_ut ;;
q|Q) sh_exit ;;
*) echo -ne ${RB}${UW}"\"$choice\"${NC} is not a valid choice"\\n; sleep 2; clear ;;
esac
}
main_man
