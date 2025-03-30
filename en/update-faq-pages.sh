#!/bin/bash

# Count FAQ posts
FAQ_COUNT=$(ls _posts/*dyslexia-faq*.md | wc -l)

# Calculate number of pages needed (5 posts per page)
PAGES_NEEDED=$(( (FAQ_COUNT + 4) / 5 ))

# Create directory if it doesn't exist
mkdir -p dyslexia-faq

# Copy page2.html as template for new pages
for ((i=3; i<=PAGES_NEEDED; i++)); do
    if [ ! -f "dyslexia-faq/page${i}.html" ]; then
        cp dyslexia-faq/page2.html "dyslexia-faq/page${i}.html"
        
        # Update the page number and title in the new file
        sed -i '' "s/page_number: 2/page_number: ${i}/" "dyslexia-faq/page${i}.html"
        sed -i '' "s/Page 2/Page ${i}/" "dyslexia-faq/page${i}.html"
        sed -i '' "s/page2/page${i}/" "dyslexia-faq/page${i}.html"
    fi
done

# Remove any extra pages that are no longer needed
for ((i=PAGES_NEEDED+1; i<=10; i++)); do
    if [ -f "dyslexia-faq/page${i}.html" ]; then
        rm "dyslexia-faq/page${i}.html"
    fi
done

echo "FAQ posts: $FAQ_COUNT"
echo "Pages needed: $PAGES_NEEDED"
echo "Pagination setup complete!" 