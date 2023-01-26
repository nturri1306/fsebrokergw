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
    <svrl:schematron-output schemaVersion="" title="Schematron Laboratorio Analisi 1.3">
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
<svrl:text>Schematron Laboratorio Analisi 1.3</svrl:text>

<!--PATTERN all-->


	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument" mode="M3" priority="1009">
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
            <xsl:text /> DEVE avere un almeno elemento 'realmCode' e un elemento 'languageCode'.</svrl:text>
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
          <svrl:text>ERRORE-2| Almeno un elemento 'realmCode' DEVE avere l'attributo @root valorizzato come 'IT'</svrl:text>
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
      <xsl:when test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.1'])= 1 and  count(hl7:templateId/@extension)= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.1'])= 1 and count(hl7:templateId/@extension)= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-4| Almeno un elemento 'templateId' DEVE essere valorizzato attraverso l'attributo  @root='2.16.840.1.113883.2.9.10.1.1' (id del template nazionale)  associato all'attributo @extension che  indica la versione a cui il templateId fa riferimento</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='11502-2'][@codeSystem='2.16.840.1.113883.6.1']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='11502-2'][@codeSystem='2.16.840.1.113883.6.1']) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-5| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text />/code deve essere valorizzato con l'attributo @code='11502-2' e il @codeSystem='2.16.840.1.113883.6.1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='REFERTO DI LABORATORIO'])=1 or    count(hl7:code[@displayName='Referto di Laboratorio'])=1 or count(hl7:code[@displayName='Referto di laboratorio'])=1)">
      <svrl:successful-report test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='REFERTO DI LABORATORIO'])=1 or count(hl7:code[@displayName='Referto di Laboratorio'])=1 or count(hl7:code[@displayName='Referto di laboratorio'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W001| Si raccomanda di valorizzare gli attributi dell'elemento <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text />/code nel seguente modo: @codeSystemName ='LOINC' e @displayName ='Referto di laboratorio'.--&gt; </svrl:text>
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
          <svrl:text>ERRORE 7: Se ClinicalDocument.id e ClinicalDocument.setId usano lo stesso dominio di identificazione (@root identico) allora l’attributo @extension del
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
          <svrl:text> ERRORE-9| L'elemento <xsl:text />
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
          <svrl:text>ERRORE 11| L'elemento ClinicalDocument/recordTaget/patientRole/patient/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
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
          <svrl:text>ERRORE-19 | In ClinicalDocument/author/assignedAuthor DEVE essere presente almeno un elemento 'telecom' </svrl:text>
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
          <svrl:text>ERRORE-20 | L'elemento <xsl:text />
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
          <svrl:text>ERRORE-21 | L'elemento ClinicalDocument/dataEnterer DEVE avere almeno un elemento 'id' <xsl:text />
            <xsl:value-of select="$id_dataEnterer" />
            <xsl:text /> con l'attributo @root valorizzato con '2.16.840.1.113883.2.9.4.3.2'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nome" select="hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:dataEnterer)=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson)=1 and count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:dataEnterer)=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson)=1 and count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-22 | L'elemento <xsl:text />
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
          <svrl:text>ERRORE-23 | L'elemento <xsl:text />
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
          <svrl:text>ERRORE-28 | ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson DEVE contenere l'elemento 'name'. </svrl:text>
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
          <svrl:text>ERRORE-29 | ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson/name DEVE riportare gli elementi 'given' e 'family'</svrl:text>
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
          <svrl:text>ERRORE-30 | In ClinicalDocuemnt DEVE essere presente almeno un elemento 'inFulfillmentOf'. </svrl:text>
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
          <svrl:text>ERRORE-31 | ClinicalDocument/infulfillmentOf/order/priorityCode DEVE avere l'attributo code valorizzato con uno dei seguenti valori: 'R'|'P'|'UR'|'EM' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson)=0 or     count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson)=0 or count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-32 | L'elemento ClinicalDocument/documentationOf/serviceEvent/performer/assignedEntity/assignedPerson se presente, deve contenere l'elemento name </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson)=0 or     (count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and     count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson)=0 or (count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-33 |l'elemento ClinicalDocument/documentationOf/serviceEvent/performer/assignedEntity/assignedPerson/name deve contenere gli attributi given e family </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="path_name" select="hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or     count (hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERROR-34 | deve essere presente l'elemento ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedentity/assignedPerson/name </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or     (count($path_name/hl7:given)=1 and count($path_name/hl7:family)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or (count($path_name/hl7:given)=1 and count($path_name/hl7:family)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-35 | L'elemento ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedentity/assignedPerson/name deve contenere gli elementi given e family </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization)=0 or     count (hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:id)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization)=0 or count (hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:id)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-36 | L'elemento ClinicalDocument/componentOf/encompassingEncounter/location/healthcareFacility/serviceProviderOrganization deve contenere l'elemento 'id' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" mode="M3" priority="1008">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:code[@code='18717-9'])>= 1 or count(hl7:code[@code='18718-7'])>= 1 or       count(hl7:code[@code='18719-5'])>= 1 or count(hl7:code[@code='18720-3'])>= 1 or       count(hl7:code[@code='18721-1'])>= 1 or count(hl7:code[@code='18722-9'])>= 1 or       count(hl7:code[@code='18723-7'])>= 1 or count(hl7:code[@code='18724-5'])>= 1 or       count(hl7:code[@code='18725-2'])>= 1 or count(hl7:code[@code='18727-8'])>= 1 or       count(hl7:code[@code='18729-6'])>= 1 or count(hl7:code[@code='18729-4'])>= 1 or       count(hl7:code[@code='18767-4'])>= 1 or count(hl7:code[@code='18768-2'])>= 1 or       count(hl7:code[@code='18769-0'])>= 1 or count(hl7:code[@code='26435-8'])>= 1 or       count(hl7:code[@code='26436-6'])>= 1 or count(hl7:code[@code='26437-4'])>= 1 or       count(hl7:code[@code='26438-2'])>= 1 or count(hl7:code[@code='18716-1'])>= 1 or       count(hl7:code[@code='26439-0'])>= 1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:code[@code='18717-9'])>= 1 or count(hl7:code[@code='18718-7'])>= 1 or count(hl7:code[@code='18719-5'])>= 1 or count(hl7:code[@code='18720-3'])>= 1 or count(hl7:code[@code='18721-1'])>= 1 or count(hl7:code[@code='18722-9'])>= 1 or count(hl7:code[@code='18723-7'])>= 1 or count(hl7:code[@code='18724-5'])>= 1 or count(hl7:code[@code='18725-2'])>= 1 or count(hl7:code[@code='18727-8'])>= 1 or count(hl7:code[@code='18729-6'])>= 1 or count(hl7:code[@code='18729-4'])>= 1 or count(hl7:code[@code='18767-4'])>= 1 or count(hl7:code[@code='18768-2'])>= 1 or count(hl7:code[@code='18769-0'])>= 1 or count(hl7:code[@code='26435-8'])>= 1 or count(hl7:code[@code='26436-6'])>= 1 or count(hl7:code[@code='26437-4'])>= 1 or count(hl7:code[@code='26438-2'])>= 1 or count(hl7:code[@code='18716-1'])>= 1 or count(hl7:code[@code='26439-0'])>= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-37| L'elemento code della section DEVE essere valorizzato con uno dei seguenti codici LOINC individuati:
						18717-9 BANCA DEL SANGUE
						18718-7 MARCATORI CELLULARI 
						18719-5 CHIMICA
						18720-3	COAGULAZIONE
						18721-1 MONITORAGGIO TERAPEUTICO DEI FARMACI
						18722-9 FERTILITÀ
						18723-7 EMATOLOGIA
						18724-5 HLA
						18725-2 MICROBIOLOGIA
						18727-8 SEROLOGIA
						18728-6 TOSSICOLOGIA
						18729-4 ESAMI DELLE URINE
						18767-4 EMOGASANALISI
						18768-2 CONTE CELLULARE+DIFFERENZIALE
						18769-0 SUSCETTIBILITÀ ANTIMICROBICA
						26435-8 PATOLOGIA MOLECOLARE
						26436-6 ESAMI DI LABORATORIO
						26437-4 TEST DI SENSIBILITÀ A SOSTANZE CHIMICHE
						26438-2 CITOLOGIA
						18716-1 ALLERGOLOGIA
						26439-0 PATOLOGIA CHIRURGICA</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:component/hl7:section)>=1 or count(hl7:text)=1) or (count(hl7:component/hl7:section)>=1 and count (hl7:text)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:component/hl7:section)>=1 or count(hl7:text)=1) or (count(hl7:component/hl7:section)>=1 and count (hl7:text)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERORE-38| L'elemento component/structuredBody/component/section/text DEVE essere presente nel caso in cui non è riportata la sezione foglia. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:entry/hl7:act)=0 or (count(hl7:entry/hl7:act/hl7:entryRelationship[@typeCode='SUBJ'])=1 and     count(hl7:entry/hl7:act/hl7:entryRelationship[@inversionInd='true'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:entry/hl7:act)=0 or (count(hl7:entry/hl7:act/hl7:entryRelationship[@typeCode='SUBJ'])=1 and count(hl7:entry/hl7:act/hl7:entryRelationship[@inversionInd='true'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-39| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> /entry/act/entryRelationship deve avere gli attributi @typeCode="SUBJ"e @inversionInd="true" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:entry/hl7:act/hl7:entryRelationship)=0 or     (count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:code[@code='48767-8'])=1 and     count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:entry/hl7:act/hl7:entryRelationship)=0 or (count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:code[@code='48767-8'])=1 and count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERROR-40| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> /entry/act/entryRelationship/act/code deve avere gli attributi @code="48767-8" e @codeSystem="2.16.840.1.113883.6.1" </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:entry/hl7:act/hl7:entryRelationship)=0 or     (count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:text/hl7:reference)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:entry/hl7:act/hl7:entryRelationship)=0 or (count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:text/hl7:reference)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERROR-41| L'elemento <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> /entry/act/entryRelationship/act/text deve contenere l'elemento reference </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:act/hl7:specimen" mode="M3" priority="1007">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:act/hl7:specimen" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:specimenRole/hl7:id)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:specimenRole/hl7:id)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-42| Gli elementi entry/act/specimen/specimenRole DEVONO avere un elemento 'id'. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:specimenRole/hl7:specimenPlayingEntity)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:specimenRole/hl7:specimenPlayingEntity)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-43| L'elemento component/struturedBody/component/section/entry/act/specimen deve contenere l'elemento specimenRole/specimenPlayingEntity </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:specimenRole/hl7:specimenPlayingEntity/hl7:code)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:specimenRole/hl7:specimenPlayingEntity/hl7:code)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-44| L'elemento entry/act/specimen/specimenRole/specimenPlayingEntity deve contenere l'elemento code</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:component/hl7:section" mode="M3" priority="1006">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:component/hl7:section" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:component/hl7:section)=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:component/hl7:section)=0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-45| La sezione foglia non deve includere ulteriori component</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="stCode" select="hl7:entry/hl7:act/hl7:statusCode/@code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:entry/hl7:act/hl7:statusCode)=1 and ($stCode='completed' or $stCode='active' or $stCode='aborted')" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:entry/hl7:act/hl7:statusCode)=1 and ($stCode='completed' or $stCode='active' or $stCode='aborted')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-46| L'elemento entry/act/statusCode deve contenere l'attibuto @code = 'completed' or 'active' or 'aborted' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--REPORT -->
<xsl:if test="not(count(hl7:entry/hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)">
      <svrl:successful-report test="not(count(hl7:entry/hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W003 | si consiglia di utilizzare il sistema di codifica LOINC per la valorizzazione dell'elemento code di  <xsl:text />
          <xsl:value-of select="name(.)" />
          <xsl:text /> /entry.--&gt; </svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:component/hl7:section/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation" mode="M3" priority="1005">
    <svrl:fired-rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:component/hl7:section/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation" />

		<!--REPORT -->
<xsl:if test="not(count(hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)">
      <svrl:successful-report test="not(count(hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)">
        <xsl:attribute name="location">
          <xsl:apply-templates mode="schematron-select-full-path" select="." />
        </xsl:attribute>
        <svrl:text>W004 | si consiglia di utilizzare il sistema di codifica LOINC per la valorizzazione dell'elemento code di observation.--&gt; </svrl:text>
      </svrl:successful-report>
    </xsl:if>
    <xsl:variable name="obs_int" select="hl7:interpretationCode/@codeSystem" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(hl7:interpretationCode)=0 or $obs_int='2.16.840.1.113883.5.83'" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(hl7:interpretationCode)=0 or $obs_int='2.16.840.1.113883.5.83'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> ERRORE-47| L'elemento observation/interpretationCode DEVE essere valorizzato secondo il value set HL7 Observation Interpretation (2.16.840.1.113883.5.83)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.6.1']" mode="M3" priority="1004">
    <svrl:fired-rule context="//*[@codeSystem='2.16.840.1.113883.6.1']" />
    <xsl:variable name="val_LOINC" select="encode-for-uri(@code)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.1?code=',$val_LOINC))//result='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.1?code=',$val_LOINC))//result='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-1_DIZ| Codice LOINC <xsl:text />
            <xsl:value-of select="$val_LOINC" />
            <xsl:text /> errato
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@codeSystem='2.16.840.1.113883.5.1052']" mode="M3" priority="1003">
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
          <svrl:text>Errore 4_DIZ| Codice "ActSite" '<xsl:text />
            <xsl:value-of select="$sito" />
            <xsl:text />' errato!
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[@classCode='BATTERY']" mode="M3" priority="1002">
    <svrl:fired-rule context="//*[@classCode='BATTERY']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(hl7:code)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(hl7:code)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-48| L’elemento organizer di tipo 'BATTERY' (@classCode='BATTERY') DEVE contenere l’elemento organizer/code.
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:telecom" mode="M3" priority="1001">
    <svrl:fired-rule context="//hl7:telecom" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@use)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@use)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ERRORE-49| L’elemento 'telecom' DEVE contenere l'attributo @use.
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']" mode="M3" priority="1000">
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
          <svrl:text> ERRORE-50| codice fiscale '<xsl:text />
            <xsl:value-of select="$CF" />
            <xsl:text />' cittadino ed operatore: 16 cifre [A-Z0-9]{16}</svrl:text>
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
