<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:hl7="urn:hl7-org:v3" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*:</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>[namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1+ $preceding" />
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="" title="Schematron Profilo Sanitario Sintetico 1.4 ">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="hl7" uri="urn:hl7-org:v3" />
      <svrl:ns-prefix-in-attribute-values prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">all</xsl:attribute>
        <xsl:attribute name="name">all</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M3" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Schematron Profilo Sanitario Sintetico 1.4 </svrl:text>

<!--PATTERN all-->


	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument" mode="M3" priority="1064">
    <svrl:fired-rule context="hl7:ClinicalDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:realmCode)>=1 and count(hl7:realmCode[@code='IT'])= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:realmCode)>=1 and count(hl7:realmCode[@code='IT'])= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-1| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE avere almeno un elemento 'realmCode', il cui attributo @code deve essere valorizzato con 'IT'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:templateId)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:templateId)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-2| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE avere almeno un elemento di tipo 'templateId'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.1.1'])= 1 and  count(hl7:templateId/@extension)= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.1.1'])= 1 and count(hl7:templateId/@extension)= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-3| Almeno un elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/templateId DEVE essere valorizzato attraverso l'attributo @root='2.16.840.1.113883.2.9.10.1.4.1.1', associato all'attributo @extension che  indica la versione a cui il templateId fa riferimento</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='60591-5'][@codeSystem='2.16.840.1.113883.6.1']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='60591-5'][@codeSystem='2.16.840.1.113883.6.1']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-4| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/code DEVE essere valorizzato con l'attributo @code='60591-5' e il @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Profilo Sanitario Sintetico'])=1 or    count(hl7:code[@displayName='PROFILO SANITARIO SINTETICO'])=1 or count(hl7:code[@displayName='Profilo sanitario sintetico'])=1)">
      <svrl:successful-report test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Profilo Sanitario Sintetico'])=1 or count(hl7:code[@displayName='PROFILO SANITARIO SINTETICO'])=1 or count(hl7:code[@displayName='Profilo sanitario sintetico'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W001| Si raccomanda di valorizzare gli attributi dell'elemento <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />/code nel seguente modo: @codeSystemName ='LOINC' e @displayName ='Profilo Sanitario Sintetico'.--&gt; </svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:confidentialityCode[@code='N'][@codeSystem='2.16.840.1.113883.5.25'])= 1) or     (count(hl7:confidentialityCode[@code='V'][@codeSystem='2.16.840.1.113883.5.25'])= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:confidentialityCode[@code='N'][@codeSystem='2.16.840.1.113883.5.25'])= 1) or (count(hl7:confidentialityCode[@code='V'][@codeSystem='2.16.840.1.113883.5.25'])= 1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-5| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/confidentialityCode DEVE avere l'attributo @code valorizzato con 'N' o 'V', e il @codeSystem='2.16.840.1.113883.5.25'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:languageCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:languageCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-6| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE contenere un elemento 'languageCode' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="versionNumber" select="hl7:versionNumber/@value" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string(number($versionNumber)) = 'NaN') or      ($versionNumber= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension = hl7:setId/@extension) or      ($versionNumber!= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension != hl7:setId/@extension) or      (hl7:id/@root != hl7:setId/@root)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string(number($versionNumber)) = 'NaN') or ($versionNumber= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension = hl7:setId/@extension) or ($versionNumber!= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension != hl7:setId/@extension) or (hl7:id/@root != hl7:setId/@root)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-7| Se ClinicalDocument.id e ClinicalDocument.setId usano lo stesso dominio di identificazione (@root identico) allora l’attributo @extension del ClinicalDocument.id 
			deve essere diverso da quello del ClinicalDocument.setId a meno che ClinicalDocument.versionNumber non sia uguale ad 1; cioè i valori di setId ed id per un documento clinico possono coincidere solo per la prima versione di un documento</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string(number($versionNumber)) ='NaN') or         ($versionNumber=1) or          (($versionNumber >1) and count(hl7:relatedDocument)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string(number($versionNumber)) ='NaN') or ($versionNumber=1) or (($versionNumber >1) and count(hl7:relatedDocument)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-8| Se l'attributo <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/versionNumber/@value è maggiore di 1, l'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE contenere un elemento di tipo 'relatedDocument'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:recordTarget)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:recordTarget)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-9| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE contenere un solo elemento 'recordTarget' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr" select="count(hl7:recordTarget/hl7:patientRole/hl7:addr)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr=0 or (count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:country)=$num_addr and     count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:city)=$num_addr and     count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:streetAddressLine)=$num_addr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr=0 or (count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:country)=$num_addr and count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:city)=$num_addr and count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:streetAddressLine)=$num_addr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-10| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="patient" select="hl7:recordTarget/hl7:patientRole/hl7:patient" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($patient)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($patient)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-11| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTaget/patientRole DEVE contenere l'elemento 'patient'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count($patient/hl7:name/hl7:given)=1 and count($patient/hl7:name/hl7:family)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count($patient/hl7:name/hl7:given)=1 and count($patient/hl7:name/hl7:family)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-12| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTaget/patientRole/patient/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="genderOID" select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@codeSystem" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-13| L'attributo <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/patient DEVE contenere l'elemento administrativeGenderCode </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$genderOID='2.16.840.1.113883.5.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$genderOID='2.16.840.1.113883.5.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-14| L'OID assegnato all'attributo <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/patient/administrativeGenderCode/@codeSystem='<xsl:text />
            <xsl:value-of select="$genderOID" />
            <xsl:text />' non è corretto. L'attributo DEVE essere valorizzato con '2.16.840.1.113883.5.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-15| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/patient DEVE contenere l'elemento birthTime </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthplace)=0 or     count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthplace/hl7:place/hl7:addr)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthplace)=0 or count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthplace/hl7:place/hl7:addr)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-16| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/patient/birthplace DEVE contenere un elemento place/addr </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-17| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor DEVE contenere almeno un elemento 'id' con il relativo attributo @root='2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:author/hl7:assignedAuthor/hl7:code)=0 or     count(hl7:author/hl7:assignedAuthor/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.13'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:author/hl7:assignedAuthor/hl7:code)=0 or count(hl7:author/hl7:assignedAuthor/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.13'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-18| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/code DEVE essere valorizzato secondo il value set "assignedAuthorCode_PSSIT" - @codeSystem='2.16.840.1.113883.2.9.77.22.11.13'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_author" select="count(hl7:author/hl7:assignedAuthor/hl7:addr)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_author=0 or (count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:country)=$num_addr_author and     count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:city)=$num_addr_author and    count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:streetAddressLine)=$num_addr_author)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_author=0 or (count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:country)=$num_addr_author and count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:city)=$num_addr_author and count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:streetAddressLine)=$num_addr_author)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-19| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:author/hl7:assignedAuthor/hl7:telecom)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:author/hl7:assignedAuthor/hl7:telecom)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-20| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor DEVE contenere almeno un elemento 'telecom'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="name_author" select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count($name_author/hl7:given)>=1 and count($name_author/hl7:family)>=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count($name_author/hl7:given)>=1 and count($name_author/hl7:family)>=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-21| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="id_dataEnterer" select="hl7:dataEnterer/hl7:assignedEntity/hl7:id" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or count($id_dataEnterer[@root='2.16.840.1.113883.2.9.4.3.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or count($id_dataEnterer[@root='2.16.840.1.113883.2.9.4.3.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-22| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/dataEnterer/assignedEntity DEVE avere almeno un elemento 'id' <xsl:text />
            <xsl:value-of select="$id_dataEnterer" />
            <xsl:text /> con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_data_ent" select="count(hl7:dataEnterer/hl7:assignedEntity/hl7:addr)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_data_ent=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:addr/hl7:country)=$num_addr_data_ent and     count(hl7:dataEnterer/hl7:assignedEntity/hl7:addr/hl7:city)=$num_addr_data_ent and    count(hl7:dataEnterer/hl7:assignedEntity/hl7:addr/hl7:streetAddressLine)=$num_addr_data_ent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_data_ent=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:addr/hl7:country)=$num_addr_data_ent and count(hl7:dataEnterer/hl7:assignedEntity/hl7:addr/hl7:city)=$num_addr_data_ent and count(hl7:dataEnterer/hl7:assignedEntity/hl7:addr/hl7:streetAddressLine)=$num_addr_data_ent)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-23| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/dataEnterer/assignedEntity/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nome" select="hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or (count($nome/hl7:family)=1 and count($nome/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or (count($nome/hl7:family)=1 and count($nome/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-24| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/dataEnterer/assignedEntity/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:informant/hl7:relatedEntity)=0 or     (count(hl7:informant/hl7:relatedEntity[@classCode='CON' or @classCode='PROV' or @classCode='PRS'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:informant/hl7:relatedEntity)=0 or (count(hl7:informant/hl7:relatedEntity[@classCode='CON' or @classCode='PROV' or @classCode='PRS'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-25| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/informant/relatedEntity deve essere valorizzato con l'attributo @classCode='CON' o @classCode='PROV' o @classCode='PRS'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nome" select="hl7:informant/hl7:relatedEntity/hl7:relatedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:informant/hl7:relatedEntity)=0 or (count($nome/hl7:family)=1 and count($nome/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:informant/hl7:relatedEntity)=0 or (count($nome/hl7:family)=1 and count($nome/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-26| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/informant/relatedEntity/relatedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:informant/hl7:assignedEntity/hl7:id)=0 or     count(hl7:informant/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:informant/hl7:assignedEntity/hl7:id)=0 or count(hl7:informant/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-27| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/informant se presente, DEVE contenere l'elemento relatedEntity/id valorizzato con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nome" select="hl7:informant/hl7:assignedEntity/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:informant/hl7:assignedEntity)=0 or (count($nome/hl7:family)=1 and count($nome/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:informant/hl7:assignedEntity)=0 or (count($nome/hl7:family)=1 and count($nome/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-28| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/informant/assignedEntity/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-29| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/custodian/assignedCustodian/representedCustodianOrganization deve contenere un elemento 'name'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_cust" select="count(hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr)" />
    <xsl:variable name="addr_cust" select="hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_cust=0 or (count($addr_cust/hl7:country)=$num_addr_cust and    count($addr_cust/hl7:city)=$num_addr_cust and     count($addr_cust/hl7:streetAddressLine)=$num_addr_cust)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_cust=0 or (count($addr_cust/hl7:country)=$num_addr_cust and count($addr_cust/hl7:city)=$num_addr_cust and count($addr_cust/hl7:streetAddressLine)=$num_addr_cust)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-30| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/custodian/assignedCustodian/representedCustodianOrganization/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:legalAuthenticator)&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:legalAuthenticator)&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-31| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator può essere presente una sola volta </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)=0 or count(hl7:legalAuthenticator/hl7:signatureCode[@code='S'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)=0 or count(hl7:legalAuthenticator/hl7:signatureCode[@code='S'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-32| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator/signatureCode deve essere valorizzato con il codice "S" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)=0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)=0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-33| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator/assignedEntity DEVE contenere almeno un elemento 'id' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_legauth" select="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:addr)" />
    <xsl:variable name="addr_legauth" select="hl7:legalAuthenticator/hl7:assignedEntity/hl7:addr" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_legauth=0 or (count($addr_legauth/hl7:country)=$num_addr_legauth and    count($addr_legauth/hl7:city)=$num_addr_legauth and     count($addr_legauth/hl7:streetAddressLine)=$num_addr_legauth)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_legauth=0 or (count($addr_legauth/hl7:country)=$num_addr_legauth and count($addr_legauth/hl7:city)=$num_addr_legauth and count($addr_legauth/hl7:streetAddressLine)=$num_addr_legauth)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-34| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator/assignedEntity/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)=0 or     (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and     count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)=0 or (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-35| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator/assignedEntity/assignedPerson/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:authenticator)=0 or count(hl7:authenticator/hl7:signatureCode[@code='S'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:authenticator)=0 or count(hl7:authenticator/hl7:signatureCode[@code='S'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-36| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/authenticator se presente, DEVE contenere l'elemento signatureCode valorizzato con l'attributo @code='S'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:authenticator)=0 or count(hl7:authenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:authenticator)=0 or count(hl7:authenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-37| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/authenticator DEVE contenere almeno un elemento assignedEntity/id valorizzato con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_auth" select="count(hl7:authenticator/hl7:assignedEntity/hl7:addr)" />
    <xsl:variable name="addr_auth" select="hl7:authenticator/hl7:assignedEntity/hl7:addr" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_auth=0 or (count($addr_auth/hl7:country)=$num_addr_auth and    count($addr_auth/hl7:city)=$num_addr_auth and     count($addr_auth/hl7:streetAddressLine)=$num_addr_auth)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_auth=0 or (count($addr_auth/hl7:country)=$num_addr_auth and count($addr_auth/hl7:city)=$num_addr_auth and count($addr_auth/hl7:streetAddressLine)=$num_addr_auth)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-38| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/authenticator/assignedEntity/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:authenticator/hl7:assignedEntity/hl7:assignedPerson)=0 or     (count(hl7:authenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and     count(hl7:authenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:authenticator/hl7:assignedEntity/hl7:assignedPerson)=0 or (count(hl7:authenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:authenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-39| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/authenticator/assignedEntity/assignedPerson/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participant)=0 or count(hl7:participant/hl7:associatedEntity/hl7:id)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participant)=0 or count(hl7:participant/hl7:associatedEntity/hl7:id)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-40| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/participant/associatedEntity deve contenere almeno un elemento 'id'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_pcp" select="count(hl7:participant/hl7:associatedEntity/hl7:addr)" />
    <xsl:variable name="addr_pcp" select="hl7:participant/hl7:associatedEntity/hl7:addr" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_pcp=0 or (count($addr_pcp/hl7:country)=$num_addr_pcp and                           count($addr_pcp/hl7:city)=$num_addr_pcp and                           count($addr_pcp/hl7:streetAddressLine)=$num_addr_pcp)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_pcp=0 or (count($addr_pcp/hl7:country)=$num_addr_pcp and count($addr_pcp/hl7:city)=$num_addr_pcp and count($addr_pcp/hl7:streetAddressLine)=$num_addr_pcp)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-41| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/participant/associatedEntity/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson)=0 or     (count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:family)=1 and count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson)=0 or (count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:family)=1 and count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-42| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/participant/associatedEntity/associatedPerson/name deve contenere gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.1']" mode="M3" priority="1063">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.6.1']" />
    <xsl:variable name="val_LOINC" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.1?code=',$val_LOINC))//result='true' or    $val_LOINC='LA16666-2' or $val_LOINC='LA18632-2' or $val_LOINC='LA28752-6' or $val_LOINC='LA18821-1' or    $val_LOINC='LA4270-0' or $val_LOINC='LA21285-4' or $val_LOINC='LA21286-5' or $val_LOINC='LA6743-4'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.1?code=',$val_LOINC))//result='true' or $val_LOINC='LA16666-2' or $val_LOINC='LA18632-2' or $val_LOINC='LA28752-6' or $val_LOINC='LA18821-1' or $val_LOINC='LA4270-0' or $val_LOINC='LA21285-4' or $val_LOINC='LA21286-5' or $val_LOINC='LA6743-4'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 1-DIZ| Codice LOINC '<xsl:text />
            <xsl:value-of select="$val_LOINC" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.5']" mode="M3" priority="1062">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.5']" />
    <xsl:variable name="val_AIC" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.6.1.5?code=',$val_AIC))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.6.1.5?code=',$val_AIC))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 2-DIZ| Codice AIC '<xsl:text />
            <xsl:value-of select="$val_AIC" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.73']" mode="M3" priority="1061">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.6.73']" />
    <xsl:variable name="val_ATC" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.73?code=',$val_ATC))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.73?code=',$val_ATC))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 3-DIZ| Codice ATC '<xsl:text />
            <xsl:value-of select="$val_ATC" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.51']" mode="M3" priority="1060">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.51']" />
    <xsl:variable name="val_GE" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.6.1.51?code=',$val_GE))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.6.1.51?code=',$val_GE))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 4-DIZ| Codice GE '<xsl:text />
            <xsl:value-of select="$val_GE" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2']" mode="M3" priority="1059">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2']" />
    <xsl:variable name="val_AllNoFarm" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.2?code=',$val_AllNoFarm))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.2?code=',$val_AllNoFarm))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 6-DIZ| Codice "Allergeni (No Farmaci)"  '<xsl:text />
            <xsl:value-of select="$val_AllNoFarm" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4']" mode="M3" priority="1058">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4']" />
    <xsl:variable name="reaz_aller" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.4?code=',$reaz_aller))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.4?code=',$reaz_aller))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 7-DIZ| Codice "ReazioniAllergiche"  '<xsl:text />
            <xsl:value-of select="$reaz_aller" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.112']" mode="M3" priority="1057">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.5.112']" />
    <xsl:variable name="via_somminist" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.112?code=',$via_somminist))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.112?code=',$via_somminist))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 8-DIZ| Codice "RouteOfAdministration"  '<xsl:text />
            <xsl:value-of select="$via_somminist" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:statusCode" mode="M3" priority="1056">
    <svrl:fired-rule context="//hl7:statusCode" />
    <xsl:variable name="val_status" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(@code)=0 or doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.6.1.5?code=',$val_status))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(@code)=0 or doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.6.1.5?code=',$val_status))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 9-DIZ| Codice "ActStatus" '<xsl:text />
            <xsl:value-of select="$val_status" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.5.2.8']" mode="M3" priority="1055">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.5.2.8']" />
    <xsl:variable name="val_assdom" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.5.2.8?code=',$val_assdom))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.5.2.8?code=',$val_assdom))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 10-DIZ| Codice "AssistenzaDomiciliare_PSSIT" '<xsl:text />
            <xsl:value-of select="$val_assdom" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.1052']" mode="M3" priority="1054">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.5.1052']" />
    <xsl:variable name="val_actsite" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1052?code=',$val_actsite))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1052?code=',$val_actsite))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 11-DIZ| Codice "ActSite" '<xsl:text />
            <xsl:value-of select="$val_actsite" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.1.11.19700']" mode="M3" priority="1053">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.1.11.19700']" />
    <xsl:variable name="obsIntoleranceType1" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.19700?code=',$obsIntoleranceType1))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.19700?code=',$obsIntoleranceType1))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 12-DIZ| Codice "ObservationIntoleranceType" '<xsl:text />
            <xsl:value-of select="$obsIntoleranceType1" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3']" mode="M3" priority="1052">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3']" />
    <xsl:variable name="reaz_int" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.3?code=',$reaz_int))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.3?code=',$reaz_int))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 14-DIZ| Codice "ReazioniIntolleranza"  '<xsl:text />
            <xsl:value-of select="$reaz_int" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.6']" mode="M3" priority="1051">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.6']" />
    <xsl:variable name="cri_obs" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.6?code=',$cri_obs))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.6?code=',$cri_obs))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 15-DIZ| Codice "CriticalityObservation"  '<xsl:text />
            <xsl:value-of select="$cri_obs" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7']" mode="M3" priority="1050">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7']" />
    <xsl:variable name="problem_status" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.7?code=',$problem_status))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.7?code=',$problem_status))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 16-DIZ| Codice "Stato clinico del problema"  '<xsl:text />
            <xsl:value-of select="$problem_status" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.8']" mode="M3" priority="1049">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.8']" />
    <xsl:variable name="age" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.8?code=',$age))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.8?code=',$age))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 17-DIZ| Codice "Età insorgenza"  '<xsl:text />
            <xsl:value-of select="$age" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.11.22.9']" mode="M3" priority="1048">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.11.22.9']" />
    <xsl:variable name="val_allergies" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.9?code=',$val_allergies))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.9?code=',$val_allergies))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 18-DIZ| Codice "Absent or Unknown Allergies" '<xsl:text />
            <xsl:value-of select="$val_allergies" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.9']" mode="M3" priority="1047">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.9']" />
    <xsl:variable name="prob_obs" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.9?code=',$prob_obs))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.9?code=',$prob_obs))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 19-DIZ| Codice "ProblemObservation"  '<xsl:text />
            <xsl:value-of select="$prob_obs" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10']" mode="M3" priority="1046">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10']" />
    <xsl:variable name="prob_cron" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.10?code=',$prob_cron))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.10?code=',$prob_cron))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 20-DIZ| Codice "CronicitàProblema"  '<xsl:text />
            <xsl:value-of select="$prob_cron" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.11']" mode="M3" priority="1045">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.11']" />
    <xsl:variable name="status_aller" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.11?code=',$status_aller))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.11?code=',$status_aller))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 21-DIZ| Codice "StatoClinicoAllergia"  '<xsl:text />
            <xsl:value-of select="$status_aller" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.12']" mode="M3" priority="1044">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.12']" />
    <xsl:variable name="proc_trap" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.12?code=',$proc_trap))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.12?code=',$proc_trap))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 22-DIZ| Codice "ProcedureTrapianti_PSSIT"  '<xsl:text />
            <xsl:value-of select="$proc_trap" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.13']" mode="M3" priority="1043">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.13']" />
    <xsl:variable name="author_code" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.13?code=',$author_code))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.13?code=',$author_code))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 23-DIZ| Codice "assignedAuthorCode_PSSIT"  '<xsl:text />
            <xsl:value-of select="$author_code" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.14']" mode="M3" priority="1042">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.14']" />
    <xsl:variable name="enc_code" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.14?code=',$enc_code))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.14?code=',$enc_code))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 24-DIZ| Codice "Encounter Code"  '<xsl:text />
            <xsl:value-of select="$enc_code" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.15']" mode="M3" priority="1041">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.15']" />
    <xsl:variable name="cap_mot" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.15?code=',$cap_mot))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.15?code=',$cap_mot))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 25-DIZ| Codice "Capacità Motoria"  '<xsl:text />
            <xsl:value-of select="$cap_mot" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.16']" mode="M3" priority="1040">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.16']" />
    <xsl:variable name="organi_manc9" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.16?code=',$organi_manc9))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.16?code=',$organi_manc9))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 26-DIZ| Codice "OrganiMancanti_ICD9_PSSIT"  '<xsl:text />
            <xsl:value-of select="$organi_manc9" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.17']" mode="M3" priority="1039">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.17']" />
    <xsl:variable name="organi_manc10" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.17?code=',$organi_manc10))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.17?code=',$organi_manc10))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 27-DIZ| Codice "OrganiMancanti_ICD10_PSSIT"  '<xsl:text />
            <xsl:value-of select="$organi_manc10" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.18']" mode="M3" priority="1038">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.18']" />
    <xsl:variable name="trapianti" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.18?code=',$trapianti))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.18?code=',$trapianti))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 28-DIZ| Codice "Trapianti_PSSIT"  '<xsl:text />
            <xsl:value-of select="$trapianti" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.11.22.15']" mode="M3" priority="1037">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.11.22.15']" />
    <xsl:variable name="medication" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.15?code=',$medication))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.15?code=',$medication))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 29-DIZ| Codice "Absent or Unknown Medication"  '<xsl:text />
            <xsl:value-of select="$medication" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.11.22.17']" mode="M3" priority="1036">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.11.22.17']" />
    <xsl:variable name="prob" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.17?code=',$prob))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.17?code=',$prob))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 30-DIZ| Codice "Absent or Unknown Problems"  '<xsl:text />
            <xsl:value-of select="$prob" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.11.22.36']" mode="M3" priority="1035">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.11.22.36']" />
    <xsl:variable name="procedures" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.36?code=',$procedures))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.36?code=',$procedures))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 31-DIZ| Codice "Absent or Unknown Procedures"  '<xsl:text />
            <xsl:value-of select="$procedures" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.11.22.61']" mode="M3" priority="1034">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.11.22.61']" />
    <xsl:variable name="devices" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.61?code=',$devices))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.61?code=',$devices))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 32-DIZ| Codice "Absent or Unknown Devices"  '<xsl:text />
            <xsl:value-of select="$devices" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody//hl7:component/hl7:section[hl7:code[@code!='29762-2']]//hl7:value[@unit]" mode="M3" priority="1033">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody//hl7:component/hl7:section[hl7:code[@code!='29762-2']]//hl7:value[@unit]" />
    <xsl:variable name="unit" select="encode-for-uri(@unit)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.12839?code=',$unit))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.12839?code=',$unit))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 33_DIZ| Codice "UnitsOfMeasureCaseSensitive"  '<xsl:text />
            <xsl:value-of select="$unit" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.1.11.1']" mode="M3" priority="1032">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.1.11.1']" />
    <xsl:variable name="gender" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.1?code=',$gender))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.1?code=',$gender))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 35_DIZ| Codice "AdministrativeGender" '<xsl:text />
            <xsl:value-of select="$gender" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.1']" mode="M3" priority="1031">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.5.1']" />
    <xsl:variable name="gender1" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1?code=',$gender1))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1?code=',$gender1))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 36_DIZ| Codice "AdministrativeGender" '<xsl:text />
            <xsl:value-of select="$gender1" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.111']" mode="M3" priority="1030">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.5.111']" />
    <xsl:variable name="roleCode" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.111?code=',$roleCode))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.111?code=',$roleCode))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 37_DIZ| Codice "RoleCode"  '<xsl:text />
            <xsl:value-of select="$roleCode" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:telecom" mode="M3" priority="1029">
    <svrl:fired-rule context="//hl7:telecom" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@use)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@use)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-43| L’elemento 'telecom' DEVE contenere l'attributo @use </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']" mode="M3" priority="1028">
    <svrl:fired-rule context="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']" />
    <xsl:variable name="CF" select="@extension" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(@extension,'[A-Z0-9]{16}')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(@extension,'[A-Z0-9]{16}')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-44| Il codice fiscale '<xsl:text />
            <xsl:value-of select="$CF" />
            <xsl:text />' cittadino ed operatore deve essere costituito da 16 cifre [A-Z0-9]{16}</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:observation" mode="M3" priority="1027">
    <svrl:fired-rule context="//hl7:observation" />
    <xsl:variable name="moodCd" select="@moodCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(@classCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(@classCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-45| L'attributo "@classCode" dell'elemento "observation" deve essere presente </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody" mode="M3" priority="1026">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='48765-2'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='48765-2'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-46| Sezione Allergie e intolleranze: la sezione DEVE essere presente.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-47| Sezione Allergie e intolleranze: la sezione deve contenere l'elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-48| Sezione Allergie e intolleranze: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Allergie e Intolleranze'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-49| Sezione Allergie e intolleranze: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='10160-0'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='10160-0'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-50| Sezione Terapie farmacologiche: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-51| Sezione Terapie farmacologiche: la sezione deve contenere l'elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-52| Sezione Terapie farmacologiche: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Terapie farmacologiche'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry[hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1']])=0 and    count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry[hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.3']])=1) or     (count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry[hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1']])>=1 and    count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry[hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.3']])=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry[hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1']])=0 and count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry[hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.3']])=1) or (count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry[hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1']])>=1 and count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry[hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.3']])=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-53| Sezione Terapie farmacologiche: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='11450-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='11450-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-54| Sezione Lista dei problemi: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-55| Sezione Lista dei problemi: la sezione deve contenere l'elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.4'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-56| Sezione Lista dei problemi: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Lista dei problemi'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-57| Sezione Lista dei problemi: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='46264-8'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='46264-8'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-58| Sezione Protesi, impianti e ausili: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.9'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.9'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-59| Sezione Protesi, impianti e ausili: la sezione deve contenere l'elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.9'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-60| Sezione Protesi, impianti e ausili: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Protesi, impianti e ausili'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry[hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']])=0 and     count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry[hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.2']])=1) or     (count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry[hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']])>=1 and     count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry[hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.2']])=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry[hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']])=0 and count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry[hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.2']])=1) or (count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry[hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']])>=1 and count(hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry[hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.2']])=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-61| Sezione Protesi, impianti e ausili: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='47519-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='47519-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-62| Sezione Trattamenti e procedure terapeutiche, chirurgiche e diagnostiche: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.11'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.11'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-63| Sezione Trattamenti e procedure terapeutiche, chirurgiche e diagnostiche: la sezione deve contenere l'elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.11'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-64| Sezione Trattamenti e procedure terapeutiche, chirurgiche e diagnostiche: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Trattamenti e procedure terapeutiche, chirurgiche e diagnostiche'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:entry)>=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:entry)>=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-65| Sezione Trattamenti e procedure terapeutiche, chirurgiche e diagnostiche: la sezione DEVE contenere un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='47420-5'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='47420-5'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-66| Sezione Stato funzionale del paziente: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='47420-5']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.13'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='47420-5']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.13'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-67| Sezione Stato funzionale del paziente: la sezione deve contenere l'elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.13'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='47420-5']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='47420-5']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-68| Sezione Stato funzionale del paziente: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Stato funzionale del paziente'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11369-6']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.3'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11369-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.3'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-69| Sezione Vaccinazioni: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.3'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11369-6']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11369-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-70| Sezione Vaccinazioni: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Vaccinazioni'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11369-6']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11369-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-71| Sezione Vaccinazioni: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10157-6']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.16'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10157-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.16'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-72| Sezione Anamnesi familiare: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.16”'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10157-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10157-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-73| Sezione Anamnesi familiare: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Vaccinazioni'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='29762-2']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='29762-2']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.6'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='29762-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29762-2']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.6'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-74| Sezione Stile di vita: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.6'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='29762-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29762-2']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='29762-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29762-2']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-75| Sezione Stile di vita: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Stile di vita'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10162-6']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='10162-6']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.7'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10162-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10162-6']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.7'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-76| Sezione Gravidanze e parto: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.7'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10162-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10162-6']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10162-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10162-6']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-77| Sezione Gravidanze e parto: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Gravidanze, parti, stato mestruale'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10162-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10162-6']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10162-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10162-6']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-78| Sezione Gravidanze e parto: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='8716-3']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='8716-3']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.8'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='8716-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='8716-3']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.8'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-79| Sezione Parametri vitali: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.8'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='8716-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='8716-3']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='8716-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='8716-3']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-80| Sezione Parametri vitali: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Parametri vitali'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='18776-5']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='18776-5']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.10'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='18776-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='18776-5']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.10'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-81| Sezione Piani di cura: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.10'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='18776-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='18776-5']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='18776-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='18776-5']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-82| Sezione Piani di cura: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Piani di cura'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='46240-8']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='46240-8']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.12'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='46240-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='46240-8']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.12'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-83| Sezione Visite o ricoveri: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.12'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='46240-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='46240-8']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='46240-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='46240-8']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-84| Sezione Visite o ricoveri: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Visite e ricoveri'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='46240-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='46240-8']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='46240-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='46240-8']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-85| Sezione Visite o ricoveri: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='30954-2']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.14'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='30954-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.14'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-86| Sezione Indagini diagnostiche e esami di laboratorio: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.14'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='30954-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='30954-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-87| Sezione Indagini diagnostiche e esami di laboratorio: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Indagini diagnostiche e esami di laboratorio'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='42348-3']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='42348-3']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.15'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='42348-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='42348-3']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.15'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-88| Sezione Assenso/dissenso donazione organi: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.15'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='42348-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='42348-3']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='42348-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='42348-3']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-89| Sezione Assenso/dissenso donazione organi: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Assenso/dissenso donazione organi'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='57827-8']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='57827-8']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.17'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='57827-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='57827-8']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.17'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-90| Sezione Esenzioni: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.17'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='57827-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='57827-8']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='57827-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='57827-8']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-91| Sezione Esenzioni: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Esenzioni'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='57827-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='57827-8']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='57827-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='57827-8']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-92| Sezione Esenzioni: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:code[@codeSystem='2.16.840.1.113883.2.9.5.2.8'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']])=0 or count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:code[@codeSystem='2.16.840.1.113883.2.9.5.2.8'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-93| Sezione Reti di patologia: la sezione DEVE contenere un elemento 'code' valorizzato con l'attributo @codeSystem='2.16.840.1.113883.2.9.5.2.8'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']])=0 or     count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.18'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']])=0 or count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.2.18'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-94| Sezione Reti di patologia: la sezione DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.2.18'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']])=0 or count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']])=0 or count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-95| Sezione Reti di patologia: la sezione DEVE contenere un elemento 'title' possibilmente valorizzato con 'Reti di patologia'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']])=0 or count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']])=0 or count(hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-96| Sezione Reti di patologia: la sezione DEVE contenere almeno un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" mode="M3" priority="1025">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" />
    <xsl:variable name="codice" select="hl7:code/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='48765-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='10160-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='11369-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or    count(hl7:code[@code='11450-4'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='10157-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='29762-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or    count(hl7:code[@code='10162-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='8716-3'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='46264-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or    count(hl7:code[@code='18776-5'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='47519-4'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='46240-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or    count(hl7:code[@code='47420-5'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='30954-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='42348-3'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='57827-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:code[@code='PSSIT99'][@codeSystem='2.16.840.1.113883.2.9.5.2.8'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='48765-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='10160-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='11369-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='11450-4'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='10157-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='29762-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='10162-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='8716-3'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='46264-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='18776-5'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='47519-4'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='46240-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='47420-5'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='30954-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='42348-3'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='57827-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='PSSIT99'][@codeSystem='2.16.840.1.113883.2.9.5.2.8'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-97| Il codice '<xsl:text />
            <xsl:value-of select="$codice" />
            <xsl:text />' non è corretto. La sezione deve essere valorizzata con uno dei seguenti codici:
			48765-2		- Sezione Allergie e intolleranze
			10160-0		- Sezione Terapie farmacologiche
			11369-6		- Sezione Vaccinazioni
			11450-4		- Sezione Lista dei problemi
			10157-6		- Sezione Anamnesi familiare
			29762-2		- Sezione Stile di vita
			10162-6		- Sezione Gravidanze e parto
			8716-3		- Sezione Parametri vitali
			46264-8		- Sezione Protesi, impianti e ausili
			18776-5		- Sezione Piani di cura 
			47519-4 	- Sezione Trattamenti e procedure terapeutiche, chirurgiche e diagnostiche
			46240-8	  	- Sezione Visite e ricoveri
			47420-5		- Sezione Stato funzionale del paziente
			30954-2		- Sezione Indagini diagnostiche e esami di laboratorio
			42348-3		- Sezione Assenso/dissenso donazione organi
			57827-8		- Sezione Esenzioni
			PSSIT99		- Sezione Reti di patologia			
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry" mode="M3" priority="1024">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-98| Sezione Allergie e Intolleranze: entry/act DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.3.1.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="status" select="hl7:act/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-99| Sezione Allergie e Intolleranze: entry/act DEVE contenere un elemento 'effectiveTime' il quale deve avere l'elemento 'low' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or      ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or       ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or       ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-100| Sezione Allergie e Intolleranze: entry/act/effectiveTime deve contenere l'elemento 'high' valorizzato nel caso in cui lo 'statusCode' è "completed"|"aborted".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.4']])=0 and     count(hl7:act/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']])=1) or    (count(hl7:act/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']])=0 and     count(hl7:act/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.4']])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.4']])=0 and count(hl7:act/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']])=1) or (count(hl7:act/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']])=0 and count(hl7:act/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.4']])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-101| Sezione Allergie e Intolleranze: entry/act DEVE contenere una sola entryRelationship/observation conenente l'elemento 'templateId' valorizzato nei seguenti modi:
			- @root='2.16.840.1.113883.2.9.10.1.4.3.1.4' per "Assenza allergie note" 
			- @root='2.16.840.1.113883.2.9.10.1.4.3.1.3' per "Presenza allergie e/o intolleranze".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3'])=0) and     not(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:code[@code='52473-6'][@codeSystem='2.16.840.1.113883.6.1'])=1)">
      <svrl:successful-report test="not(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3'])=0) and not(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:code[@code='52473-6'][@codeSystem='2.16.840.1.113883.6.1'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W003| Sezione Allergie e Intolleranze: si consiglia di valorizzare l'elemento entry/act/entryRelationship/observation/code con @code='52473-6' derivato da LOINC.--&gt;</svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3'])=0 or    count(hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3'])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-102| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation DEVE contenere un elemento 'effectiveTime' il quale deve avere l'elemento 'low' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3'])=0 or    count(hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3'])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-103| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation DEVE contenere un elemento 'value' con l'attributo @xsi:type="CD".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="temp" select="hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($temp)=0 or     (count($temp/hl7:value/@code)=1 and count($temp/hl7:value/hl7:originalText/hl7:reference/@value)&lt;=1 and     count($temp/hl7:value[@codeSystem='2.16.840.1.113883.5.4' or @codeSystem='2.16.840.1.113883.1.11.19700'])=1) or     (count($temp/hl7:value/@code)=0 and count($temp/hl7:value/hl7:originalText/hl7:reference/@value)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($temp)=0 or (count($temp/hl7:value/@code)=1 and count($temp/hl7:value/hl7:originalText/hl7:reference/@value)&lt;=1 and count($temp/hl7:value[@codeSystem='2.16.840.1.113883.5.4' or @codeSystem='2.16.840.1.113883.1.11.19700'])=1) or (count($temp/hl7:value/@code)=0 and count($temp/hl7:value/hl7:originalText/hl7:reference/@value)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-104| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/value può essere valorizzato nei modi seguenti:
			- nel caso di 'value' non codificato DEVE avere l'elemento originalText/reference/@value valorizzato;
			- nel caso di 'value' codificato DEVE essere valorizzato con l'attributo @codeSystem='2.16.840.1.113883.5.4' o @codeSystem='2.16.840.1.113883.1.11.19700'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($temp)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($temp)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-105| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation DEVE contenere almeno un 'participant' - "Descrizione Agente".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or      count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.3'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.3'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-106| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation (Criticità di un'allergia o intolleranza) DEVE includere l'identificativo 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.3.1.5.3' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or      count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation]/hl7:observation/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation]/hl7:observation/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-107| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation (Criticità di un'allergia o intolleranza) DEVE avere un elemento 'value' con l'attributo @xsi:type='CD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or      count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.1063'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.1063'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-108| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation/value (Criticità di un'allergia o intolleranza) DEVE essere derivato dal value set "CriticalityObservation" - @codeSystem='2.16.840.1.113883.5.1063'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-109| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation (Stato di un'allergia) DEVE includere l'identificativo 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.3.1.6'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-110| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation (Stato di un'allergia) DEVE contenere un elemento 'code' valorizzato con gli attributi @code='33999-4' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.11' or @codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.11' or @codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-111| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation (Stato di un'allergia) DEVE avere un elemento 'value' valorizzato secondo il value set "Stato clinico allergia" - @codeSystem='2.16.840.1.113883.6.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-112| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation (Note e commenti) DEVE contenere un 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.3.1.7'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="temp_abs" select="hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.4']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($temp_abs)=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.4']]/hl7:code[@code='OINT'][@codeSystem='2.16.840.1.113883.5.4' or @codeSystem='2.16.840.1.113883.1.11.19700'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($temp_abs)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.4']]/hl7:code[@code='OINT'][@codeSystem='2.16.840.1.113883.5.4' or @codeSystem='2.16.840.1.113883.1.11.19700'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-113| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation DEVE avere un elemento 'code' valorizzato con @code='OINT' e @codeSystem='2.16.840.1.113883.5.4' o @codeSystem='2.16.840.1.113883.1.11.19700'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($temp_abs)=0 or     (count($temp_abs/hl7:value/@code)=1 and     count($temp_abs/hl7:value[@codeSystem='2.16.840.1.113883.5.1150.1' or @codeSystem='2.16.840.1.113883.11.22.9'])=1    and count($temp_abs/hl7:value/hl7:originalText/hl7:reference/@value)&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($temp_abs)=0 or (count($temp_abs/hl7:value/@code)=1 and count($temp_abs/hl7:value[@codeSystem='2.16.840.1.113883.5.1150.1' or @codeSystem='2.16.840.1.113883.11.22.9'])=1 and count($temp_abs/hl7:value/hl7:originalText/hl7:reference/@value)&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-114| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/value DEVE deve essere valorizzato secondo il value set "Absent or Unknown allergies" @codeSystem='2.16.840.1.113883.5.1150.1' or @codeSystem='2.16.840.1.113883.11.22.9'  
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]/hl7:participant" mode="M3" priority="1023">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]/hl7:participant" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:code/@code)=0 or     count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or     count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or     count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:code/@code)=0 or count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-115| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/participant/participantRole/playingEntity/code deve avere l'attributo @codeSystem valorizzato come segue:
				- 2.16.840.1.113883.6.73		codifica "WHO ATC"
				- 2.16.840.1.113883.2.9.6.1.5 		codifica "AIC"
				- 2.16.840.1.113883.11.22.9 		value set "AbsentorUnknownAllergies" (- per le allergie non a farmaci –)
				</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:code/@nullFlavor)=0 or      count(hl7:participantRole/hl7:playingEntity/hl7:code[@nullFlavor='NI'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:code/@nullFlavor)=0 or count(hl7:participantRole/hl7:playingEntity/hl7:code[@nullFlavor='NI'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-116| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/participant/participantRole/playingEntity DEVE contenere l'elemento code valorizzato con l'attributo @nullFlavor='NI'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:participantRole/hl7:playingEntity/hl7:code/@nullFlavor)=0 or     count(hl7:participantRole/hl7:playingEntity/hl7:code/hl7:originalText/hl7:reference)=1) " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:participantRole/hl7:playingEntity/hl7:code/@nullFlavor)=0 or count(hl7:participantRole/hl7:playingEntity/hl7:code/hl7:originalText/hl7:reference)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-117| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/participant/participantRole/playingEntity DEVE contenere l'elemento originalText/reference.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]/hl7:entryRelationship[@typeCode='MFST']" mode="M3" priority="1022">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.3']]/hl7:entryRelationship[@typeCode='MFST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1' or @root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1' or @root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-118| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation (Descrizione reazioni) DEVE contenere il 'templateId' valorizzato come segue:
				- @root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1' nel caso di Descrizione Reazione codificato
				- @root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2' nel caso di Descrizione reazione non codificato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-119| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation (Descrizione reazioni) DEVE contenere l'elemento 'code' valorizzato con i seguenti attributi @code='75321-0' e @codeSystem='2.16.840.1.113883.6.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1'])=0 or     count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3' or @codeSystem='2.16.840.1.113883.2.9.77.22.11.4' or @codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1'])=0 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3' or @codeSystem='2.16.840.1.113883.2.9.77.22.11.4' or @codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-120| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation/code (Descrizione reazioni) DEVE essere valorizzato secondo i seguenti dizionari:
				- 2.16.840.1.113883.2.9.77.22.11.3		Value Set Reazioni Intolleranza
				- 2.16.840.1.113883.2.9.77.22.11.4 		Value Set Reazioni Allergiche
				- 2.16.840.1.113883.6.103			ICD-9-CM
				</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2'])=0 or     count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2'])=0 or count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-121| Sezione Allergie e Intolleranze: entry/act/entryRelationship/observation/entryRelationship/observation/value (Descrizione reazioni) DEVE contenere l'elemento originalText/reference.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry" mode="M3" priority="1021">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration[@moodCode='INT' or @moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration[@moodCode='INT' or @moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-122| Sezione Terapia Farmacologica: entry DEVE contenere un elemento di tipo 'substanceAdministration' con attributo @moodCode valrizzato con 'INT' o 'EVN'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1'])=1 or         count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.3'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1'])=1 or count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.3'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-123| Sezione Terapia Farmacologica: entry/substanceAdministration DEVE contenere un elemento 'templateId' valorizato come segue:
			- @root='2.16.840.1.113883.2.9.10.1.4.3.2.1' per Terapia o 
			- @root='2.16.840.1.113883.2.9.10.1.4.3.2.3' per Assenza di terapia</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:text)=0 or count(hl7:substanceAdministration/hl7:text/hl7:reference/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:text)=0 or count(hl7:substanceAdministration/hl7:text/hl7:reference/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-124| Sezione Terapia Farmacologica: entry/substanceAdministration/text DEVE contenere l'elemento reference/@value valorizzato con l’URI che punta alla descrizione della terapia nel narrative block della sezione.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1'])=0 or    count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1'])=0 or count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-125| Sezione Terapia Farmacologica: entry/substanceAdministration/effectiveTime DEVE essere presente e deve avere l'elemento 'low' valorizzato  </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="status" select="hl7:substanceAdministration/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1'])=0 or    ($status='completed' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or    ($status='aborted' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or     ($status='suspended' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0) or     ($status='active' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1'])=0 or ($status='completed' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or ($status='aborted' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or ($status='suspended' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0) or ($status='active' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-126| Sezione Terapia Farmacologica: entry/substanceAdministration/effectiveTime/high DEVE essere presente nel caso in cui lo 'statusCode' sia 'completed'oppure'aborted'
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1'])=0 or    count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1'])=0 or count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-127| Sezione Terapia Farmacologica: entry/substanceAdministration/consumable/manufacturedProduct DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.2.2'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="farma" select="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1']]/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1']])=0 or     (count($farma/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or     count($farma/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or    count($farma/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1']])=0 or (count($farma/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count($farma/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or count($farma/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-128| Sezione Terapia Farmacologica: entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial deve contenere un elemento 'code' valorizzato secondo i seguenti sistemi di codifica:
			- @codeSystem='2.16.840.1.113883.2.9.6.1.5' 	(AIC)
			- @codeSystem='2.16.840.1.113883.6.73'			(ATC)
			- @codeSystem='2.16.840.1.113883.2.9.6.1.51'	(GE)
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="trans_vl" select="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.1']]/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($trans_vl/hl7:code/hl7:translation)=0 or    (count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or    count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or    count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or    count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or    count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or    count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($trans_vl/hl7:code/hl7:translation)=0 or (count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-129| Sezione Terapia farmacologica: entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/translation DEVE essere valorizzato secondo i seguenti sistemi di codifica:
			@codeSystem='2.16.840.1.113883.6.73' (ATC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.5' (AIC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.51' (GE)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.3'])=0 or     count(hl7:substanceAdministration/hl7:code[@codeSystem='2.16.840.1.113883.11.22.15' or @codeSystem='2.16.840.1.113883.5.1150.1'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.2.3'])=0 or count(hl7:substanceAdministration/hl7:code[@codeSystem='2.16.840.1.113883.11.22.15' or @codeSystem='2.16.840.1.113883.5.1150.1'])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-130| Sezione Terapia farmacologica: entry/substanceAdministration/code DEVE essere valorizzato secondo il value set @codeSystem='2.16.840.1.113883.11.22.15' o @codeSystem='2.16.840.1.113883.5.1150.1' (Absent or Unknown Medication)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:entry" mode="M3" priority="1020">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration)=1 and count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration)=1 and count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-131| Sezione Vaccinazioni: entry/substanceAdministration DEVE essere conforme al 'templateId' valorizzato con  @root='2.16.840.1.113883.2.9.10.1.4.3.3.1'
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:code[@code='IMMUNIZ'][@codeSystem='2.16.840.1.113883.5.4'])=1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:code[@code='IMMUNIZ'][@codeSystem='2.16.840.1.113883.5.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-132| Sezione Vaccinazioni: entry/substanceAdministration DEVE contenere un 'code' valorizzato con il gli attributi @code='IMMUNIZ' e @codeSystem='2.16.840.1.113883.5.4' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:text)=0 or count(hl7:substanceAdministration/hl7:text/hl7:reference/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:text)=0 or count(hl7:substanceAdministration/hl7:text/hl7:reference/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-133| Sezione Vaccinazioni: entry/substanceAdministration/text/reference DEVE contenere l'attributo @value valorizzato con l’URI che punta alla descrizione della terapia nel narrative block della sezione.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:statusCode[@code='completed'])=1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-134| Sezione Vaccinazioni: entry/substanceAdministration DEVE contenere uno statusCode valorizzato @code='completed' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-135| Sezione Vaccinazioni: entry/substanceAdministration/consumable/manufacturedProduct DEVE contenere l'elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="farma_vacc" select="hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($farma_vacc/hl7:code/@code)=0 or     count($farma_vacc/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or     count($farma_vacc/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($farma_vacc/hl7:code/@code)=0 or count($farma_vacc/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count($farma_vacc/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-136| Sezione Vaccinazioni: entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial DEVE contenere un elemento 'code' valorizzato secondo i seguenti sistemi di codifica:
			- @codeSystem='2.16.840.1.113883.2.9.6.1.5' 	(AIC)
			- @codeSystem='2.16.840.1.113883.6.73'			(ATC)
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="trans_vacc" select="hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($trans_vacc/hl7:code/hl7:translation)=0 or    (count($trans_vacc/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or    count($trans_vacc/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($trans_vacc/hl7:code/hl7:translation)=0 or (count($trans_vacc/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count($trans_vacc/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-137| Sezione Vaccinazioni: entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/translation DEVE essere valorizzato secondo i seguenti sistemi di codifica:
			@codeSystem='2.16.840.1.113883.6.73' (ATC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.5' (AIC)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:lotNumberText)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:lotNumberText)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-138| Sezione Vaccinazioni: entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial DEVE contenere un elemento 'lotNumberText'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@nullFlavor)=0 or     count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@nullFlavor='OTH'])=1 and     count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/hl7:originalText/hl7:reference)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/@nullFlavor)=0 or count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@nullFlavor='OTH'])=1 and count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code/hl7:originalText/hl7:reference)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-139| Sezione Vaccinazioni: entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code non codificato deve avere l'attributo @nullFlavor='OTH' e deve contenere l'elemento originalText/reference valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3']) &lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3']) &lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-140| Sezione Vaccinazioni: entry/substanceAdministration può contenere  al più un entryRelationship/obersavation che descrive il "Periodo di copertura" conforme al 'templateId' @root='2.16.840.1.113883.2.9.10.1.4.3.3.3' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3'])=0 or    count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3']]/hl7:code[@code='59781-5'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3']]/hl7:code[@code='59781-5'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-141| Sezione Vaccinazioni: entry/substanceAdministration/entryReletionship/observation (Periodo di copertura) DEVE avere un elemento 'code' valorizzato con @code='59781-5' e @codeSystem='2.16.840.1.113883.6.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3'])=0 or    count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3']]/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3']]/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-142| Sezione Vaccinazioni: entry/substanceAdministration/entryReletionship/observation (Periodo di copertura) DEVE contenere un elemento 'statusCode' valorizzato con 'completed'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3'])=0 or    count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3']]/hl7:value/hl7:high)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.3']]/hl7:value/hl7:high)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-143| Sezione Vaccinazioni: entry/substanceAdministration/entryReletionship/observation (Periodo di copertura) DEVE deve contenere un elemento 'value' il quale deve avere l'elemento 'high' valorizzato. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']) &lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']) &lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-144| Sezione Vaccinazioni: entry/substanceAdministration può contenere al più un entryRelationship/obersavation che descrive il "Numero delle dosi" conforme al 'templateId' @root='2.16.840.1.113883.2.9.10.1.4.3.3.4'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4'])=0 or    count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']]/hl7:code[@code='30973-2'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']]/hl7:code[@code='30973-2'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-145| Sezione Vaccinazioni: entry/substanceAdministration/entryReletionship/observation (Numero delle dosi) DEVE contenere un elemento 'code' valorizzato con @code='30973-2' e @codeSystem='2.16.840.1.113883.6.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4'])=0 or    count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']]/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']]/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-146| Sezione Vaccinazioni: entry/substanceAdministration/entryReletionship/observation (Numero delle dosi) DEVE deve contenere un elemento 'statusCode' valorizzato con @code='completed' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4'])=0 or    count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']]/hl7:value[@xsi:type='INT'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']]/hl7:value[@xsi:type='INT'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-147| Sezione Vaccinazioni: entry/substanceAdministration/entryReletionship/observation (Numero delle dosi) DEVE contenere un elemento 'value' il cui attributo @xsi:type='INT' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4'])=0 or    count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']]/hl7:value/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.3.4']]/hl7:value/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-148| Sezione Vaccinazioni: entry/substanceAdministration/entryReletionship/observation/value DEVE avere l'attributo @value valorizzato</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])=0 or     count(hl7:substanceAdministration/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])=0 or count(hl7:substanceAdministration/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-149| Sezione Vaccinazioni: entry/substanceAdministration/entryRelationship/act relativo a "Annotazioni e commenti" deve contenere l'elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.1.7' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship[@typeCode='CAUS']" mode="M3" priority="1019">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11369-6']]/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship[@typeCode='CAUS']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1' or @root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1' or @root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-150| Sezione Vaccinazioni: entry/substanceAdministration/entryRelationship/observation (Descrizione reazione) DEVE essere conforme al 'templateId' @root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1' (Descrizione reazione codificata) o '2.16.840.1.113883.2.9.10.1.4.3.1.5.2' (Descrizione reazione non codificata)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-151| Sezione Vaccinazioni: entry/substanceAdministration/entryRelationship/observation (Descrizione reazione) DEVE contenere l'elemento 'code' valorizzato con @code='75321-0' e @codeSystem='2.16.840.1.113883.6.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1'])=0 or     count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3' or @codeSystem='2.16.840.1.113883.2.9.77.22.11.4' or @codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.1'])=0 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3' or @codeSystem='2.16.840.1.113883.2.9.77.22.11.4' or @codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-152| Sezione Vaccinazioni: entry/substanceAdministration/entryRelationship/observation (Descrizione reazione) DEVE contenere l'elemento 'value' valorizzato secondo i seguenti sistemi di codifica:
				- 2.16.840.1.113883.2.9.77.22.11.3		Value Set Reazioni Intolleranza
				- 2.16.840.1.113883.2.9.77.22.11.4 		Value Set Reazioni Allergiche
				-2.16.840.1.113883.6.103				ICD-9-CM
				</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2'])=0 or     count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.5.2'])=0 or count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-153| Sezione Vaccinazioni: entry/substanceAdministration/entryRelationship/observation/value (Descrizione reazione) DEVE contenere l'elemento originalText/reference.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:entry" mode="M3" priority="1018">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act[@classCode='ACT'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act[@classCode='ACT'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-154| Sezione Lista dei problemi: la 'entry' DEVE essere di tipo 'act' valorizzato con gli attributi @classCode='ACT' e @moodCode='EVN'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-155| Sezione Lista dei problemi: entry/act DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.4.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-156| Sezione Lista dei problemi: entry/act DEVE contenere un elemento 'effectiveTime' il quale deve avere l'elemento 'low' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:statusCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:statusCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-157| Sezione Lista dei problemi: entry/act DEVE contenere l'elemento 'statusCode'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="stats" select="hl7:act/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:statusCode/@nullFlavor)=1 or     ($stats='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or    ($stats='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or     ($stats='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or     ($stats='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:statusCode/@nullFlavor)=1 or ($stats='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($stats='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($stats='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or ($stats='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-158| Sezione Lista dei problemi: entry/act/effectiveTime/high DEVE essere presente nel caso in cui lo 'statusCode' sia 'completed' oppure 'aborted'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-159| Sezione Lista dei problemi: entry/act DEVE contenere almeno una entryRelationship/observation relativa ai "Dettagli del problema" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:entry/hl7:act/hl7:entryRelationship" mode="M3" priority="1017">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11450-4']]/hl7:entry/hl7:act/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1 or count(hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1 or count(hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-160| Sezione Lista dei problemi: l'elemento entry/act/entryRelationship deve avere uno dei seguenti sotto elementi:
				- 'observation': per i dettagli del problema;
				- 'act': per i riferimenti interni al problema;</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-161| Sezione Lista dei problemi: entry/act/entryRelationship/observation deve avere un elemento templateId con attributo @root='2.16.840.1.113883.2.9.10.1.4.3.4.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-162| Sezione Lista dei problemi: entry/act/entryRelationship/observation deve contenere l'elemento id </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-163| Sezione Lista dei problemi: entry/act/entryRelationship/observation/effectiveTime deve contenere l'elemento low e deve essere valorizzato</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-164| Sezione Lista dei problemi: entry/act/entryRelationship/observation deve contenere l'elemento 'value'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:statusCode[@nullFlavor='NA'])=0 or      count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.11.22.17'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:statusCode[@nullFlavor='NA'])=0 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.11.22.17'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-165| Sezione Lista dei problemi: entry/act/entryRelationship/observation/value deve essere valorizzato secondo il value set  "Absent or Unknown Problems" - @codeSystem='2.16.840.1.113883.11.22.17' .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or       count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.4']])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.4']])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-166| Sezione Lista dei problemi: entry/act/entryRelationship/observation può contenere una ed una sola 'entryRelationship/observation' relativa alla "Gravità del problema" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or       count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-167| Sezione Lista dei problemi: entry/act/entryRelationship/observation può contenere una ed una sola 'entryRelationship/observation' relativa allo "Stato clinico del problema"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']])=0 or      count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']]/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']])=0 or count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']]/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-168| Sezione Lista dei problemi: entry/act/entryRelationship/observation/entryRelationship/observation/code (Stato problema) DEVE essere valorizzato con @code='33999-4' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']])=0 or      count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.11' or @codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']])=0 or count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.6']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.11' or @codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-169| Sezione Lista dei problemi: entry/act/entryRelationship/observation/entryRelationship/observation/value/@code DEVE essere selezionato dal value set "Stato clinico del Problema" - @codeSystem='2.16.840.1.113883.2.9.77.22.11.11' oppure LOINC - @codeSystem='2.16.840.1.113883.6.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or       count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-170| Sezione Lista dei problemi: entry/act/entryRelationship/observation può contenere una ed una sola 'entryRelationship/observation' relativa alla "Cronicità del problema"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']])=0 or       count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']]/hl7:code[@code='89261-2'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']])=0 or count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']]/hl7:code[@code='89261-2'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-171| Sezione Lista dei problemi: entry/entryRelationship/observation/entryRelationship/observation (Cronicità del Problema) DEVE contenere un elemento 'code' valorizzato con @code='89261-2' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']])=0 or       count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10' or @codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']])=0 or count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.5']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10' or @codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-172| Sezione Lista dei problemi: entry/entryRelationship/observation/entryRelationship/observation (Cronicità del Problema) DEVE contenere un elemento 'value' valorizzato secondo @codeSystem='2.16.840.1.113883.2.9.77.22.11.10' (CronicitàProblema_PSS) or @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])=0 or       count(hl7:observation/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])=0 or count(hl7:observation/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-173| Sezione Lista dei problemi: entry/act/entryRelationship/observation/entryRelationship/act (Note e Commenti) DEVE avere un templateId valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.1.7'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.3'])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.4.3'])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-174| Sezione Lista dei problemi: entry/act/entryRelationship/act (Riferimenti interni) DEVE avere un elemento 'templateId' valorizzato con  @root='2.16.840.1.113883.2.9.10.1.4.3.4.3'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:entry" mode="M3" priority="1016">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer[@classCode='CLUSTER'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer[@classCode='CLUSTER'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-175| Sezione Anamnesi Familiare: la sezione DEVE contenere un elemento entry/organizer valorizzato con attributi @classCode='CLUSTER' e @moodCode='EVN'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.16.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.16.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-176| Sezione Anamnesi Familiare: entry/organizer DEVE contenere un elemento 'templateId' dvalorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.16.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:subject)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:subject)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-177| Sezione Anamnesi Familiare: entry/organizer DEVE contenere un elemento 'subject'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:subject/hl7:relatedSubject[@classCode='PRS'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:subject/hl7:relatedSubject[@classCode='PRS'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-178| Sezione Anamnesi Familiare: entry/organizer/subject/relatedSubject DEVE essere valorizzato con l'attributo @classCode='PRS'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:code[@codeSystem='2.16.840.1.113883.5.111'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:code[@codeSystem='2.16.840.1.113883.5.111'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-179| Sezione Anamnesi Familiare: entry/organizer/subject/relatedSubject/code deve essere valorizzato secondo la tabella "PersonalRelationshipRoleCodeType" relativo al code system "RoleCode" - @codeSystem='2.16.840.1.113883.5.111' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:subject/hl7:administrativeGenderCode)=0 or    count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:subject/hl7:administrativeGenderCode[@codeSystem='2.16.840.1.113883.5.1' or @codeSystem='2.16.840.1.113883.1.11.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:subject/hl7:administrativeGenderCode)=0 or count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:subject/hl7:administrativeGenderCode[@codeSystem='2.16.840.1.113883.5.1' or @codeSystem='2.16.840.1.113883.1.11.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-180| Sezione Anamnesi Familiare: entry/organizer/subject/relatedSubject/subject/administrativeGenderCode DEVE essere valorizzato secondo il code system "HL7 AdministrativeGender" - @codeSystem='2.16.840.1.113883.1.11.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:component[hl7:observation])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:component[hl7:observation])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-181| Sezione Anamnesi Familiare: entry/organizer DEVE contenere almeno un elemento 'component' di tipo 'observation'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:entry/hl7:organizer/hl7:component" mode="M3" priority="1015">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:entry/hl7:organizer/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-182| Sezione Anamnesi Familiare: entry/organizer/component DEVE contenere un elemento di tipo 'observation'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.16.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.16.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-183| Sezione Anamnesi Familiare: entry/organizer/component/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.16.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1' or @codeSystem='2.16.840.1.113883.2.9.77.22.11.9'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1' or @codeSystem='2.16.840.1.113883.2.9.77.22.11.9'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-184| Sezione Anamnesi Familiare: entry/organizer/component/observation DEVE contenere un elemento 'code' valorizzato secondo @codeSystem='2.16.840.1.113883.6.1' oppure @codeSystem='2.16.840.1.113883.2.9.77.22.11.9'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation/hl7:entryRelationship[hl7:observation])&lt;=2)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation/hl7:entryRelationship[hl7:observation])&lt;=2)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-185| Sezione Anamnesi Familiare: entry/organizer/component/observation/entryRelationship di tipo 'observation' DEVE essere presente al più 2 volte:
				- età di insorgenza
				- età di decesso</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:entry/hl7:organizer/hl7:component/hl7:observation/hl7:entryRelationship" mode="M3" priority="1014">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10157-6']]/hl7:entry/hl7:organizer/hl7:component/hl7:observation/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.16.3'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.16.3'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-186| Sezione Anamnesi Familiare: entry/organizer/component/observation/entryRelationship/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.16.3'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='35267-4' or @code='39016-1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='35267-4' or @code='39016-1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-187| Sezione Anamnesi Familiare: entry/organizer/component/observation/entryRelationship/observation/code DEVE essere valorizzato secondo il value set "EtàInsorgenza" derivato da @codeSystem='2.16.840.1.113883.6.1':
				- @code='35267-4': età di insorgenza
				- @code='39016-1': età di decesso</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-188| Sezione Anamnesi Familiare: entry/organizer/component/observation/entryRelationship/observation DEVE contenere un elemento 'statusCode' valorizzato con @code='completed'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-189| Sezione Anamnesi Familiare: entry/organizer/component/observation/entryRelationship/observation DEVE contenere un elemento 'value'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='29762-2']]/hl7:entry" mode="M3" priority="1013">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='29762-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-190| Sezione stile di vita: entry/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-191| Sezione stile di vita: entry/observation DEVE contenere un solo elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-192| Sezione stile di vita: entry/observation/code DEVE essere selezionato dal value set "SocialHistoryEntryElement_PSSIT DYNAMIC" derivato da @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:text)=0 or count(hl7:observation/hl7:text/hl7:reference/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:text)=0 or count(hl7:observation/hl7:text/hl7:reference/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-193| Sezione stile di vita: entry/observation/text DEVE contenere l'elemento 'reference/@value' valorizzato con l'URI che punta alla descrizione del problema nel narrative block</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value/hl7:originalText)=0 or count(hl7:observation/hl7:value/hl7:originalText/hl7:reference/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value/hl7:originalText)=0 or count(hl7:observation/hl7:value/hl7:originalText/hl7:reference/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-194| Sezione stile di vita: entry/observation/value/originalText DEVE contenere l'elemento 'reference/@value' valorizzato con l'URI che punta alla descrizione dell'informazione nel narrative block</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10162-6']]/hl7:entry" mode="M3" priority="1012">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10162-6']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.7.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.7.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-195| Sezione gravidanze e parto: entry/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.7.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-196| Sezione gravidanze e parto: entry/observation DEVE contenere un solo elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-197| Sezione gravidanze e parto: entry/observation/code DEVE essere selezionato dal value set "PregnancyObservation_PSSIT" derivato da @codeSystem='2.16.840.1.113883.6.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='8716-3']]/hl7:entry" mode="M3" priority="1011">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='8716-3']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=1 or count(hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=1 or count(hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-198| Sezione Parametri Vitali: l'entry DEVE contenere o un elemento di tipo 'organizer' oppure di tipo 'observation'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.8.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.8.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-199| Sezione Parametri Vitali: entry/organizer DEVE contenere un 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.8.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:component[hl7:observation])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:component[hl7:observation])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-200| Sezione Parametri Vitali: entry/organizer DEVE contenere almeno un elemento 'component' di tipo 'observation'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.8.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.8.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-201| Sezione Parametri Vitali: entry/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.8.2'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-202| Sezione Parametri Vitali: entry/observation/code DEVE essere valorizzato con @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:value[@xsi:type='PQ'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:value[@xsi:type='PQ'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-203| Sezione Parametri Vitali: entry/observation/value DEVE avere valorizzato l'attributo @xsi:type='PQ'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='8716-3']]/hl7:entry/hl7:organizer/hl7:component" mode="M3" priority="1010">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='8716-3']]/hl7:entry/hl7:organizer/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.8.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.8.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-204| Sezione Parametri Vitali: entry/organizer/component/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.8.2'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-205| Sezione Parametri Vitali: entry/organizer/component/observation/code DEVE essere valorizzato secondo il @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value[@xsi:type='PQ'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value[@xsi:type='PQ'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-206| Sezione Parametri Vitali: entry/organizer/component/observation/value DEVE avere valorizzato l'attributo @xsi:type='PQ'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry" mode="M3" priority="1009">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='46264-8']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:supply)=1) and    (count(hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1'])=1 or    count(hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.2'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:supply)=1) and (count(hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1'])=1 or count(hl7:supply/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.2'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-207| Sezione Protesi, impianti, ausili: l'entry DEVE essere di tipo 'supply' e DEVE contenere un elemento 'templateId' valorizzato a seconda dei due seguenti casi:
			- Indicazione presenza: @root='2.16.840.1.113883.2.9.10.1.4.3.9.1'
			- Indiczione assenza: @root='2.16.840.1.113883.2.9.10.1.4.3.9.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:supply[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']])=0 or     count(hl7:supply/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.48'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:supply[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']])=0 or count(hl7:supply/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.48'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-208| Sezione Protesi, impianti, ausili: entry/supply DEVE contenere un elemento 'code'valorizzato secondo il code system "Classificazione Nazionale dei Dispositivi medici" - @codeSystem='2.16.840.1.113883.2.9.6.1.48'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:supply[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']])=0 or     count(hl7:supply[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']]/hl7:effectiveTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:supply[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']])=0 or count(hl7:supply[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.1']]/hl7:effectiveTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-209| Sezione Protesi, impianti, ausili: entry/supply DEVE contenere un elemento 'effectiveTime'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:supply[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.2']])=0 or     count(hl7:supply/hl7:code[@codeSystem='2.16.840.1.113883.11.22.36'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:supply[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.9.2']])=0 or count(hl7:supply/hl7:code[@codeSystem='2.16.840.1.113883.11.22.36'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-210| Sezione Protesi, impianti, ausili: entry/supply DEVE contenere un elemento 'code' valorizzato secondo il value set "IPSNoProceduresInfos" - @codeSystem='2.16.840.1.113883.11.22.36'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='18776-5']]/hl7:entry" mode="M3" priority="1008">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='18776-5']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1 or count(hl7:substanceAdministration)=1 or count(hl7:procedure)=1 or count(hl7:encounter)=1 or count(hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1 or count(hl7:substanceAdministration)=1 or count(hl7:procedure)=1 or count(hl7:encounter)=1 or count(hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-211| Sezione Piani di cura: l'entry può contenere uno dei seguenti sotto statement:
			- 'observation':	 per le prestazioni del piano di cura;
			- 'substanceAdministration': 	per le terapie o le vaccinazioni del piano di cura;
			- 'procedure': 	per le procedure chirurgiche previste dal piano di cura;
			- 'encounter': 	per le visite o i ricoveri previsti da piano di cura;
			- 'act': 	per altre attività del piano di cura.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation[@moodCode='INT' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO' or @moodCode='GOL'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation[@moodCode='INT' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO' or @moodCode='GOL'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-212|Sezione Piani di cura: entry/observation DEVE avere l'attributo @moodCode valorizzato con uno dei seguenti valori: 'INT' or 'PRMS' or 'PRP' or 'RQO' or 'GOL' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-213|Sezione Piani di cura: entry/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.10.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-214|Sezione Piani di cura: entry/observation DEVE contenere un solo elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:effectiveTime)=0 or (count(hl7:observation/hl7:effectiveTime[@value])=1 or count(hl7:observation/hl7:effectiveTime/hl7:low)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:effectiveTime)=0 or (count(hl7:observation/hl7:effectiveTime[@value])=1 or count(hl7:observation/hl7:effectiveTime/hl7:low)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-215|Sezione Piani di cura: entry/observation/effectiveTime DEVE avere l'attributo @value valorizzato nel caso si voglia descrivere un preciso istante (point in time)
			oppure DEVE avere l'elemento 'low' valorizzato nel caso si voglia indicare un intervallo temporale.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration)=0 or count(hl7:substanceAdministration[@moodCode='INT' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration)=0 or count(hl7:substanceAdministration[@moodCode='INT' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-216|Sezione Piani di cura: entry/substanceAdministration DEVE avere l'attributo @moodCode valorizzato con uno dei seguenti valori: 'INT' or 'PRMS' or 'PRP' or 'RQO'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration)=0 or count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration)=0 or count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-217|Sezione Piani di cura: entry/substanceAdministration DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.10.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration)=0 or count(hl7:substanceAdministration/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration)=0 or count(hl7:substanceAdministration/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-218|Sezione Piani di cura: entry/substanceAdministration DEVE contenere un solo elemento 'id'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS'])=0 or     (count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/@value)=1 or count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS'])=0 or (count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/@value)=1 or count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-219|Sezione Piani di cura: entry/substanceAdministration/effectiveTime DEVE avere l'attributo @value valorizzato nel caso si voglia descrivere un preciso istante (point in time)
			oppure DEVE avere l'elemento 'low' valorizzato nel caso si voglia indicare un intervallo temporale. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:procedure)=0 or count(hl7:procedure[@moodCode='INT' or @moodCode='ARQ' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:procedure)=0 or count(hl7:procedure[@moodCode='INT' or @moodCode='ARQ' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-220|Sezione Piani di cura: entry/procedure DEVE avere l'attributo @moodCode valorizzato con uno dei seguenti valori: 'INT' or 'ARQ' or 'PRMS' or 'PRP' or 'RQO'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:procedure)=0 or count(hl7:procedure/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.3'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:procedure)=0 or count(hl7:procedure/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.3'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-221|Sezione Piani di cura: entry/procedure DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.10.3'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:procedure)=0 or count(hl7:procedure/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:procedure)=0 or count(hl7:procedure/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-222|Sezione Piani di cura: entry/procedure DEVE contenere un solo elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:procedure)=0 or count(hl7:procedure/hl7:code)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:procedure)=0 or count(hl7:procedure/hl7:code)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-223|Sezione Piani di cura: entry/procedure DEVE contenere un solo elemento code </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:procedure/hl7:effectiveTime)=0 or (count(hl7:procedure/hl7:effectiveTime[@value])=1 or count(hl7:procedure/hl7:effectiveTime/hl7:low)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:procedure/hl7:effectiveTime)=0 or (count(hl7:procedure/hl7:effectiveTime[@value])=1 or count(hl7:procedure/hl7:effectiveTime/hl7:low)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-224|Sezione Piani di cura: entry/procedure/effectiveTime DEVE avere l'attributo @value valorizzato nel caso si voglia descrivere un preciso istante (point in time)
			oppure DEVE avere l'elemento 'low' valorizzato nel caso si voglia indicare un intervallo temporale.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter)=0 or count(hl7:encounter[@moodCode='INT' or @moodCode='ARQ' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter)=0 or count(hl7:encounter[@moodCode='INT' or @moodCode='ARQ' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-225|Sezione Piani di cura: entry/encounter DEVE avere l'attributo @moodCode valorizzato con uno dei seguenti valori: 'INT' or 'ARQ' or 'PRMS' or 'PRP' or 'RQO'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter)=0 or count(hl7:encounter/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter)=0 or count(hl7:encounter/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-226|Sezione Piani di cura: entry/encounter DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.10.4'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter)=0 or count(hl7:encounter/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter)=0 or count(hl7:encounter/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-227|Sezione Piani di cura: entry/encounter DEVE contenere un solo elemento 'id'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter)=0 or count(hl7:encounter/hl7:code)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter)=0 or count(hl7:encounter/hl7:code)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-228|Sezione Piani di cura: entry/encounter DEVE contenere un solo elemento 'code' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter)=0 or count(hl7:encounter/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.14' or @codeSystem='2.16.840.1.113883.5.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter)=0 or count(hl7:encounter/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.14' or @codeSystem='2.16.840.1.113883.5.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-229|Sezione Piani di cura: entry/encounter/code DEVE essere valorizzato secondo il value set "EncounterCode" - @codeSystem='2.16.840.1.113883.2.9.77.22.11.14' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter/hl7:effectiveTime)=0 or (count(hl7:encounter/hl7:effectiveTime/@value)=1 or count(hl7:encounter/hl7:effectiveTime/hl7:low)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter/hl7:effectiveTime)=0 or (count(hl7:encounter/hl7:effectiveTime/@value)=1 or count(hl7:encounter/hl7:effectiveTime/hl7:low)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-230|Sezione Piani di cura: entry/encounter/effectiveTime DEVE avere l'attributo @value valorizzato nel caso si voglia descrivere un preciso istante (point in time)
			oppure DEVE avere l'elemento 'low' valorizzato nel caso si voglia indicare un intervallo temporale. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act[@moodCode='INT' or @moodCode='ARQ' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act[@moodCode='INT' or @moodCode='ARQ' or @moodCode='PRMS' or @moodCode='PRP' or @moodCode='RQO'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-231|Sezione Piani di cura: entry/act DEVE acere l'attributo @moodCode valorizzato secondo i seguenti valori: 'INT' or 'ARQ' or 'PRMS' or 'PRP' or 'RQO'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.5'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.10.5'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-232|Sezione Piani di cura: entry/act DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.10.5'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-233|Sezione Piani di cura: entry/act DEVE contenere un solo elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:effectiveTime)=0 or (count(hl7:act/hl7:effectiveTime[@value])=1 or count(hl7:act/hl7:effectiveTime/hl7:low)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:effectiveTime)=0 or (count(hl7:act/hl7:effectiveTime[@value])=1 or count(hl7:act/hl7:effectiveTime/hl7:low)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-234|Sezione Piani di cura: entry/act/effectiveTime DEVE avere l'attributo @value valorizzato nel caso si voglia descrivere un preciso istante (point in time)
			oppure DEVE avere l'elemento 'low' valorizzato nel caso si voglia indicare un intervallo temporale. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:entry" mode="M3" priority="1007">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:procedure/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.11.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:procedure/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.11.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-235| Sezione Trattamenti e procedure terapeutiche, chirurgiche e diagnostiche: entry/procedure DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.4.3.11.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1 or    count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.12'])=1 or    count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.11.22.36'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1 or count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.12'])=1 or count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.11.22.36'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-236| Sezione Trattamenti e procedure terapeutiche, chirurgiche e diagnostiche: entry/procedure DEVE contenere un elemento 'code' valorizzato secondo i seguenti sistemi di codifica:
			- LOINC (@codeSystem: 2.16.840.1.113883.6.1)
			- ICD-9-CM (@codeSystem: 2.16.840.1.113883.6.103)
			- ProcedureTrapianti_PSSIT (2.16.840.1.113883.2.9.77.22.11.12)
			- IPSNoProceduresInfos  (@codeSystem='2.16.840.1.113883.11.22.36').</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='46240-8']]/hl7:entry" mode="M3" priority="1006">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='46240-8']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter[@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter[@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-237| Sezione Visite o ricoveri: entry/encounter DEVE avere l'attributo @moodCode valorizzato con 'EVN'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.12.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.12.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-238| Sezione Visite o ricoveri: entry/encounter DEVE contenere un elemento 'templateId valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.12.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-239| Sezione Visite o ricoveri: entry/encounter DEVE contenere un 'id'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:encounter/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:encounter/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.14'])=1 or     count(hl7:encounter/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:encounter/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:encounter/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.14'])=1 or count(hl7:encounter/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-240| Sezione Visite o ricoveri: entry/encounter DEVE contenere un elemento 'code' valorizzato secondo i seguenti sistemi di codifica:
			- LOINC (@codeSystem: 2.16.840.1.113883.6.1)
			- EncounterCode (@codeSystem=2.16.840.1.113883.2.9.77.22.11.14) (derivato da ActCode)
			- ActCode  (@codeSystem=2.16.840.1.113883.5.4).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:encounter/hl7:text)=0 or count(hl7:encounter/hl7:text/hl7:reference/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:encounter/hl7:text)=0 or count(hl7:encounter/hl7:text/hl7:reference/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-241| Sezione Visite o ricoveri: entry/encounter/text DEVE contenere un elemento reference/@value valorizzato con l’URI che punta alla descrizione estesa della visita o ricovero nel narrative block della sezione.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:encounter/hl7:performer)=1)">
      <svrl:successful-report test="not(count(hl7:encounter/hl7:performer)=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W004| Sezione Visite o ricoveri: si consiglia di valorizzare, all'interno di entry/encounter, almeno un elemento 'performer'.--&gt; </svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47420-5']]/hl7:entry" mode="M3" priority="1005">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47420-5']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.14.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.14.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-242| Sezione Stato funzionale del paziente: entry/organizer DEVE contenere un 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.14.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:component[hl7:observation/hl7:code[@code='75246-9']])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:component[hl7:observation/hl7:code[@code='75246-9']])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-243| Sezione Stato funzionale del paziente: entry/organizer DEVE contenere  una ed una sola component/observation relativa alla "Capacità motoria". </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:component[hl7:observation/hl7:code[@code!='75246-9']])=0 or    (count(hl7:organizer/hl7:component[hl7:observation/hl7:code[@code!='75246-9']])&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:component[hl7:observation/hl7:code[@code!='75246-9']])=0 or (count(hl7:organizer/hl7:component[hl7:observation/hl7:code[@code!='75246-9']])&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-244| Sezione Stato funzionale del paziente: entry/organizer può contenere una ed una sola component/observation relativa al "Regime di assistenza" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:component/hl7:observation/hl7:code[@code='75246-9'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:component/hl7:observation/hl7:code[@code='75246-9'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-245| Sezione Stato funzionale del paziente: entry/organizer/component/observation (Capacità motoria) DEVE contenere un elemento 'code' valorizzato con @code='75246-9' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code='75246-9']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1' or @codeSystem='2.16.840.1.113883.2.9.77.22.11.15'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code='75246-9']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1' or @codeSystem='2.16.840.1.113883.2.9.77.22.11.15'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-246| Sezione Stato funzionale del paziente: entry/organizer/component/observation (Capacità motoria) DEVE contenere un elemento 'value' valorizzato secondo i seguenti code system:
			- LOINC (@codeSystem: 2.16.840.1.113883.6.1)
			- CapacitàMotoria_PSSIT  (@codeSystem=2.16.840.1.113883.2.9.77.22.11.15). </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code!='75246-9']])=0 or     count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code!='75246-9']]/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code!='75246-9']])=0 or count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code!='75246-9']]/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-247| Sezione Stato funzionale del paziente: entry/organizer/component/observation (Regime di assistenza) DEVE contenere un elemento 'code' valorizzato secondo il code system "ActCode" - @codeSystem='2.16.840.1.113883.5.4' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code!='75246-9']]/hl7:value)=0 or    count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code!='75246-9']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.5.2.8'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code!='75246-9']]/hl7:value)=0 or count(hl7:organizer/hl7:component/hl7:observation[hl7:code[@code!='75246-9']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.5.2.8'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-248| Sezione Stato funzionale del paziente: entry/organizer/component/observation/value (Regime di assistenza) DEVE essere valorizzato secondo il value set "AssistenzaDomiciliare_PSSIT" - @codeSystem='2.16.840.1.113883.2.9.5.2.8' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47420-5']]/hl7:entry/hl7:organizer/hl7:component" mode="M3" priority="1004">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47420-5']]/hl7:entry/hl7:organizer/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.14.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.14.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-249| Sezione Stato funzionale del paziente: entry/organizer/component/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.14.2'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry" mode="M3" priority="1003">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.14.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.14.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-250| Sezione Indagini diagnostiche ed esami di laboratorio:  entry/organizer DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.14.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer/hl7:component[hl7:observation])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer/hl7:component[hl7:observation])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-251| Sezione Indagini diagnostiche ed esami di laboratorio:  entry/organizer DEVE contenere almeno un elemento 'component' di tipo 'observation'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry/hl7:organizer/hl7:component" mode="M3" priority="1002">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry/hl7:organizer/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.14.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.14.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-252| Sezione Indagini diagnostiche ed esami di laboratorio: entry/organizer/component/observation DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.14.2'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-253| Sezione Indagini diagnostiche ed esami di laboratorio: entry/organizer/component/observation DEVE contenere un solo elemento 'id'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='57827-8']]/hl7:entry" mode="M3" priority="1001">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='57827-8']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act[@classCode='ACT'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act[@classCode='ACT'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-254| Sezione Esenzioni: entry/act DEVE avere valorizzati gli attributi nel seguente modo @classCode='ACT' e @moodCode='EVN'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.17.1']])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.17.1']])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-255| Sezione Esenzioni: entry/act DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.17.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.22' or @codeSystem='2.16.840.1.113883.2.9.5.2.2'])=1 or     matches(hl7:act/hl7:code/@codeSystem,'2.16.840.1.113883.2.9.2.[0-9]{3}.6.22')" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.22' or @codeSystem='2.16.840.1.113883.2.9.5.2.2'])=1 or matches(hl7:act/hl7:code/@codeSystem,'2.16.840.1.113883.2.9.2.[0-9]{3}.6.22')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-256| Sezione Esenzioni: entry/act/code DEVE essere valorizzato secondo i seguenti sistemi di codifica:
			- Catalogo Nazionale Esenzioni (2.16.840.1.113883.2.9.6.1.22)
			- Catalogo Regionale (2.16.840.1.113883.2.9.2.[REGIONE].6.22)
			- Catalogo Nazionale Nessuna Esenzione (2.16.840.1.113883.2.9.5.2.2)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-257| Sezione Esenzioni: entry/act DEVE contenere un elemento 'effectiveTime' il quale deve avere l'elemento 'low' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="status" select="hl7:act/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or       ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or        ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or        ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-258| Sezione Esenzioni: entry/act/effectiveTime DEVE avere un elemento 'high' nel caso in cui lo 'statusCode' è 'completed'|'aborted'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:act)=0 or     count(hl7:act/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-259| Sezione Esenzioni: entry/act/entryRelationship/act relativo a Note e Commenti deve contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.1.7'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:entry" mode="M3" priority="1000">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='PSSIT99']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act[@classCode='PCPR'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act[@classCode='PCPR'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-260| Sezione Reti di Patologia: entry/act DEVE avere gli attributi valorizzati nel seguente modo @classCode='PCPR' e @moodCode='EVN'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.18.1']])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.18.1']])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-261| Sezione Reti di Patologia: entry/act DEVE avere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.18.1'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-262| Sezione Reti di Patologia: entry/act DEVE contenere un elemento 'id'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-263| Sezione Reti di Patologia: entry/act DEVE contenere un elemento 'effectiveTime' il quale deve avere l'elemento 'low' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="status" select="hl7:act/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or       ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or        ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or        ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-264| Sezione Reti di Patologia: entry/act/effectiveTime DEVE contenere un elemento 'high' nel caso in cui lo 'statusCode' è 'completed'|'aborted'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:act)=0 or     count(hl7:act/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:act/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.4.3.1.7'])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-265| Sezione Reti di Patologia: entry/act/entryRelationship/act relativo a Note e Commenti deve contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.4.3.1.7'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M3" priority="-1" />
  <xsl:template match="@*|node()" mode="M3" priority="-2">
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
