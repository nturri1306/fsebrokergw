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
    <svrl:schematron-output schemaVersion="" title="Schematron Referto di Specialistica Ambulatoriale ">
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
<svrl:text>Schematron Referto di Specialistica Ambulatoriale </svrl:text>

<!--PATTERN all-->


	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument" mode="M3" priority="1044">
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
      <xsl:when test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.9.1'])= 1 and  count(hl7:templateId/@extension)= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.9.1'])= 1 and count(hl7:templateId/@extension)= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-3| Almeno un elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/templateId DEVE essere valorizzato attraverso l'attributo @root='2.16.840.1.113883.2.9.10.1.9.1', associato all'attributo @extension che  indica la versione a cui il templateId fa riferimento</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='11488-4'][@codeSystem='2.16.840.1.113883.6.1']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='11488-4'][@codeSystem='2.16.840.1.113883.6.1']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-4| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/code DEVE essere valorizzato con l'attributo @code='11488-4' e il @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName=' Nota di consulto'])=1 or    count(hl7:code[@displayName='NOTA DI CONSULTO'])=1 or count(hl7:code[@displayName='Nota di Consulto'])=1)">
      <svrl:successful-report test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName=' Nota di consulto'])=1 or count(hl7:code[@displayName='NOTA DI CONSULTO'])=1 or count(hl7:code[@displayName='Nota di Consulto'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W001| Si raccomanda di valorizzare gli attributi dell'elemento <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />/code nel seguente modo: @codeSystemName ='LOINC' e @displayName ='Nota di consulto'.--&gt; </svrl:text>
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
            <xsl:text /> DEVE contenere un solo elemento 'languageCode' </svrl:text>
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
      <xsl:when test="count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])>= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])>= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-16| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor DEVE contenere almeno un elemento 'id' con il relativo attributo @root='2.16.840.1.113883.2.9.4.3.2'</svrl:text>
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
          <svrl:text>ERRORE-17| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-18| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-19| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or count(hl7:dataEnterer/hl7:time)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or count(hl7:dataEnterer/hl7:time)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-20| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/dataEnterer se presente, DEVE contenere un elemento 'time'</svrl:text>
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
          <svrl:text>ERRORE-21| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-22| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-23| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/dataEnterer/assignedEntity/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
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
          <svrl:text>ERRORE-24| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-25| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/custodian/assignedCustodian/representedCustodianOrganization/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-26| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator è obbligatorio </svrl:text>
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
          <svrl:text>ERRORE-27| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-28| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator/assignedEntity DEVE contenere almeno un elemento id valorizzato con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)=0 or (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and     count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)=0 or (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-29| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator/assignedEntity/assignedPerson/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
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
          <svrl:text>ERRORE-30| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/participant/associatedEntity deve contenere almeno un elemento 'id'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_pcp" select="count(hl7:participant/hl7:associatedEntity/hl7:addr)" />
    <xsl:variable name="addr_pcp" select="hl7:participant/hl7:associatedEntity/hl7:addr" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_pcp=0 or (count($addr_pcp/hl7:country)=$num_addr_pcp and                            count($addr_pcp/hl7:city)=$num_addr_pcp and                             count($addr_pcp/hl7:streetAddressLine)=$num_addr_pcp)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_pcp=0 or (count($addr_pcp/hl7:country)=$num_addr_pcp and count($addr_pcp/hl7:city)=$num_addr_pcp and count($addr_pcp/hl7:streetAddressLine)=$num_addr_pcp)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-31| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/participant/associatedEntity/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode)=0 or (count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode/@code)=1 and count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode[@codeSystem='2.16.840.1.113883.5.7'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode)=0 or (count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode/@code)=1 and count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode[@codeSystem='2.16.840.1.113883.5.7'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-32| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/inFulfillmentOf/order/priorityCode, se presente DEVE avere l'attributo '@code' e '@codeSystem='2.16.840.1.113883.5.7'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-33| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/componentOf è obbligatorio </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf)=0 or count(hl7:componentOf/hl7:encompassingEncounter/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf)=0 or count(hl7:componentOf/hl7:encompassingEncounter/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-34| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/componentOf/encompassingEncounter deve contenere l'elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:componentOf)=0 or count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:componentOf)=0 or count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-35| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/componentOf/encompassingEncounter/location/healthcareFacility  deve essere presente </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf)=0 or count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:asOrganizationPartOf)=0 or     count (hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:asOrganizationPartOf/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf)=0 or count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:asOrganizationPartOf)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:asOrganizationPartOf/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-36| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/componentOf/encompassingEncounter/location/healthcareFacility/serviceProviderOrganization/asOrganizationPartOf, se presente deve contenere l'elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.1']" mode="M3" priority="1043">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.6.1']" />
    <xsl:variable name="val_LOINC" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.1?code=',$val_LOINC))//result='true' or     $val_LOINC='LA16666-2' or $val_LOINC='LA18632-2' or $val_LOINC='LA28752-6' or $val_LOINC='LA18821-1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.1?code=',$val_LOINC))//result='true' or $val_LOINC='LA16666-2' or $val_LOINC='LA18632-2' or $val_LOINC='LA28752-6' or $val_LOINC='LA18821-1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 1_DIZ| Codice LOINC '<xsl:text />
            <xsl:value-of select="$val_LOINC" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.5']" mode="M3" priority="1042">
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
          <svrl:text>Errore 2_DIZ| Codice AIC '<xsl:text />
            <xsl:value-of select="$val_AIC" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.73']" mode="M3" priority="1041">
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
          <svrl:text>Errore 3_DIZ| Codice ATC '<xsl:text />
            <xsl:value-of select="$val_ATC" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.51']" mode="M3" priority="1040">
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
          <svrl:text>Errore 4_DIZ| Codice GE '<xsl:text />
            <xsl:value-of select="$val_GE" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2']" mode="M3" priority="1039">
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
          <svrl:text>Errore 5_DIZ| Codice "Allergeni (No Farmaci)"  '<xsl:text />
            <xsl:value-of select="$val_AllNoFarm" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4']" mode="M3" priority="1038">
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
          <svrl:text>Errore 6_DIZ| Codice "ReazioniAllergiche"  '<xsl:text />
            <xsl:value-of select="$reaz_aller" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.1052']" mode="M3" priority="1037">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.5.1052']" />
    <xsl:variable name="sito" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1052?code=',$sito))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1052?code=',$sito))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 8_DIZ| Codice "ActSite"  '<xsl:text />
            <xsl:value-of select="$sito" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.112']" mode="M3" priority="1036">
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
          <svrl:text>Errore 9_DIZ| Codice "RouteOfAdministration"  '<xsl:text />
            <xsl:value-of select="$via_somminist" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:statusCode" mode="M3" priority="1035">
    <svrl:fired-rule context="//hl7:statusCode" />
    <xsl:variable name="val_status" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.12?code=',$val_status))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.12?code=',$val_status))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 10_DIZ| Codice ActStatus '<xsl:text />
            <xsl:value-of select="$val_status" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.111']" mode="M3" priority="1034">
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
          <svrl:text>Errore 11_DIZ| Codice "RoleCode"  '<xsl:text />
            <xsl:value-of select="$roleCode" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.1.11.19700']" mode="M3" priority="1033">
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
          <svrl:text>Errore 12_DIZ| Codice "ObservationIntoleranceType" '<xsl:text />
            <xsl:value-of select="$obsIntoleranceType1" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@unit]" mode="M3" priority="1032">
    <svrl:fired-rule context="//*[@unit]" />
    <xsl:variable name="unit" select="encode-for-uri(@unit)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.12839?code=',$unit))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.12839?code=',$unit))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 14_DIZ| Codice "UnitsOfMeasureCaseSensitive"  '<xsl:text />
            <xsl:value-of select="$unit" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.1.11.1']" mode="M3" priority="1031">
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
          <svrl:text>Errore 15_DIZ| Codice "AdministrativeGender" '<xsl:text />
            <xsl:value-of select="$gender" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.1']" mode="M3" priority="1030">
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
          <svrl:text>Errore 16_DIZ| Codice "AdministrativeGender" '<xsl:text />
            <xsl:value-of select="$gender1" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3']" mode="M3" priority="1029">
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
          <svrl:text>Errore 17_DIZ| Codice "ReazioniIntolleranza"  '<xsl:text />
            <xsl:value-of select="$reaz_int" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.6']" mode="M3" priority="1028">
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
          <svrl:text>Errore 18_DIZ| Codice "CriticalityObservation"  '<xsl:text />
            <xsl:value-of select="$cri_obs" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7']" mode="M3" priority="1027">
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
          <svrl:text>Errore 19_DIZ| Codice "Stato clinico del problema"  '<xsl:text />
            <xsl:value-of select="$problem_status" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.8']" mode="M3" priority="1026">
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
          <svrl:text>Errore 20_DIZ| Codice "Età insorgenza"  '<xsl:text />
            <xsl:value-of select="$age" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.9']" mode="M3" priority="1025">
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
          <svrl:text>Errore 21_DIZ| Codice "ProblemObservation"  '<xsl:text />
            <xsl:value-of select="$prob_obs" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10']" mode="M3" priority="1024">
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
          <svrl:text>Errore 22_DIZ| Codice "CronicitàProblema"  '<xsl:text />
            <xsl:value-of select="$prob_cron" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:telecom" mode="M3" priority="1023">
    <svrl:fired-rule context="//hl7:telecom" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@use)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@use)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-37| L’elemento 'telecom' DEVE contenere l'attributo @use </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']" mode="M3" priority="1022">
    <svrl:fired-rule context="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']" />
    <xsl:variable name="CF" select="@extension" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(@extension, '[A-Z0-9]{16}')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(@extension, '[A-Z0-9]{16}')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-38| Il codice fiscale '<xsl:text />
            <xsl:value-of select="$CF" />
            <xsl:text />' cittadino ed operatore deve essere costituito da 16 cifre [A-Z0-9]{16}</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:observation" mode="M3" priority="1021">
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
          <svrl:text>ERRORE-39| L'attributo "@classCode" dell'elemento "observation" deve essere presente </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$moodCd='EVN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$moodCd='EVN'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-40| L'attributo "@moodCode" dell'elemento "observation" deve essere valorizzato con "EVN" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody" mode="M3" priority="1020">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='62387-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='62387-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-41| Sezione Prestazioni: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='62387-6'][@codeSystem='2.16.840.1.113883.6.1'])=0 or count(hl7:component/hl7:section[hl7:code[@code='62387-6']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='62387-6'][@codeSystem='2.16.840.1.113883.6.1'])=0 or count(hl7:component/hl7:section[hl7:code[@code='62387-6']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-42| Sezione Prestazioni: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='62387-6'][@codeSystem='2.16.840.1.113883.6.1'])=0 or count(hl7:component/hl7:section[hl7:code[@code='62387-6']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='62387-6'][@codeSystem='2.16.840.1.113883.6.1'])=0 or count(hl7:component/hl7:section[hl7:code[@code='62387-6']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-43| Sezione Prestazioni: la sezione DEVE contenere un elemento 'entry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='47045-0'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='47045-0'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-44| Sezione Referto: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='47045-0']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='47045-0']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-45| Sezione Referto: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='29299-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29299-5']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='29299-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29299-5']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-46| Sezione Quesito Diagnostico: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11329-0']])=0 or count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11329-0']])=0 or count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-47| Sezione Storia Clinica: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component[hl7:section/hl7:code[@code='48765-2']])&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component[hl7:section/hl7:code[@code='48765-2']])&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-48| Sezione Storia Clinica: la sezione può contenere al massimo una sotto-sezione "Allergie"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section/hl7:code[@code='48765-2'])=0) or     (count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:text)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section/hl7:code[@code='48765-2'])=0) or (count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:text)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-49| Sezione Storia Clinica: la sotto-sezione Allergie DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component[hl7:section/hl7:code[@code='10160-0']])&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component[hl7:section/hl7:code[@code='10160-0']])&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-50| Sezione Storia Clinica: la sezione può contenere al massimo una sotto-sezione "Terapia Farmacologica in Atto"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section/hl7:code[@code='10160-0'])=0) or     (count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:text)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section/hl7:code[@code='10160-0'])=0) or (count(hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:text)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-51| Sezione Storia Clinica: la sotto-sezione Terapia Farmacologica in Atto DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='30954-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='30954-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-52| Sezione Precedenti Esami Eseguiti: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='29545-1']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29545-1']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='29545-1']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29545-1']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-53| Sezione Esame obiettivo: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='93126-1']])=0 or count(hl7:component/hl7:section[hl7:code[@code='93126-1']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='93126-1']])=0 or count(hl7:component/hl7:section[hl7:code[@code='93126-1']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-54| Sezione Confronto Con Precedenti Esami Eseguiti: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='29548-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29548-5']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='29548-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='29548-5']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-55| Sezione Diagnosi: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='55110-1']])=0 or count(hl7:component/hl7:section[hl7:code[@code='55110-1']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='55110-1']])=0 or count(hl7:component/hl7:section[hl7:code[@code='55110-1']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-56| Sezione Conclusioni: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='62385-0']])=0 or count(hl7:component/hl7:section[hl7:code[@code='62385-0']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='62385-0']])=0 or count(hl7:component/hl7:section[hl7:code[@code='62385-0']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-57| Sezione Suggerimenti per il medico prescrittore: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='80615-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='80615-8']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='80615-8']])=0 or count(hl7:component/hl7:section[hl7:code[@code='80615-8']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-58| Sezione Accertamenti e controlli consigliati: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='93341-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='93341-6']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='93341-6']])=0 or count(hl7:component/hl7:section[hl7:code[@code='93341-6']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-59| Sezione Terapia farmacologica consigliata: la sezione DEVE contenere un elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" mode="M3" priority="1019">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" />
    <xsl:variable name="codice" select="hl7:code/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='29299-5'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='11329-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='30954-2'][@codeSystem='2.16.840.1.113883.6.1'])=1     or count(hl7:code[@code='29545-1'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='62387-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='93126-1'][@codeSystem='2.16.840.1.113883.6.1'])=1     or count(hl7:code[@code='47045-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='29548-5'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='55110-1'][@codeSystem='2.16.840.1.113883.6.1'])=1      or count(hl7:code[@code='62385-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='80615-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='93341-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='29299-5'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='11329-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='30954-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='29545-1'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='62387-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='93126-1'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='47045-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='29548-5'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='55110-1'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='62385-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='80615-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='93341-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-60| Il codice '<xsl:text />
            <xsl:value-of select="$codice" />
            <xsl:text />' non è corretto. La sezione deve essere valorizzata con uno dei seguenti codici:
			29299-5	Sezione Quesito Diagnostico
			11329-0	Sezione Storia Clinica
			30954-2	Sezione Precedenti Esami Eseguiti
			29545-1	Sezione Esame Obiettivo
			62387-6	Sezione Prestazioni
			93126-1	Sezione Confronto Con Precedenti Esami Eseguiti
			47045-0	Sezione Referto
			29548-5 Sezione Diagnosi
			55110-1	Sezione Conclusioni
			62385-0	Sezione Suggerimenti Per Il Medico Prescrittore 
			80615-8 Sezione Accertamenti e Controlli Consigliati 
			93341-6 Sezione Terapia Farmacologica Consigliata
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='29299-5']]/hl7:entry" mode="M3" priority="1018">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='29299-5']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='29298-7'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='29298-7'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-61| Sezione Quesito Diagnostico: l'elemento entry/observation/code deve avere l'attributo @code='29298-7' e l'attributo @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-62| Sezione Quesito Diagnostico: l'elemento entry/observation/value DEVE avere attributo @codeSystem valorizzato con l'OID del sistema di codifica ICD-9-CM </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry" mode="M3" priority="1017">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1 or count(hl7:organizer)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1 or count(hl7:organizer)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-63| Sezione Storia Clinica: l'elemento 'entry' deve avere uno dei seguenti sotto elementi:
			- 'observation': per l'Anamnesi patologica e fisiologica;
			- 'organizer': per l'Anamnesi familiare.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:code[@code='75326-9'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:code[@code='75326-9'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-64| Sezione Storia Clinica: l'elemento entry/observation/code deve avere l'attributo @code='75326-9' e l'attributo @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-65| Sezione Storia Clinica: l'elemento entry/observation/statusCode deve avere l'attributo @code='completed'</svrl:text>
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
          <svrl:text>ERRORE-66| Sezione Storia Clinica: l'elemento entry/observation/effectiveTime deve essere presente e deve avere l'elemento 'low' valorizzato</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation)=0 or count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:code[@code='33999-4']])=0) or     (count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@code='LA18632-2'])=1 and     count(hl7:observation/hl7:effectiveTime/hl7:high)=1) or count(hl7:observation/hl7:effectiveTime/hl7:high)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation)=0 or count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:code[@code='33999-4']])=0) or (count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@code='LA18632-2'])=1 and count(hl7:observation/hl7:effectiveTime/hl7:high)=1) or count(hl7:observation/hl7:effectiveTime/hl7:high)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-67| Sezione Storia Clinica: l'elemento entry/observation/effectiveTime deve essere presente e deve avere l'elemento 'high' valorizzato nel caso in cui il problema non sia più presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or count(hl7:observation/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-68| Sezione Storia Clinica: l'elemento entry/observation/value deve avere l'attributo @xsi:type="CD" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1)    or (count(hl7:observation/hl7:value/@code)=1 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or (count(hl7:observation/hl7:value/@code)=1 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-69| Sezione Storia Clinica: nel caso di entry/observation/value non codificato, deve essere valorizzato l'elemento 'originalText/reference'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or (count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code='89261-2']])&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or (count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code='89261-2']])&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-70| Sezione Storia Clinica: l'entry/observation può contenere al più una entryRelationship relativa alla Cronicità della patologia </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or (count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code='33999-4']])&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or (count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code='33999-4']])&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-71| Sezione Storia Clinica: l'entry/observation può contenere al più una 'entryRelationship' relativa allo Stato Clinico del problema </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer[@classCode='CLUSTER'])=1 and count(hl7:organizer/@moodCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer[@classCode='CLUSTER'])=1 and count(hl7:organizer/@moodCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-72| Sezione Storia Clinica: l'elemento entry/organizer deve avere gli attributi @classCode='CLUSTER' e @moodCode </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:code[@code='10157-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:code[@code='10157-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-73| Sezione Storia Clinica: l'elemento entry/organizer/code deve avere gli attributi @code='10157-6' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-74| Sezione Storia Clinica: l'elemento entry/organizer/statusCode deve avere l'attributo @code='completed'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:effectiveTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:effectiveTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-75| Sezione Storia Clinica: l'elemento entry/organizer/effectiveTime deve essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:subject/hl7:relatedSubject[@classCode='PRS'])=1 and     count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:code[@codeSystem='2.16.840.1.113883.5.111'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:subject/hl7:relatedSubject[@classCode='PRS'])=1 and count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:code[@codeSystem='2.16.840.1.113883.5.111'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-76| Sezione Storia Clinica: l'elemento entry/organizer/subject/relatedSubject deve avere l'attributo @classCode='PRS' e deve contenere l'elemento 'code'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:component)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:component)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-77| Sezione Storia Clinica: l'elemento entry/organizer deve contenere almeno un elemento component di tipo observation </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:organizer/hl7:component" mode="M3" priority="1016">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:organizer/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-78| Sezione Storia Clinica: l'elemento entry/organizer/component/observation/code deve avere l'attributo @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
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
          <svrl:text>ERRORE-79| Sezione Storia Clinica: l'elemento entry/organizer/component/observation/statusCode deve avere l'attributo @code='completed'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:effectiveTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:effectiveTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-80| Sezione Storia Clinica: l'elemento entry/organizer/component/observation/effectiveTime deve essere presente </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-81| Sezione Storia Clinica: l'elemento entry/organizer/component/observation/value deve essere presente e valorizzato secondo il @codeSystem='2.16.840.1.113883.6.103' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code='35267-4']])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code='35267-4']])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-82| Sezione Storia Clinica: l'elemento entry/organizer/component/observation deve contenere almeno una entryRelationship relativa all'Età di insorgenza o di morte </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code!='35267-4']])=1 and     count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code='39016-1']])=1 and     count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:code[@code='39016-1']]/hl7:value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code!='35267-4']])=1 and count(hl7:observation/hl7:entryRelationship[hl7:observation/hl7:code[@code='39016-1']])=1 and count(hl7:observation/hl7:entryRelationship/hl7:observation[hl7:code[@code='39016-1']]/hl7:value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-83| Sezione Storia Clinica: l'elemento entry/organizer/component/observation/entryRelationship/observation deve avere il code valorizzato con @code='39016-1' e deve contenere un elemento 'value'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:observation/hl7:entryRelationship" mode="M3" priority="1015">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:observation/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation/hl7:code[@code='89261-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or    count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation/hl7:code[@code='89261-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-84| Sezione Storia Clinica: l'elemento entry/observation/entryRelationship/observation/code deve avere l'attributo @code valorizzato con:
			"89261-2" per "Cronicità patologia";
			"33999-4" per "Stato clinico patologia"
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value)=0 or     (count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value)=0 or (count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-85| Sezione Storia Clinica: l'elemento entry/observation/entryRelationship/observation/value relativo alla Cronicità deve essere valorizzato secondo il Value set "CronicitàProblema"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value)=0 or     (count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value)=0 or (count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-86| Sezione Storia Clinica: l'elemento entry/observation/entryRelationship/observation/value relativo allo Stato Clinico della patologia deve essere valorizzato secondo il Value set "StatoClinicoProblema"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry" mode="M3" priority="1014">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act[@classCode='ACT'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act[@classCode='ACT'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-87| Sotto-sezione Allergie: la sezione deve contenere un elemento entry di tipo 'act'con attributi @classCode='ACT' e @moodCode='EVN'</svrl:text>
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
          <svrl:text>ERRORE-88| Sotto-sezione  Allergie: l'elemento entry/act/effectiveTime deve essere presente e deve avere l'elemento 'low' valorizzato</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="status" select="hl7:act/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:statusCode)=0 or ($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or    ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or     ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or     ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:statusCode)=0 or ($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-89| Sotto-sezione  Allergie: l'elemento entry/act/effectiveTime/high deve essere presente nel caso in cui lo 'statusCode' sia 'completed'oppure'aborted'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:code[@code='52473-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:code[@code='52473-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-90| Sotto-sezione Allergie: l'entry/act deve includere uno ed un solo elemento entryRelationship/observation con attributo @code='52473-6' e @codeSystem='2.16.840.1.113883.6.1</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:text)=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:text/hl7:reference/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:text)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:text/hl7:reference/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-91| Sotto-sezione Allergie: l'entry/act/entryRelationship/observation/text se presente, ha l'attributo reference/@value valorizzato con l'URI che punta alla descrizione di allarme, allergia o intolleranza nel narrative block della sezione </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-92| Sotto-sezione Allergie: l'elemento entry/act/entryRelationship/observation/statusCode/@code deve assumere il valore costante 'completed'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-93| Sotto-sezione Allergie: l'elemento entry/act/entryRelationship/observation/effectiveTime deve essere presente e deve avere l'elemento 'low' valorizzato </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-94| Sotto-sezione Allergie: l'elemento entry/act/entryRelationship/observation/value deve avere l'attributo @xsi:type='CD'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-95| Sotto-sezione Allergie: l'elemento entry/act/entryRelationship/observation/value codificato, deve avere l'attributo @code valorizzato secondo il value set "ObservationIntoleranceType" - @codeSystem='2.16.840.1.113883.5.4'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=0 and     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference/@value)=1) or     (hl7:act/hl7:entryRelationship/count(hl7:observation/hl7:value/@code)=1 and     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference/@value)&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=0 and count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference/@value)=1) or (hl7:act/hl7:entryRelationship/count(hl7:observation/hl7:value/@code)=1 and count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference/@value)&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-96| Sotto-sezione Allergie: l'elemento entry/act/entryRelationship/observation/value non codificato, deve avere l'elemento originalText/reference/@value valorizzato, altrimenti l'elemento originalText/reference può non essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-97| Sotto-sezione Allergie: entry/act/entryRelationship/observation deve contenere almeno un elemento 'participant'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-98| Sotto-sezione Allergie: entry/act/entryRelationship/observation deve contenere solo un elemento 'entryRelationship/observation' relativo alla Criticità</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-99| Sotto-sezione Allergie: entry/act/entryRelationship/observation deve contenere solo un elemento 'entryRelationship/observation' relativo allo Stato dell'allergia</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-100| Sotto-sezione Allergie: entry/act/entryRelationship/observation deve contenere solo un elemento 'entryRelationship/act' relativo ai Commenti</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant" mode="M3" priority="1013">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or    count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or    count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-101| Sotto-sezione Allergie (descrizione agente codificato): l'elemento entry/act/entryRelationship/observation/participant/participantRole/playingEntity deve avere l'attributo code/@codeSystem valorizzato come segue:
			- 2.16.840.1.113883.6.73		codifica "WHO ATC"
			- 2.16.840.1.113883.2.9.6.1.5 		codifica "AIC"
			- 2.16.840.1.113883.2.9.77.22.11.2 	value set "AllergenNoDrugs" (- per le allergie non a farmaci –)
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='MFST']" mode="M3" priority="1012">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='MFST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-102| Sotto-sezione Allergie (descrizione reazione): entry/act/entryRelationship/observation/entryRelationship/observation deve avere un elemento 'code' con gli attributi @code=75321-0' e @codeSystem='2.16.840.1.113883.6.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-103| Sotto-sezione Allergie (descrizione reazione): entry/act/entryRelationship/observation/entryRelationship/observation deve avere un 'effectiveTime' che contiene l'elemento 'low' valorizzato </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value)=0 or count(hl7:observation/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value)=0 or count(hl7:observation/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-104| Sotto-sezione Allergie (descrizione reazione): l'elemento entry/act/entryRelationship/observation/entryRelationship/observation/value deve avere l'attributo @xsi:type='CD'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value)=0 or       (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or       (count(hl7:observation/hl7:value/@code)=1 and (count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)&lt;=1))" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value)=0 or (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or (count(hl7:observation/hl7:value/@code)=1 and (count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)&lt;=1))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-105| Sotto-sezione Allergie (descrizione reazione): nel caso di entry/act/entryRelationship/observation/entryRelationship/observation/value non codificato, questi deve avere l'elemento originalText/reference valorizzato</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value/@code)=0 or       (count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4'])=1 or        count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3'])=1 or        count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value/@code)=0 or (count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4'])=1 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3'])=1 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-106| Sotto-sezione Allergie (descrizione reazione): entry/act/entryRelationship/observation/entryRelationship/observation/value deve avere l'attributo @codeSystem valorizzato come segue:
			- "2.16.840.1.113883.2.9.77.22.11.4" per le reazioni da allergia 
			- "2.16.840.1.113883.2.9.77.22.11.3" per le reazioni da intolleranza 
			- "2.16.840.1.113883.6.103" per le reazioni riportate nel sistema ICD-9-CM
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation]" mode="M3" priority="1011">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-107| Sotto-sezione Allergie (criticità dell'allergia o intolleranza): entry/act/entryRelationship/observation/entryRelationship/observation/code deve avere l'attributo @codesystem='2.16.840.1.113883.5.4'</svrl:text>
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
          <svrl:text>ERRORE-108| Sotto-sezione Allergie (criticità dell'allergia o intolleranza): entry/act/entryRelationship/observation/entryRelationship/observation/text/reference/value deve essere valorizzato con l'URI che punta alla descrizione della severità nel narrative block della sezione </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.1063'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.1063'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-109| Sotto-sezione Allergie (criticità dell'allergia o intolleranza): entry/act/entryRelationship/observation/entryRelationship/observation/value deve essere valorizzato secondo il value set "CriticalityObservation" @codesystem='2.16.840.1.113883.5.1063'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']" mode="M3" priority="1010">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-110| Sotto-sezione Allergie (stato dell'allergia): entry/act/entryRelationship/observation/entryRelationship/observation/code deve avere l'attributo @code='33999-4' e @codesystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-111| Sotto-sezione Allergie (stato dell'allergia): entry/act/entryRelationship/observation/entryRelationship/observation/value deve essere valorizzato secondo il value set "StatoClinicoAllergia" (@codesystem='2.16.840.1.113883.6.1')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act]" mode="M3" priority="1009">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:code[@code='48767-8'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:code[@code='48767-8'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-112| Sotto-sezione Allergie (commenti): l'elemento entry/act/entryRelationship/observation/entryRelationship/act deve contenere l'elemento act con attributi @code='48767-8' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry" mode="M3" priority="1008">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration[@classCode='SBADM'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration[@classCode='SBADM'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-113| Sotto-sezione Terapia farmacologica in atto: la sezione deve contenere un elemento substanceAdministration con attributi @classCode='SBADM' e @moodCode='EVN'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-114| Sotto-sezione Terapia farmacologica in atto: la sezione deve contenere un elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="man_mat" select="hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or     count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or    count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-115| Sotto-sezione Terapia farmacologica in atto: l'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial deve contenere un elemento 'code' il cui @codeSystem deve essere valorizzato secondo i seguenti sistemi di codifica:
			@codeSystem='2.16.840.1.113883.6.73'		(ATC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.5' 	(AIC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.51' 	(GE)
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($man_mat/hl7:code/hl7:translation)=0 or     (count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or     count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or    count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or     count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or    count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or     count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($man_mat/hl7:code/hl7:translation)=0 or (count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or count($man_mat/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-116| Sotto-sezione Terapia farmacologica in atto: l'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/translation deve essere valorizzato secondo i seguenti sistemi di codifica:
			@codeSystem='2.16.840.1.113883.6.73'		(ATC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.5' 	(AIC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.51' 	(GE)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry" mode="M3" priority="1007">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-117| Sezione Precedenti esami eseguiti: l'elemento entry DEVE contenere una observation</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-118| Sezione Precedenti esami eseguiti: l'elemento entry/observation DEVE contenere l'elemento code valorizzato con @codeSystem='2.16.840.1.113883.6.1' o @codeSystem='2.16.840.1.113883.6.103' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='62387-6']]/hl7:entry" mode="M3" priority="1006">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='62387-6']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-119| Sezione Prestazioni: l'elemento entry DEVE contenere un elemento act</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act[@classCode='ACT'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act[@classCode='ACT'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-120| Sezione Prestazioni: l'elemento entry/act DEVE avere gli attributi valorizzati @classCode="ACT" e @moodCode="EVN"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:effectiveTime/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:effectiveTime/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-121| Sezione Prestazioni: l'elemento entry/act DEVE contenere l'elemento effectiveTime valorizzato con l'attributo @value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='62387-6']]/hl7:entry/hl7:act/hl7:entryRelationship" mode="M3" priority="1005">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='62387-6']]/hl7:entry/hl7:act/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:procedure)=1 or count(hl7:substanceAdministration)=1 or count(hl7:observation)=1 or count(hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:procedure)=1 or count(hl7:substanceAdministration)=1 or count(hl7:observation)=1 or count(hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-122| Sezione Prestazioni: l'elemento entry/act/entryRelationship deve avere uno dei seguenti sotto elementi:
			- 'procedure': per procedure diagnostiche invasive, interventistiche, chirurgiche;
			- 'substanceAdministration': per somministrazioni farmaceutiche;
			- 'observation': per osservazioni eseguite durante la prestazione;
			- 'act': per altre procedure che non ricadono nei casi precedenti.
			</svrl:text>
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
          <svrl:text>ERRORE-123| Sezione Prestazioni: l'elemento entry/act/entryRelationship/procedure deve contenere l'elemento code </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration)=0 or count(hl7:substanceAdministration/hl7:code)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration)=0 or count(hl7:substanceAdministration/hl7:code)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-124| Sezione Prestazioni: l'elemento entry/act/entryRelationship/substanceAdministration deve contenere l'elemento code </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='29548-5']]/hl7:entry" mode="M3" priority="1004">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='29548-5']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-125| Sezione Diagnosi: l'elemento entry DEVE contenere un elemento observation</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='29308-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='29308-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-126| Sezione Diagnosi: l'elemento entry/observation DEVE contenere l'elemento code valorizzato con gli attributi @code='29308-4' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
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
          <svrl:text>ERRORE-127| Sezione Diagnosi: l'elemento entry/observation DEVE contenere l'elemento value </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='80615-8']]/hl7:entry" mode="M3" priority="1003">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='80615-8']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-128| Sezione Accertamenti e controlli consigliati: l'elemento entry DEVE contenere l'elemento act </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act[@classCode='ACT'][@moodCode='PRP'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act[@classCode='ACT'][@moodCode='PRP'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-129| Sezione Accertamenti e controlli consigliati: l'elemento entry/act DEVE avere gli attributi valorizzati @classCode="ACT" e @moodCode="PRP" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='93341-6']]/hl7:entry" mode="M3" priority="1002">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='93341-6']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-130| Sezione Terapia farmacologica consigliata: l'elemento entry deve contenere un elemento substanceAdministration </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration[@classCode='SBADM'][@moodCode='PRP'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration[@classCode='SBADM'][@moodCode='PRP'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-131| Sezione Terapia Farmacologica Cosnigliata: l'elemento entry/act DEVE avere gli attributi valorizzati @classCode="SBADM" e @moodCode="PRP" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-132| Sezione Terapia farmacologica consigliata: l'elemento entry/substanceAdministration DEVE contenere l'elemento effectiveTime e DEVE avere l'elemento 'low' valorizzato </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or    count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or     count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-133|Sezione Terapia farmacologica consigliata: l'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code DEVE avere l'attributo "@codeSystem" valorizzato come segue:
			- 2.16.840.1.113883.6.73 		codifica "ATC";
			- 2.16.840.1.113883.2.9.6.1.5 	codifica "AIC";
			- 2.16.840.1.113883.2.9.6.1.51	codifica "GE".
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="trans_vl" select="hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($trans_vl/hl7:code/hl7:translation)=0 or     (count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or     count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or    count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or     count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or    count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or     count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($trans_vl/hl7:code/hl7:translation)=0 or (count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.6.73']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1 or count($trans_vl/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51']/hl7:translation[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-134| Sezione Terapia farmacologica consigliata: l'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/translation deve essere valorizzato secondo i seguenti sistemi di codifica:
			@codeSystem='2.16.840.1.113883.6.73'		(ATC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.5' 	(AIC)
			@codeSystem='2.16.840.1.113883.2.9.6.1.51' 	(GE)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='93341-6']]/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship" mode="M3" priority="1001">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='93341-6']]/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1 or count(hl7:supply)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1 or count(hl7:supply)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-135| Sezione Terapia farmacologica consigliata: l'elemento entry/substanceAdministration/entryRelationship deve avere uno dei seguenti sotto elementi:
			- 'observation': per informazioni relative a grammatura e quantità della confezione;
			- 'supply': per il numero di confezioni prescritte;
			</svrl:text>
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
          <svrl:text>ERRORE-135a| Sezione Terapia farmacologica consigliata: l'elemento entry/substanceAdministration/entryRelationship/observation DEVE avere l'elemento 'value' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:supply)=0 or count(hl7:supply/hl7:quantity)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:supply)=0 or count(hl7:supply/hl7:quantity)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-135b| Sezione Terapia farmacologica consigliata: l'elemento entry/substanceAdministration/entryRelationship/supply deve avere l'elemento 'quantity' valorizzato</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='93341-6']]/hl7:entry/hl7:substanceAdministration/hl7:participant" mode="M3" priority="1000">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='93341-6']]/hl7:entry/hl7:substanceAdministration/hl7:participant" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:id)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:id)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-136| Sezione Terapia Farmacologica consigliata: se presente entry/substanceAdministration/participant, DEVE contenere almeno un elemento participantRole/id </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:given)=1 and count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:family)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:given)=1 and count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:family)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-137| Sezione Terapia Farmacologica consigliata: se presente entry/substanceAdministration/participant, DEVE contenere l'elemento participant/playingEntity/name con i sotto-elementi given e family </svrl:text>
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
