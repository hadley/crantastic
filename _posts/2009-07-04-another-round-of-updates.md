---
layout: post
author: Bjørn Arild Mæland &amp; Hadley Wickham
title: Another round of updates
---

We're very pleased to announce an update to
[http://crantastic.org/](http://crantastic.org/), the
community site for R packages. Notable new features include:

* More package relationships.  We now have enhances, imports, and reverse
  relationships.

* Easier rating: just log-in, and click the number of stars you think the package
  deserves.  You don't even need to leave the page.

* A latest versions feed, which lists all package updates. The feed displays
  package descriptions, readme's, news, and changelogs. The feed is available
  via auto-discovery (in most browsers this means that it is listed in the
  feed-list in the right part of the address bar), or directly from
  [http://crantastic.org/versions/feed](http://crantastic.org/versions/feed).

* A new packages feed, which only includes new packages.  This is
  ideal if you want to follow a low-traffic feed but still keep up-to-date with
  package releases. This is also available via auto-discovery, or directly from
  from [http://crantastic.org/packages/feed](http://crantastic.org/packages/feed).

* Integrated CRAN package priorities. These packages are now automatically
  tagged with a special priority-tag (either "Recommended" or "Base"). Have a
  look at the [boot package](http://crantastic.org/packages/boot) for an example.

* You can now set up a homepage and a short profile for your user page.

Other minor improvements include:

* Made the [package index page](http://crantastic.org/packages) more
  "browser-friendly" - one can now use the browser's "back"-button to return to
  the previous state and link directly and/or bookmark searches.

* Package ratings are now displayed in search results.

* Instructions for how package ratings integrate with reviews are now displayed
  when writing a new review. Its possible to rate the package while filling out
  the review form.

* Login/signup is now displayed in a single Ajax dialogue (for clients
  that has JavaScript enabled).

Please [visit the site](http://crantastic.org), rate & review your favourite
packages, and give us some [feedback](http://crantastic.uservoice.com/)! If you
run into any bugs or errors, please report them at [GitHub
Issues](http://github.com/hadley/crantastic/issues) or ship us an
[e-mail](mailto:cranatic@gmail.com).

Development notes
-----------------

We've upgraded to the latest version of the [compass](http://compass-style.org/)
stylesheet framework. This includes version 0.9 of Blueprint. No problems were encountered.

We've added a [sitemap](http://www.sitemaps.org/) which should help keep search
engines up to date with changes to R packages.
