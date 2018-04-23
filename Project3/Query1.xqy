xquery version "1.0";

('&#xa;',<author_coauthors>
{
  let $doc := doc("dblp-excerpt.xml")
  let $tab := '&#9;' (: tab :)
  let $nl := '&#xa;'
  let $both := '&#xa;&#9;'
  for $author in distinct-values($doc/dblp/*/author)
  let $coAuthors := distinct-values($doc/dblp/*[author=$author]/author)
  let $coAuthors := remove($coAuthors,index-of($coAuthors,$author))
  let $coAuthorsNb := count($coAuthors)
  order by $author
  return
    ($nl,$tab,<author>
        {$both}{$tab}<name>{$author}</name>
        {$both}{$tab}<coauthors number="{$coAuthorsNb}">
        {
            for $coAuthor in $coAuthors
            let $nbJoint := count(distinct-values($doc/dblp/*[author=$author and author=$coAuthor]))
            order by $coAuthor
            return (
                $both,$tab,$tab,<coauthor>
                {$both}{$tab}{$tab}{$tab}<name>{$coAuthor}</name>
                {$both}{$tab}{$tab}{$tab}<nb_joint_pubs>{$nbJoint}</nb_joint_pubs>

                {$both}{$tab}{$tab}</coauthor>
                )
        }
        {$both}{$tab}</coauthors>
    {$both}</author>)
}
{'&#xa;'}</author_coauthors>)
