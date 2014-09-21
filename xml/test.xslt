    <?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="/">
    <countries>

    <xsl:for-each select="countries/country">
        <country cities="{count(city)}" languages="{count(language)}">
            <name><xsl:value-of select="@name" /></name>
            <population><xsl:value-of select="@population" /></population>
        </country>
    </xsl:for-each>

    </countries>
</xsl:template>
            
<xsl:template match="text()" />
</xsl:stylesheet>
