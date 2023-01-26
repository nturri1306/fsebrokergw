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
    <svrl:schematron-output schemaVersion="" title="Schematron Referto di Radiologia  1.1">
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
<svrl:text>Schematron Referto di Radiologia  1.1</svrl:text>

<!--PATTERN all-->


	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument" mode="M3" priority="1035">
    <svrl:fired-rule context="hl7:ClinicalDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:realmCode) >= 1 and count(hl7:languageCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:realmCode) >= 1 and count(hl7:languageCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-1| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE avere almeno un elemento 'realmCode' e un solo elemento 'languageCode'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:realmCode[@code='IT'])= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:realmCode[@code='IT'])= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-2| L'elemento 'realmCode' DEVE avere l'attributo @root valorizzato come 'IT'</svrl:text>
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
          <svrl:text>ERRORE-3| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE avere almeno un elemento di tipo 'templateId'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.7.1'])= 1 and  count(hl7:templateId/@extension)= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.7.1'])= 1 and count(hl7:templateId/@extension)= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-4| Almeno un elemento 'templateId' DEVE essere valorizzato attraverso l'attributo  @root='2.16.840.1.113883.2.9.10.1.7.1' (id del template nazionale)  associato all'attributo @extension che  indica la versione a cui il templateId fa riferimento</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='68604-8'][@codeSystem='2.16.840.1.113883.6.1']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='68604-8'][@codeSystem='2.16.840.1.113883.6.1']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-5| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/code deve essere valorizzato con l'attributo @code='68604-8' e il @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Referto Radiologico'])=1 or    count(hl7:code[@displayName='REFERTO RADIOLOGICO'])=1 or count(hl7:code[@displayName='Referto radiologico'])=1)">
      <svrl:successful-report test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Referto Radiologico'])=1 or count(hl7:code[@displayName='REFERTO RADIOLOGICO'])=1 or count(hl7:code[@displayName='Referto radiologico'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W001| Si raccomanda di valorizzare gli attributi dell'elemento <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />/code nel seguente modo: @codeSystemName ='LOINC' e @displayName ='Referto Radiologico'.--&gt; </svrl:text>
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
          <svrl:text>ERRORE-6| L'elemento  'confidentialityCode' di <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE avere l'attributo @code  valorizzato con 'N' o 'V', e il suo @codeSystem  con '2.16.840.1.113883.5.25'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="versionNumber" select="hl7:versionNumber/@value" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string(number($versionNumber)) = 'NaN') or      ($versionNumber= 1 and hl7:id/@root = hl7:setId/@root and hl7:id/@extension = hl7:setId/@extension) or      ($versionNumber!= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension != hl7:setId/@extension) or      (hl7:id/@root != hl7:setId/@root)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string(number($versionNumber)) = 'NaN') or ($versionNumber= 1 and hl7:id/@root = hl7:setId/@root and hl7:id/@extension = hl7:setId/@extension) or ($versionNumber!= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension != hl7:setId/@extension) or (hl7:id/@root != hl7:setId/@root)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-7: Se ClinicalDocument.id e ClinicalDocument.setId usano lo stesso dominio di identificazione (@root identico) allora l’attributo @extension del
			ClinicalDocument.id deve essere diverso da quello del ClinicalDocument.setId a meno che ClinicalDocument.versionNumber non sia uguale ad 1; cioè i valori del setId ed id per un documento clinico possono coincidere solo per la prima versione di un documento.</svrl:text>
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
            <xsl:text />/versionNumber/@value maggiore di  1 l'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />  deve contenere un elemento di tipo 'relatedDocument'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr" select="count(hl7:recordTarget/hl7:patientRole/hl7:addr)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr=0 or (count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:country)>=$num_addr and count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:city)=$num_addr and count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:streetAddressLine)=$num_addr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr=0 or (count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:country)>=$num_addr and count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:city)=$num_addr and count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:streetAddressLine)=$num_addr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-9: L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/addr DEVE riportare i suoi sotto-elementi 'country', 'city' e 'streetAddressLine'.   </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="patient" select="hl7:recordTarget/hl7:patientRole/hl7:patient" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($patient)=0 or count($patient/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($patient)=0 or count($patient/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-10| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTaget/patientRole/patient DEVE contenere l'elemento 'name'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($patient)=0 or (count($patient/hl7:name/hl7:given)=1 and count($patient/hl7:name/hl7:family)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($patient)=0 or (count($patient/hl7:name/hl7:given)=1 and count($patient/hl7:name/hl7:family)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-11| L'elemento ClinicalDocument/recordTaget/patientRole/patient/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="genderCode" select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@code" />
    <xsl:variable name="genderOID" select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@codeSystem" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or ($genderCode='M' or $genderCode='F' or $genderCode='UN')" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or ($genderCode='M' or $genderCode='F' or $genderCode='UN')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-12| L'attributo <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/patient/administrativeGenderCode/@code='<xsl:text />
            <xsl:value-of select="$genderCode" />
            <xsl:text />' non è valorizzato correttamente. Deve assumere uno dei seguenti valori:'M', 'F', 'UN', e l'attributo @codeSystem con '2.16.840.1.113883.5.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or $genderOID='2.16.840.1.113883.5.1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or $genderOID='2.16.840.1.113883.5.1'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-13| L'OID assegnato all'attributo <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/patient/administrativeGenderCode/@codeSystem='<xsl:text />
            <xsl:value-of select="$genderOID" />
            <xsl:text />' non è corretto. L'attributo DEVE essere valorizzato con '2.16.840.1.113883.5.1' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-14| L'elemento ClinicalDocument/recordTaget/patientRole/patient DEVE riportare un elemento 'birthTime'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-15| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor DEVE contenere almeno un elemento 'id' con il relativo attributo @root valorizzato con '2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_author" select="count(hl7:author/hl7:assignedAuthor/hl7:addr)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_author=0 or (count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:country)=$num_addr_author and count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:city)=$num_addr_author and count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:streetAddressLine)=$num_addr_author)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_author=0 or (count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:country)=$num_addr_author and count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:city)=$num_addr_author and count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:streetAddressLine)=$num_addr_author)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-16: L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/addr DEVE riportare i suoi sotto-elementi 'country', 'city' e 'streetAddressLine'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="name_author" select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($name_author)=0 or count($name_author/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($name_author)=0 or count($name_author/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-17| L'elemento ClinicalDocument/author/assignedAuthor/assignedPerson DEVE avere l'elemento 'name' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($name_author)=0 or (count($name_author/hl7:name/hl7:given)=1 and count($name_author/hl7:name/hl7:family)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($name_author)=0 or (count($name_author/hl7:name/hl7:given)=1 and count($name_author/hl7:name/hl7:family)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-18| L'elemento ClinicalDocument/author/assignedAuthor/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
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
          <svrl:text>ERRORE-19| In ClinicalDocument/author/assignedAuthor DEVE essere presente almeno un elemento 'telecom' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or count(hl7:dataEnterer/hl7:time)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or count(hl7:dataEnterer/hl7:time)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-20| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/dataEnterer DEVE avere un elemento 'time'</svrl:text>
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
          <svrl:text>ERRORE-21| L'elemento ClinicalDocument/dataEnterer/assignedEntity DEVE avere almeno un elemento 'id' <xsl:text />
            <xsl:value-of select="$id_dataEnterer" />
            <xsl:text /> con l'attributo @root valorizzato con '2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nome" select="hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson)=1 and     count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson)=1 and count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-22| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/dataEnterer/assignedEntity DEVE riportare l'elemento 'assignedPerson/name'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

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
            <xsl:text />/dataEnterer/assignedEntity/assignedPerson/name DEVE avere gli elementi 'given' e 'family'.</svrl:text>
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
          <svrl:text>ERRORE-24| ClinicalDocument/custodian/assignedCustodian/representedCustodianOrganization deve contenere un elemento 'name'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="num_addr_cust" select="count(hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr)" />
    <xsl:variable name="addr_cust" select="hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$num_addr_cust=0 or (count($addr_cust/hl7:country)=$num_addr_cust and count($addr_cust/hl7:city)=$num_addr_cust and count($addr_cust/hl7:streetAddressLine)=$num_addr_cust)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$num_addr_cust=0 or (count($addr_cust/hl7:country)=$num_addr_cust and count($addr_cust/hl7:city)=$num_addr_cust and count($addr_cust/hl7:streetAddressLine)=$num_addr_cust)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-25: L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/custodian/assignedCustodian/representedCustodianOrganization/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:signatureCode[@code='S'])= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:signatureCode[@code='S'])= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-26| L'elemento legalAuthenticator/signatureCode deve essere valorizzato con il codice "S"  </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-27| L'elemento legalAuthenticator/assignedEntity DEVE contenere almeno un elemento id valorizzato con l'attributo @root '2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-28| ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson DEVE contenere l'elemento 'name'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)= 0 or (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)= 0 or (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-29| ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="prioriry" select="hl7:inFulfillmentOf/hl7:order/hl7:priorityCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:inFulfillmentOf)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:inFulfillmentOf)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-30| In ClinicalDocuemnt DEVE essere presente almeno un elemento 'inFulfillmentOf'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode)=0 or ($prioriry='R' or $prioriry='P' or $prioriry='UR' or $prioriry='EM')" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode)=0 or ($prioriry='R' or $prioriry='P' or $prioriry='UR' or $prioriry='EM')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-31| ClinicalDocument/infulfillmentOf/order/priorityCode DEVE avere l'attributo code valorizzato con uno dei seguenti valori: 'R'|'P'|'UR'|'EM' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count (hl7:documentationOf/hl7:serviceEvent)=0 or                     count (hl7:documentationOf/hl7:serviceEvent/hl7:code[@code='PROG'])=1 or                             count (hl7:documentationOf/hl7:serviceEvent/hl7:code[@code='DIR'])=1 or         count (hl7:documentationOf/hl7:serviceEvent/hl7:code[@code='RAD_PROG'])=1 or         count (hl7:documentationOf/hl7:serviceEvent/hl7:code[@code='RAD_DIR'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count (hl7:documentationOf/hl7:serviceEvent)=0 or count (hl7:documentationOf/hl7:serviceEvent/hl7:code[@code='PROG'])=1 or count (hl7:documentationOf/hl7:serviceEvent/hl7:code[@code='DIR'])=1 or count (hl7:documentationOf/hl7:serviceEvent/hl7:code[@code='RAD_PROG'])=1 or count (hl7:documentationOf/hl7:serviceEvent/hl7:code[@code='RAD_DIR'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-32| L'elemento ClinicalDocument/documentationOf/serviceEvent deve contenere l'elemento code e DEVE valorizzare il suo attributo code con uno dei seguenti valori: 'PROG'|'DIR'|'RAD_PROG|'RAD_DIR' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:documentationOf/hl7:serviceEvent)= 0 or count(hl7:documentationOf/hl7:serviceEvent/hl7:code[@codeSystem='2.16.840.1.113883.2.9.5.1.4'])= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:documentationOf/hl7:serviceEvent)= 0 or count(hl7:documentationOf/hl7:serviceEvent/hl7:code[@codeSystem='2.16.840.1.113883.2.9.5.1.4'])= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-33| L'elemento ClinicalDocument/documentationOf/serviceEvent DEVE contenere l'elemento code valorizzato con l'attributo @codeSystem '2.16.840.1.113883.2.9.5.1.4'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="path_name" select="hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name" />
    <xsl:variable name="code_encomp" select="hl7:componentOf/hl7:encompassingEncounter/hl7:code/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-34| deve essere presente l'elemento ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedentity/assignedPerson/name </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or (count($path_name/hl7:given)=1 and count($path_name/hl7:family)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or (count($path_name/hl7:given)=1 and count($path_name/hl7:family)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-35| L'elemento ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedentity/assignedPerson/name deve contenere gli elementi given e family </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-36| L'elemento ClinicalDocument/componentOf/encompassingEncounter/location/healthcareFacility/serviceProviderOrganization deve contenere l'elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.1']" mode="M3" priority="1034">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.5']" mode="M3" priority="1033">
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
          <svrl:text>Errore 2_DIZ| Codice  AIC  '<xsl:text />
            <xsl:value-of select="$val_AIC" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.73']" mode="M3" priority="1032">
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
          <svrl:text>Errore 3_DIZ| Codice  ATC  '<xsl:text />
            <xsl:value-of select="$val_ATC" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.11.22.9']" mode="M3" priority="1031">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.11.22.9']" />
    <xsl:variable name="val_UKA" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.9?code=',$val_UKA))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.11.22.9?code=',$val_UKA))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 4_DIZ| Codice Absent or Unknown Allergies '<xsl:text />
            <xsl:value-of select="$val_UKA" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.1.11.19700']" mode="M3" priority="1030">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.1.11.19700']" />
    <xsl:variable name="val_OIT" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.19700?code=',$val_OIT))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.19700?code=',$val_OIT))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 5_DIZ| Codice ObservationIntoleranceType  '<xsl:text />
            <xsl:value-of select="$val_OIT" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2']" mode="M3" priority="1029">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2']" />
    <xsl:variable name="val_ANF" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.2?code=',$val_ANF))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.2?code=',$val_ANF))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 7_DIZ| Codice Allergeni (No Farmaci)  '<xsl:text />
            <xsl:value-of select="$val_ANF" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3']" mode="M3" priority="1028">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3']" />
    <xsl:variable name="val_REAZINT" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.3?code=',$val_REAZINT))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.3?code=',$val_REAZINT))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 8_DIZ| Codice  Reazioni Intolleranza  '<xsl:text />
            <xsl:value-of select="$val_REAZINT" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4']" mode="M3" priority="1027">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4']" />
    <xsl:variable name="val_REAZALL" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.4?code=',$val_REAZALL))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.4?code=',$val_REAZALL))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 9_DIZ| Codice  Reazioni Allergiche  '<xsl:text />
            <xsl:value-of select="$val_REAZALL" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.5']" mode="M3" priority="1026">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.5']" />
    <xsl:variable name="val_SEVOBS" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.5?code=',$val_SEVOBS))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.5?code=',$val_SEVOBS))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 10_DIZ| Codice  SeverityObservation  '<xsl:text />
            <xsl:value-of select="$val_SEVOBS" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.6']" mode="M3" priority="1025">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.6']" />
    <xsl:variable name="val_CRIOBS" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.6?code=',$val_CRIOBS))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.6?code=',$val_CRIOBS))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 11_DIZ| Codice  CriticalityObservation  '<xsl:text />
            <xsl:value-of select="$val_CRIOBS" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.11']" mode="M3" priority="1024">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.11']" />
    <xsl:variable name="val_STATCLINALL" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.11?code=',$val_STATCLINALL))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.11?code=',$val_STATCLINALL))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 12_DIZ| Codice  StatoClinicoAllergia  '<xsl:text />
            <xsl:value-of select="$val_STATCLINALL" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.8']" mode="M3" priority="1023">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.8']" />
    <xsl:variable name="val_age" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.8?code=',$val_age))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.8?code=',$val_age))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 13_DIZ| Codice EtaInsorgenza_PSSIT '<xsl:text />
            <xsl:value-of select="$val_age" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.9']" mode="M3" priority="1022">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.9']" />
    <xsl:variable name="val_problem_obs" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.9?code=',$val_problem_obs))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.9?code=',$val_problem_obs))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 14_DIZ| Codice ProblemObservation_PSSIT '<xsl:text />
            <xsl:value-of select="$val_problem_obs" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.111']" mode="M3" priority="1021">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.5.111']" />
    <xsl:variable name="val_parentela" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.111?code=',$val_parentela))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.111?code=',$val_parentela))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 15_DIZ| Codice RoleCode '<xsl:text />
            <xsl:value-of select="$val_parentela" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.1']" mode="M3" priority="1020">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.5.1']" />
    <xsl:variable name="val_Gender1" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1?code=',$val_Gender1))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1?code=',$val_Gender1))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 16_DIZ| Codice AdministrativeGender '<xsl:text />
            <xsl:value-of select="$val_Gender1" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.1.11.1']" mode="M3" priority="1019">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.1.11.1']" />
    <xsl:variable name="val_Gender2" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.1?code=',$val_Gender2))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.1?code=',$val_Gender2))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 17_DIZ| Codice AdministrativeGender '<xsl:text />
            <xsl:value-of select="$val_Gender2" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10']" mode="M3" priority="1018">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10']" />
    <xsl:variable name="val_CronProbl" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.10?code=',$val_CronProbl))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.10?code=',$val_CronProbl))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 18_DIZ| Codice CronicitàProblema '<xsl:text />
            <xsl:value-of select="$val_CronProbl" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7']" mode="M3" priority="1017">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7']" />
    <xsl:variable name="val_StatoProbl" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.7?code=',$val_StatoProbl))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.7?code=',$val_StatoProbl))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 19_DIZ| Codice StatoClinicoProblema '<xsl:text />
            <xsl:value-of select="$val_StatoProbl" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:telecom" mode="M3" priority="1016">
    <svrl:fired-rule context="//hl7:telecom" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@use)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@use)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore-37| L’elemento 'telecom' DEVE contenere l'attributo @use.
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']" mode="M3" priority="1015">
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
          <svrl:text>Errore-38| codice fiscale '<xsl:text />
            <xsl:value-of select="$CF" />
            <xsl:text />' cittadino ed operatore: 16 cifre [A-Z0-9]{16}</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:observation" mode="M3" priority="1014">
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
          <svrl:text>Errore-39| L'attributo "@classCode" dell'elemento "observation" deve essere presente </svrl:text>
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
          <svrl:text>Errore-40| L'attributo "@moodCode" dell'elemento "observation" deve essere valorizzato con "EVN" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:act" mode="M3" priority="1013">
    <svrl:fired-rule context="//hl7:act" />
    <xsl:variable name="mood_act" select="@moodCode" />
    <xsl:variable name="class_act" select="@classCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$mood_act='EVN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$mood_act='EVN'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore-41| L'attributo "@moodCode" dell'elemento "Act" deve essere valorizzato con "EVN" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$class_act='ACT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$class_act='ACT'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore-42| L'attributo "@classCode" dell'elemento "Act" deve essere valorizzato con "ACT" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody" mode="M3" priority="1012">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='55111-9'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='55111-9'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-43| Sezione Esame Eseguito: la sezione DEVE essere presente.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='55111-9']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='55111-9']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-44| Sezione Esame Eseguito: La sezione deve contenere l'elemento 'text'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='55111-9']]/hl7:entry)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='55111-9']]/hl7:entry)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-45| Sezione Esame Eseguito: La sezione deve contenere un elemento 'entry'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='18782-3'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='18782-3'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-46| Sezione Referto: DEVE essere presente la sezione "Referto".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='18782-3']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='18782-3']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-47| Sezione Referto: La sezione deve contenere l'elemento 'text'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" mode="M3" priority="1011">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" />
    <xsl:variable name="codice" select="hl7:code/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='121181'])=1 or count(hl7:code[@code='18785-6'])=1 or count(hl7:code[@code='11329-0'])=1     or count(hl7:code[@code='55114-3'])=1 or count(hl7:code[@code='55111-9'])=1 or count(hl7:code[@code='18782-3'])=1     or count(hl7:code[@code='55110-1'])=1 or count(hl7:code[@code='55107-7'])=1 or count(hl7:code[@code='55109-3'])=1 or count(hl7:code[@code='18783-1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='121181'])=1 or count(hl7:code[@code='18785-6'])=1 or count(hl7:code[@code='11329-0'])=1 or count(hl7:code[@code='55114-3'])=1 or count(hl7:code[@code='55111-9'])=1 or count(hl7:code[@code='18782-3'])=1 or count(hl7:code[@code='55110-1'])=1 or count(hl7:code[@code='55107-7'])=1 or count(hl7:code[@code='55109-3'])=1 or count(hl7:code[@code='18783-1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-48| Il codice '<xsl:text />
            <xsl:value-of select="$codice" />
            <xsl:text />' non è corretto. La sezione deve essere valorizzata con uno dei seguenti codici:
			121181   Sezione DICOM Object Catalog
			18785-6  Sezione Quesito Diagnostico
			11329-0	 Sezione Storia Clinica
			55114-3	 Sezione Precedenti Esami Eseguiti
			55111-9	 Sezione Esame Eseguito
			18782-3	 Sezione Referto
			55110-1	 Sezione Conclusioni
			55107-7	 Sezione Informazioni Aggiuntive
			55109-3	 Sezione Complicanze
			18783-1  Sezione Suggerimenti per il medico prescrittore
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component" mode="M3" priority="1010">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='121181']])=0 or    count(hl7:section[hl7:code[@code='121181']]/hl7:entry/hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='121181']])=0 or count(hl7:section[hl7:code[@code='121181']]/hl7:entry/hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-49| Sezione Dicom Object Catalog: La sezione deve avere l'elemento 'entry' di tipo 'act'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='18785-6']])=0 or count(hl7:section[hl7:code[@code='18785-6']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='18785-6']])=0 or count(hl7:section[hl7:code[@code='18785-6']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-50| Sezione Quesito Diagnostico: La sezione deve contenere l'elemento 'text'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry)=0 or count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry/hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry)=0 or count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry/hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-51| Sezione Quesito Diagnostico: La 'entry' della sezione deve contenere l'elemento 'observation'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry)=0 or     count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry/hl7:observation/hl7:code[@code='29308-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry)=0 or count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry/hl7:observation/hl7:code[@code='29308-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-52| Sezione Quesito Diagnostico: L'elemento entry/observation/code deve avere l'attributo @code='29308-4' secondo il @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry)=0 or     count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry)=0 or count(hl7:section[hl7:code[@code='18785-6']]/hl7:entry/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-53| Sezione Quesito Diagnostico: L'elemento entry/observation/value deve essere presente e deve essere valorizzato secondo il sistema di codifica  ICD-9-CM (@codeSystem='2.16.840.1.113883.6.103')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='11329-0']])=0 or count(hl7:section[hl7:code[@code='11329-0']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='11329-0']])=0 or count(hl7:section[hl7:code[@code='11329-0']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-54| Sezione Storia Clinica: La sezione deve contenere l'elemento 'text'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='55114-3']])=0 or count(hl7:section[hl7:code[@code='55114-3']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='55114-3']])=0 or count(hl7:section[hl7:code[@code='55114-3']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-55| Sezione Precedenti Esami Eseguiti: La section deve contenere l'elemento 'text'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='55110-1']])=0 or count(hl7:section[hl7:code[@code='55110-1']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='55110-1']])=0 or count(hl7:section[hl7:code[@code='55110-1']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-56| Sezione Conclusiooni: La section deve contenere l'elemento "text"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='55107-7']])=0 or count(hl7:section[hl7:code[@code='55107-7']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='55107-7']])=0 or count(hl7:section[hl7:code[@code='55107-7']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE 57| Sezione Informazioni Aggiuntive: La section deve contenere l'elemento "text"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='55109-3']])=0 or count(hl7:section[hl7:code[@code='55109-3']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='55109-3']])=0 or count(hl7:section[hl7:code[@code='55109-3']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-58| Sezione Complicanze: La section deve contenere l'elemento "text".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='55109-3']]/hl7:entry)=0 or count(hl7:section[hl7:code[@code='55109-3']]/hl7:entry/hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='55109-3']]/hl7:entry)=0 or count(hl7:section[hl7:code[@code='55109-3']]/hl7:entry/hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-59|Sezione Complicanze: La section/entry deve contenere l'elemento "observation"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='18783-1']])=0 or count(hl7:section[hl7:code[@code='18783-1']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='18783-1']])=0 or count(hl7:section[hl7:code[@code='18783-1']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-60| Sezione Suggerimenti per il medico prescrittore: La section deve contenere l'elemento 'text'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry" mode="M3" priority="1009">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1 or count(hl7:organizer)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1 or count(hl7:organizer)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-61| Sezione Storia Clinica: L'elemento 'entry' deve avere uno dei seguenti sotto elementi:
				- 'observation': per l'Anamnesi patologica e fisiologica;
				- 'organizer': per l'Anamnesi familiare.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or      count(hl7:observation/hl7:code[@code='75326-9'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:code[@code='75326-9'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-62| Sezione Storia Clinica: L'elemento entry/observation/code deve avere gli attributi @code='75326-9' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or      count(hl7:observation/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-63| Sezione Storia Clinica: L'elemento entry/observation/statusCode deve avere l'attributo @code='completed'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or     count(hl7:observation/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-64| Sezione Storia Clinica: L'elemento entry/observation/effectiveTime deve essere presente e deve avere l'elemento 'low' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or     count(hl7:observation/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or count(hl7:observation/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-65| Sezione Storia Clinica: L'elemento entry/observation/value deve avere l'attributo @xsi:type="CD".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=0 or      (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or     count(hl7:observation/hl7:value/@code)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=0 or (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or count(hl7:observation/hl7:value/@code)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-66| Sezione Storia Clinica: Nel caso di 'value' non codificato (in entry/observation), deve essere valorizzato l'elemento 'originalText/reference'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or count(hl7:organizer[@classCode='CLUSTER'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer[@classCode='CLUSTER'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-67| Sezione Storia Clinica: L'elemento entry/organizer deve avere l'attributo @classCode valorizzato come "CLUSTER".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or      count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:code)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:subject/hl7:relatedSubject/hl7:code)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-68| Sezione Storia Clinica: La entry/organizer deve avere un elemento subjectect/relatedSubject il quale deve contenere l'elemento 'code'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:organizer)=0 or      count(hl7:organizer/hl7:component/hl7:observation)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:organizer)=0 or count(hl7:organizer/hl7:component/hl7:observation)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-69| Sezione Storia Clinica: L'elemento entry/organizer deve contenere almeno un elemento 'component' di tipo 'observation'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:observation/hl7:entryRelationship" mode="M3" priority="1008">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:observation/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation/hl7:code[@code='89261-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation/hl7:code[@code='89261-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-70| Sezione Storia Clinica: L'elemento entry/observation/entryRelationship/observation/code deve avere l'attributo @code valorizzato con:
				"89261-2" per "Dettaglio Cronicità patologia"
				"33999-4" per "Dettaglio Stato patologia"
				</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value)=0 or      (count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1 or      count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value)=0 or (count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation[hl7:code[@code='89261-2']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-71| Sezione Storia Clinica: L'elemento 'value' relativo alla Cronicità deve essere valorizzato secondo il Value set "CronicitàProblema".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value)=0 or      (count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1 or      count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value)=0 or (count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation[hl7:code[@code='33999-4']]/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-72| Sezione Storia Clinica: L'elemento 'value' relativo allo Stato Clinico della patoligia deve essere valorizzato secondo il Value set "StatoClinicoProblema".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:organizer/hl7:component" mode="M3" priority="1007">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:organizer/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-73| Sezione Storia Clinica: L'elemento entry/organizer/component/observation/statusCode deve contenere l'attributo @code valorizzato con 'completed'.</svrl:text>
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
          <svrl:text>ERRORE-74| Sezione Storia Clinica: L'elemento entry/organizer/component/observation deve contenere l'elemento 'effectiveTime'.</svrl:text>
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
          <svrl:text>ERRORE-75| Sezione Storia Clinica: L'elemento entry/organizer/component/observation deve contenere l'elemento 'value'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation/hl7:entryRelationship)>=1 and count(hl7:observation/hl7:entryRelationship)&lt;=2) and     (count(hl7:observation/hl7:entryRelationship/hl7:observation)>=1 and count(hl7:observation/hl7:entryRelationship/hl7:observation)&lt;=2)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation/hl7:entryRelationship)>=1 and count(hl7:observation/hl7:entryRelationship)&lt;=2) and (count(hl7:observation/hl7:entryRelationship/hl7:observation)>=1 and count(hl7:observation/hl7:entryRelationship/hl7:observation)&lt;=2)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-76| Sezione Storia Clinica: L'elemento entry/organizer/component/observation deve avere al più 2 elementi 'entryRelationship' di tipo observation:
				- Età di insorgenza (OBBLIGATORIO)
				- Età di decesso (OPZIONALE)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:organizer/hl7:component/hl7:observation/hl7:entryRelationship" mode="M3" priority="1006">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:organizer/hl7:component/hl7:observation/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation/hl7:code[@code='35267-4'])=1 or count(hl7:observation/hl7:code[@code='39016-1'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation/hl7:code[@code='35267-4'])=1 or count(hl7:observation/hl7:code[@code='39016-1'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-77| Sezione Storia Clinica: La 'entryRelationship' deve avere l'elemento observation/code valorizzato con uno dei seguenti valori:
				"35267-4" per "Età di insorgenza" 
				"39016-1" per "Età di decesso".</svrl:text>
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
          <svrl:text>ERRORE-78| Sezione Storia Clinica: La entryRelationship/observation relativa all'Età di insorgenza o Età di decesso deve avere l'elemento 'value' valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component" mode="M3" priority="1005">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section/hl7:code[@code='48765-2'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section/hl7:code[@code='48765-2'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-79| Sotto sezione Allergie: Il code della section deve essere valorizzato con il @code='48765-2' e il @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
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
          <svrl:text>ERRORE-80| Sotto sezione Allergie: La section deve avere un elemento 'text'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or     count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-81| Sotto sezione Allergie: L'entryRelationship/observation relativa alla "Criticità dell'allergia"  può essere presente solo una volta.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or    count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation])=0 or count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-82| Sotto sezione Allergie: L'entryRelationship/observation (Criticità dell'allergia) deve avere l'attributo @codesystem='2.16.840.1.113883.5.4'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation)=0 or     count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.1063'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation)=0 or count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.1063'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-83| Sotto sezione Allergie: L'entryRelationship/observation/value (Criticità dell'allergia) deve essere valorizzato secondo il value set "CriticalityObservation" @codesystem='2.16.840.1.113883.5.1063'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or     count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-84| Sotto sezione Allergie: L'entryRelationship/observation relativa allo "Stato"  può essere presente solo una volta.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or     count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-85| Sotto sezione Allergie: L'elemento 'code' all'interno di entryRelationship/observation (Stato dell'allergia) deve avere l'attributo @code='33999-4' e il @codesystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or     count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR'])=0 or count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-86| Sotto sezione Allergie: L'elemento 'value' all'interno di entryRelationship/observation (Stato dell'allergia) deve essere valorizzato secondo il value set "StatoClinicoAllergia" @codesystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])=0 or     count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act])=0 or count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-87| Sotto sezione Allergie: L'entryRelationship/act relativo ai "Commenti" può essere presente una sola volta.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:act)=0 or     count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:act/hl7:code[@code='48767-8'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:act)=0 or count(hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:act/hl7:code[@code='48767-8'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-88| Sotto sezione Allergie: L'elemento 'code' all'interno di entryRelationship/act (Commenti) deve avere l'attributo @code='48767-8' e il @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry" mode="M3" priority="1004">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-89| Sotto sezione Allergie: La 'entry' della section deve essere di tipo 'act'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="status" select="hl7:act/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$status='active' or $status='completed' or $status='aborted' or $status='suspended'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$status='active' or $status='completed' or $status='aborted' or $status='suspended'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-90| Sotto sezione Allergie: L'elemento 'statusCode' deve essere valorizzato secondo il value set ActStatus: 'active'|'completed'|'aborted'|'suspended'.</svrl:text>
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
          <svrl:text>ERRORE-91| Sotto sezione Allergie: L'elemento 'effectiveTime' deve essere presente e deve avere l'elemento 'low' valorizzato.</svrl:text>
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
          <svrl:text>ERRORE-92| Sotto sezione Allergie: L'elemento 'effectiveTime/high' deve essere presente nel caso in cui lo 'statusCode' è 'completed'|'aborted'.</svrl:text>
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
          <svrl:text>ERRORE-93| Sotto sezione Allergie: L'entry/act deve includere uno ed un solo elemento entryRelationship/observation con il 'code' uguale a '52473-6'.</svrl:text>
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
          <svrl:text>ERRORE-94| Sotto sezione Allergie: L'elemento entry/act/entryRelationship/observation/statusCode/@code deve assumere il valore costante 'completed'.</svrl:text>
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
          <svrl:text>ERRORE-95| Sotto sezione Allergie: I'elemento entry/act/entryRelationship/observation/effectiveTime deve avere valorizzato l'elemento 'low'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value)=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-96| Sotto sezione Allergie: L'elemento entry/act/entryRelationship/observation/value deve avere l'attributo @xsi:type valorizzato come 'CD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value)=0 or     (count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=0 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.4'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value)=0 or (count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.4'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-97| Sotto sezione Allergie: L'elemento entry/act/entryRelationship/observation/value codificato, deve avere l'attributo @code valorizzato secondo il value set "ObservationIntoleranceType" (@codeSystem='2.16.840.1.113883.5.4').</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value)=0 or     (count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=1 or     count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value)=0 or (count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=1 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-98| Sotto sezione Allergie: L'elemento entry/act/entryRelationship/observation/value non codificato, deve avere l'elemento originalText/reference valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship" mode="M3" priority="1003">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:participant)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:participant)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-99| Sotto sezione Allergie: L'elemento entryRelationship/observation (Descrizione Agente) deve avere almeno un elemento 'participant' che dettaglia l'agente scatenante.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:participant/hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or    count(hl7:observation/hl7:participant/hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or    count(hl7:observation/hl7:participant/hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:participant/hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or count(hl7:observation/hl7:participant/hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count(hl7:observation/hl7:participant/hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-100| Sotto sezione Allergie: L'elemento participant/participantRole/playingEntity deve avere l'attributo code/@codeSystem valorizzato come segue:
			- '2.16.840.1.113883.6.73' codifica "WHO ATC"
			- '2.16.840.1.113883.2.9.6.1.5' codifica "AIC"
			- '2.16.840.1.113883.2.9.77.22.11.2' value set "AllergenNoDrugs" (- per le allergie non a farmaci –)
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='MFST']" mode="M3" priority="1002">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='MFST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-101| Sotto sezione Allergie: L'entryRelationship/observation (Descrizione Reazioni) deve avere un elemento 'code' con gli attributi @code='75321-0' e @codeSystem='2.16.840.1.113883.6.1'.</svrl:text>
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
          <svrl:text>ERRORE-102| Sotto sezione Allergie: L'entryRelationship/observation (Descrizione Reazioni) deve avere un 'effectiveTime'  con un elemento 'low' valorizzato.</svrl:text>
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
          <svrl:text>ERRORE-103| Sotto sezione Allergie: L'elemento 'value' di entryRelationship/observation (Descrizione Reazioni) deve avere l'attributo @xsi:type='CD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value)=0 or    (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or    (count(hl7:observation/hl7:value/@code)=1 and (count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)&lt;=1))" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value)=0 or (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or (count(hl7:observation/hl7:value/@code)=1 and (count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)&lt;=1))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-104| Sotto sezione Allergie: Nel caso di 'value' non codificato (in Descrizione Reazioni), questo deve avere l'elemento originalText/reference valorizzato.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value)=0 or count(hl7:observation/hl7:value/@code)=0 or    (count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4'])=1 or     count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3'])=1 or     count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value)=0 or count(hl7:observation/hl7:value/@code)=0 or (count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4'])=1 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3'])=1 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-105| Sotto sezione Allergie: L'entryRelationship/observation/value (in Descrizione Reazioni) deve avere l'attributo @codeSystem valorizzato come segue:
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
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='55114-3']]/hl7:entry" mode="M3" priority="1001">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='55114-3']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-106| Sezione Precedenti Esami Eseguiti: L'elemento 'entry' della sezione deve contenere un elemento di tipo 'observation'.</svrl:text>
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
          <svrl:text>ERRORE-107| Sezione Precedenti Esami Eseguiti: l'entry/observation/code può essere valorizzato secodo i sistemi di codifica
			LOINC: @codeSystem='2.16.840.1.113883.6.1'
			ICD-9-CM: @codeSystem='2.16.840.1.113883.6.103' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='55111-9']]/hl7:entry" mode="M3" priority="1000">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='55111-9']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-108| Sezione Esame Eseguito: La 'entry' della sezione deve contenere un elemento di tipo 'act'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-109| Sezione Esame Eseguito: L'elemento entry/act/code può essere valorizzato secondo i sistemi di codifica:
			- LOINC (@codeSystem: 2.16.840.1.113883.6.1)
			- ICD-9-CM (@codeSystem: 2.16.840.1.113883.6.103).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:statusCode[@code='active'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:statusCode[@code='active'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-110| Sezione Esame Eseguito: L'elemento 'statusCode' all'interno di entry/act deve avere l'attributo @code valorizzato come "active".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:effectiveTime)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:effectiveTime)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-111| Sezione Esame Eseguito: entry/act della sezione deve avere l'elemento 'effectiveTime'.</svrl:text>
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
