#!/bin/bash

# Check if content file is provided
if [ -z "$1" ]; then
    echo "Usage: ./create-faq-post.sh <content-file.md>"
    exit 1
fi

CONTENT_FILE="$1"

# Check if content file exists
if [ ! -f "$CONTENT_FILE" ]; then
    echo "Error: Content file '$CONTENT_FILE' not found"
    exit 1
fi

# Get today's date
TODAY=$(date +%Y-%m-%d)

# Find the highest FAQ number
MAX_NUM=$(ls _posts/*dyslexia-faq-*.md 2>/dev/null | sed -n 's/.*dyslexia-faq-\([0-9]*\)\.md/\1/p' | sort -n | tail -n 1)

# If no existing files, start at 1
if [ -z "$MAX_NUM" ]; then
    MAX_NUM=0
fi

# Calculate next number
NEXT_NUM=$((MAX_NUM + 1))

# Create new filename
NEW_FILE="_posts/${TODAY}-dyslexia-faq-${NEXT_NUM}.md"

# Create temporary file
TMP_FILE=$(mktemp)

{
    # Output first --- line
    echo "---"
    
    # Add permalink
    echo "permalink: /dyslexia-faq/${NEXT_NUM}/"
    
    # Extract and clean up frontmatter
    awk '
        BEGIN { in_front=0; first=1 }
        /^---$/ {
            if (first) {
                in_front=1;
                first=0;
                next;
            }
            if (in_front) {
                in_front=0;
                exit;
            }
        }
        in_front && !/^permalink:/ && NF { print }
    ' "$CONTENT_FILE" | sed '/^$/N;/^\n$/D'
    
    # Close frontmatter
    echo "---"
    echo ""
    
    # Add content (everything after the second ---)
    awk '
        BEGIN { count=0 }
        /^---$/ { count++; next }
        count >= 2 && NF { print }
    ' "$CONTENT_FILE"
} > "$TMP_FILE"

# Move temporary file to final location
mv "$TMP_FILE" "$NEW_FILE"

# Remove original file
rm "$CONTENT_FILE"

echo "Created new FAQ post: $NEW_FILE"

# Update FAQ pages
echo "Updating FAQ pages..."
./update-faq-pages.sh 