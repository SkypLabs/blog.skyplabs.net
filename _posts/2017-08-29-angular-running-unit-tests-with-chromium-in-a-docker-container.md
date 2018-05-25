---
layout: post
title: "[Angular] Running unit tests with Chromium in a Docker container"
categories:
    - Development
tags:
    - Angular
    - Chrome
    - Chromium
    - CI
    - Docker
    - WebApp
---
Running unit tests for front-end web applications require them to be tested in a web browser. While it's not an issue on a workstation, it can become tedious when running in a restricted environment such as a Docker container. In fact, these execution environments are generally lightweight and do not contain any graphical environment.

One solution to work around this issue is to use a headless web browser designed for development purposes, like [PhantomJS][phantomjs]. While it's an elegant solution for testing an application, it would be even better to test it directly in a web browser which will be used by the end-users in order to match real conditions of use, for examples Firefox or Chromium/Google Chrome. However, as mentioned above, it is needed to find a way to execute a regular web browser in a restricted environment.

<!--more-->

The main issue is that regular web browsers need a graphical environment to be executed. A widely used workaround is to rely on [xvfb][xvfb] to provide "an X server that can run on machines with no display hardware and no physical input devices". While this method works well, it requires you to install additional software on the restricted environment and the configuration can be a bit tricky. Thankfully for us, some web browsers designed for end-users now come with a headless mode. This last one doesn't require any graphical rendering server to work. Chromium/Google Chrome has already [implemented this feature][chrome-headless] while Mozilla [is still working on it][firefox-headless] to add it to Firefox.

So, what are we waiting for? Let's create a testing environment in a Docker container! For that purpose, the testing environment will rely on the [official Node.js Docker image][docker-node] as base image and Chromium as web browser. I will suppose that you have an Angular project bootstrapped with [Angular CLI][angular-cli].

Chromium/Google Chrome is shipped with the headless mode since version 59. The official Node.js Docker image is based on Debian Jessie by default and to this date, the latest version of Chromium in Debian Jessie's repositories is 57 since it is 59 for Debian Stretch. It is possible to use an official Node.js Docker image based on Debian Stretch using the appropriate tag. In our case, `8-stretch`:

{% gist SkypLabs/aa27e9f37471280c12d75e265a067d9e Dockerfile %}

Now, it is needed to configure Karma to use Chromium with the headless mode. The [karma-chrome-launcher][karma-chrome-launcher] supports natively `ChromeHeadless` as web browser. To define it as default web browser in `karma.conf.js`:

    ...
    browsers: ['ChromeHeadless'],
    ...

It is now possible to build the Docker image and to use it to run the unit tests. Navigate to the folder containing the source code of your Angular project and the above `Dockerfile`, then:

    docker build -t angular-dev .
    docker run --rm -v $(pwd):/usr/src/app:z angular-dev npm test

Everything should work well. However, on some continuous integration environments, the Chromium's sandbox feature [can present a problem][chrome-namespace-issue]. To fix it, add an additional web browser called `ChromeHeadlessCI` to the Karma configuration which will be based on `ChromeHeadless` but with the `--no-sandbox` flag this time:

    ...
    customLaunchers: {
      ChromeHeadlessCI: {
        base: 'ChromeHeadless',
        flags: ['--no-sandbox']
      }
    },
    ...

Also, increase the browser's no activity timeout to be sure that the continuous integration pipeline doesn't fail because the duration value is too short:

    ...
    browserNoActivityTimeout: 60000
    ...

The complete `karma.conf.js` should look like this:

{% gist SkypLabs/aa27e9f37471280c12d75e265a067d9e karma.conf.js %}

Finally, add an npm script to run `ng test` using `ChromeHeadlessCI` and with the `--single-run=true` option:

{% gist SkypLabs/aa27e9f37471280c12d75e265a067d9e package.json %}

With this done, it is now possible to run the continuous integration tests inside a Docker container:

    docker run --rm -v $(pwd):/usr/src/app:z angular-dev npm run test:ci

 [angular-cli]: https://cli.angular.io/
 [chrome-headless]: https://developers.google.com/web/updates/2017/04/headless-chrome
 [chrome-namespace-issue]: https://github.com/jessfraz/dockerfiles/issues/65
 [firefox-headless]: https://bugzilla.mozilla.org/show_bug.cgi?id=1338004
 [karma-chrome-launcher]: https://www.npmjs.com/package/karma-chrome-launcher
 [docker-node]: https://hub.docker.com/_/node/
 [phantomjs]: http://phantomjs.org/
 [xvfb]: https://www.x.org/releases/X11R7.6/doc/man/man1/Xvfb.1.xhtml
