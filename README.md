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

The gems' version in the `Gemfile.lock` file should match those of [GitHub Pages][github-pages-versions].

### Verify the validity of the generated HTML source code

To verify the validity of the generated HTML source code:

    ./scripts/cibuild

If `bundle`, `jekyll` or `htmlproofer` are not installed on your system, you can execute the script through the Docker container:

    # To build the Docker image if not already done.
    docker-compose build
    docker run --rm -v $(pwd):/usr/src/app:z --entrypoint=bash blogskyplabsnet_skyplabs-blog ./scripts/cibuild

## Publishing a new post

Below are the different steps to do before publishing a new post:

1. Update Ruby's version to the one used by [GitHub Pages][github-pages-versions]
2. Update the dependences
3. Verify that Jekyll can generate the HTML source code
4. Verify the validity of the generated HTML source code
5. Set up a development environment and check if everything looks good

Steps `3` and `4` can be done by using the `./scripts/cibuild` script.

## License

All the articles and images are [CC BY-NC 4.0][CC] licensed. The rest is [MIT][MIT] licensed.

 [blog]: http://blog.skyplabs.net
 [docker]: https://www.docker.com/
 [docker-compose]: https://docs.docker.com/compose/
 [github-pages-versions]: https://pages.github.com/versions/
 [jekyll]: http://jekyllrb.com/
 [CC]: http://creativecommons.org/licenses/by-nc/4.0/
 [MIT]: http://opensource.org/licenses/MIT
