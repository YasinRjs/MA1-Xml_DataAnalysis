<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:p2="http://www.xml.project2.ulb.ac.be"
    xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="text"/>
    <xsl:output indent="yes" method="html" use-character-maps="m1" name="html" encoding="UTF-8"/>
    <xsl:character-map name="m1">
       <xsl:output-character character="&#127;" string="="/>
       <xsl:output-character character="&#128;" string="="/>
       <xsl:output-character character="&#129;" string="="/>
       <xsl:output-character character="&#130;" string="="/>
       <xsl:output-character character="&#131;" string="="/>
       <xsl:output-character character="&#132;" string="="/>
       <xsl:output-character character="&#133;" string="="/>
       <xsl:output-character character="&#134;" string="="/>
       <xsl:output-character character="&#135;" string="="/>
       <xsl:output-character character="&#136;" string="="/>
       <xsl:output-character character="&#137;" string="="/>
       <xsl:output-character character="&#138;" string="="/>
       <xsl:output-character character="&#139;" string="="/>
       <xsl:output-character character="&#140;" string="="/>
       <xsl:output-character character="&#141;" string="="/>
       <xsl:output-character character="&#142;" string="="/>
       <xsl:output-character character="&#143;" string="="/>
       <xsl:output-character character="&#144;" string="="/>
       <xsl:output-character character="&#145;" string="="/>
       <xsl:output-character character="&#146;" string="="/>
       <xsl:output-character character="&#147;" string="="/>
       <xsl:output-character character="&#148;" string="="/>
       <xsl:output-character character="&#149;" string="="/>
       <xsl:output-character character="&#150;" string="="/>
       <xsl:output-character character="&#151;" string="="/>
       <xsl:output-character character="&#152;" string="="/>
       <xsl:output-character character="&#153;" string="="/>
       <xsl:output-character character="&#154;" string="="/>
       <xsl:output-character character="&#155;" string="="/>
       <xsl:output-character character="&#156;" string="="/>
       <xsl:output-character character="&#157;" string="="/>
       <xsl:output-character character="&#158;" string="="/>
       <xsl:output-character character="&#159;" string="="/>
    </xsl:character-map>

    <xsl:function name="p2:create-filename-and-folder">
        <xsl:param name="author"/>
        <xsl:variable name="authorWithoutAlphaNum" select="replace($author,'[^a-zA-Z\d\s:]','=')"/>
        <xsl:variable name="lastname" select="replace($authorWithoutAlphaNum,'.*\s','')" />
        <xsl:variable name="firstletter" select="upper-case(substring($lastname,1,1))"/>
        <xsl:variable name="spaceLastname" select="concat('\s',$lastname)"/>
        <xsl:variable name="firstname" select="replace($authorWithoutAlphaNum,$spaceLastname,'')" />
        <xsl:variable name="firstname" select="replace($firstname,'\s','_')" />
        <xsl:sequence select="concat($firstletter,'/',$lastname,'.',$firstname,'.html')"/>
    </xsl:function>


    <xsl:template match="/">
        <xsl:variable name="globalContext" select="." />
        <xsl:variable name="allAuthors" select="distinct-values(//author | //editor)"/>
        <xsl:for-each select="$allAuthors">
            <xsl:sort select="."/>
            <xsl:variable name="author" select="."/>
            <xsl:variable name="filenameAndFolder" select="p2:create-filename-and-folder($author)"/>
            <xsl:value-of select="$author"/>
            <xsl:text>&#xa;</xsl:text>
            <xsl:result-document href="a-tree/{$filenameAndFolder}" format="html" encoding="UTF-8">
                <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html
                  PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
                  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;&#xa;</xsl:text>
                  <html>
                      <head>
                          <title>Publication of <xsl:value-of select="$author"/></title>
                      </head>
                      <body>
                          <xsl:variable name="works" select="$globalContext/dblp/*[author=$author] | $globalContext/dblp/*[editor=$author]"/>
                          <h1><xsl:value-of select="$author"/></h1>
                          <xsl:call-template name="publications">
                              <xsl:with-param name="works" select="$works"/>
                              <xsl:with-param name="author" select="$author"/>
                          </xsl:call-template>

                          <h2> Co-author index </h2>
                          <xsl:call-template name="coAuthorIndex">
                              <xsl:with-param name="works" select="$works"/>
                              <xsl:with-param name="author" select="$author"/>
                          </xsl:call-template>
                      </body>
                  </html>


            </xsl:result-document>

        </xsl:for-each>
    </xsl:template>


    <xsl:template name="publications">
        <xsl:param name="works"/>
        <xsl:param name="author"/>
        <p>
            <table border="1">
                <xsl:variable name="years" select="distinct-values($works/year)"/>
                <xsl:variable name="worksQuantity" select="count($works)"/>
                <xsl:for-each select="$years">
                    <xsl:sort select="." data-type="number" order="descending"/>
                    <xsl:variable name="currentYear" select="."/>
                    <tr><th colspan="3" bgcolor="#FFFFCC"><xsl:value-of select="$currentYear"/></th></tr>
                    <xsl:for-each select="$works">
                        <xsl:sort select="year" data-type="number" order="descending"/>
                        <xsl:sort select="title"/>
                        <xsl:if test="./year = $currentYear">
                            <xsl:variable name="index" select="$worksQuantity - position() + 1"/>
                            <tr>
                                <td align="right" valign="top"><a name="p{$index}"><xsl:value-of select="$index"/></a> </td>
                                <xsl:choose>
                                    <xsl:when test="./ee">
                                        <xsl:variable name="url" select="./ee"/>
                                        <td valign="top">
                                            <a href="{$url}">
                                                <img alt="Electronic Edition" title="Electronic Edition"
                                                src="http://www.informatik.uni-trier.de/~ley/db/ee.gif"
                                                border="0" height="16" width="16"/>
                                            </a>
                                        </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <td/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <td>
                                    <xsl:for-each select="./author | ./editor">
                                        <xsl:sort select="replace(.,'.*\s','')"/>
                                        <xsl:sort select="."/>
                                        <xsl:variable name="currentAuthor" select="."/>
                                        <xsl:choose>
                                            <xsl:when test="$author=$currentAuthor">
                                                <xsl:value-of select="$currentAuthor" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <a href="../{p2:create-filename-and-folder($currentAuthor)}"> <xsl:value-of select="$currentAuthor"/></a>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when test="position()=last()">
                                                <xsl:text>:&#xa;</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>,&#xa;</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:for-each>
                                    <xsl:call-template name="work-informations">
                                        <xsl:with-param name="work" select="."/>
                                    </xsl:call-template>

                                </td>
                            </tr>
                        </xsl:if>
                   </xsl:for-each>
                </xsl:for-each>
            </table>
        </p>
    </xsl:template>


    <xsl:template name="work-informations">
        <xsl:param name="work"/>
        <b><xsl:value-of select="$work/title"/></b>
        <xsl:text>&#xa;</xsl:text>
        <xsl:choose>
            <xsl:when test="name($work) = 'article'">
                <xsl:call-template name="create-url">
                    <xsl:with-param name="url" select="url"/>
                    <xsl:with-param name="refname" select="journal"/>
                </xsl:call-template>
                <xsl:text>:</xsl:text>
            </xsl:when>
            <xsl:when test="name($work) = 'inproceedings' or name($work)='incollection'">
                <xsl:variable name="ref" select="concat(booktitle,' ',year)"/>
                <xsl:call-template name="create-url">
                    <xsl:with-param name="url" select="url"/>
                    <xsl:with-param name="refname" select="$ref"/>
                </xsl:call-template>
                <xsl:text>:</xsl:text>
            </xsl:when>
            <xsl:when test="name($work)='proceedings'">
                <xsl:variable name="ref" select="concat(booktitle,' ',year)"/>
                <xsl:call-template name="create-url">
                    <xsl:with-param name="url" select="url"/>
                    <xsl:with-param name="refname" select="$ref"/>
                </xsl:call-template>
                <xsl:text> </xsl:text>
            </xsl:when>

        </xsl:choose>
        <xsl:if test="pages">
            <i><xsl:value-of select="pages"/></i>
        </xsl:if>
        <xsl:if test="publisher">
            <xsl:value-of select="publisher"/>
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:if test="isbn">
            ISBN <xsl:value-of select="isbn"/>
        </xsl:if>
    </xsl:template>


    <xsl:template name="create-url">
        <xsl:param name="url"/>
        <xsl:param name="refname"/>
        <xsl:choose>
            <xsl:when test="matches($url,'http.*')">
                <xsl:variable name="url" select="./url"/>
                    <a href="{$url}"><xsl:value-of select="$refname"/></a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="link" select="concat('http://dblp.uni-trier.de/',$url)"/>
                <a href="{$link}"><xsl:value-of select="$refname"/></a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="coAuthorIndex">
        <xsl:param name="works"/>
        <xsl:param name="author"/>
        <p>
            <xsl:variable name="coAuthors" select="distinct-values($works/author | $works/editor)"/>
            <xsl:variable name="worksQuantity" select="count($works)"/>
            <xsl:choose>
                <xsl:when test="count($coAuthors)=1">
                    <i>There is no co-author </i>
                </xsl:when>
                <xsl:otherwise>
                    <table border="1">
                        <xsl:for-each select="$coAuthors">
                            <xsl:sort select="replace(.,'.*\s','')"/>
                            <xsl:sort select="."/>
                            <xsl:variable name="coAuthor" select="."/>
                            <xsl:if test="$author != $coAuthor">
                                <tr>
                                    <td align="right">
                                        <a href="../{p2:create-filename-and-folder($coAuthor)}"> <xsl:value-of select="$coAuthor"/></a>
                                    </td>
                                    <td align="left">
                                        <xsl:for-each select="$works">
                                            <xsl:sort select="year" data-type="number" order="descending"/>
                                            <xsl:sort select="title"/>
                                            <xsl:if test="author = $coAuthor or editor=$coAuthor">
                                                <xsl:variable name="index" select="$worksQuantity - position() + 1"/>
                                                [<a href="#p{$index}"><xsl:value-of select="$index"/></a>]
                                            </xsl:if>

                                        </xsl:for-each>
                                    </td>

                                </tr>
                            </xsl:if>

                        </xsl:for-each>
                    </table>
                </xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
</xsl:stylesheet>
