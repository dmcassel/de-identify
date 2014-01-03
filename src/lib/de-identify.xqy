xquery version "1.0-ml";

module namespace deid = "http://marklogic.com/deidentify";

declare function deid:transform(
  $content as map:map,
  $context as map:map)
as map:map*
{
  $content
};
