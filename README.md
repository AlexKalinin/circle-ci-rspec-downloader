# Circle CI rspec.xml files downloader

## Setup
Read Circle CI documentation: https://circleci.com/docs/api/

Copy `config/application.yml.sample` to `config/application.yml`

Edit `config/application.yml`, paste valid data.

## Usage

To begin import xml files from CircleCI, run:
```
rake circleci:download_rspec_reports
``` 

To load files into SQLite database:
```
rake db:migrate
rake db:load_rspec_reports_from_artifact
```