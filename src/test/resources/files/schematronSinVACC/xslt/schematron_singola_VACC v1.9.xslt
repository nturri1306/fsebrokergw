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
    <svrl:schematron-output schemaVersion="" title="Schematron Scheda della Singola Vaccinazione 1.1 ">
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
<svrl:text>Schematron Scheda della Singola Vaccinazione 1.1 </svrl:text>

<!--PATTERN all-->


	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument" mode="M3" priority="1015">
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
      <xsl:when test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.1.1'])= 1 and  count(hl7:templateId/@extension)= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.1.1'])= 1 and count(hl7:templateId/@extension)= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-3| Almeno un elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/templateId DEVE essere valorizzato attraverso l'attributo @root='2.16.840.1.113883.2.9.10.1.11.1.1', associato all'attributo @extension che  indica la versione a cui il templateId fa riferimento</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='87273-9'][@codeSystem='2.16.840.1.113883.6.1']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='87273-9'][@codeSystem='2.16.840.1.113883.6.1']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-4| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/code DEVE essere valorizzato con l'attributo @code='87273-9' e il @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Immunization Note'])=1 or    count(hl7:code[@displayName='IMMUNIZATION NOTE'])=1 or count(hl7:code[@displayName='Immunization note'])=1 or count(hl7:code[@displayName=' Immunization note'])=1)">
      <svrl:successful-report test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Immunization Note'])=1 or count(hl7:code[@displayName='IMMUNIZATION NOTE'])=1 or count(hl7:code[@displayName='Immunization note'])=1 or count(hl7:code[@displayName=' Immunization note'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W001| Si raccomanda di valorizzare gli attributi dell'elemento <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />/code nel seguente modo: @codeSystemName ='LOINC' e @displayName ='Immunization Note'.--&gt; </svrl:text>
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
      <xsl:when test="count(hl7:author/hl7:assignedAuthor/hl7:id/@nullFlavor)=1 or     count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:author/hl7:assignedAuthor/hl7:id/@nullFlavor)=1 or count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-17| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-18| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="name_author" select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:author/hl7:assignedAuthor/hl7:id/@nullFlavor)=1 or     (count($name_author/hl7:given)>=1 and count($name_author/hl7:family)>=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:author/hl7:assignedAuthor/hl7:id/@nullFlavor)=1 or (count($name_author/hl7:given)>=1 and count($name_author/hl7:family)>=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-19| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_auth" select="count(hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:addr)" />
    <xsl:variable name="addr_auth" select="hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:addr" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_auth=0 or (count($addr_auth/hl7:country)=$num_addr_auth and    count($addr_auth/hl7:city)=$num_addr_auth and     count($addr_auth/hl7:streetAddressLine)=$num_addr_auth)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_auth=0 or (count($addr_auth/hl7:country)=$num_addr_auth and count($addr_auth/hl7:city)=$num_addr_auth and count($addr_auth/hl7:streetAddressLine)=$num_addr_auth)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-20| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/representedOrganization/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</svrl:text>
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
          <svrl:text>ERRORE-21| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-22| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-23| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator può essere presente una volta sola.</svrl:text>
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
          <svrl:text>ERRORE-24| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-25| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator/assignedEntity DEVE contenere almeno un elemento id valorizzato con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'</svrl:text>
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
          <svrl:text>ERRORE-26| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/legalAuthenticator/assignedEntity/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson)=0 or     (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and     count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson)=0 or (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-27| L'elemento <xsl:text />
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
          <svrl:text>ERRORE-28| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/participant/associatedEntity deve contenere l'elemento 'id'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson)=0 or     count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:family)=1 and     count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:given)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson)=0 or count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:family)=1 and count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:given)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-29| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/participant/associatedEntity/associatedPerson/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.1']" mode="M3" priority="1014">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.5']" mode="M3" priority="1013">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.73']" mode="M3" priority="1012">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.51']" mode="M3" priority="1011">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.1052']" mode="M3" priority="1010">
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
          <svrl:text>Errore 6_DIZ| Codice "ActSite"  '<xsl:text />
            <xsl:value-of select="$sito" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.112']" mode="M3" priority="1009">
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
          <svrl:text>Errore 7_DIZ| Codice "RouteOfAdministration"  '<xsl:text />
            <xsl:value-of select="$via_somminist" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:telecom" mode="M3" priority="1008">
    <svrl:fired-rule context="//hl7:telecom" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@use)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@use)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-30| L’elemento 'telecom' DEVE contenere l'attributo @use </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']" mode="M3" priority="1007">
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
          <svrl:text>ERRORE-31| Il codice fiscale '<xsl:text />
            <xsl:value-of select="$CF" />
            <xsl:text />' cittadino ed operatore deve essere costituito da 16 cifre [A-Z0-9]{16}</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:observation" mode="M3" priority="1006">
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
          <svrl:text>ERRORE-32| L'attributo "@classCode" dell'elemento "observation" deve essere presente </svrl:text>
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
          <svrl:text>ERRORE-33| L'attributo "@moodCode" dell'elemento "observation" deve essere valorizzato con "EVN" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component" mode="M3" priority="1005">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[@classCode='DOCSECT'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[@classCode='DOCSECT'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-34| La section DEVE contenere gli attributi @classCode='DOCSECT' @moodCode='EVN'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section/hl7:templateId)=0 or count(hl7:section/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.3.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section/hl7:templateId)=0 or count(hl7:section/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.3.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-35| L'elemento section DEVE contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.11.3.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section/hl7:code)=0 or count(hl7:section/hl7:code[@code='11369-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section/hl7:code)=0 or count(hl7:section/hl7:code[@code='11369-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-36| L'elemento section/code DEVE contenere gli attributi valorizzati nel seguente modo: @code='11369-6' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section/hl7:title)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section/hl7:title)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-37| L'elemento section DEVE contenere un elemento 'title'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-38| L'elemento section DEVE contenere un elemento 'text'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section/hl7:entry)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section/hl7:entry)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-39| L'elemento section DEVE contenere un solo elemento 'entry' relativo ad uno dei seguenti casi:
			- "Dati Vaccinazione"
			- "Esonero/omissione o differimento".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry" mode="M3" priority="1004">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration[@classCode='SBADM'][@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration[@classCode='SBADM'][@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-40| L'elemento entry/substanceAdministration DEVE avere gli attributi valorizzati con @classCode='SBADM' e @moodCode='EVN'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=1 or     count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=1 or count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-41| L'elemento entry/substanceAdministration DEVE contenere un elemento 'templateId' valorizzato con uno dei seguenti modi:
			- @root='2.16.840.1.113883.2.9.10.1.11.4.1' per "Dati Vaccinazione"
			- @root='2.16.840.1.113883.2.9.10.1.11.4.2' per "Esonero/omissione o differimento".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or     count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-42| L'elemento entry/substanceAdministration DEVE contenere un elemento 'statusCode' valorizzato con l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or     count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:effectiveTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:effectiveTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-43| L'elemento entry/substanceAdministration DEVE contenere un elemento 'effectiveTime'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or     count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:consumable[@typeCode='CSM'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:consumable[@typeCode='CSM'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-44| L'elemento entry/substanceAdministration DEVE contenere un elemento 'consumable' con l'attributo @typeCode='CSM' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0) and     not(count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:routeCode)=1)">
      <svrl:successful-report test="not(count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0) and not(count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:routeCode)=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W003| Si consiglia di valorizzare la via di somministrazione tramite l'elemento 'routeCode'.--&gt; </svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="not(count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0) and     not(count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:approachSiteCode)=1)">
      <svrl:successful-report test="not(count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0) and not(count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:approachSiteCode)=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W004| Si consiglia di valorizzare la sede anatomica di somministrazione tramite l'elemento 'approachSiteCode' .--&gt; </svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--REPORT -->
