<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
		xmlns:cda="urn:hl7-org:v3"
        xmlns:iso="http://purl.oclc.org/dsdl/schematron"
        xmlns:sch="http://www.ascc.net/xml/schematron"
        queryBinding="xslt2">
	<title>Schematron Certificato Vaccinale v 1.1</title>
	<ns prefix="hl7" uri="urn:hl7-org:v3"/>
	<ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
	<pattern id="all">


<!--_______________________________________________________________HEADER _____________________________________________________________________-->


	<!-- ClinicalDocument -->
		<rule context="hl7:ClinicalDocument">
	        
			<!--Controllo realmCode-->	
			<assert test="count(hl7:realmCode)>=1 and count(hl7:realmCode[@code='IT'])= 1"
			>ERRORE-1| L'elemento <name/> DEVE avere almeno un elemento 'realmCode', il cui attributo @code deve essere valorizzato con 'IT'</assert>
			
			<!--Controllo templateId-->
			<assert test="count(hl7:templateId)>=1"
			>ERRORE-2| L'elemento <name/> DEVE avere almeno un elemento di tipo 'templateId'</assert>
			<assert test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.1.2'])= 1 and  count(hl7:templateId/@extension)= 1"
			>ERRORE-3| Almeno un elemento <name/>/templateId DEVE essere valorizzato attraverso l'attributo @root='“2.16.840.1.113883.2.9.10.1.11.1.2', associato all'attributo @extension che  indica la versione a cui il templateId fa riferimento</assert>
			
			<!--Controllo code-->	
			<assert test="count(hl7:code[@code='82593-5'][@codeSystem='2.16.840.1.113883.6.1']) = 1"
			>ERRORE-4| L'elemento <name/>/code DEVE essere valorizzato con l'attributo @code='82593-5"' e il @codeSystem='2.16.840.1.113883.6.1'</assert>
			<report test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='Immunization summary report'])=1 or
			count(hl7:code[@displayName='IMMUNIZATION SUMMARY REPORT'])=1 or count(hl7:code[@displayName='Immunization Summary Report'])=1)"
			>W001| Si raccomanda di valorizzare gli attributi dell'elemento <name/>/code nel seguente modo: @codeSystemName ='LOINC' e @displayName ='Immunization summary report'.--> </report>
			
			<!--Controllo confidentialityCode-->
			<assert test="(count(hl7:confidentialityCode[@code='N'][@codeSystem='2.16.840.1.113883.5.25'])= 1) or 
			(count(hl7:confidentialityCode[@code='V'][@codeSystem='2.16.840.1.113883.5.25'])= 1)"
			>ERRORE-5| L'elemento <name/>/confidentialityCode DEVE avere l'attributo @code valorizzato con 'N' o 'V', e il @codeSystem='2.16.840.1.113883.5.25'</assert>
			
			<!--Controllo languageCode-->	
			<assert test="count(hl7:languageCode)=1"
			>ERRORE-6| L'elemento <name/> DEVE contenere un elemento 'languageCode' </assert>
			
			<!--Controllo incrociato tra setId-versionNumber e relatedDocument-->
			<let name="versionNumber" value="hl7:versionNumber/@value"/>
			<assert test="(string(number($versionNumber)) = 'NaN') or
					($versionNumber= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension = hl7:setId/@extension) or
					($versionNumber!= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension != hl7:setId/@extension) or
					(hl7:id/@root != hl7:setId/@root)"
			>ERRORE-7| Se ClinicalDocument.id e ClinicalDocument.setId usano lo stesso dominio di identificazione (@root identico) allora l’attributo @extension del ClinicalDocument.id 
			deve essere diverso da quello del ClinicalDocument.setId a meno che ClinicalDocument.versionNumber non sia uguale ad 1; cioè i valori di setId ed id per un documento clinico possono coincidere solo per la prima versione di un documento</assert>
			<assert test="(string(number($versionNumber)) ='NaN') or
						  ($versionNumber=1) or 
						  (($versionNumber &gt;1) and count(hl7:relatedDocument)=1)"
			>ERRORE-8| Se l'attributo <name/>/versionNumber/@value è maggiore di 1, l'elemento <name/> DEVE contenere un elemento di tipo 'relatedDocument'</assert>
			
			
			<!--Controllo recordTarget-->
			<assert test="count(hl7:recordTarget)=1"
			>ERRORE-9| L'elemento <name/> DEVE contenere un solo elemento 'recordTarget' </assert>
			
			<!--Controllo recordTarget/patientRole/id-->	
			<!--report test="not(count(hl7:recordTarget/hl7:patientRole/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1) or 
			not(count(hl7:recordTarget/hl7:patientRole/hl7:id[@root='2.16.840.1.113883.2.9.4.3.7'])=1) or 
			not(count(hl7:recordTarget/hl7:patientRole/hl7:id[@root='2.16.840.1.113883.2.9.4.3.3'])=1) or 
			not(count(hl7:recordTarget/hl7:patientRole/hl7:id[@root='2.16.840.1.113883.2.9.4.3.18'])=1)or 
			not(count(hl7:recordTarget/hl7:patientRole/hl7:id[@root='2.16.840.1.113883.2.9.4.3.17'])=1)or
			not(count(hl7:recordTarget/hl7:patientRole/hl7:id[@root='2.16.840.1.113883.2.9.4.3.15'])=1)"
			>W002| Si si consiglia di valorizzare l'elemento recordTarget/patientRole/id  con una  delle seguenti informazioni:
			CF 2.16.840.1.113883.2.9.4.3.2
			TEAM 2.16.840.1.113883.2.9.4.3.7 o 2.16.840.1.113883.2.9.4.3.3
			ENI 2.16.840.1.113883.2.9.4.3.18
			STP 2.16.840.1.113883.2.9.4.3.17
			ANA 2.16.840.1.113883.2.9.4.3.15.> 
			</report-->
			
			<!--Controllo recordTarget/patientRole/addr-->
			<let name="num_addr" value="count(hl7:recordTarget/hl7:patientRole/hl7:addr)"/>
			
			<assert test="count(hl7:recordTarget)=0 or $num_addr=0 or (count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:country)=$num_addr and 
			count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:city)=$num_addr and 
			count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:streetAddressLine)=$num_addr)"
			>ERRORE-10| L'elemento <name/>/recordTarget/patientRole/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </assert>
			
			<!--Controllo recordTarget/patientRole/patient-->
			<let name="patient" value="hl7:recordTarget/hl7:patientRole/hl7:patient"/>
			
			<assert test="count(hl7:recordTarget)=0 or count($patient)=1"
			>ERRORE-11| L'elemento <name/>/recordTaget/patientRole DEVE contenere l'elemento 'patient'</assert>
			<assert test="count(hl7:recordTarget)=0 or (count($patient/hl7:name/hl7:given)=1 and count($patient/hl7:name/hl7:family)=1)"
			>ERRORE-12| L'elemento <name/>/recordTaget/patientRole/patient/name DEVE riportare gli elementi 'given' e 'family'</assert>
			
			<!--Controllo recordTarget/patientRole/patient/administrativeGenderCode-->
			<let name="genderOID" value="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@codeSystem"/>
			
			<assert test="count(hl7:recordTarget)=0 or count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode)=1"
			>ERRORE-13| L'attributo <name/>/recordTarget/patientRole/patient DEVE contenere l'elemento administrativeGenderCode </assert>
			<assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode)=0 or $genderOID='2.16.840.1.113883.5.1'"
			>ERRORE-14| L'OID assegnato all'attributo <name/>/recordTarget/patientRole/patient/administrativeGenderCode/@codeSystem='<value-of select="$genderOID"/>' non è corretto. L'attributo DEVE essere valorizzato con '2.16.840.1.113883.5.1' </assert>
			
			<!--Controllo recordTarget/patientRole/patient/birthTime-->
			<assert test="count(hl7:recordTarget)=0 or count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime)=1"
			>ERRORE-15| L'elemento <name/>/recordTarget/patientRole/patient DEVE contenere l'elemento birthTime </assert>	
			
			<!--Controllo recordTarget/patientRole/patient/birthplace/place/addr-->
			<assert test="count(hl7:recordTarget)=0 or count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthplace)=0 or 
			count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthplace/hl7:place/hl7:addr)=1"
			>ERRORE-16| L'elemento <name/>/recordTarget/patientRole/patient/birthplace DEVE contenere un elemento place/addr </assert>	
			
			<!--Controllo author/assignedAuthor/id-->
			<assert test="count(hl7:author/hl7:assignedAuthor/hl7:id/@nullFlavor)=1 or 
			count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1"
			>ERRORE-17| L'elemento <name/>/author/assignedAuthor DEVE contenere almeno un elemento 'id' con il relativo attributo @root='2.16.840.1.113883.2.9.4.3.2'</assert>
						
			<!--Controllo author/assignedAuthor/addr-->
			<let name="num_addr_author" value="count(hl7:author/hl7:assignedAuthor/hl7:addr)"/>
			
			<assert test="$num_addr_author=0 or (count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:country)=$num_addr_author and 
			count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:city)=$num_addr_author and
			count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:streetAddressLine)=$num_addr_author)"
			>ERRORE-18| L'elemento <name/>/author/assignedAuthor/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine' </assert>
						
			<!--Controllo author/assignedAuthor/assignedPerson/name-->
			<let name="name_author" value="hl7:author/hl7:assignedAuthor/hl7:assignedPerson/hl7:name"/>
		
			<assert test="count(hl7:author/hl7:assignedAuthor/hl7:id/@nullFlavor)=1 or 
			(count($name_author/hl7:given)>=1 and count($name_author/hl7:family)>=1)"
			>ERRORE-19| L'elemento <name/>/author/assignedAuthor/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</assert>
		
			<let name="num_addr_auth" value="count(hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:addr)"/>
			<let name="addr_auth" value="hl7:author/hl7:assignedAuthor/hl7:representedOrganization/hl7:addr"/>
			<assert test="$num_addr_auth=0 or (count($addr_auth/hl7:country)=$num_addr_auth and
			count($addr_auth/hl7:city)=$num_addr_auth and 
			count($addr_auth/hl7:streetAddressLine)=$num_addr_auth)"
			>ERRORE-20| L'elemento <name/>/author/assignedAuthor/representedOrganization/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</assert>
			
			<!--Controllo custodian/assignedCustodian/representedCustodianOrganization-->
			<assert test="count(hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:name)=1"
			>ERRORE-21| L'elemento <name/>/custodian/assignedCustodian/representedCustodianOrganization deve contenere un elemento 'name'</assert>
			
			<let name="num_addr_cust" value="count(hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr)"/>
			<let name="addr_cust" value="hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr"/>
			<assert test="$num_addr_cust=0 or (count($addr_cust/hl7:country)=$num_addr_cust and
			count($addr_cust/hl7:city)=$num_addr_cust and 
			count($addr_cust/hl7:streetAddressLine)=$num_addr_cust)"
			>ERRORE-22| L'elemento <name/>/custodian/assignedCustodian/representedCustodianOrganization/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</assert>
			
			<!--Controllo legalAuthenticator-->
			<assert test = "(count(hl7:legalAuthenticator)&lt;=1)" 
			>ERRORE-23| L'elemento <name/>/legalAuthenticator può essere presente una volta sola.</assert>
			<assert test = "count(hl7:legalAuthenticator)=0 or count(hl7:legalAuthenticator/hl7:signatureCode[@code='S'])=1" 
			>ERRORE-24| L'elemento <name/>/legalAuthenticator/signatureCode deve essere valorizzato con il codice "S" </assert>
			<assert test = "count(hl7:legalAuthenticator)=0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])=1"
			>ERRORE-25| L'elemento <name/>/legalAuthenticator/assignedEntity DEVE contenere almeno un elemento id valorizzato con l'attributo @root='2.16.840.1.113883.2.9.4.3.2'</assert>
			<let name="num_addr_legauth" value="count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:addr)"/>
			<let name="addr_legauth" value="hl7:legalAuthenticator/hl7:assignedEntity/hl7:addr"/>
			<assert test=" $num_addr_legauth=0 or (count($addr_legauth/hl7:country)=$num_addr_legauth and
			count($addr_legauth/hl7:city)=$num_addr_legauth and 
			count($addr_legauth/hl7:streetAddressLine)=$num_addr_legauth)"
			>ERRORE-26| L'elemento <name/>/legalAuthenticator/assignedEntity/addr DEVE riportare i sotto-elementi 'country','city' e 'streetAddressLine'</assert>	
			<assert test = " count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson)=0 or 
			(count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and 
			count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)"
			>ERRORE-27| L'elemento <name/>/legalAuthenticator/assignedEntity/assignedPerson/name DEVE riportare gli elementi 'given' e 'family'</assert>
			
			<!--Controllo Participant-->
			<assert test="count(hl7:participant)=0 or count(hl7:participant/hl7:associatedEntity/hl7:id)>=1"
			>ERRORE-28| L'elemento <name/>/participant/associatedEntity deve contenere l'elemento 'id'.</assert>
			<assert test = "count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson)=0 or 
			count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:family)=1 and 
			count(hl7:participant/hl7:associatedEntity/hl7:associatedPerson/hl7:name/hl7:given)=1"
			>ERRORE-29| L'elemento <name/>/participant/associatedEntity/associatedPerson/name DEVE riportare gli elementi 'given' e 'family'</assert>
			
		</rule>
	
	
