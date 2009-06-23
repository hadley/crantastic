---
layout: post
author: Bjørn Arild Mæland &amp; Hadley Wickham
title: Announcing new features
---

We're very pleased to announce an update to
[http://crantastic.org/](http://crantastic.org/), the
community site for R packages. Notable new features include:

* RPX login. This means that you can login/signup with an existing account
  from Google, Twitter, OpenID, Yahoo!, Flickr, MyOpenID. This makes sure that
  it is painless to contribute to the site &mdash; no signup is required.

  There was some initial bugs with this system, but they should be fixed by
  now. Please try again if you ran into any problems earlier.

* Timelines with recent changes. The main timeline is available right from the
  [front page](http://crantastic.org/), with customized ones being available
  from e.g. user profiles and tags.

* Task View integration:
  [http://crantastic.org/tags](http://crantastic.org/tags).

* Ratings. You can currently rate the package as a whole, or just the
  documentation. This way package authors could get insight into the quality
  of their documentation. (Thanks to Peter for suggesting this on our [page at
  UserVoice](http://crantastic.uservoice.com/))!

* Package search.

* Many smaller fixes/changes, including gravatars (profile pictures) for users
  and package authors.

Please [visit the site](http://crantastic.org), rate & review your favourite
package, and give us some [feedback](http://crantastic.uservoice.com/)! If you
run into any bugs (e.g. spelling or errors), please report them at [GitHub
Issues](http://github.com/hadley/crantastic/issues) or ship us an
[e-mail](mailto:cranatic@gmail.com).

Development notes
-----------------

We have also moved the existing site and infrastructure to a new cloud-based
hosting platform for Ruby web applications called [Heroku](http://heroku.com).
This means we don't have to worry about servers any more and the site should
run more smoothly. There definitively was some challenges along the way but we
think it will pay off. In the process we managed to improve the CRAN
interaction - the code is completely rewritten in Ruby. We have released a
[Ruby gem for parsing DCF
files](http://github.com/Chrononaut/treetop-dcf/tree/master) (the format used
for describing CRAN packages), as there was no such existing tool for Ruby.

Most of the time so far has been spent on refactoring/robustness and building
up an automated test suite. This will pay off by making it easier to provide
new features. We've got some pretty neat stuff coming up, so stay tuned.
