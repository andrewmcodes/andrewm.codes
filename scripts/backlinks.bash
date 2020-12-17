term=$(xclip -selection clipboard -o | xargs basename |  cut -f 1 -d '.')
rg -e "\[.*\]\(.*$term\.md\)" -e "\[\[$term\]\]" -e "\[\[$term.*\]\]" \
~/src/production/andrewm-codes-website/src/_posts/notes \
-t markdown -ol
