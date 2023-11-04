# Simple client to Github api

The app is dockerized, so to run it you need to have Docker (docker-compose) in your system
and run:
``` bash
 docker-compose up rails
```


Main points:

* Github::SearchRepoService incapsulate requests to GitHub API

* Any new implementation to Github API should lay in Github namespace

* For test it uses VCR gem


Limitations:

* no showing proper notifications in case of exception

* the number of the last page is calculated incorrectly
