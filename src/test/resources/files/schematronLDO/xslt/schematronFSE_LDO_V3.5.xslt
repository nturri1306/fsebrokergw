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
    <svrl:schematron-output schemaVersion="" title="Schematron Lettera Dimissione Ospedaliera V 1.2">
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
<svrl:text>Schematron Lettera Dimissione Ospedaliera V 1.2</svrl:text>

<!--PATTERN all-->


	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument" mode="M3" priority="1048">
    <svrl:fired-rule context="hl7:ClinicalDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:realmCode)>=1 and count(hl7:languageCode)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:realmCode)>=1 and count(hl7:languageCode)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-1| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE avere almeno un elemento 'realmCode' e un elemento 'languageCode'</svrl:text>
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
          <svrl:text>ERRORE-2| L'elemento 'realmCode' DEVE avere l'attributo @code valorizzato come 'IT'</svrl:text>
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
      <xsl:when test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.5'])= 1 and  count(hl7:templateId/@extension)= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.5'])= 1 and count(hl7:templateId/@extension)= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-4| Almeno un elemento 'templateId' DEVE essere valorizzato attraverso l'attributo @root='2.16.840.1.113883.2.9.10.1.5' (id del template nazionale), associato all'attributo @extension che  indica la versione a cui il templateId fa riferimento</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='34105-7'][@codeSystem='2.16.840.1.113883.6.1']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='34105-7'][@codeSystem='2.16.840.1.113883.6.1']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-5| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/code deve essere valorizzato con l'attributo @code='34105-7' e il @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Lettera di dimissione ospedaliera'])=1 or    count(hl7:code[@displayName='LETTERA DI DIMISSIONE OSPEDALIERA'])=1)">
      <svrl:successful-report test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Lettera di dimissione ospedaliera'])=1 or count(hl7:code[@displayName='LETTERA DI DIMISSIONE OSPEDALIERA'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W001| Si raccomanda di valorizzare gli attributi dell'elemento <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />/code nel seguente modo: @codeSystemName ='LOINC' e @displayName ='Lettera di dimissione ospedaliera'.--&gt; </svrl:text>
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
          <svrl:text>ERRORE-6| L'elemento 'confidentialityCode' di <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> DEVE avere l'attributo @code valorizzato con 'N' o 'V', e il @codeSystem='2.16.840.1.113883.5.25'</svrl:text>
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
          <svrl:text>ERRORE-7| Se ClinicalDocument.id e ClinicalDocument.setId usano lo stesso dominio di identificazione (@root identico) allora l’attributo @extension del
			ClinicalDocument.id deve essere diverso da quello del ClinicalDocument.setId a meno che ClinicalDocument.versionNumber non sia uguale ad 1; cioè i valori di setId ed id per un documento clinico possono coincidere solo per la prima versione di un documento</svrl:text>
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
            <xsl:text />  deve contenere un elemento di tipo 'relatedDocument'</svrl:text>
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
          <svrl:text>ERRORE-9| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="patient" select="hl7:recordTarget/hl7:patientRole/hl7:patient" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($patient)=1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count($patient)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-10| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTaget/patientRole DEVE contenere l'elemento patient</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($patient/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($patient/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-11| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTaget/patientRole/patient DEVE contenere l'elemento 'name'</svrl:text>
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
          <svrl:text>ERRORE-12| L'elemento ClinicalDocument/recordTaget/patientRole/patient/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="genderCode" select="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@code" />
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
            <xsl:text />/recordTarget/patientRole/patient  DEVE contenere l'elemento administrativeGenderCode </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($genderCode='M' or $genderCode='F' or $genderCode='UN')" />
      <xsl:otherwise>
        <svrl:failed-assert test="($genderCode='M' or $genderCode='F' or $genderCode='UN')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-14| L'attributo <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/patient/administrativeGenderCode/@code='<xsl:text />
            <xsl:value-of select="$genderCode" />
            <xsl:text />' non è valorizzato correttamente. Deve assumere uno dei seguenti valori:'M', 'F', 'UN', mentre @codeSystem deve essere uguale a '2.16.840.1.113883.5.1' </svrl:text>
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
          <svrl:text>ERRORE-15| L'OID assegnato all'attributo <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/recordTarget/patientRole/patient/administrativeGenderCode/@codeSystem='<xsl:text />
            <xsl:value-of select="$genderOID" />
            <xsl:text />' non è corretto. L'attributo DEVE essere valorizzato con '2.16.840.1.113883.5.1' </svrl:text>
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
          <svrl:text>ERRORE-17| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/author/assignedAuthor/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="name_author" select="hl7:author/hl7:assignedAuthor/hl7:assignedPerson" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($name_author/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($name_author/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-18| L'elemento ClinicalDocument/author/assignedAuthor/assignedPerson DEVE avere l'elemento 'name'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count($name_author/hl7:name/hl7:given)=1 and count($name_author/hl7:name/hl7:family)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count($name_author/hl7:name/hl7:given)=1 and count($name_author/hl7:name/hl7:family)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-19| L'elemento ClinicalDocument/author/assignedAuthor/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
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
          <svrl:text>ERRORE-20| In ClinicalDocument/author/assignedAuthor DEVE essere presente almeno un elemento 'telecom'</svrl:text>
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
          <svrl:text>ERRORE-21| L'elemento ClinicalDocument/dataEnterer DEVE contenere un elemento 'time'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="id_dataEnterer" select="hl7:dataEnterer/hl7:assignedEntity/hl7:id" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or count($id_dataEnterer[@root='2.16.840.1.113883.2.9.4.3.2'])>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or count($id_dataEnterer[@root='2.16.840.1.113883.2.9.4.3.2'])>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-22| L'elemento ClinicalDocument/dataEnterer/assignedEntity DEVE avere almeno un elemento 'id' <xsl:text />
            <xsl:value-of select="$id_dataEnterer" />
            <xsl:text /> con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nome" select="hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson)>=1 and count($nome)>=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson)>=1 and count($nome)>=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-23| L'elemento clinicalDocument/dataEnterer/assignedEntity/assignedPerson DEVE riportare l'elemento 'name'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or (count($nome/hl7:family)>=1 and count($nome/hl7:given)>=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or (count($nome/hl7:family)>=1 and count($nome/hl7:given)>=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-24| L'elemento clinicalDocument/dataEnterer/assignedEntity/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</svrl:text>
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
          <svrl:text>ERRORE-25| ClinicalDocument/custodian/assignedCustodian/representedCustodianOrganization deve contenere un elemento 'name'</svrl:text>
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
          <svrl:text>ERRORE-26| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/custodian/assignedCustodian/representedCustodianOrganization/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator)= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator)= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-27| L'elemento legalAuthenticator è obbligatorio </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator/hl7:signatureCode[@code='S'])= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator/hl7:signatureCode[@code='S'])= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-28| L'elemento legalAuthenticator/signatureCode deve essere valorizzato con il codice "S" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-29| L'elemento legalAuthenticator/assignedEntity DEVE contenere almeno un elemento id valorizzato con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-30| ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson DEVE contenere l'elemento 'name'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-31| ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="prioriry" select="hl7:inFulfillmentOf/hl7:order/hl7:priorityCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode)=0 or ($prioriry='R' or $prioriry='P' or $prioriry='UR' or $prioriry='EM')" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode)=0 or ($prioriry='R' or $prioriry='P' or $prioriry='UR' or $prioriry='EM')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-32| ClinicalDocument/infulfillmentOf/order/priorityCode DEVE avere l'attributo code valorizzato con uno dei seguenti valori: 'R'|'P'|'UR'|'EM' </svrl:text>
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
          <svrl:text>ERRORE-33| L'elemento componentOf è obbligatorio </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-34| L'elemento ClinicalDocument/componentOf/encompassingEncounter deve contenere l'elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:low)=1 and count(hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:high)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:low)=1 and count(hl7:componentOf/hl7:encompassingEncounter/hl7:effectiveTime/hl7:high)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-35| L'elemento ClinicalDocument/componentOf/encompassingEncounter/effectiveTime deve contenere gli elementi 'low' e 'high' valorizzati </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="path_name" select="hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-36| Deve essere presente l'elemento ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedentity/assignedPerson/name </svrl:text>
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
          <svrl:text>ERRORE-37| L'elemento ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedentity/assignedPerson/name deve contenere gli elementi 'given' e 'family' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:location)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:location)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-38| L'elemento componentOf/encompassingEncounter DEVE contenere l'elemento 'location'</svrl:text>
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
          <svrl:text>ERRORE-39| L'elemento ClinicalDocument/componentOf/encompassingEncounter/location/healthcareFacility/serviceProviderOrganization deve contenere l'elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.1']" mode="M3" priority="1047">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.5']" mode="M3" priority="1046">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.73']" mode="M3" priority="1045">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.51']" mode="M3" priority="1044">
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
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2']" mode="M3" priority="1043">
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
          <svrl:text>Errore 6_DIZ| Codice "Allergeni (No Farmaci)" '<xsl:text />
            <xsl:value-of select="$val_AllNoFarm" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@unit]" mode="M3" priority="1042">
    <svrl:fired-rule context="//*[@unit]" />
    <xsl:variable name="unit" select="encode-for-uri(@unit)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.12839?code=',  $unit))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.12839?code=', $unit))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 7_DIZ| Codice "UnitsOfMeasureCaseSensitive" '<xsl:text />
            <xsl:value-of select="$unit" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.12']" mode="M3" priority="1041">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.12']" />
    <xsl:variable name="procedure_trapiani" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.12?code=',$procedure_trapiani))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.12?code=',$procedure_trapiani))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 8_DIZ| Codice "ProcedureTrapianti" '<xsl:text />
            <xsl:value-of select="$procedure_trapiani" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3']" mode="M3" priority="1040">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3']" />
    <xsl:variable name="reaz_intoller" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.3?code=',$reaz_intoller))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.3?code=',$reaz_intoller))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 9_DIZ| Codice "Reazioni Intolleranza" '<xsl:text />
            <xsl:value-of select="$reaz_intoller" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4']" mode="M3" priority="1039">
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
          <svrl:text>Errore 10_DIZ| Codice "ReazioniAllergiche" '<xsl:text />
            <xsl:value-of select="$reaz_aller" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.6']" mode="M3" priority="1038">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.6']" />
    <xsl:variable name="criticality" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.6?code=',$criticality))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.6?code=',$criticality))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 11_DIZ| Codice "CriticalityObservation" '<xsl:text />
            <xsl:value-of select="$criticality" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7']" mode="M3" priority="1037">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.7']" />
    <xsl:variable name="status_problem" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.7?code=',$status_problem))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.7?code=',$status_problem))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 12_DIZ| Codice "StatoClinicoProblema" '<xsl:text />
            <xsl:value-of select="$status_problem" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10']" mode="M3" priority="1036">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.2.9.77.22.11.10']" />
    <xsl:variable name="conicita" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.10?code=',$conicita))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.77.22.11.10?code=',$conicita))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 13_DIZ| Codice "Cronicità" '<xsl:text />
            <xsl:value-of select="$conicita" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.1052']" mode="M3" priority="1035">
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
          <svrl:text>Errore 14_DIZ| Codice "ActSite" '<xsl:text />
            <xsl:value-of select="$sito" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.1.11.19700']" mode="M3" priority="1034">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.1.11.19700']" />
    <xsl:variable name="intoleranceType" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.19700?code=',$intoleranceType))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.1.11.19700?code=',$intoleranceType))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore 15_DIZ| Codice "ObservationIntoleranceType" '<xsl:text />
            <xsl:value-of select="$intoleranceType" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.112']" mode="M3" priority="1033">
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
          <svrl:text>Errore 17_DIZ| Codice "RouteOfAdministration" '<xsl:text />
            <xsl:value-of select="$via_somminist" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:telecom" mode="M3" priority="1032">
    <svrl:fired-rule context="//hl7:telecom" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@use)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@use)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Errore-40| L’elemento 'telecom' DEVE contenere l'attributo @use </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']" mode="M3" priority="1031">
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
          <svrl:text>Errore-41| codice fiscale '<xsl:text />
            <xsl:value-of select="$CF" />
            <xsl:text />' cittadino ed operatore: 16 cifre [A-Z0-9]{16}</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:observation" mode="M3" priority="1030">
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
          <svrl:text>Errore-42| L'attributo "@classCode" dell'elemento "observation" deve essere presente </svrl:text>
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
          <svrl:text>Errore-43| L'attributo "@moodCode" dell'elemento "observation" deve essere valorizzato con "EVN" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:act" mode="M3" priority="1029">
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
          <svrl:text>Errore-44| L'attributo "@moodCode" dell'elemento "Act" deve essere valorizzato con "EVN" </svrl:text>
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
          <svrl:text>Errore-45| L'attributo "@classCode" dell'elemento "Act" deve essere valorizzato con "ACT" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody" mode="M3" priority="1028">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='46241-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='46241-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-46| Sezione Motivo del Ricovero: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='46241-6']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='46241-6']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-47| Sezione Motivo del Ricovero: la sezione deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='8648-8'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='8648-8'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-48| Sezione Decorso Ospedaliero: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='8648-8']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='8648-8']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-49| Sezione Decorso Ospedaliero: La sezione deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section/hl7:code[@code='11535-2'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section/hl7:code[@code='11535-2'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-50| Sezione Condizioni del paziente e diagnosi alla dimissione: la sezione DEVE essere presente</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11535-2']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11535-2']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-51| Sezione Condizioni del paziente e diagnosi alla dimissione: La sezione DEVE contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:component/hl7:section[hl7:code[@code='11535-2']]/hl7:entry)>=1)">
      <svrl:successful-report test="not(count(hl7:component/hl7:section[hl7:code[@code='11535-2']]/hl7:entry)>=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W003|  Sezione Condizioni del paziente e diagnosi alla dimissione: La sezione PUO' contenere l'elemento 'entry' </svrl:text>
      </svrl:successful-report>
    </xsl:if>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='47039-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='47039-3']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='47039-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='47039-3']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-52| Sezione Inquadramento Clinico Iniziale: deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='55109-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='55109-3']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='55109-3']])=0 or count(hl7:component/hl7:section[hl7:code[@code='55109-3']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-53| Sezione Complicanze: deve contenere l'elemento "text"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='11493-4']])=0 or count(hl7:component/hl7:section[hl7:code[@code='11493-4']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='11493-4']])=0 or count(hl7:component/hl7:section[hl7:code[@code='11493-4']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-54| Sezione Riscontri ed accertamenti significativi: deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='34104-0']])=0 or count(hl7:component/hl7:section[hl7:code[@code='34104-0']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='34104-0']])=0 or count(hl7:component/hl7:section[hl7:code[@code='34104-0']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-55| Sezione Consulenza: deve contenere l'elemento 'text'</svrl:text>
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
          <svrl:text>ERRORE-56| Sezione Esami eseguiti durante il ricovero: deve contenere l'elemento "text" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='47519-4']])=0 or count(hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='47519-4']])=0 or count(hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-57| Sezione Procedure Eseguite durante il ricovero: deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='48765-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='48765-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-58| Sezione Allergie: deve contenere l'elemento "text" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10160-0']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10160-0']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-59| Sezione Terapia farmacologica effettuata durante il ricovero: deve contenere l'elemento "text" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='10183-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10183-2']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='10183-2']])=0 or count(hl7:component/hl7:section[hl7:code[@code='10183-2']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-60| Sezione Terapia farmacologica alla dimissione: deve contenere l'elemento "text" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section[hl7:code[@code='18776-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='18776-5']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section[hl7:code[@code='18776-5']])=0 or count(hl7:component/hl7:section[hl7:code[@code='18776-5']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-61| Sezione Istruzioni di follow-up: deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" mode="M3" priority="1027">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" />
    <xsl:variable name="codice" select="hl7:code/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='46241-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='47039-3'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='8648-8'][@codeSystem='2.16.840.1.113883.6.1'])=1     or count(hl7:code[@code='55109-3'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='11493-4'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='34104-0'][@codeSystem='2.16.840.1.113883.6.1'])=1     or count(hl7:code[@code='30954-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='47519-4'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='48765-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='10160-0'][@codeSystem='2.16.840.1.113883.6.1'])=1     or count(hl7:code[@code='11535-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='10183-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='18776-5'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='46241-6'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='47039-3'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='8648-8'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='55109-3'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='11493-4'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='34104-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='30954-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='47519-4'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='48765-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='10160-0'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='11535-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='10183-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:code[@code='18776-5'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-62| Il codice '<xsl:text />
            <xsl:value-of select="$codice" />
            <xsl:text />' non è corretto. La sezione deve essere valorizzata con uno dei seguenti codici:
			46241-6	Sezione Motivo del ricovero
			47039-3	Sezione Inquadramento clinico iniziale
			8648-8  Sezione Decorso Ospedaliero
			55109-3 Sezione Complicanze
			11493-4 Sezione Riscontri ed accertamenti significativi
			34104-0 Sezione Consulenza
			30954-2 Sezione Esami eseguiti durante il ricovero
			47519-4 Sezione Procedure eseguite durante il ricovero
			48765-2 Sezione Allergie
			10160-0 Sezione Terapia farmacologica effettuata durante il ricovero
			11535-2 Sezione Condizioni del paziente alla dimissione e diagnosi alla dimissione
			10183-2 Sezione Terapia farmacologica alla dimissione
			18776-5 Sezione Istruzioni di follow-up
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='46241-6']]/hl7:entry" mode="M3" priority="1026">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='46241-6']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='8646-2'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='8646-2'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-63| Sezione Motivo di Ricovero: l'elemento entry/observation/code deve avere l'attributo @code='8646-2' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
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
          <svrl:text>ERRORE-64| Sezione Motivo di Ricovero: l'elemento entry/observation DEVE contenere l'elemento value che dettaglia il Motivo del Ricovero</svrl:text>
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
          <svrl:text>ERRORE-65| Sezione Motivo di Ricovero: l'elemento entry/observation/value  DEVE  essere valorizzato attraverso il dizionario ICD9-CM </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47039-3']]/hl7:component" mode="M3" priority="1025">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47039-3']]/hl7:component" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='11329-0']])=0 or count(hl7:section[hl7:code[@code='11329-0']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='11329-0']])=0 or count(hl7:section[hl7:code[@code='11329-0']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-66| Sotto-sezione Anamnesi: deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='29545-1']])=0 or count(hl7:section[hl7:code[@code='29545-1']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='29545-1']])=0 or count(hl7:section[hl7:code[@code='29545-1']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-67| Sotto-sezione Esame Obiettivo: deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:section[hl7:code[@code='42346-7']])=0 or count(hl7:section[hl7:code[@code='42346-7']]/hl7:text)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:section[hl7:code[@code='42346-7']])=0 or count(hl7:section[hl7:code[@code='42346-7']]/hl7:text)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-68| Sotto-sezione Terapia Farmacologica all'ingresso: deve contenere l'elemento 'text'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47039-3']]/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry" mode="M3" priority="1024">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47039-3']]/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='75326-9'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='75326-9'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-69| Sotto-sezione Anamnesi: l'elemento entry/observation/code deve avere gli attributi @code='75326-9' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
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
          <svrl:text>ERRORE-70| Sotto-sezione Anamnesi: l'elemento entry/observation/statusCode deve avere l'attributo @code='completed'</svrl:text>
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
          <svrl:text>ERRORE-71| Sotto-sezione Anamnesi: l'elemento entry/observation/effectiveTime deve essere presente e deve avere l'elemento 'low' valorizzato</svrl:text>
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
          <svrl:text>ERRORE-72| Sotto-sezione Anamnesi: l'elemento entry/observation/value deve avere l'attributo @xsi:type="CD" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or     count(hl7:observation/hl7:value/@code)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or count(hl7:observation/hl7:value/@code)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-73| Sotto-sezione Anamnesi: nel caso di 'value' non codificato (in entry/observation), deve essere valorizzato l'elemento 'originalText/reference'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47039-3']]/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:observation/hl7:entryRelationship" mode="M3" priority="1023">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47039-3']]/hl7:component/hl7:section[hl7:code[@code='11329-0']]/hl7:entry/hl7:observation/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:observation/hl7:code[@code='89261-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or     count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:observation/hl7:code[@code='89261-2'][@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-74| Sotto-sezione Anamnesi: l'elemento entry/observation/entryRelationship/observation/code deve avere l'attributo @code valorizzato con:
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
          <svrl:text>ERRORE-75| Sotto-sezione Anamnesi: l'elemento 'value' relativo alla Cronicità deve essere valorizzato secondo il Value set "CronicitàProblema"</svrl:text>
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
          <svrl:text>ERRORE-76| Sotto-sezione Anamnesi: l'elemento 'value' relativo allo Stato Clinico della patologia deve essere valorizzato secondo il Value set "StatoClinicoProblema"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='55109-3']]/hl7:entry" mode="M3" priority="1022">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='55109-3']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='75326-9'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='75326-9'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-77| Sezione Complicanze:l'elemento entry DEVE contenere al suo interno un observation che valorizza  l'elemento "code" con attributi @code='75326-9' e @codeSystem='2.16.840.1.113883.6.1 </svrl:text>
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
          <svrl:text>ERRORE-78| Sezione Complicanze: entry/observation deve contenere l'elemento "value"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='34104-0']]/hl7:entry" mode="M3" priority="1021">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='34104-0']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='34820-1'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='34820-1'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-79| Sezione Consulenza: l'elemento entry DEVE contenere al suo interno un observation che valorizza  l'elemento 'code' con gli attributi @code='75321-0' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
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
          <svrl:text>ERRORE-80| Sezione Consulenza: l'elemento entry/observation DEVE contenere l'elemento 'value'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='34104-0']]/hl7:entry/hl7:observation/hl7:performer" mode="M3" priority="1020">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='34104-0']]/hl7:entry/hl7:observation/hl7:performer" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-81| Sezione Consulenza: l'elemento entry/observation/performer/assignedEntity/assignedPerson DEVE contenere l'elemento name</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and      count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-82| Sezione Consulenza: se presente section/entry/observation/performer/assignedEntity/assignedPerson/name deve contenere gli elementi "given" e "family" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='34104-0']]/hl7:entry/hl7:observation/hl7:participant" mode="M3" priority="1019">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='34104-0']]/hl7:entry/hl7:observation/hl7:participant" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole)=1 and count(hl7:participantRole/hl7:id)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole)=1 and count(hl7:participantRole/hl7:id)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-83| Sezione Consulenza: l'elemento entry/observation/participant DEVE contenere l'elemento 'participantRole' e almeno un elemento 'id'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-84| Sezione Consulenza: l'elemento entry/observation/participant/participantRole/playingEntity DEVE contenere l'elemento name</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:given)=1 and      count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:family)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:given)=1 and count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:family)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-85| Sezione Esami eseguiti durante il ricovero: se presente section/entry/observation/participant/participantRole/playingEntity/name deve contenere gli elementi "given" e "family" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry" mode="M3" priority="1018">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-86| Sezione Esami eseguiti durante il ricovero: se presente l'elemento section/entry, deve contenere l'elemento "observation" </svrl:text>
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
          <svrl:text>ERRORE-87| Sezione Esami eseguiti durante il ricovero: l'entry/observation/code può essere valorizzato secondo i sistemi di codifica
			LOINC @codeSystem='2.16.840.1.113883.6.1'
			ICD-9-CM @codeSystem='2.16.840.1.113883.6.103'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry/hl7:observation/hl7:performer" mode="M3" priority="1017">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry/hl7:observation/hl7:performer" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-88| Sezione Esami eseguiti durante il ricovero: section/entry/observation/performer/assignedEntity/assignedPerson deve avere l'elemento "name" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-89| Sezione Esami eseguiti durante il ricovero: section/entry/observation/performer/assignedEntity/assignedPerson/name deve contenere gli elementi "given" e "family" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry/hl7:observation/hl7:participant" mode="M3" priority="1016">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='30954-2']]/hl7:entry/hl7:observation/hl7:participant" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:id)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:id)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-90| Sezione Esami eseguiti durante il ricovero: se presente section/entry/observation/participant deve avere l'elemento "participantRole/id" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-91| Sezione Esami eseguiti durante il ricovero: se presente section/entry/observation/participant/participantRole/playingEntity deve avere l'elemento "name" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:family)=1 and count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:given)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:family)=1 and count(hl7:participantRole/hl7:playingEntity/hl7:name/hl7:given)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-92| Sezione Esami eseguiti durante il ricovero: se presente section/entry/observation/participant/participantRole/playingEntity/name deve contenere gli elementi "given" e "family" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:entry" mode="M3" priority="1015">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or    count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1 or count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.12'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1 or count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1 or count(hl7:procedure/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.12'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-93|Sezione Procedure Eseguite durante il ricovero: l'elemento entry/procedure/code deve essere valorizzato con uno dei seguenti sistemi di codifica:
			  -2.16.840.1.113883.6.1
			  -2.16.840.1.113883.6.103
			  -2.16.840.1.113883.2.9.77.22.11.12
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:entry/hl7:procedure/hl7:entryRelationship" mode="M3" priority="1014">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='47519-4']]/hl7:entry/hl7:procedure/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@typeCode='RSON'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@typeCode='RSON'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-94|Sezione Procedure Eseguite durante il ricovero: L'elemento proceduere/entryRelationship, deve avere un attributo @typeCode='RSON' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-95| Sezione Procedure Eseguite durante il ricovero: L'elemento proceduere/entryRelationship, deve avere un elemento 'observation'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1)">
      <svrl:successful-report test="not(count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.6.103'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W004| Si consiglia di valorizzare l'attributo @codeSystem dell'elemento procedure/entryRelationship/observation/code con il sistema di codifica ICD-9-CM (@codesystem='2.16.840.1.113883.6.103')--&gt; </svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry" mode="M3" priority="1013">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-96| Sezione Allergie: la sezione deve contenere l'elemento entry di tipo 'act'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="status" select="hl7:act/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or     $status='active' or $status='completed' or $status='aborted' or $status='suspended'" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or $status='active' or $status='completed' or $status='aborted' or $status='suspended'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-97| Sezione Allergie: l'elemento 'statusCode' deve essere valorizzato secondo il value set ActStatus: 'active'|'completed'|'aborted'|'suspended'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-98| Sezione Allergie: l'elemento 'effectiveTime' deve essere presente e deve avere l'elemento 'low' valorizzato</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or ($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or      ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or       ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or       ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or ($status='completed' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='aborted' and count(hl7:act/hl7:effectiveTime/hl7:high)=1) or ($status='suspended' and count(hl7:act/hl7:effectiveTime/hl7:high)=0) or ($status='active' and count(hl7:act/hl7:effectiveTime/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-99| Sezione Allergie: l'elemento 'effectiveTime/high' deve essere presente nel caso in cui lo 'statusCode' sia 'completed'oppure'aborted'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:code[@code='52473-6'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:code[@code='52473-6'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-100| Sezione Allergie: l'entry/act deve includere uno ed un solo elemento entryRelationship/observation con attributo @code='52473-6'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:text)=0 or        count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:text/hl7:reference/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:text)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:text/hl7:reference/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-101| Sezione Allergie: l'entry/act/entryRelationship/observation/text/reference/value deve essere valorizzato con l'URI che punta alla descrizione di allarme, allergia o intolleranza nel narrative block della sezione </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:statusCode[@code='completed'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:statusCode[@code='completed'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-102| Sezione Allergie: l'elemento entry/act/entryRelationship/observation/statusCode/@code deve assumere il valore costante 'completed'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:effectiveTime/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-103| Sezione Allergie: l'elemento 'effectiveTime' deve essere presente e deve avere l'elemento 'low' valorizzato </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value)=0 or        count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@xsi:type='CD'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@xsi:type='CD'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-104| Sezione Allergie: l'elemento entry/act/entryRelationship/observation/value deve avere l'attributo @xsi:type='CD'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=0 or        count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.5.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-105| Sezione Allergie: l'elemento entry/act/entryRelationship/observation/value codificato, deve avere l'attributo @code valorizzato secondo il value set "ObservationIntoleranceType".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=1 or        count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/@code)=1 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-106| Sezione Allergie: l'elemento entry/act/entryRelationship/observation/value non codificato, deve avere l'elemento originalText/reference valorizzato </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText)=0 or        count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference/@value)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:value/hl7:originalText/hl7:reference/@value)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-107| Sezione Allergie: entry/act/entryRelationship/observation/value/originalText/reference/value deve essere valorizzato con l'URI che punta alla descrizione del concetto espresso all'interno del narrative block </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act)=0 or count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-108| Sezione Allergie: entry/act/entryRelationship/observation deve contenere almeno un elemento 'participant'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation)&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation)&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-109| Sezione Allergie: entry/act/entryRelationship/observation deve contenere solo un elemento 'entryRelationship/observation' relativo alla Criticità</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation)&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']/hl7:observation)&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-110| Sezione Allergie: entry/act/entryRelationship/observation deve contenere solo un elemento 'entryRelationship/observation' relativo allo Stato dell'allergia</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:act)&lt;=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ']/hl7:act)&lt;=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-111| Sezione Allergie: entry/act/entryRelationship/observation deve contenere solo un elemento 'entryRelationship/act' relativo ai Commenti</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant" mode="M3" priority="1012">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:participant" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or      count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or      count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count(hl7:participantRole/hl7:playingEntity/hl7:code[@codeSystem='2.16.840.1.113883.2.9.77.22.11.2'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-112| Sezione Allergie: l'elemento participant/participantRole/playingEntity deve avere l'attributo code/@codeSystem valorizzato come segue:
					- '2.16.840.1.113883.6.73' per la codifica "WHO ATC"
					- '2.16.840.1.113883.2.9.6.1.5' per la codifica "AIC"
					- '2.16.840.1.113883.2.9.77.22.11.2' per il value set "AllergenNoDrugs" (- per le allergie non a farmaci –)
				</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='MFST']" mode="M3" priority="1011">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='MFST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='75321-0'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-113| Sezione Allergie: entryRelationship/observation (Descrizione Reazioni) deve avere un elemento 'code' con gli attributi @code=75321-0' e @codeSystem='2.16.840.1.113883.6.1' e @displayName='Obiettività Clinica'</svrl:text>
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
          <svrl:text>ERRORE-114| Sezione Allergie: L'entryRelationship/observation (Descrizione Reazioni) deve avere un 'effectiveTime' con l'elemento 'low' valorizzato</svrl:text>
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
          <svrl:text>ERRORE-115| Sezione Allergie: l'elemento 'value' di entryRelationship/observation (Descrizione Reazioni) deve avere l'attributo @xsi:type='CD'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value)=0 or        (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or        (count(hl7:observation/hl7:value/@code)=1 and (count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)&lt;=1))" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value)=0 or (count(hl7:observation/hl7:value/@code)=0 and count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)=1) or (count(hl7:observation/hl7:value/@code)=1 and (count(hl7:observation/hl7:value/hl7:originalText/hl7:reference)&lt;=1))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-116| Sezione Allergie: nel caso di 'value' non codificato (in Descrizione Reazioni), questo deve avere l'elemento originalText/reference valorizzato</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:value/@code)=0 or        (count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4'])=1 or         count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3'])=1 or         count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:value/@code)=0 or (count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.4'])=1 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.2.9.77.22.11.3'])=1 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-117| Sezione Allergie: entryRelationship/observation/value (in Descrizione Reazioni) deve avere l'attributo @codeSystem valorizzato come segue:
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
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation]" mode="M3" priority="1010">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:observation]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@codeSystem='2.16.840.1.113883.5.4'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-118| Sezione Allergie: entryRelationship/observation (Criticità dell'allergia) deve avere l'attributo @codesystem='2.16.840.1.113883.5.4'</svrl:text>
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
          <svrl:text>ERRORE-119| Sezione Allergie: entryRelationship/observation/value (Criticità dell'allergia) deve essere valorizzato secondo il value set "CriticalityObservation" @codesystem='2.16.840.1.113883.5.1063'</svrl:text>
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
          <svrl:text>ERRORE-120| Sezione Allergie: entry/act/entryRelationship/observation/text/reference/value deve essere valorizzato con l'URI che punta alla descrizione della severità nel narrative block della sezione </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']" mode="M3" priority="1009">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='REFR']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='33999-4'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-121| Sezione Allergie: l'elemento 'code' all'interno di entryRelationship/observation (Stato dell'allergia) deve avere l'attributo @code='33999-4' e @codesystem='2.16.840.1.113883.6.1'</svrl:text>
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
          <svrl:text>ERRORE-122| Sezione Allergie: l'elemento 'value' all'interno di entryRelationship/observation (Stato dell'allergia) deve essere valorizzato secondo il value set "StatoClinicoAllergia" (@codesystem='2.16.840.1.113883.6.1')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act]" mode="M3" priority="1008">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='48765-2']]/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation/hl7:entryRelationship[@typeCode='SUBJ'][hl7:act]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:act/hl7:code[@code='48767-8'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:act/hl7:code[@code='48767-8'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-123| Sezione Allergie: l'elemento 'code' all'interno di entryRelationship/act (Commenti) deve avere l'attributo @code='48767-8' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry" mode="M3" priority="1007">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration[@moodCode='EVN'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration[@moodCode='EVN'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-124| Sezione Terapia farmacologica effettuata durante il ricovero: se presente section/entry deve avere l'elemento "substanceAdministration" con attributi "classCode=SBADM"e "moodCode=EVN" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or       count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-125| Sezione Terapia farmacologica effettuata durante il ricovero: l'elemento section/entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code deve avere l'attributo "@codeSystem" valorizzato come segue:
			- '2.16.840.1.113883.2.9.6.1.5' codifica "AIC"
			- '2.16.840.1.113883.6.73' codifica "WHO ATC" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="stats" select="hl7:substanceAdministration/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$stats='active' or $stats='completed' or $stats='aborted' or $stats='suspended'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$stats='active' or $stats='completed' or $stats='aborted' or $stats='suspended'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-126| Sezione Terapia farmacologica effettuata durante il ricovero: section/entry/substanceAdministration deve avere l'elemento "statusCode" valorizzato secondo il value set ActStatus: 'active'|'completed'|'aborted'|'suspended'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-127| Sezione Terapia farmacologica effettuata durante il ricovero: section/entry/substanceAdministration/effectiveTime deve avere l'elemento 'low' valorizzato </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($stats='completed' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or      ($stats='aborted' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or       ($stats='suspended' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0) or       ($stats='active' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($stats='completed' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or ($stats='aborted' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or ($stats='suspended' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0) or ($stats='active' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-128| Sezione Terapia farmacologica effettuata durante il ricovero: section/entry/substanceAdministration/effectiveTime/high deve essere presente solo nel caso in cui lo 'statusCode' è 'completed'oppure'aborted'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry/hl7:substanceAdministration/hl7:performer" mode="M3" priority="1006">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry/hl7:substanceAdministration/hl7:performer" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-129| Sezione Terapia farmacologica effettuata durante il ricovero: se presente section/entry/substanceAdministration/assignedEntity/assignedPerson deve avere l'elemento "name" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and count(hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-130| Sezione Terapia farmacologica effettuata durante il ricovero: se presente section/entry/substanceAdministration/performer/assignedEntity/assignedPerson/name deve contenere gli elementi "given" e "family" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry/hl7:substanceAdministration/hl7:participant" mode="M3" priority="1005">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry/hl7:substanceAdministration/hl7:participant" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:id)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:id)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-131| Sezione Terapia farmacologica effettuata durante il ricovero: se presente section/entry/substanceAdministration/participant, deve avere almeno un elemento "participantRole/id" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-132| Sezione Terapia farmacologica effettuata durante il ricovero: se presente section/entry/substanceAdministration/participant/participantRole/playingEntity, deve avere l'elemento "name" </svrl:text>
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
          <svrl:text>ERRORE-133| Sezione Terapia farmacologica effettuata durante il ricovero: se presente section/entry/substanceAdministration/participant/participantRole/playingEntity/name, deve contenere gli elementi "given" e "family" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship" mode="M3" priority="1004">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10160-0']]/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1 or count(hl7:supply)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1 or count(hl7:supply)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-134| Sezione Terapia farmacologica effettuata durante il ricovero: se presente section/entry/substanceAdministration/entryRelationship  deve contenere uno o più elementi di tipo "observation" o "supply" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11535-2']]/hl7:entry" mode="M3" priority="1003">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='11535-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-135| Sezione Condizioni del paziente e diagnosi alla dimissione: la section/entry deve contenere l'elemento 'observation'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation/hl7:code[@code='8651-2'][@codeSystem='2.16.840.1.113883.6.1'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation/hl7:code[@code='8651-2'][@codeSystem='2.16.840.1.113883.6.1'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-136| Sezione Condizioni del paziente e diagnosi alla dimissione: l'elemento entry/observation/code deve avere l'attributo @code='8651-2' e @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
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
          <svrl:text>ERRORE-137| Sezione Condizioni del paziente e diagnosi alla dimissione: l'elemento entry/observation/value deve avere l'attributo @codeSystem='2.16.840.1.113883.6.103'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10183-2']]/hl7:entry" mode="M3" priority="1002">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10183-2']]/hl7:entry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration[@classCode='SBADM'][@moodCode='INT'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration[@classCode='SBADM'][@moodCode='INT'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-138|Sezione Terapia farmacologica alla dimissione: se presente section/entry deve avere l'elemento "substanceAdministration" con attributi "classCode=SBADM"e "moodCode=INT" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or       count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or        count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1 or count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.6.73'])=1 or count(hl7:substanceAdministration/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.51'])=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-139|Sezione Terapia farmacologica alla dimissione: l'elemento section/entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code deve avere l'attributo "@codeSystem" valorizzato come segue:
			- '2.16.840.1.113883.2.9.6.1.5' codifica "AIC"
			- '2.16.840.1.113883.6.73' codifica "WHO ATC" 
			- '2.16.840.1.113883.2.9.6.1.51' codifica "GE"
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="stscd" select="hl7:substanceAdministration/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$stscd='active' or $stscd='completed' or $stscd='aborted' or $stscd='suspended'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$stscd='active' or $stscd='completed' or $stscd='aborted' or $stscd='suspended'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-140|Sezione Terapia farmacologica alla dimissione: section/entry/substanceAdministration deve avere l'elemento "statusCode" valorizzato secondo il value set ActStatus: 'active'|'completed'|'aborted'|'suspended'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:low)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-141|Sezione Terapia farmacologica alla dimissione: section/entry/substanceAdministration/effectiveTime deve avere l'elemento 'low' valorizzato </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($stscd='completed' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or      ($stscd='aborted' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or       ($stscd='suspended' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0) or       ($stscd='active' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($stscd='completed' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or ($stscd='aborted' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=1) or ($stscd='suspended' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0) or ($stscd='active' and count(hl7:substanceAdministration/hl7:effectiveTime[@xsi:type='IVL_TS']/hl7:high)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-142|Sezione Terapia farmacologica alla dimissione: section/entry/substanceAdministration/effectiveTime/high deve essere presente solo nel caso in cui lo 'statusCode' sia 'completed'oppure'aborted'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10183-2']]/hl7:entry/hl7:substanceAdministration/hl7:participant" mode="M3" priority="1001">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10183-2']]/hl7:entry/hl7:substanceAdministration/hl7:participant" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:id)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:id)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-143|Sezione Terapia farmacologica alla dimissione: se presente section/entry/substanceAdministration/participant, deve avere almeno un elemento "participantRole/id" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:participantRole/hl7:playingEntity/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:participantRole/hl7:playingEntity/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-144|Sezione Terapia farmacologica alla dimissione: se presente section/entry/substanceAdministration/participant/participantRole/playingEntity, deve avere l'elemento "name" </svrl:text>
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
          <svrl:text>ERRORE-145|Sezione Terapia farmacologica alla dimissione: se presente section/entry/substanceAdministration/participant/participantRole/playingEntity/name, deve contenere gli elementi "given" e "family" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10183-2']]/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship" mode="M3" priority="1000">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section[hl7:code[@code='10183-2']]/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:observation)=1 or count(hl7:supply)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:observation)=1 or count(hl7:supply)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-146|Sezione Terapia farmacologica alla dimissione: se presente section/entry/substanceAdministration/entryRelationship  deve contenere uno o più elementi di tipo "observation" o "supply" </svrl:text>
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
