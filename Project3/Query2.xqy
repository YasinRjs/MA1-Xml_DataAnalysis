xquery version "1.0";



('&#xa;',<proceeding>
{
let $doc := doc("dblp-excerpt.xml")
let $tab := '&#9;' (: tab :)
let $nl := '&#xa;'
let $both := '&#xa;&#9;'

for $proceeding in $doc/dblp/proceedings
order by $proceeding
return (
  $both,<proc_title>{distinct-values($proceeding/title)}</proc_title>,
      for $inproceeding in $doc/dblp/inproceedings[booktitle=$proceeding/booktitle]
      return ($both,$inproceeding/title)
)
}
&#xa;</proceeding>)

(: Proceeding contains InProceedings :)
