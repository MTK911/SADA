#!/bin/bash
#set -xv
##~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#
#                                        #
#    SADA Web Application Testing tool   #
#             Written by MTK             #
#               Ver {0.3}                #
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
echo -ne ${G}"Starting test"${NC}
echo ''
sub_sc_list
else
echo -ne ${R}"Domain down or doesn't exists"${NC}
sleep 2
main_man
fi
}
sub_sc_list () {
cat names.txt | while read -r LINE
do
if ping -w 2 -q -c 1 "$LINE.$dom" 2>/dev/null | grep -q 'bytes'
then
echo -ne ${G}"$LINE.$dom"${NC}
echo ''
echo -ne "$LINE.$dom\\n" >> subdomains
else
echo -ne ${NC}
fi
done
main_man
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
                                                     ${BW}${UW}Ver 0.3${NC}             
                             
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
clear

echo -ne "        Bringing simplicity back"
echo -ne "
##~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#
#                                        #
#    SADA Web Application Testing tool   #
#             Written by MTK             #
#               Ver {0.3}                #
#----------------------------------------#
#     Created by Open Source shared      #
#            as Open source              #
#    www.mtk911.cf | mtk_911@yahoo.com	 #
#                                        #
#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~#~##






"
cat subdomains > report_$(date +%F-%H:%M).txt
echo '' > subdomains
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
                                                     ${BW}${UW}Ver 0.3${NC}             
                             
     ${R} +-----------------------------------------------------------+${NC}
     ${R} |${NC}  1.  Subdomain finder                                     ${R}|${NC}
     ${R} |${NC}  2.  Host Header Attack tests (Located subdomains)        ${R}|${NC}
     ${R} |${NC}  3.  Host Header Attack tests (Manual)                    ${R}|${NC}
     ${R} |${NC}  0.  About SADA                                           ${R}|${NC}
     ${R} |${NC}  q.  Quit                                                 ${R}|${NC}
     ${R} +-----------------------------------------------------------+${NC}
"

read -r -p "[-] (Your choice?):" choice
case $choice in
1) sub_sc ;;
2) hha_asc ;;
3) hha_msc ;;
0) abo_ut ;;
q) sh_exit ;;
*) echo -ne ${RB}${UW}"\"$choice\"${NC} is not a valid choice"\\n; sleep 2; clear ;;
esac
}
clear
main_man
