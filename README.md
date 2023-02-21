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
