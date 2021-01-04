# Skyper's Blog

[![Master Branch Build Status](https://img.shields.io/travis/com/SkypLabs/blog.skyplabs.net/master.svg?label=master&logo=travis&style=flat)](https://travis-ci.com/SkypLabs/blog.skyplabs.net) [![Develop Branch Build Status](https://img.shields.io/travis/com/SkypLabs/blog.skyplabs.net/develop.svg?label=develop&logo=travis&style=flat)](https://travis-ci.com/SkypLabs/blog.skyplabs.net)

**No more maintained - New blog repository available at
https://github.com/SkypLabs/personal-blog**

My personal [blog][blog] made with [Jekyll][jekyll].

## How to

### Set up a development environment

The fastest way to set up a development environment is to use [Docker][docker] through [Docker Compose][docker-compose]:

    docker-compose up -d

After that, a local instance of this blog will be available at [http://localhost:4000/](http://localhost:4000/).

### Update `Gemfile.lock`

To update `Gemfile.lock`:

    bundle lock --update

If `bundle` is not installed on your system, you can execute it through the Docker container:

    # To build the Docker image if not already done.
    docker-compose build
    docker run --rm -v $(pwd):/usr/src/app:z blogskyplabsnet_skyplabs-blog bundle lock --update

The gems' version in the `Gemfile.lock` file should match those of [GitHub Pages][github-pages-versions].

### Update `yarn.lock`

To update `yarn.lock`:

    yarn upgrade

If `yarn` is not installed on your system, you can execute it through the Docker container:

    # To build the Docker image if not already done.
    docker-compose build
    docker run --rm -v $(pwd):/usr/src/app:z blogskyplabsnet_skyplabs-blog yarn upgrade

### Verify the validity of the generated HTML source code

To verify the validity of the generated HTML source code:

    bundle exec rake

If `bundle`, `jekyll` or `htmlproofer` are not installed on your system, you can execute the script through the Docker container:

    # To build the Docker image if not already done.
    docker-compose build
    docker run --rm -v $(pwd):/usr/src/app:z blogskyplabsnet_skyplabs-blog bundle exec rake

## Publishing a new post

Below are the different steps to do before publishing a new post:

1. Update Ruby's version in `Dockerfile` and in `.travis.yml` to match the one used by [GitHub Pages][github-pages-versions]
2. Update `Gemfile.lock`
3. Update `yarn.lock`
4. Verify that Jekyll can generate the HTML source code
5. Verify the validity of the generated HTML source code
6. Set up a development environment and check if everything looks good
7. Update the version number in `package.json`

Steps `4` and `5` can be done by using `bundle exec rake`.

## License

All the articles and images are [CC BY-NC 4.0][CC] licensed. The rest is [MIT][MIT] licensed.

 [blog]: https://blog.skyplabs.net
 [docker]: https://www.docker.com/
 [docker-compose]: https://docs.docker.com/compose/
 [github-pages-versions]: https://pages.github.com/versions/
 [jekyll]: https://jekyllrb.com/
 [CC]: https://creativecommons.org/licenses/by-nc/4.0/
 [MIT]: https://opensource.org/licenses/MIT
