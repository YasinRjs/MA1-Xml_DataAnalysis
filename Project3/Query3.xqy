xquery version "1.0";
declare namespace functx = "http://www.functx.com";
declare function functx:value-except
  ( $arg1 as xs:anyAtomicType* ,
    $arg2 as xs:anyAtomicType* )  as xs:anyAtomicType* {

  distinct-values($arg1[not(.=$arg2)])
 } ;

declare function local:find-all-coAuthors($authorsSeq){
    let $doc := doc("dblp-excerpt.xml")
    let $coAuthorsSeq := ()
    for $author in $authorsSeq
        let $coAuthors := distinct-values($doc/dblp/*[author=$author]/author)
        let $coAuthorsSeq :=  insert-before($coAuthorsSeq,1,$coAuthors)
    return distinct-values($coAuthorsSeq)
};

declare function local:distance($targetAuthor,$currentAuthorsList,$totalAuthorsList,$distance){
    if (empty($currentAuthorsList)) then 0
    else if ($targetAuthor=$currentAuthorsList) then $distance
    else let $totalAuthorsList :=  insert-before($totalAuthorsList,1,$currentAuthorsList)
            let $doc := doc("dblp-excerpt.xml")
            let $coAuthors := local:find-all-coAuthors($currentAuthorsList)
            let $currentAuthorsList := functx:value-except($coAuthors,$totalAuthorsList)
            return local:distance($targetAuthor,$currentAuthorsList,$totalAuthorsList,$distance+1)

};

('&#xa;',<distances>
{
let $doc := doc("dblp-excerpt.xml")
let $allAuthors := distinct-values($doc/dblp/*/author)
let $tab := '&#9;' (: tab :)
let $nl := '&#xa;'
let $both := '&#xa;&#9;'
for $author1 in $allAuthors
let $pos1 := index-of($allAuthors,$author1)
for $author2 in $allAuthors
let $pos2 := index-of($allAuthors,$author2)
where ($author1 != $author2) and ($pos1 < $pos2)
order by $author1,$author2
return(
    $both,<distance author1="{$author1}" author2="{$author2}" distance="{local:distance($author2,$author1,(),0)}"/>
    )
}
&#xa;</distances>)
