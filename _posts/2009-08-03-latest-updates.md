---
layout: post
author: Bjørn Arild Mæland
title: Latest updates
---

We're very pleased to announce an update to
[http://crantastic.org/](http://crantastic.org/), the
community site for R packages.

**Notable new features include:**

* Crantastic now tweets package releases and updates to the site's
  [twitter account](http://twitter.com/cranatic).

* Package pages now include a list of related packages, based on package tags.

* We're now using [Feedburner](http://feedburner.google.com/) for our main feeds
  -- this means that we now can provide
  [updates through email](http://crantastic.org/email_notifications).

* Popularity contest for packages: you can now select which packages you use on
  the site. This will be used to provide stats on package popularity. We're
  looking into ways for integrating this with Jeffrey Horner's PopCon.

* Reviews can now be written in
  [Markdown](http://daringfireball.net/projects/markdown/), and supports
  highlighting of embedded R code. For an example, take a look at
  [this review](http://crantastic.org/packages/HiddenMarkov/reviews/3).

* Users can now identify as package authors.

* Its now possible to comment on reviews. If a package author responds to one of
  "his" packages, the comment will be marked accordingly. Note that this feature
  will receive some polish in the coming days.

* Greatly improved cross-browser appearance -- the site should now look much
  better in Internet Explorer and Opera (we mainly use Firefox and Safari
  ourselves, so these browser receives most attention).

**Other minor improvements include:**

* Added possibility to reset passwords, for the forgetful.

* "Live" validations of the signup form, providing instant feedback on
  e.g. username availability.

* All packages now have links to the
  [R Graphical Manual](http://bm2.genes.nig.ac.jp/RGM2/index.php).

**New features just around the corner:**

* A new R package for interacting with the site through the R console (tagging
  packages, ++).

* Weekly digests including all activity on the site.

* ..and more!

Please [visit the site](http://crantastic.org), rate & review your favourite
packages, and give us some [feedback](http://crantastic.uservoice.com/)! If you
run into any bugs or errors, please report them at [GitHub
Issues](http://github.com/hadley/crantastic/issues) or ship us an
[e-mail](mailto:cranatic@gmail.com).

Development notes
-----------------

We've done a lot of refactoring since the previous update, the biggest change
being the transition to the excellent
[authlogic](http://github.com/binarylogic/authlogic/tree/master) authentication
system.