<!--_______________________________________________________CONTROLLI SUI DIZIONARI_____________________________________________________________-->

		<!--Verifica che i codici LOINC utilizzati siano corretti-->
		<rule context="//*[@codeSystem='2.16.840.1.113883.6.1']">
			<let name="val_LOINC" value="encode-for-uri(@code)"/>
			<assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.1?code=',$val_LOINC))//result='true' or
			$val_LOINC='LA16666-2' or $val_LOINC='LA18632-2' or $val_LOINC='LA28752-6' or $val_LOINC='LA18821-1' or
			$val_LOINC='LA4270-0' or $val_LOINC='LA21285-4' or $val_LOINC='LA21286-5' or $val_LOINC='LA6743-4'"
			>Errore 1_DIZ| Codice LOINC '<value-of select="$val_LOINC"/>' errato!
			</assert>
		</rule>
		 
		<!--Verifica che i codici AIC utilizzati siano corretti-->
		<rule context="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.5']">
			<let name="val_AIC" value="encode-for-uri(@code)"/>
			<assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.6.1.5?code=',$val_AIC))//result='true'"
			>Errore 2_DIZ| Codice AIC '<value-of select="$val_AIC"/>' errato!
			</assert>
		</rule>
	
		<!--Verifica che i codici ATC utilizzati siano corretti-->
		<rule context="//*[@codeSystem='2.16.840.1.113883.6.73']">
			<let name="val_ATC" value="encode-for-uri(@code)"/>
			<assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.73?code=',$val_ATC))//result='true'"
			>Errore 3_DIZ| Codice ATC '<value-of select="$val_ATC"/>' errato!
			</assert>
		</rule>
		
		<!--Verifica che i codici GE utilizzati siano corretti-->
		<rule context="//*[@codeSystem='2.16.840.1.113883.2.9.6.1.51']">
			<let name="val_GE" value="encode-for-uri(@code)"/>
			<assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.2.9.6.1.51?code=',$val_GE))//result='true'"
			>Errore 4_DIZ| Codice GE '<value-of select="$val_GE"/>' errato!
			</assert>
		</rule>
		 
		<!--Verifica che i codici relativi al value set "ActSite" utilizzati siano corretti-->
		<rule context="//*[@codeSystem='2.16.840.1.113883.5.1052']">
			<let name="sito" value="encode-for-uri(@code)"/>
			<assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1052?code=',$sito))//result='true'"
			>Errore 6_DIZ| Codice "ActSite"  '<value-of select="$sito"/>' errato!
			</assert>
		</rule>
		
		<!--Verifica che i codici relativi al value set "RouteOfAdministration" utilizzati siano corretti-->
		<rule context="//*[@codeSystem='2.16.840.1.113883.5.112']">
			<let name="via_somminist" value="encode-for-uri(@code)"/>
			<assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.112?code=',$via_somminist))//result='true'"
			>Errore 7_DIZ| Codice "RouteOfAdministration"  '<value-of select="$via_somminist"/>' errato!
			</assert>
		</rule>
	
	
	<!--__________________________________________________________CONTROLLI GENERICI________________________________________________________________-->


		<!--Controllo use Telecom-->
		<rule context="//hl7:telecom">
			<assert test="(count(@use)=1)"
			>ERRORE-30| L’elemento 'telecom' DEVE contenere l'attributo @use </assert>
		</rule>	
		
		<!-- Controllo formato: -->
		<!--campi Codice Fiscale: 16 cifre [A-Z0-9]{16} -->
		<rule context="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']">
			<let name="CF" value="@extension"/>
			<assert test="matches(@extension, '[A-Z0-9]{16}')"
			>ERRORE-31| Il codice fiscale '<value-of select="$CF"/>' cittadino ed operatore deve essere costituito da 16 cifre [A-Z0-9]{16}</assert>
		</rule>
	
		<!--Controllo sugli attributi di observation-->
		<rule context="//hl7:observation">
			<let name="moodCd" value="@moodCode"/>
			<assert test="count(@classCode)=1"
			>ERRORE-32| L'attributo "@classCode" dell'elemento "observation" deve essere presente </assert>
			<assert test="$moodCd='EVN'"
			>ERRORE-33| L'attributo "@moodCode" dell'elemento "observation" deve essere valorizzato con "EVN" </assert>
		</rule>
		
