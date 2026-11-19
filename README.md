# Cyber-security-Reconnaissance-tools
This is my 2nd Project
# networkwalks-recon

A small reconnaissance toolkit for cybersecurity practice. It chains common recon tools against a target domain (default: `networkwalks.com`) and saves each tool's output to a timestamped folder.

> **Legal notice:** Use only on domains you own or have **written authorization** to test. Unauthorized scanning may be illegal. The author accepts no liability for misuse.

## Tools used

| Phase | Tool | Purpose |
|---|---|---|
| Registration | `whois` | Registrar, dates, name servers |
| DNS | `nslookup`, `dig` | A/AAAA/MX/NS/TXT/SOA records, delegation trace |
| HTTP | `curl` | Headers, redirects, robots.txt, sitemap.xml, security.txt |
| Fingerprinting | `whatweb` | CMS, server, frameworks, versions |
| Defenses | `wafw00f` | Web Application Firewall detection |
| OSINT | `theHarvester` | Subdomains, emails, hosts (passive sources) |

## Install (Kali / Debian / Ubuntu)

```bash
sudo apt update
sudo apt install -y whois dnsutils curl whatweb wafw00f theharvester
```

## Usage

```bash
git clone https://github.com/<Sunilkashyap05>/networkwalks-recon.git
cd networkwalks-recon
chmod +x recon.sh
./recon.sh                 # defaults to networkwalks.com
./recon.sh example.com     # any other authorized target
```

Output lands in `results/<domain>_<timestamp>/`.

## Manual commands

```bash
whois networkwalks.com
nslookup -type=any networkwalks.com
dig networkwalks.com MX +short
curl -sIL https://networkwalks.com
whatweb -a 1 -v networkwalks.com
wafw00f https://networkwalks.com
theHarvester -d networkwalks.com -b crtsh,duckduckgo
```

## Repo structure

```
networkwalks-recon/
├── recon.sh
├── README.md
├── LICENSE
├── .gitignore
├── docs/methodology.md
└── results/            # scan output (git-ignored)
```

## Publish to GitHub

```bash
git init
git add .
git commit -m "Initial commit: recon toolkit"
git branch -M main
git remote add origin https://github.com/<your-username>/networkwalks-recon.git
git push -u origin main
```

## License
MIT

