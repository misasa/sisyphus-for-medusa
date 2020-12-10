FROM ruby:2.7
RUN gem install bundler
WORKDIR /app/sisyphus
COPY . /app/sisyphus
RUN bash -l -c 'bundle install'
RUN rm -r /app/sisyphus/pkg | bundle exec rake build sisyphus.gemspec
RUN gem install pkg/sisyphus-for-medusa-*.gem
ENTRYPOINT ["sisyphus"]




