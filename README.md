# Skyper's Blog

[![Build Status](https://travis-ci.org/SkypLabs/blog.skyplabs.net.svg?branch=gh-pages)](https://travis-ci.org/SkypLabs/blog.skyplabs.net) [![Dependency Status](https://gemnasium.com/badges/github.com/SkypLabs/blog.skyplabs.net.svg)](https://gemnasium.com/github.com/SkypLabs/blog.skyplabs.net) [![Known Vulnerabilities](https://snyk.io/test/github/SkypLabs/blog.skyplabs.net/badge.svg)](https://snyk.io/test/github/SkypLabs/blog.skyplabs.net)

My personal [blog][blog] using [Jekyll][jekyll].

## How to

### Set up a development environment

The fastest way to set up a development environment is to use [Docker][docker] through [Docker Compose][docker-compose]:

    docker-compose up -d

After that, a local instance of this blog will be available at [http://localhost:4000/](http://localhost:4000/).

### Update the `Gemfile.lock`

To update the `Gemfile.lock`:

    bundle update

If `bunble` is not installed on your system, you can execute it through the Docker container:

    # To build the Docker image if not already done.
    docker-compose build
    docker run --rm -v $(pwd):/usr/src/app:z --entrypoint=bundle blogskyplabsnet_skyplabs-blog update

## License

All the articles and images are [CC BY-NC 4.0][CC] licensed. The rest is [MIT][MIT] licensed.

 [blog]: http://blog.skyplabs.net
 [docker]: https://www.docker.com/
 [docker-compose]: https://docs.docker.com/compose/
 [jekyll]: http://jekyllrb.com/
 [CC]: http://creativecommons.org/licenses/by-nc/4.0/
 [MIT]: http://opensource.org/licenses/MIT
