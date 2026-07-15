#!/bin/sh
# sync-calendars.sh — pull external calendars (vdirsyncer) and convert each
# to an Org file under ~/org/calendars/ for org-agenda. Generated files are
# overwritten every run; never hand-edit them.

export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

CALDIR="$HOME/.calendars"
ORGDIR="$HOME/org/calendars"
NAMES="$HOME/.config/vdirsyncer/icloud-names.tsv"
mkdir -p "$ORGDIR"

vdirsyncer sync >/dev/null 2>&1

# iCloud: one .ics per calendar; look up a readable name for #+CATEGORY.
for ics in "$CALDIR"/icloud/*.ics; do
  [ -s "$ics" ] || continue                       # skip empty calendars
  id=$(basename "$ics" .ics)
  name=""
  [ -f "$NAMES" ] && name=$(awk -F'\t' -v k="$id" '$1==k{print $2}' "$NAMES")
  [ -n "$name" ] || name="$id"
  out="$ORGDIR/icloud-$id.org"
  tmp=$(mktemp)
  if ical2orgpy --continue-on-error "$ics" "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
    { printf '#+CATEGORY: %s\n#+TITLE: iCloud: %s\n\n' "$name" "$name"; cat "$tmp"; } > "$out"
  else
    rm -f "$out"                                   # no events in window -> drop stale
  fi
  rm -f "$tmp"
done

# Yale (Outlook): single published-ICS calendar -> one Org file.
yics="$CALDIR/yale.ics"
if [ -s "$yics" ]; then
  tmp=$(mktemp)
  if ical2orgpy --continue-on-error "$yics" "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
    { printf '#+CATEGORY: Yale\n#+TITLE: Yale (Outlook)\n\n'; cat "$tmp"; } > "$ORGDIR/yale.org"
  else
    rm -f "$ORGDIR/yale.org"
  fi
  rm -f "$tmp"
fi
