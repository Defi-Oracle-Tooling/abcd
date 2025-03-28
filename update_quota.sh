#!/bin/bash
# This script updates the quota value of a given SKU and Region in the quota_defaults.csv file.
# Usage: ./update_quota.sh "SKU" "Region" new_quota

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 \"SKU\" \"Region\" new_quota"
    exit 1
fi

sku="$1"
region="$2"
new_quota="$3"
file="quota_defaults.csv"

# Create a temporary file and update the matching row.
awk -F, -v sku="$sku" -v region="$region" -v quota="$new_quota" 'BEGIN {OFS=","}
NR==1 { print; next }
$1==sku && $2==region { $3 = quota }
{ print }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

echo "Updated quota for [$sku, $region] to $new_quota."