<!--___________________________________________________________________BODY__________________________________________________________________________-->
	
	
	
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody">
		
			<!--Vaccinazioni-->
			<assert test="count(hl7:component/hl7:section[@classCode='DOCSECT'][@moodCode='EVN'])=1"
			>ERRORE-34| L'elemento component/section deve avere gli attributi @classCode='DOCSECT </assert>
			<assert test="count(hl7:component/hl7:section/hl7:templateId)=0 or 
			count(hl7:component/hl7:section/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.3.2'])=1"
			>ERRORE-35| L'elemento section può contenere un elemento 'templateId' valorizzato con l'attributo @root='2.16.840.1.113883.2.9.10.1.11.3.2'</assert>
			<assert test="count(hl7:component/hl7:section/hl7:code)=0 or 
			count(hl7:component/hl7:section/hl7:code[@code='11369-6'][@codeSystem='2.16.840.1.113883.6.1'])=1"
			>ERRORE-36| L'elemento section può contenere un elemento 'code' valorizzato con gli attributi @code='11369-6' e @codeSystem='2.16.840.1.113883.6.1'</assert>
			<assert test="count(hl7:component/hl7:section/hl7:title)=1"
			>ERRORE-37| L'elemento section DEVE contenere un elemento 'title' possibilmente valorizzato con 'Certificato Vaccinale'</assert>
			<assert test="count(hl7:component/hl7:section/hl7:text)=1"
			>ERRORE-38| L'elemento section DEVE contenere un elemento 'text'</assert>
			<assert test="count(hl7:component/hl7:section/hl7:entry)&gt;=1"
			>ERRORE-39| L'elemento section DEVE contenere almeno un elemento 'entry'</assert>
			
		</rule>
		
		
		<!--controllo sulle entry-->
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry">
			
			<assert test="count(hl7:substanceAdministration[@moodCode='EVN'][@classCode='SBADM'])=1"
			>ERRORE-40| L'elemento entry/substanceAdministration DEVE avere attributi @moodCode='EVN' e @classCode='SBADM'</assert>
			<assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1' or @root='2.16.840.1.113883.2.9.10.1.11.4.2'])=1"
			>ERRORE-41| L'elemento entry/substanceAdministration DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.1'</assert>
			<assert test="count(hl7:substanceAdministration/hl7:effectiveTime)=1"
			>ERRORE-42| L'elemento entry/substanceAdministration DEVE contenere un elemento 'effectiveTime'.</assert>
			<assert test="count(hl7:substanceAdministration/hl7:consumable[@typeCode='CSM'])=1"
			>ERRORE-43| L'elemento entry/substanceAdministration DEVE contenere un elemento 'consumable' valorizzato con @typeCode='CSM'</assert>
			<assert test="count(hl7:substanceAdministration/hl7:participant)=0 or 
			count(hl7:substanceAdministration/hl7:participant[@typeCode='LOC'])>=1"
			>ERRORE-44| L'elemento entry/substanceAdministration può contenere un elemento 'participant' valorizzato con l'attributo @typeCode='LOC'</assert>
			<assert test="count(hl7:substanceAdministration/hl7:participant)=0 or 
			count(hl7:substanceAdministration/hl7:participant/hl7:participantRole[@classCode='ROL'])>=1"
			>ERRORE-45| L'elemento entry/substanceAdministration/participant DEVE contenere l'elemento 'participantRole' valorizzato con l'attributo @classCode='ROL' </assert>
			
			<!-- entry - Dati Vaccino-->
			<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']])=0 or 
			count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:statusCode[@code='completed'])=1"
			>ERRORE-46| L'elemento entry/substanceAdministration (in Dati vaccinazione) DEVE contenere un elemento 'statusCode' valorizzato con attributo @code='completed' </assert>
			<let name="farma_dv" value="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial"/>
			<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']])=0 or 
			count($farma_dv/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1"
			>ERRORE-47| L'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial (in Dati vaccinazione) DEVE contenere un elemento 'code' valorizzato secondo AIC - @codeSystem='2.16.840.1.113883.2.9.6.1.5'.</assert>
			<assert test="count($farma_dv/hl7:code/hl7:translation)=0 or
			(count($farma_dv/hl7:code/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1)"
			>ERRORE-48| L'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code (in Dati vaccinazione) può contenere un elemento 'translation' valorizzato secondo ATC - @codeSystem='2.16.840.1.113883.6.73'.</assert>

				<!-- entryRelationship - Numero di dose-->
				<assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or 
				count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.3'])=1"
				>ERRORE-49| L'elemento entry/substanceAdministration/entryRelationship/observation (Numero di dose) DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.3' </assert>
				<assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or
				count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:code[@code='30973-2'][@codeSystem='2.16.840.1.113883.6.1'])=1"
				>ERRORE-50| L'elemento entry/substanceAdministration/entryRelationship/observation (Numero di dose) DEVE contenere un elemento 'code' valorizzato con gli attributi @code='30973-2' e @codeSystem='2.16.840.1.113883.6.1'</assert>			
				<assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or 
				count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:statusCode[@code='completed'])=1"
				>ERRORE-51| L'elemento entry/substanceAdministration/entryRelationship/observation (Numero di dose) DEVE contenere un elemento 'statusCode' valorizzato con l'attributo @code='completed'</assert>			
				<assert test="count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ'][@inversionInd='true'])=0 or 
				count(hl7:substanceAdministration/hl7:entryRelationship[@typeCode='SUBJ']/hl7:observation/hl7:value[@xsi:type='INT'])=1"
				>ERRORE-52| L'elemento entry/substanceAdministration/entryRelationship/observation (Numero di dose) DEVE contenere un elemento value valorizzato con l'attributo @xsi:type='INT'</assert>
				
				<!--entryRelationship relativa al periodo di copertura/ data prossimo vaccino-->
				<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='REFR'])&lt;=2"
				>ERRORE-53| L'elemento entry/substanceAdministration/entryRelationship relativo al "Periodo di Copertura /prossimo appuntamento" può essere presente al più due volte.</assert>			
				
				
				<!--Vaccinazioni: entryRelationship - categorie di rischio-->
				<let name="risk" value="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.5']]"/>
				
				<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']])=0 or
				count($risk)&lt;=1"
				>ERRORE-54| L'elemento entry/substanceAdministration/entryRelationship/observation (Categorie a rischio) può essere presente al più una sola volta.</assert> 	
				<assert test="count($risk)=0 or 
				count($risk/hl7:code[@code='95715-9'][@codeSystem='2.16.840.1.113883.6.1'])=1"
				>ERRORE-55| L'elemento entry/substanceAdministration/entryRelationship/observation (Categorie a rischio)  DEVE contenere un elemento 'code' valorizzato con gli attributi @code='95715-9' e @codeSystem='2.16.840.1.113883.6.1'.</assert>			
				<assert test="count($risk)=0 or 
				count($risk/hl7:statusCode[@code='completed'])=1"
				>ERRORE-56| L'elemento entry/substanceAdministration/entryRelationship/observation (Categorie a rischio)  DEVE contenere un elemento 'statusCode' valorizzato con @code='completed'</assert>			
				<assert test="count($risk)=0 or 
				count($risk/hl7:value[@xsi:type='CD'])=1"
				>ERRORE-57| L'elemento entry/substanceAdministration/entryRelationship/observation (Categorie a rischio)  DEVE contenere un elemento 'value valorizzato con l'attributo @xsi:type='CD'</assert>
				
				
				
				<!--Vaccinazioni: entryRelationship - condizioni sanitarie a rischio-->
				<let name="condition" value="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='RSON'][@inversionInd='false']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.6']]"/>
				<assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or 
				count($condition)&lt;=1"
				>ERRORE-58| L'elemento entry/substanceAdministration/entryRelationship/observation (Condizioni sanitarie a rischio)  può essere presente al più una sola volta.</assert> 	
				<assert test="count($condition)=0 or 
				count($condition/hl7:code[@code='59785-6'][@codeSystem='2.16.840.1.113883.6.1'])=1"
				>ERRORE-59| L'elemento entry/substanceAdministration/entryRelationship/observation (Condizioni sanitarie a rischio)  DEVE contenere un elemento 'code' valorizzato con gli attributi @code='59785-6' e @codeSystem='2.16.840.1.113883.6.1'</assert>			
				<assert test="count($condition)=0 or 
				count($condition/hl7:statusCode[@code='completed'])=1"
				>ERRORE-60| L'elemento entry/substanceAdministration/entryRelationship/observation (Condizioni sanitarie a rischio)  DEVE contenere un elemento 'statusCode' valorizzato con @code='completed'.</assert>			
				<assert test="count($condition)=0 or 
				count($condition/hl7:value[@xsi:type='CD'][@codeSystem='2.16.840.1.113883.6.103'])=1"
				>ERRORE-61| L'elemento entry/substanceAdministration/entryRelationship/observation (Condizioni sanitarie a rischio)  DEVE contenere un elemento 'value' valorizzato con l'attributo @xsi:type='CD' e @codeSystem='2.16.840.1.113883.6.103' (ICD-9-CM)</assert>
				
					<!--Vaccinazioni: entryRelationship - reazioni Avverse-->
				<let name="reaction" value="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='CAUS']"/>
				<assert test="count(hl7:substanceAdministration/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1'])=0 or 
				count($reaction)&lt;=1"
				>ERRORE-62| L'elemento entry/substanceAdministration/entryRelationship/observation (Reazioni avverse) può essere presente al più una sola volta.</assert>
				<assert test="count($reaction)=0 or 
				count($reaction/hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.8'])=1"
				>ERRORE-63| L'elemento entry/substanceAdministration/entryRelationship/observation (Reazioni avverse) DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.8'</assert>			
				<assert test="count($reaction)=0 or 
				count($reaction/hl7:observation/hl7:code[@code='31044-1'][@codeSystem='2.16.840.1.113883.6.1'])=1"
				>ERRORE-64| L'elemento entry/substanceAdministration/entryRelationship/observation (Reazioni avverse) DEVE contenere un elemento 'code' valorizzato con gli attributi @code='31044-1' e @codeSystem='2.16.840.1.113883.6.1'</assert>			
				<assert test="count($reaction)=0 or 
				count($reaction/hl7:observation/hl7:statusCode[@code='completed'])=1"
				>ERRORE-65| L'elemento entry/substanceAdministration/entryRelationship/observation (Reazioni avverse) DEVE contenere un elemento 'statusCode' valorizzato con @code='completed'</assert>						
				<assert test="count($reaction/hl7:observation/hl7:value)=0 or
				count($reaction/hl7:observation/hl7:value[@xsi:type='CD'][@codeSystem='2.16.840.1.113883.6.103'])=1"
				>ERRORE-66| L'elemento entry/substanceAdministration/entryRelationship/observation (Reazioni avverse) DEVE contenere un elemento 'value' valorizzato con l'attributo @xsi:type='CD' e @codeSystem='2.16.840.1.113883.6.103' (ICD-9-CM)</assert>


		
			<!--entry - Dati esonero/omissione o differimento-->
			<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']])=0 or 
			count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:statusCode[@code='cancelled'])=1"
			>ERRORE-67| L'elemento entry/substanceAdministration (in Dati Esonero/omissione o differimento) DEVE contenere un elemento 'statusCode' valorizzato con @code='cancelled' </assert>
			<let name="farma_de" value="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:consumable/hl7:manufacturedProduct/hl7:manufacturedMaterial"/>
			<assert test="count($farma_de/hl7:code)=0 or
			count($farma_de/hl7:code[@codeSystem='2.16.840.1.113883.2.9.6.1.5'])=1"
			>ERRORE-68| L'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterialin (in Dati Esonero/omissione o differimento) può contenere un elemento 'code' valorizzato secondo AIC - @codeSystem='2.16.840.1.113883.2.9.6.1.5'.</assert>
			<assert test="count($farma_de/hl7:code/hl7:translation)=0 or
			(count($farma_de/hl7:code/hl7:translation[@codeSystem='2.16.840.1.113883.6.73'])=1)"
			>ERRORE-69| L'elemento entry/substanceAdministration/consumable/manufacturedProduct/manufacturedMaterial/code (in Dati Esonero/omissione o differimento) può contenere un elemento 'translation' valorizzato secondo ATC - @codeSystem='2.16.840.1.113883.6.73'.</assert>
		
		
			<!--Vaccinazioni: entryRelationship - Ragione esonero/omissione o differimento-->
			<let name="reason" value="hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON']/hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10']]"/>
			
			<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']])=0 or 
			count($reason)=1"
			>ERRORE-70| L'elemento entry/substanceAdministration/entryRelationship relativo alla "Ragione esonero/omissione o differimento" DEVE essere presente. </assert>						
			<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']])=0 or
			count($reason/hl7:code[@code='85714-4'][@codeSystem='2.16.840.1.113883.6.1'])=1"
			>ERRORE-71| L'elemento entry/substanceAdministration/entryRelationship/observation (Ragione esonero/omissione o differimento) DEVE contenere  un elemento 'code' valorizzato con gli attributi @code='85714-4' e @codeSystem='2.16.840.1.113883.6.1'</assert>					
			<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']])=0 or
			count($reason/hl7:statusCode[@code='completed'])=1"
			>ERRORE-72| L'elemento entry/substanceAdministration/entryRelationship/observation (Ragione esonero/omissione o differimento) DEVE contenere  un elemento 'statusCode' valorizzato con l'attributo @code='completed'.</assert>			
			<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']])=0 or
			count($reason/hl7:effectiveTime/hl7:low)=1"
			>ERRORE-73| L'elemento entry/substanceAdministration/entryRelationship/observation (Ragione esonero/omissione o differimento) DEVE contenere  un elemento 'effectiveTime' col sottoelemento 'low' valorizzato.</assert>				
			<assert test="count(hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']])=0 or
			count($reason/hl7:effectiveTime/hl7:high)=1"
			>ERRORE-74| L'elemento entry/substanceAdministration/entryRelationship/observation (Ragione esonero/omissione o differimento) DEVE contenere  un elemento 'effectiveTime' col sottoelemento 'high' valorizzato.</assert>
		
		</rule>
		
		
		<!--entryRelationship - periodo di copertura/prossimo appuntamento-->
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.1']]/hl7:entryRelationship[@typeCode='REFR']">
			
			<assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.4'])=1"
			>ERRORE-75| L'elemento entry/substanceAdministration/entryRelationship/observation (Periodo di copertura/prossimo appuntament) DEVE contenere un elemento 'templateId' valorizzato con @root='2.16.840.1.113883.2.9.10.1.11.4.4'.</assert>
			<assert test="(count(hl7:observation/hl7:code[@code='59778-1'][@codeSystem='2.16.840.1.113883.6.1'])=1 or
			count(hl7:observation/hl7:code[@code='59778-1'][@codeSystem='2.16.840.1.113883.4.642.3.308'])=1) or
			(count(hl7:observation/hl7:code[@code='30980-7'][@codeSystem='2.16.840.1.113883.6.1'])=1 or
			count(hl7:observation/hl7:code[@code='30980-7'][@codeSystem='2.16.840.1.113883.4.642.3.308'])=1)"
			>ERRORE-76| L'elemento entry/substanceAdministration/entryRelationship/observation (Periodo di copertura/prossimo appuntament) DEVE contenere un elemento 'code' valorizzato con 
			- 59778-1 per Periodo di copertura:
			- 30980-7 per prossimo appuntamento.</assert>	
			<assert test="count(hl7:observation/hl7:statusCode[@code='completed'])=1"
			>ERRORE-77| L'elemento entry/substanceAdministration/entryRelationship/observation (Periodo di copertura/prossimo appuntament) DEVE contenere un elemento 'statusCode' valorizzato con @code='completed'.</assert>	
			<assert test="count(hl7:observation/hl7:value[@xsi:type='IVL_TS' or @xsi:type='TS'])=1"
			>ERRORE-78| L'elemento entry/substanceAdministration/entryRelationship/observation (Periodo di copertura/prossimo appuntament) DEVE contenere un elemento 'value' valorizzato con l'attributo @xsi:type='IVL_TS'</assert>
			
		
		</rule>
				
		<!--Vaccinazioni: entry/substanceAdministration/entryRelationship - dati vaccinazione- malattia per cui si effettua la vaccinazione-->
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship[@typeCode='RSON'][hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9']]">
		
			<assert test="count(hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9']]/hl7:code[@code='75323-6'][@codeSystem='2.16.840.1.113883.6.1'])=1"
			>ERRORE-79| L'elemento entry/substanceAdministration/entryRelationship/observation (Malattia per cui si effettua la vaccinazione) DEVE contenere un elemento 'code' valorizzato con gli attributi @code='75323-6' e @codeSystem='2.16.840.1.113883.6.1'</assert>
			<assert test="count(hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9']]/hl7:statusCode[@code='completed'])=1"
			>ERRORE-80| L'elemento entry/substanceAdministration/entryRelationship/observation (malattia per cui si effettua la vaccinazione) DEVE contenere un elemento 'statusCode' valorizzato con @code='completed'</assert>
			<assert test="count(hl7:observation[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9']]/hl7:value[@xsi:type='CD'][@codeSystem='2.16.840.1.113883.6.103'])=1"
			>ERRORE-81| L'elemento entry/substanceAdministration/entryRelationship/observation (malattia per cui si effettua la vaccinazione) DEVE contenere un elemento 'value' valorizzato con l'attributo @xsi:type='CD' e @codeSystem='2.16.840.1.113883.6.103' (ICD-9-CM)</assert>
		
		</rule>
			
			
		<!--Vaccinazioni: entry/substanceAdministration/entryRelationship - Esonero/omissione o differimento - Malattia con presunta immunità-->			
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration[hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.2']]/hl7:entryRelationship[@typeCode='RSON'][hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.7']]">
		
			<assert test="count(hl7:observation/hl7:code[@code='59784-9'][@codeSystem='2.16.840.1.113883.6.1'])=1"
			>ERRORE-82| L'elemento entry/substanceAdministration/entryRelationship/observation (malattia con presunta immunità) DEVE contenere un elemento 'code' valorizzato con gli attributi @code='59784-9' e @codeSystem='2.16.840.1.113883.6.1'</assert>
			<assert test="count(hl7:observation/hl7:statusCode[@code='completed'])=1"
			>ERRORE-83| L'elemento entry/substanceAdministration/entryRelationship/observation (malattia con presunta immunità) DEVE contenere un elemento 'statusCode' valorizzato con l'attributo @code='completed' </assert>
			<assert test="count(hl7:observation/hl7:value)=0 or count(hl7:observation/hl7:value[@codeSystem='2.16.840.1.113883.6.103'])=1"
			>ERRORE-84| L'elemento entry/substanceAdministration/entryRelationship/observation (malattia con presunta immunità) DEVE contenere un elemento 'value' che deve essere valorizzato secondo il sistema di codifica ICD-9-CM (@codeSystem='2.16.840.1.113883.6.103')</assert>
		
		</rule>
	
		<!--controli template ER @typeCode='RSON'-->
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:substanceAdministration/hl7:entryRelationship[@typeCode='RSON']">
			
			<assert test="count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.5'])=1 or
			count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.6'])=1 or
			count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.7'])>=1 or
			count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.9'])>=1 or
			count(hl7:observation/hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.11.4.10'])=1"
			>ERRORE 85| Ciascuno di questi templateId è contenuto in una entryRelationship con l'attributo @typeCode='RSON'.
			- @root='2.16.840.1.113883.2.9.10.1.11.4.5' (Categorie a rischio)
			- @root='2.16.840.1.113883.2.9.10.1.11.4.6' (Condizioni sanitarie)
			- @root='2.16.840.1.113883.2.9.10.1.11.4.7' (Malattia con presunta immunità)
			- @root='2.16.840.1.113883.2.9.10.1.11.4.9' (Malattia per cui si effettua la vaccinazione)
			- @root='2.16.840.1.113883.2.9.10.1.11.4.10' (Ragione dell'esonero)</assert>
		
		</rule>
			
			
		
	</pattern>
</schema>