#!/usr/bin/env bash
# networkwalks-recon - basic reconnaissance wrapper
# Usage: ./recon.sh [domain]     (default: networkwalks.com)
# Only run against targets you own or have written permission to test.

set -u
TARGET="${1:-networkwalks.com}"
TS="$(date +%Y%m%d_%H%M%S)"
OUT="results/${TARGET}_${TS}"
mkdir -p "$OUT"

RED=$'\e[31m'; GRN=$'\e[32m'; YLW=$'\e[33m'; RST=$'\e[0m'

banner() { echo -e "\n${GRN}[+] $1${RST}"; }
have()   { command -v "$1" >/dev/null 2>&1; }
skip()   { echo "${YLW}[!] $1 not installed - skipping${RST}"; }

echo "${YLW}Authorization check${RST}"
read -r -p "Do you own or have written permission to test '$TARGET'? (yes/no): " ANS
[[ "$ANS" == "yes" ]] || { echo "${RED}Aborted.${RST}"; exit 1; }

# 1. WHOIS
banner "WHOIS"
if have whois; then whois "$TARGET" | tee "$OUT/whois.txt" >/dev/null; else skip whois; fi

# 2. DNS - nslookup
banner "DNS (nslookup)"
if have nslookup; then
  for t in A AAAA MX NS TXT SOA CNAME; do
    echo "### $t" >> "$OUT/nslookup.txt"
    nslookup -type="$t" "$TARGET" >> "$OUT/nslookup.txt" 2>&1
  done
else skip nslookup; fi

# 3. DNS - dig
banner "DNS (dig)"
if have dig; then
  dig "$TARGET" ANY +noall +answer > "$OUT/dig_any.txt"
  dig "$TARGET" +trace > "$OUT/dig_trace.txt" 2>&1
else skip dig; fi

# 4. HTTP headers & basic files via curl
banner "HTTP headers (curl)"
if have curl; then
  curl -sIL --max-time 20 "https://$TARGET" > "$OUT/curl_headers.txt"
  for f in robots.txt sitemap.xml security.txt .well-known/security.txt; do
    code=$(curl -s -o "$OUT/$(basename "$f")" -w "%{http_code}" --max-time 20 "https://$TARGET/$f")
    echo "$f -> HTTP $code" | tee -a "$OUT/curl_files.txt"
  done
else skip curl; fi

# 5. Technology fingerprinting
banner "WhatWeb"
if have whatweb; then whatweb -a 1 -v "$TARGET" > "$OUT/whatweb.txt" 2>&1; else skip whatweb; fi

# 6. WAF detection
banner "wafw00f"
if have wafw00f; then wafw00f "https://$TARGET" > "$OUT/wafw00f.txt" 2>&1; else skip wafw00f; fi

# 7. OSINT - theHarvester (passive sources)
banner "theHarvester"
HARVESTER=""
have theHarvester && HARVESTER=theHarvester
have theharvester && HARVESTER=theharvester
if [[ -n "$HARVESTER" ]]; then
  "$HARVESTER" -d "$TARGET" -b crtsh,duckduckgo,rapiddns -l 200 > "$OUT/theharvester.txt" 2>&1
else skip theHarvester; fi

banner "Done. Results saved in $OUT/"

