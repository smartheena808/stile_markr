# stile_markr
Markr as a service is backend-api to receive students test results and return stats for the data visualization

# Requirements
- The POST method has to read specific content type: 'text/xml+markr'
- Ignore the SSL 
- Cloud service (AWS) can be turn off any time
- Student's test results has to be save in the markr storage
- The server can receive client request for data visualization that return statistics information for specific test results
- If there is double submission, it should take the highest score
- If there is missing information from the data, reject with an appropriate HTTP error send the data back as file to be print out

# Approach
This backend api contains two functionality, which is to upload the test results in xml format and to return statistic data for the certain test id. The test results that has been upload will be stored in database, in this case using local database, since the cloud database (AWS) might be not reliable in the future. 
### Logic process
- POST method: upload the data. Check the content-type (accept 'text/xml+markr') if not the same then handle with HTTP error 406 ('Invalid header content file.'). 

## Technologies approach
For building this data ingestion and processing microservice, the backend technologies that have been used:
- Ruby programming language (I decided to give it a try with Ruby, consider this as practise for me since I just learn this languange)
- Sinatra framework to build HTTP server and other dependencies that included in Gemfile and Gemfile.lock
- SQLite3 for the database, since this is lightweight and easy to setup
- Docker for development and testing
- GitHub for version control
- Postman for client testing

# How to run
There are two ways to run this application, first using Docker images and second create the clone from Github repo and run it locally.
## Docker images
Build Docker images from docker-compose provided
```console
docker-compose build
docker-compose run
```

## GitHub repo
To run locally, clone from this repository:
https://github.com/smartheena808/stile_markr.git
After create the clone locally, install ruby in the machine and then open the terminal and run
```console
bundle install
```
This to install all the depencies that are used for this application to run.




