# Generate the index
FROM node:16-alpine AS indexer
WORKDIR /opt/blog-search
COPY . .
RUN npm install -g grunt-cli \
 && npm install \
 && grunt lunr-index

# Build the site
FROM klakegg/hugo:0.101.0-busybox AS builder
WORKDIR /opt/blog-search
COPY --from=indexer /opt/blog-search/ .
WORKDIR /opt/blog-search/blog
RUN hugo

# Serve the site
FROM nginx:1.25.4-alpine AS server
COPY --from=builder /opt/blog-search/blog/public/  /var/www/html/public/
EXPOSE 6443/tcp
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
