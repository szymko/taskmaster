taskmaster
==========

Application pulling websites from the Internet and managing them. It consists of four parts:

* simple crawler. It downloads sites asynchronously, scraps them in search of URLs and returns the batch result. It obeys robots.txt, 
more from Robots Exclusion Protocol on the way.

* layer of persistency. It inserts websites into db, chooses URLs for scrapper to visit, updates information about urls/contents.

* data processing layer. It consists of pluggable components, parsing HTML and retrieving text from various part of it. It is also responsible
for composing JSON, later sent via RabbitMQ to neo4ruby app.

* RabbitMQ client (publisher). It performs RPC calls on neo4ruby with the downloaded and processed data.


