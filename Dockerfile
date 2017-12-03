FROM ruby:2.4-slim
MAINTAINER Paul-Emmanuel Raoul <skyper@skyplabs.net>

EXPOSE 4000

RUN apt-get update \
	&& apt-get install -y --no-install-recommends gcc make patch

COPY Gemfile /tmp/
RUN bundle install --gemfile=/tmp/Gemfile

WORKDIR /usr/src/app
ENTRYPOINT ["jekyll"]
CMD ["serve", "--host", "0.0.0.0", "--watch", "--drafts", "--future"]
