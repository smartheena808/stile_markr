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
This backend api contains two functionality, which is to upload the test results in xml format and to return statistic data for the certain test id in json format.The test results that has been upload will be stored in database, in this case using local database, since the cloud database (AWS) might be not available in the future. 
### Logic process
- POST method: upload the data. Check the content-type (accept 'text/xml+markr') if not the same then handle with HTTP error 406 ('Invalid header content file.'). 
- Since the test result can be upload multiple time and where is a chance that the same student submit their result more than one, and only the highest score that will be store in the database, therefore the test result have to be filtered before enter to the database.  
- GET method: return the statistic for specific test result (filter by test id) and have to be returned in json. format. 
### Assumption
- The backend api at the moment only for upload test results and return statistic of test result. No feature for update the test result, new feature can be added easily in the future.
- Student number is not a unique id, since there are more than one student has same student number, this can be a problem in the future, but the moment ignore this and use compose keys, which are first name, last name and student number to search the test result.
- If the student number is a unique id for student the logic for insert new data have to be adjusted again.
- All the test result will be stored in one independent table, there is no database relatioship with other tables.
- If there is a missing information when uploading the file, it would rejected the whole file with appropriate HTTP error and print out the file, at the moment this will print to console.
- No Authentication to upload file and access the database.
## Technologies approach
For building this data ingestion and processing microservice, the backend technologies that have been used:
- Ruby programming language 
- Sinatra framework to build HTTP server backend and other dependencies that included in Gemfile and Gemfile.lock
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
https://github.com/smartheena808/stile_markr.git, under the branch markr01 is the final one.
After create the clone locally, install ruby in the machine and then open the terminal and run
```console
bundle install
```
This command will install all the depencies that are used for this application to run in local mechine. Once all the dependencies are installed then run this command
```console
ruby app.rb
```





