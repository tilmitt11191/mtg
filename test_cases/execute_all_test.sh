
#bash
find . -name "*.rb" -print0 | xargs -0 -I% ruby %
