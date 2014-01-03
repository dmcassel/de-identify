xquery version "1.0-ml";

module namespace deid = "http://marklogic.com/deidentify";

declare namespace groundspeak = "http://www.groundspeak.com/cache/1/0";

declare function deid:redact($node)
{
  element { fn:node-name($node) } {
    'redacted'
  }
};

(:
 : From a dateTime, returns a string that preserves the year and
 :)
declare function deid:hide-time($node) as xs:string
{
  element { fn:node-name($node) } {
    fn:year-from-dateTime($node/xs:dateTime(.)) || '-01-01T00:00:00'
  }
};

declare function deid:descend($node)
{
  typeswitch($node)
  case document-node() return $node/node() ! deid:descend(.)
  case element(groundspeak:finder) return deid:redact($node)
  case element(groundspeak:date) return deid:hide-time($node)
  case element() return
    element { fn:node-name($node) } {
      $node/@*,
      $node/node() ! deid:descend(.)
    }
  default return $node
};

declare function deid:transform(
  $content as map:map,
  $context as map:map)
as map:map*
{
  map:put($content, 'value', deid:descend(map:get($content, 'value'))),
  $content
};
