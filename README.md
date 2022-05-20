# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc

# Technical Overview

## Generation of shortes relative shortcode

we calculating total combination [ c(62, x) ] , if number of existing database records count
lies b/w the base range ( ShortUrl::CHARACTERS) and the total_combinations then r is the short code length .

for example
CASE 1
```
rows_count = 10

# Since c(62,1) max value is 62 , that mean we can generate 62 unique single digit short values #for 62 rows

expected output: 1

```

CASE 2
```
rows_count = 100

# Since c(62,1) max value is 62 , that mean we can generate only 62 unique single digit short #values for 62 rows but after that we need to increase shortcode length to 2 and so on.

expected output: 2
```