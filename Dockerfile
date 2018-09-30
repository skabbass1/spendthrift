FROM ruby:2.5

WORKDIR /usr/src/app

COPY  bin  bin
COPY  lib  lib
COPY spendthrift.gemspec spendthrift.gemspec
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle

ENTRYPOINT ["./bin/spendthrift"]
