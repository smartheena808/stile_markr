FROM ruby:3.0.1

RUN mkdir /markr.com

WORKDIR /markr.com

COPY Gemfile /markr.com/Gemfile

COPY Gemfile.lock /markr.com/Gemfile.lock

RUN bundle install

COPY . /markr.com

EXPOSE 4567

CMD ["ruby", "app.rb"]
