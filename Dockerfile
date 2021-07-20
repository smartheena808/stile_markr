FROM ruby:3.0.1

RUN mkdir /markr

WORKDIR /markr

COPY Gemfile /markr/Gemfile

COPY Gemfile.lock /markr/Gemfile.lock

RUN bundle install

COPY . /markr

EXPOSE 4567

CMD ["ruby", "app.rb"]
