yard && \
cd doc && \
rm -rf doc/phpdoc-cache-* && \
git init . && \
git add . && \
git commit -m "Update documentation."; \
git push "git@github.com:prismicio/ruby-kit.git" master:gh-pages --force && \
rm -rf .git

