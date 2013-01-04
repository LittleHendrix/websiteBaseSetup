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

	<xsl:variable name="propName" select="normalize-space(/macro/PropName)" />
	<xsl:variable name="cropName" select="normalize-space(/macro/CropName)" />
	<xsl:variable name="opt" select="normalize-space(Exslt.ExsltStrings:lowercase(/macro/Optimize))" />
	<xsl:variable name="optimize">
		<xsl:choose>
			<xsl:when test="contains('1,yes,true,',concat($opt,','))">
				<xsl:value-of select="number(1)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(0)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="width" select="number(/macro/Width)" />
	<xsl:variable name="height" select="number(/macro/Height)" />
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
	<xsl:variable name="markUp" select="normalize-space(Exslt.ExsltStrings:lowercase(/macro/MarkUp))" />
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
	<xsl:variable name="className" select="normalize-space(Exslt.ExsltStrings:lowercase(/macro/CssClass))" />
	
	<xsl:if test="string($propName)!=''">
		<xsl:variable name="media" select="$currentPage/*[not(@isDoc) and name() = $propName]" />
		<xsl:choose>
			<xsl:when test="string($markUp)!=''">
				<xsl:element name="{$markUp}">
					<xsl:if test="string($className)!=''"><xsl:attribute name="class"><xsl:value-of select="$className" /></xsl:attribute></xsl:if>
					<xsl:call-template name="mediaLoop">
						<xsl:with-param name="mediaNodes" select="$media" />
						<xsl:with-param name="cropName" select="$cropName" />
						<xsl:with-param name="optimize" select="$optimize" />
						<xsl:with-param name="width" select="$width" />
						<xsl:with-param name="height" select="$height" />
						<xsl:with-param name="imgQual" select="$imgQual" />
						<xsl:with-param name="itemMarkup" select="$itemMarkup" />
					</xsl:call-template>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mediaLoop">
					<xsl:with-param name="mediaNodes" select="$media" />
					<xsl:with-param name="cropName" select="$cropName" />
						<xsl:with-param name="optimize" select="$optimize" />
						<xsl:with-param name="width" select="$width" />
						<xsl:with-param name="height" select="$height" />
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
	<xsl:param name="optimize" />
	<xsl:param name="width" />
	<xsl:param name="height" />
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
		
		<xsl:variable name="alt" select="umbraco.library:Replace(umbraco.library:Replace(umbraco.library:Replace(umbraco.library:Replace(@nodeName,'_',' '),'.jpg',''),'.png',''),'.gif','')" />
		
		<xsl:choose>
			<xsl:when test="string($itemMarkup)!=''">
				<xsl:element name="{$itemMarkup}">
					<xsl:call-template name="img">
						<xsl:with-param name="src" select="$src" />
						<xsl:with-param name="optimize" select="$optimize" />
						<xsl:with-param name="width" select="$width" />
						<xsl:with-param name="height" select="$height" />
						<xsl:with-param name="imgQual" select="$imgQual" />
						<xsl:with-param name="alt" select="$alt" />
					</xsl:call-template>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="img">
					<xsl:with-param name="src" select="$src" />
					<xsl:with-param name="optimize" select="$optimize" />
					<xsl:with-param name="width" select="$width" />
					<xsl:with-param name="height" select="$height" />
					<xsl:with-param name="imgQual" select="$imgQual" />
					<xsl:with-param name="alt" select="$alt" />
				</xsl:call-template>			
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:for-each>
	
</xsl:template>
		
<xsl:template name="img">
	<xsl:param name="src" />
	<xsl:param name="optimize" />
	<xsl:param name="width" />
	<xsl:param name="height" />
	<xsl:param name="imgQual" />
	<xsl:param name="alt" />
			
	<img>
		<xsl:choose>
			<xsl:when test="number($optimize) = 1">
				<xsl:attribute name="src"> 
					<xsl:text>/ImageGen.ashx?image=</xsl:text><xsl:value-of select="$src" /> 
					<xsl:if test="string($width)!='' and string($width)!='NaN'"><xsl:text>&amp;width=</xsl:text><xsl:value-of select="$width" /></xsl:if>
					<xsl:if test="string($height)!='' and string($height)!='NaN'"><xsl:text>&amp;height=</xsl:text><xsl:value-of select="$height" /></xsl:if>
					<xsl:text>&amp;compression=</xsl:text><xsl:value-of select="$imgQual" />
					<xsl:text>&amp;constrain=true</xsl:text> 
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="src"> 
					<xsl:value-of select="$src" />
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:attribute name="alt">
			<xsl:value-of select="$alt" />
		</xsl:attribute>
	</img>
	
</xsl:template>

</xsl:stylesheet>