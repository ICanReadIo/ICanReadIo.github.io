docker run --platform linux/amd64 -v $(pwd):/app -p 4000:4000 jekyll-site bundle exec jekyll serve --host 0.0.0.0 --watch --livereload