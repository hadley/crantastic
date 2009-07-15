/*
 * Ubiquity functions for use with http://crantastic.org/
 */

CmdUtils.makeSearchCommand({
  icon: "http://crantastic.org/favicon.ico",
  description: "Search for packages on crantastic.",
  help: "Search for packages on crantastic.",
  author: {name: "Bjorn Arild Maeland", email: "bjorn.maeland@gmail.com"},
  license: "GPL",
  name: "crantastic",
  url: "http://crantastic.org/search?q={QUERY}"
});
