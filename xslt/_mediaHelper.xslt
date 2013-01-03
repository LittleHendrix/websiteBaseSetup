<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

	<xsl:variable name="propName" select="/macro/PropName" />
	<xsl:variable name="cropName" select="/macro/CropName" />
	<xsl:variable name="imgQual">
		<xsl:choose>
			<xsl:when test="string(/macro/ImgQual)!=''">
				<xsl:value-of select="number(/macro/ImgQual)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(80)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="markUp" select="Exslt.ExsltStrings:lowercase(/macro/MarkUp)" />
	<xsl:variable name="itemMarkup">
		<xsl:choose>
			<xsl:when test="string($markUp)=''">
				<xsl:value-of select="''" />
			</xsl:when>
			<xsl:when test="contains('ol ul', $markUp)">
				<xsl:value-of select="'li'" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'span'" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="className" select="Exslt.ExsltStrings:lowercase(/macro/CssClass)" />
	
	<xsl:if test="string($propName)!=''">
		<xsl:variable name="media" select="$currentPage/*[not(@isDoc) and name() = $propName]" />
		<xsl:choose>
			<xsl:when test="string($markUp)!=''">
				<xsl:element name="{$markUp}">
					<xsl:if test="string($className)!=''"><xsl:attribute name="class"><xsl:value-of select="$className" /></xsl:attribute></xsl:if>
					<xsl:call-template name="mediaLoop">
						<xsl:with-param name="mediaNodes" select="$media" />
						<xsl:with-param name="cropName" select="$cropName" />
						<xsl:with-param name="imgQual" select="$imgQual" />
						<xsl:with-param name="itemMarkup" select="$itemMarkup" />
					</xsl:call-template>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mediaLoop">
					<xsl:with-param name="mediaNodes" select="$media" />
					<xsl:with-param name="cropName" select="$cropName" />
					<xsl:with-param name="imgQual" select="$imgQual" />
					<xsl:with-param name="itemMarkup" select="$itemMarkup" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>

</xsl:template>

<xsl:template name="mediaLoop">
	<xsl:param name="mediaNodes" />
	<xsl:param name="cropName" />
	<xsl:param name="imgQual" />
	<xsl:param name="itemMarkup" />
		
	<xsl:for-each select="$mediaNodes//mediaItem/*[string(@id) != '']">
		
		<xsl:variable name="src">
			<xsl:choose>
				<xsl:when test="string($cropName) != '' and count(.//crop[string(@name) = $cropName]/@url) &gt; 0">
					<xsl:value-of select=".//crop[string(@name) = $cropName]/@url" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="./umbracoFile" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string($itemMarkup)!=''">
				<xsl:element name="{$itemMarkup}">
					<xsl:call-template name="img">
						<xsl:with-param name="src" select="$src" />
						<xsl:with-param name="imgQual" select="$imgQual" />
						<xsl:with-param name="alt" select="@nodeName" />
					</xsl:call-template>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="img">
					<xsl:with-param name="src" select="$src" />
					<xsl:with-param name="imgQual" select="$imgQual" />
					<xsl:with-param name="alt" select="@nodeName" />
				</xsl:call-template>			
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:for-each>
	
</xsl:template>
		
<xsl:template name="img">
	<xsl:param name="src" />
	<xsl:param name="imgQual" />
	<xsl:param name="alt" />
			
	<img src="/imageGen.ashx?image={$src}&amp;compression={$imgQual}" alt="{$alt}" />
	
</xsl:template>

</xsl:stylesheet>