FROM ruby:2.4.2-slim
MAINTAINER Paul-Emmanuel Raoul <skyper@skyplabs.net>

EXPOSE 4000

RUN apt-get update \
	&& apt-get install -y --no-install-recommends gcc make patch curl apt-transport-https \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs yarn

COPY Gemfile /tmp/
COPY Gemfile.lock /tmp/
RUN bundle install --gemfile=/tmp/Gemfile

WORKDIR /usr/src/app
ENTRYPOINT ["jekyll"]
CMD ["serve", "--host", "0.0.0.0", "--watch", "--drafts", "--future"]
