#!/bin/bash

# BLACKSITE OSINT v2.6
# Author: Inayat Hussain Chohan
# Feature: LinkedIn Enumeration Added (via Google Dorks + First Names Option)

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Welcome to BLACKSITE OSINT v2.6${NC}"
read -p "Enter target company name (e.g., tesla.com or Tesla): " TARGET
read -p "Enter company keyword for LinkedIn (e.g., Tesla or 'Tesla Inc.'): " COMPANY_KEYWORD

OUTFILE="report_${TARGET}.txt"
echo "OSINT Report for: $TARGET" > $OUTFILE
echo "Generated on: $(date)" >> $OUTFILE
echo "---------------------------------" >> $OUTFILE

function open_url() {
    if command -v termux-open-url &> /dev/null; then
        termux-open-url "$1" >/dev/null 2>&1
    elif command -v xdg-open &> /dev/null; then
        xdg-open "$1" >/dev/null 2>&1
    elif command -v open &> /dev/null; then
        open "$1" >/dev/null 2>&1
    elif command -v start &> /dev/null; then
        start "$1" >/dev/null 2>&1
    else
        echo "[-] Could not open URL automatically. Please open manually: $1"
    fi
}

# Email Search
echo -e "\n[+] Searching for public emails..." | tee -a $OUTFILE
EMAIL_GOOGLE="https://www.google.com/search?q=%22@$TARGET%22+email"
HUNTER="https://hunter.io/search/$TARGET"
echo "$EMAIL_GOOGLE" | tee -a $OUTFILE
echo "$HUNTER" | tee -a $OUTFILE
open_url "$EMAIL_GOOGLE"
open_url "$HUNTER"

# GitHub Repos
echo -e "\n[+] Searching GitHub for repositories mentioning $TARGET..." | tee -a $OUTFILE
GH_URL="https://github.com/search?q=$TARGET&type=repositories"
echo "$GH_URL" | tee -a $OUTFILE
open_url "$GH_URL"

# Leaks Databases
echo -e "\n[+] Checking public breach databases..." | tee -a $OUTFILE
HIBP="https://haveibeenpwned.com/"
INTELX="https://intelx.io/"
PASTEBIN="https://pastebin.com/search?q=$TARGET"
echo "$HIBP" | tee -a $OUTFILE
echo "$INTELX" | tee -a $OUTFILE
echo "$PASTEBIN" | tee -a $OUTFILE
open_url "$HIBP"
open_url "$INTELX"
open_url "$PASTEBIN"

# Social Media OSINT
echo -e "\n[+] Social Media OSINT..." | tee -a $OUTFILE
LINKEDIN="https://www.linkedin.com/search/results/people/?keywords=$COMPANY_KEYWORD"
TWITTER="https://twitter.com/search?q=$COMPANY_KEYWORD"
FACEBOOK="https://www.facebook.com/search/top/?q=$COMPANY_KEYWORD"
INSTAGRAM="https://www.instagram.com/explore/tags/${COMPANY_KEYWORD// /}%20"
echo "$LINKEDIN" | tee -a $OUTFILE
echo "$TWITTER" | tee -a $OUTFILE
echo "$FACEBOOK" | tee -a $OUTFILE
echo "$INSTAGRAM" | tee -a $OUTFILE
open_url "$LINKEDIN"
open_url "$TWITTER"
open_url "$FACEBOOK"
open_url "$INSTAGRAM"

# ✅ LinkedIn Enumeration with Google Dorks
echo -e "\n[+] LinkedIn Enumeration (Google Dorks):" | tee -a $OUTFILE
DORK1="https://www.google.com/search?q=site:linkedin.com/in+%22$COMPANY_KEYWORD%22"
DORK2="https://www.google.com/search?q=site:linkedin.com/in+%22$COMPANY_KEYWORD%22+AND+(email+OR+contact)"
DORK3="https://www.google.com/search?q=site:linkedin.com/in+%22$COMPANY_KEYWORD%22+AND+(IT+OR+admin+OR+developer)"
echo "$DORK1" | tee -a $OUTFILE
echo "$DORK2" | tee -a $OUTFILE
echo "$DORK3" | tee -a $OUTFILE
open_url "$DORK1"
open_url "$DORK2"
open_url "$DORK3"

# ✅ FIRST NAME ENUMERATION via Google Dorks (Optional)
read -p "Do you want to search for LinkedIn first names? (y/n): " LINKEDIN_NAMES_CHOICE
if [[ "$LINKEDIN_NAMES_CHOICE" == "y" || "$LINKEDIN_NAMES_CHOICE" == "Y" ]]; then
    echo -e "\n[+] Searching LinkedIn for employee names..." | tee -a $OUTFILE
    DORK_NAMES="https://www.google.com/search?q=site:linkedin.com/in+%22$COMPANY_KEYWORD%22+AND+(\"engineer\"+OR+\"manager\"+OR+\"developer\")"
    echo "$DORK_NAMES" | tee -a $OUTFILE
    open_url "$DORK_NAMES"
fi

# Google Dorks - Extra
echo -e "\n[+] Suggested Google Dorks for sensitive files:" | tee -a $OUTFILE
G_DORK1="https://www.google.com/search?q=site:$TARGET+intitle:index.of"
G_DORK2="https://www.google.com/search?q=site:$TARGET+filetype:pdf+OR+filetype:doc"
G_DORK3="https://www.google.com/search?q=site:pastebin.com+$TARGET"
echo "$G_DORK1" | tee -a $OUTFILE
echo "$G_DORK2" | tee -a $OUTFILE
echo "$G_DORK3" | tee -a $OUTFILE
open_url "$G_DORK1"
open_url "$G_DORK2"
open_url "$G_DORK3"

echo -e "\n${GREEN}[+] Report saved as ${OUTFILE}${NC}"