<xsl:if test="not(count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0) and     not(count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:doseQuantity)=1)">
      <svrl:successful-report test="not(count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0) and not(count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:doseQuantity)=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W005| Si consiglia di valorizzare la dose somministrata tramite l'elemento 'doseQuantity'.--&gt; </svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:variable name="farma" select="hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count($farma/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count($farma/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-45|L'elemento entry/substanceAdministration/templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'] se presente, DEVE contenere l'elemento consumable/manufacturedProduct/manufacturedMaterial/code valorizzato secondo i seguenti sistemi di codifica:
			- @codeSystem='2.16.840.1.113883.2.9.6.1.5' 	(AIC)
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count($farma/hl7:code/hl7:translation)=0 or     count($farma/hl7:code/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count($farma/hl7:code/hl7:translation)=0 or count($farma/hl7:code/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-46| L'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code/translation deve essere valorizzato secondo i seguenti sistemi di codifica:
			- @codeSystem='2.16.840.1.113883.6.73'		(ATC)
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="consum" select="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:consumable/hl7:manufacturedProduct" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count($consum/hl7:manufacturerOrganization)=0 or    count($consum/hl7:manufacturerOrganization/hl7:name)>=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count($consum/hl7:manufacturerOrganization)=0 or count($consum/hl7:manufacturerOrganization/hl7:name)>=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-47| L'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturerOrganization DEVE contenere almeno un elemento 'name'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:participant)=0 or (count(hl7:substanceAdministration/hl7:participant[@typeCode='LOC'])>=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:participant)=0 or (count(hl7:substanceAdministration/hl7:participant[@typeCode='LOC'])>=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-48| L'elemento entry/substanceAdministration/participant DEVE essere valorizzato con l'attributo @typeCode='LOC'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:participant/hl7:participantRole/@classCode)=0 or     (count(hl7:substanceAdministration/hl7:participant/hl7:participantRole[@classCode='ROL'])>=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:participant/hl7:participantRole/@classCode)=0 or (count(hl7:substanceAdministration/hl7:participant/hl7:participantRole[@classCode='ROL'])>=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-49| L'elemento entry/substanceAdministration/participant/participantRole DEVE essere valorizzato con l'attributo @typeCode='ROL'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-50| L'elemento entry/substanceAdministration/entryRelationship relativo al "Numero di dose" può essere presente una volta sola.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or      count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true']/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.3'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true']/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.3'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-51| L'elemento entry/substanceAdministration/entryRelationship/observation (Numero dose) DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.3'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or       count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:code[@code='30973-2'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:code[@code='30973-2'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-52| L'elemento entry/substanceAdministration/entryRelationship/observation (Numero dose) DEVE contenere l'elemento 'code' valorizzato con gli attributi @code='30973-2' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or      count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-53| L'elemento entry/substanceAdministration/entryRelationship/observation (Numero dose) DEVE contenere l'elemento 'statusCode' valorizzato con l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or      count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:value[@xsi:type='INT'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:value[@xsi:type='INT'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-54| L'elemento entry/substanceAdministration/entryRelationship/observation (Numero dose) DEVE contenere l'elemento value valorizzato con l'attributo @xsi:type='INT'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='REFR'])&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='REFR'])&lt;=2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-55| L'elemento entry/substanceAdministration/entryRelationship relativo al "Periodo di Copertura /prossimo appuntamento" può essere presente al più due volte.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="risk" select="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.5']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or      count($risk)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or count($risk)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-56| L'elemento entry/substanceAdministration/entryRelationship/observation (Categorie a rischio) DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.5'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($risk)=0 or      count($risk/hl7:code[@code='95715-9'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($risk)=0 or count($risk/hl7:code[@code='95715-9'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-57| L'elemento entry/substanceAdministration/entryRelationship (Categorie a rischio) DEVE contenere l'elemento code valorizzato con gli attributi @code='95715-9' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($risk)=0 or      count($risk/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($risk)=0 or count($risk/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-58| L'elemento entry/substanceAdministration/entryRelationship (Categorie a rischio) DEVE contenere l'elemento statusCode valorizzato con l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($risk)=0 or      count($risk/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($risk)=0 or count($risk/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-59| L'elemento entry/substanceAdministration/entryRelationship (Categorie a rischio) DEVE contenere l'elemento value valorizzato con l'attributo @xsi:type='CD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="cond" select="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.6']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or      count($cond)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or count($cond)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-60| L'elemento entry/substanceAdministration/entryRelationship (condizioni sanitarie a rischio) DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.6'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($cond)=0 or      count($cond/hl7:code[@code='59785-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($cond)=0 or count($cond/hl7:code[@code='59785-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-61| L'elemento entry/substanceAdministration/entryRelationship (condizioni sanitarie a rischio) DEVE contenere l'elemento code valorizzato con gli attributi @code='59785-6' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($cond)=0 or      count($cond/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($cond)=0 or count($cond/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-62| L'elemento entry/substanceAdministration/entryRelationship (condizioni sanitarie a rischio) DEVE contenere l'elemento statusCode valorizzato con l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($cond)=0 or      count($cond/hl7:value[@xsi:type='CD'][@codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($cond)=0 or count($cond/hl7:value[@xsi:type='CD'][@codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-63| L'elemento entry/substanceAdministration/entryRelationship (condizioni sanitarie a rischio) DEVE contenere l'elemento value valorizzato con l'attributo @xsi:type='CD' e @codeSystem='2.16.840.1.113883.6.103'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="reaction" select="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='CAUS']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($reaction)=0 or      count($reaction/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.8']])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($reaction)=0 or count($reaction/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.8']])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-64| --L'elemento entry/substanceAdministration/entryRelationship (reazioni avverse) DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.8'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($reaction)=0 or      count($reaction/hl7:observation/hl7:code[@code='31044-1'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($reaction)=0 or count($reaction/hl7:observation/hl7:code[@code='31044-1'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-65| L'elemento entry/substanceAdministration/entryRelationship (reazioni avverse) DEVE contenere l'elemento code valorizzato con gli attributi @code='31044-1' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($reaction)=0 or      count($reaction/hl7:observation/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($reaction)=0 or count($reaction/hl7:observation/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-66| L'elemento entry/substanceAdministration/entryRelationship (reazioni avverse) DEVE contenere l'elemento statusCode valorizzato con l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($reaction/hl7:observation/hl7:value)=0 or      count($reaction/hl7:observation/hl7:value[@xsi:type='CD'][@codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($reaction/hl7:observation/hl7:value)=0 or count($reaction/hl7:observation/hl7:value[@xsi:type='CD'][@codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-67| L'elemento entry/substanceAdministration/entryRelationship/observation/value (reazioni avverse) DEVE essere valorizzato secondo il sistema di codifica ICD9-CM (@codeSystem='2.16.840.1.113883.6.103').</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or     count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:statusCode[@code='cancelled'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:statusCode[@code='cancelled'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-68| L'elemento entry/substanceAdministration/templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'] DEVE contenere l'elemento statusCode valorizzato con l'attributo @code='cancelled'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or     count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:effectiveTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:effectiveTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-69| L'elemento entry/substanceAdministration/templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'] DEVE contenere l'elemento effectiveTime.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or     count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:consumable[@typeCode='CSM'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:consumable[@typeCode='CSM'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-70|L'elemento entry/substanceAdministration/templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'] DEVE contenere l'elemento consumable con l'attributo @typeCode='CSM' valorizzato .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or      count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON'][hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON'][hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-71| L'elemento entry/substanceAdministration/entryRelationship[@typeCode='RSON'] DEVE avere l'elemento templateId valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.11.4.10'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or      count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]/hl7:code[@code='85714-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]/hl7:code[@code='85714-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-72| L'elemento entry/substanceAdministration/entryRelationship[@typeCode='RSON']  DEVE contenere l'elemento observation/code valorizzato con gli attributi @code='85714-4' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or      count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-73| L'elemento entry/substanceAdministration/entryRelationship[@typeCode='RSON']  DEVE contenere l'elemento observation/statusCode valorizzato con l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or      count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-74| L'elemento entry/substanceAdministration/entryRelationship[@typeCode='RSON'] DEVE contenere l'elemento observation/effectiveTime/low.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or      count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]/hl7:effectiveTime/hl7:high)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2'])=0 or count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]/hl7:effectiveTime/hl7:high)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-75| L'elemento entry/substanceAdministration/entryRelationship[@typeCode='RSON'] DEVE contenere l'elemento observation/effectiveTime/high.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='REFR']" mode="M3" priority="1003">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='REFR']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-76| L'elemento entry/substanceAdministration/entryRelationship/observation (Periodo di copertura/prossimo appuntamento) DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.4'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation/hl7:code[@code='59778-1'][@codeSystem='2.16.840.1.113883.6.1'])=1 or    count(hl7:observation/hl7:code[@code='59778-1'][@codeSystem='2.16.840.1.113883.4.642.3.308'])=1) or    (count(hl7:observation/hl7:code[@code='30980-7'][@codeSystem='2.16.840.1.113883.6.1'])=1 or    count(hl7:observation/hl7:code[@code='30980-7'][@codeSystem='2.16.840.1.113883.4.642.3.308'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation/hl7:code[@code='59778-1'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation/hl7:code[@code='59778-1'][@codeSystem='2.16.840.1.113883.4.642.3.308'])=1) or (count(hl7:observation/hl7:code[@code='30980-7'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation/hl7:code[@code='30980-7'][@codeSystem='2.16.840.1.113883.4.642.3.308'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-77|L'elemento entry/substanceAdministration/entryRelationship valorizzato con l'attributo @typeCode='REFR' DEVE avere l'lemento observation/code valorizzato con i seguenti attributi:
			- @code='59778-1' con i seguenti sistemi di codifica @codeSystem='2.16.840.1.113883.6.1' o @codeSystem='2.16.840.1.113883.4.642.3.308' (Periodo di Copertura)
			- @code='30980-7' con i seguenti sistemi di codifica @codeSystem='2.16.840.1.113883.6.1' o @codeSystem='2.16.840.1.113883.4.642.3.308' (Schedulazione prossimo Vaccino)
			</svrl:text>
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
          <svrl:text>ERRORE-78|L'elemento entry/substanceAdministration/entryRelationship[@typeCode='REFR'] DEVE contenere l'elemento statusCode valorizzato sempre con il code 'completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value[@xsi:type='IVL_TS' or @xsi:type='TS'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value[@xsi:type='IVL_TS' or @xsi:type='TS'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-79|L'elemento entry/substanceAdministration/entryRelationship[@typeCode='REFR'] DEVE contenere l'elemento value valorizzato con l'attributo @xsi:type='IVL_TS' o @xsi:type='TS'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship[@typeCode='RSON'][hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9']]" mode="M3" priority="1002">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship[@typeCode='RSON'][hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='75323-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='75323-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-80| L'elemento observation (malattia per cui si effettua la vaccinazione) DEVE contenere l'elemento code valorizzato con i seguenti attributi @code='75323-6' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
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
          <svrl:text>ERRORE-81| L'elemento observation (malattia per cui si effettua la vaccinazione) DEVE contenere l'elemento statusCode valorizzato con l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-82| L'elemento observation (malattia per cui si effettua la vaccinazione) DEVE contenere l'elemento value valorizzato con l'attributo @xsi:type='CD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON'][hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.7']]" mode="M3" priority="1001">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON'][hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.7']]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='59784-9'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='59784-9'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-83| L'elemento observation(malattia con presunta immunità) DEVE contenere l'elemento code valorizzato con i seguenti attributi @code='59784-9' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
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
          <svrl:text>ERRORE-84| L'elemento observation (malattia con presunta immunità) DEVE contenere l'elemento statusCode valorizzato con l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value)=0 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value)=0 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-85| L'elemento observation/value (malattia con presunta immunità) DEVE essere valorizzato secondo il sistema di codifica ICD9-CM (@codeSystem='2.16.840.1.113883.6.103').</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship[@typeCode='RSON']" mode="M3" priority="1000">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship[@typeCode='RSON']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.5'])=1 or    count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.6'])=1 or    count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.7'])>=1 or    count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9'])>=1 or    count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.5'])=1 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.6'])=1 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.7'])>=1 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9'])>=1 or count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE 86| Ciascuno di questi templateId è contenuto in una entryRelationship con l'attributo @typeCode='RSON'.
			- @root='2.16.840.1.113883.2.9.10.1.11.4.5' (Categorie a rischio)
			- @root='2.16.840.1.113883.2.9.10.1.11.4.6' (Condizioni sanitarie)
			- @root='2.16.840.1.113883.2.9.10.1.11.4.7' (Malattia con presunta immunità)
			- @root='2.16.840.1.113883.2.9.10.1.11.4.9' (Malattia per cui si effettua la vaccinazione)
			- @root='2.16.840.1.113883.2.9.10.1.11.4.10' (Ragione dell'esonero)</svrl:text>
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
