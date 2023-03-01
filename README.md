Multi-stage builds
==================

This is an example application to demonstrate one possible use case for a
multi-stage docker build. An example that, we hope, is a reasonable candidate
for a containerized workflow has been selected.  The example used is a
statically generated website, with an added search feature. 

Assuming that we want to eventually serve the site, the example would include at
least the following steps:
+ Generate a search index
+ Build the site
+ Serve the site


# Usage 

Quickstart usage guide for this repository

Generate the certificates:

```sh 
make generate_certs
```

Host the site locally. Note the `up` target is simply a wrapper for the 
docker-compose up command. This will build and run an nginx container 
as a foreground process. The logs are redirected to stdout and stderr. 

```sh 
(sudo) make up
```

To stop the container, 
```sh 
(sudo) make down
```


To remove the image
```sh 
(sudo) make rmi
```





# Generate the search index

The blog consists of webpages that can be served statically. The content of
these pages is described in plain text files in the markdown format. This makes
it relatively easy to generate a search index. Basically we want to recursively
walk the content directory tree, read any files and use the front matter,
content and metadata of each file to populate our index.

```bash
blog/content/
├── _index.md
├── page
│   └── about.md
├── post
│   ├── 2022-03-01-multi-stage-builds.md
│   ├── 2022-11-30-k8s-applications.md
│   ├── 2023-01-16-containers.md
│   ├── 2023-01-19-kubernetes.md
│   ├── 2023-02-03-docker-compose.md
│   └── 2023-02-20-gitflow.md
└── search
    └── _index.md

4 directories, 9 files
```

The files will be parsed into an array of json objects with the following
atrributes. Note that the tags field is just included for sake of completeness.
We're not using tags in this example, so it will be empty and excluded from our
final index.

```json
{"title":"...",
 "tags":"...",
 "href":"...",
 "content":"..."}
```

The following [github gist](https://gist.github.com/sebz/efddfc8fdcb6b480f567)
provided an excellent basis for what we want to do here. It required only a few
tiny modifications to the gruntfile to generate the index. The gruntfile is a
node js script that contains a task with the specific function of creating the
index.

The generation of the index is encapsulated in the first stage in our
Dockerfile:

```Dockerfile
# Generate the index
FROM node:16-alpine AS indexer
WORKDIR /opt/blog-search
COPY . .
RUN npm install -g grunt-cli \
 && npm install \
 && grunt lunr-index
```

The image used while creating the image is the node:16-alpine image. A "small"
version of the node LTS image. The size of this image is 996MB. While we need to
spin up a container using this image in order to run the program that generates
our index, the index itself is all we need in production. As outlined above, the
site is purely static, so all content being served is known ahead of time. The
actual size of the index of this content is ~1M. 

Multi-stage builds give us the option of simply copying exactly this sliver of
data out of the image once it has been built. Thus reducing the space
requirements by a factor of 1000.

# Build the site

We want to include the index that we just built in the public folder of the site
that we are building. Docker's `COPY` directive allows us to do this:

```Dockerfile
# Build the site
FROM klakegg/hugo:0.101.0-busybox AS builder
WORKDIR /opt/blog-search
COPY --from=indexer /opt/blog-search/ .
WORKDIR /opt/blog-search/blog
RUN hugo
```

The hugo docker image comes in at a reasonably small 53MB. Again though, the
actual content that we are creating is around ~1M. We can simply copy this
sliver of data in the next step. In order to be able to do this effectively, we
need to clearly label each stage of the multi-stage Dockerfile.

# Serve the site

Let's assume that we want to serve the site in a production-ready container.
Typically we would use a production grade server like nginx or apache. Full
disclosure: I'm still making the transition from someone who can scrap together
a webpage with html/css/js and someone who actually understands how the thing
gets served over the internet. The type of setup you see specified 
The nginx config used in this example was tweaked from the example shown [here](https://git.thelyoncompany.com/edwin/nginxconfig/src/branch/master/sites-enabled/default) 
by Edwin Lyon.

Anyway, we're just using the example to illustrate a point about layering during
the docker build process. The `nginx:1.13.3-alpine` image weighs in at a
feathery 40.7MB. 


```Dockerfile
FROM nginx:1.23.3-alpine AS server
COPY --from=builder /opt/blog-search/blog/public/ /var/www/html/public/
EXPOSE 443/tcp
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
```

# Space savings 

If we included all three layers in a single docker file:

| image                | size (MB) |
| ----------           | -------   |
| Node LTS:16-alpine   | 117.0     |
| PagesIndex.json      | 000.026   |
| hugo:0.101.0-busybox | 053.0     |
| public/              | 008.9     |
| nginx:1.23.0-alpine  | 040.7     |
| ----------           | -------   |
| Total                | 219.63    |


A layered approach produces an image that is less than a quarter in size: 

| image                | size (MB) |
| ----------           | -------   |
| PagesIndex.json      | 000.026   |
| public/              | 008.9     |
| nginx:1.23.0-alpine  | 040.7     |
| ----------           | -------   |
| Total                | 049.626   |
