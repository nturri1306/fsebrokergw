<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
		xmlns:cda="urn:hl7-org:v3"
        xmlns:iso="http://purl.oclc.org/dsdl/schematron"
        xmlns:sch="http://www.ascc.net/xml/schematron"
        queryBinding="xslt2">
	<title>Schematron Laboratorio Analisi 1.3</title>
	<ns prefix="hl7" uri="urn:hl7-org:v3"/>
	<ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
	<pattern id="all">

		<!-- ClinicalDocument -->
		<rule context="hl7:ClinicalDocument">

			<!--Controllo su realmCode-->	
			<assert test="count(hl7:realmCode) >= 1 and count(hl7:languageCode)=1"
			>ERRORE-1| L'elemento <name/> DEVE avere un almeno elemento 'realmCode' e un elemento 'languageCode'.</assert>
			<assert test="count(hl7:realmCode[@code='IT'])= 1"
			>ERRORE-2| Almeno un elemento 'realmCode' DEVE avere l'attributo @root valorizzato come 'IT'</assert>

			<!-- Controllo su templateId-->
			<assert test="count(hl7:templateId)>=1"
			>ERRORE-3| L'elemento <name/> DEVE avere almeno un elemento di tipo 'templateId'</assert>
			<assert test="count(hl7:templateId[@root='2.16.840.1.113883.2.9.10.1.1'])= 1 and  count(hl7:templateId/@extension)= 1"
			>ERRORE-4| Almeno un elemento 'templateId' DEVE essere valorizzato attraverso l'attributo  @root='2.16.840.1.113883.2.9.10.1.1' (id del template nazionale)  associato all'attributo @extension che  indica la versione a cui il templateId fa riferimento</assert>
							
			<!-- Controllo su code-->	
			<assert test="count(hl7:code[@code='11502-2'][@codeSystem='2.16.840.1.113883.6.1']) = 1"
			>ERRORE-5| L'elemento <name/>/code deve essere valorizzato con l'attributo @code='11502-2' e il @codeSystem='2.16.840.1.113883.6.1'</assert>
						
			<report test="not(count(hl7:code[@codeSystemName='LOINC'])=1) or not(count(hl7:code[@displayName='REFERTO DI LABORATORIO'])=1 or
			count(hl7:code[@displayName='Referto di Laboratorio'])=1 or count(hl7:code[@displayName='Referto di laboratorio'])=1)"
			>W001| Si raccomanda di valorizzare gli attributi dell'elemento <name/>/code nel seguente modo: @codeSystemName ='LOINC' e @displayName ='Referto di laboratorio'.--> </report>
			
			<!-- Controllo su confidentialityCode-->
			<assert test="(count(hl7:confidentialityCode[@code='N'][@codeSystem='2.16.840.1.113883.5.25'])= 1) or 
			(count(hl7:confidentialityCode[@code='V'][@codeSystem='2.16.840.1.113883.5.25'])= 1)"
			>ERRORE-6| L'elemento  'confidentialityCode' di <name/> DEVE avere l'attributo @code  valorizzato con 'N' o 'V', e il suo @codeSystem  con '2.16.840.1.113883.5.25'</assert>

			<!-- Controllo incrociato tra setId-versionNumber-relatedDocument-->
			<let name="versionNumber" value="hl7:versionNumber/@value"/>
			<assert test="(string(number($versionNumber)) = 'NaN') or
					($versionNumber= 1 and hl7:id/@root = hl7:setId/@root and hl7:id/@extension = hl7:setId/@extension) or
					($versionNumber!= '1' and hl7:id/@root = hl7:setId/@root and hl7:id/@extension != hl7:setId/@extension) or
					(hl7:id/@root != hl7:setId/@root)"
					>ERRORE 7: Se ClinicalDocument.id e ClinicalDocument.setId usano lo stesso dominio di identificazione (@root identico) allora l’attributo @extension del
					ClinicalDocument.id deve essere diverso da quello del ClinicalDocument.setId a meno che ClinicalDocument.versionNumber non sia uguale ad 1; cioè i valori del setId ed id per un documento clinico possono coincidere solo per la prima versione di un documento.</assert>
			
			<assert test="(string(number($versionNumber)) ='NaN') or
						  ($versionNumber=1) or 
						  (($versionNumber &gt;1) and count(hl7:relatedDocument)=1)"
			>ERRORE-8| Se l'attributo <name/>/versionNumber/@value maggiore di  1 l'elemento <name/>  deve contenere un elemento di tipo 'relatedDocument'.</assert>
 
			<!--controllo addr-->
			<let name="num_addr" value="count(hl7:recordTarget/hl7:patientRole/hl7:addr)"/>
			<assert test="$num_addr=0 or (count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:country)>=$num_addr and count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:city)=$num_addr and count(hl7:recordTarget/hl7:patientRole/hl7:addr/hl7:streetAddressLine)=$num_addr)"
			> ERRORE-9| L'elemento <name/>/recordTarget/patientRole/addr DEVE riportare i suoi sotto-elementi 'country', 'city' e 'streetAddressLine'.   </assert>

			<!-- Controllo recordTarget/patientRole/patient/name -->
			<let name="patient" value="hl7:recordTarget/hl7:patientRole/hl7:patient"/>
			<assert test="count($patient)=0 or count($patient/hl7:name)=1"
			>ERRORE-10| L'elemento <name/>/recordTaget/patientRole/patient DEVE contenere l'elemento 'name'</assert>
			<assert test="count($patient)=0 or (count($patient/hl7:name/hl7:given)=1 and count($patient/hl7:name/hl7:family)=1)"
			>ERRORE 11| L'elemento ClinicalDocument/recordTaget/patientRole/patient/name DEVE riportare gli elementi 'given' e 'family'</assert>

			<!-- Controllo recordTarget/patientRole/patient/administrativeGenderCode -->
			<let name="genderCode" value="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@code"/>
			<let name="genderOID" value="hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:administrativeGenderCode/@codeSystem"/>
			<assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or ($genderCode='M' or $genderCode='F' or $genderCode='UN')"
			>ERRORE-12| L'attributo <name/>/recordTarget/patientRole/patient/administrativeGenderCode/@code='<value-of select="$genderCode"/>' non è valorizzato correttamente. Deve assumere uno dei seguenti valori:'M', 'F', 'UN', e l'attributo @codeSystem con '2.16.840.1.113883.5.1' </assert>
			<assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or $genderOID='2.16.840.1.113883.5.1'"
			>ERRORE-13| L'OID assegnato all'attributo <name/>/recordTarget/patientRole/patient/administrativeGenderCode/@codeSystem='<value-of select="$genderOID"/>' non è corretto. L'attributo DEVE essere valorizzato con '2.16.840.1.113883.5.1' </assert>

			<!-- Controllo recordTarget/patientRole/patient/birthTime -->
			<assert test="count(hl7:recordTarget/hl7:patientRole/hl7:patient)=0 or count(hl7:recordTarget/hl7:patientRole/hl7:patient/hl7:birthTime)=1"
			>ERRORE-14| L'elemento ClinicalDocument/recordTaget/patientRole/patient DEVE riportare un elemento 'birthTime'.</assert>

			<!-- Controllo author/assignedAuthor/id/@root -->
			<assert test="count(hl7:author/hl7:assignedAuthor/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])= 1"
			>ERRORE-15| L'elemento <name/>/author/assignedAuthor DEVE contenere almeno un elemento 'id' con il relativo attributo @root valorizzato con '2.16.840.1.113883.2.9.4.3.2'</assert>
			
			<!-- Controllo author/assignedAuthor/addr -->
			<let name="num_addr_author" value="count(hl7:author/hl7:assignedAuthor/hl7:addr)"/>
			<assert test="$num_addr_author=0 or (count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:country)=$num_addr_author and count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:city)=$num_addr_author and count(hl7:author/hl7:assignedAuthor/hl7:addr/hl7:streetAddressLine)=$num_addr_author)"
			>ERRORE-16: L'elemento <name/>/author/assignedAuthor/addr DEVE riportare i suoi sotto-elementi 'country', 'city' e 'streetAddressLine'. </assert>

			<!-- Controllo author/assignedAuthor/assignedPerson/name -->
			<let name="name_author" value="hl7:author/hl7:assignedAuthor/hl7:assignedPerson"/>
			<assert test="count($name_author)=0 or count($name_author/hl7:name)=1"
			>ERRORE-17| L'elemento ClinicalDocument/author/assignedAuthor/assignedPerson DEVE avere l'elemento 'name' </assert>
			<assert test="count($name_author)=0 or (count($name_author/hl7:name/hl7:given)=1 and count($name_author/hl7:name/hl7:family)=1)"
			>ERRORE-18| L'elemento ClinicalDocument/author/assignedAuthor/assignedPerson/name DEVE avere gli elementi 'given' e 'family'</assert>

			<!-- controllo author/assignedAuthor/telecom -->
			<assert test="count(hl7:author/hl7:assignedAuthor/hl7:telecom)>=1"
			>ERRORE-19 | In ClinicalDocument/author/assignedAuthor DEVE essere presente almeno un elemento 'telecom' </assert>

			<!-- Controllo dataEnterer/time -->	
			<assert test="count(hl7:dataEnterer)=0 or count(hl7:dataEnterer/hl7:time)"
			>ERRORE-20 | L'elemento <name/>/dataEnterer DEVE avere un elemento 'time'</assert>
			
			<!-- Controllo dataEnterer/assignedEntity/id -->
			<let name="id_dataEnterer" value="hl7:dataEnterer/hl7:assignedEntity/hl7:id"/>
			<assert test="count(hl7:dataEnterer)=0 or count($id_dataEnterer[@root='2.16.840.1.113883.2.9.4.3.2'])=1"
			>ERRORE-21 | L'elemento ClinicalDocument/dataEnterer DEVE avere almeno un elemento 'id' <value-of select="$id_dataEnterer"/> con l'attributo @root valorizzato con '2.16.840.1.113883.2.9.4.3.2'</assert>
			
			<!-- Controllo dataEnterer/assignedEntity/assignedPerson -->
			<let name="nome" value="hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name"/>
			<assert test="count(hl7:dataEnterer)=0 or (count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson)=1 and count(hl7:dataEnterer/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1)"
			>ERRORE-22 | L'elemento <name/>/dataEnterer/assignedEntity DEVE riportare l'elemento 'assignedPerson/name'.</assert>
			<assert test="count(hl7:dataEnterer)=0 or (count($nome/hl7:family)=1 and count($nome/hl7:given)=1)"
			>ERRORE-23 | L'elemento <name/>/dataEnterer/assignedEntity/assignedPerson/name DEVE avere gli elementi 'given' e 'family'.</assert>

			<!-- Controllo ClinicalDocument/custodian/assignedCustodian/representedCustodianOrganization-->
			<assert test="count(hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:name)=1"
			>ERRORE-24| ClinicalDocument/custodian/assignedCustodian/representedCustodianOrganization deve contenere un elemento 'name'</assert>
			<let name="num_addr_cust" value="count(hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr)"/>
			<let name="addr_cust" value="hl7:custodian/hl7:assignedCustodian/hl7:representedCustodianOrganization/hl7:addr"/>
			<assert test="$num_addr_cust=0 or (count($addr_cust/hl7:country)=$num_addr_cust and count($addr_cust/hl7:city)=$num_addr_cust and count($addr_cust/hl7:streetAddressLine)=$num_addr_cust)"
			>ERRORE-25: L'elemento <name/>/custodian/assignedCustodian/representedCustodianOrganization/addr DEVE riportare i sotto-elementi 'country', 'city' e 'streetAddressLine'.</assert>


			<!--legalAuthenticator -->
			<assert test = "count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:signatureCode[@code='S'])= 1" 
			>ERRORE-26| L'elemento legalAuthenticator/signatureCode deve essere valorizzato con il codice "S"  </assert>
			<assert test = "count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:id[@root='2.16.840.1.113883.2.9.4.3.2'])= 1"
			>ERRORE-27| L'elemento legalAuthenticator/assignedEntity DEVE contenere almeno un elemento id valorizzato con l'attributo @root '2.16.840.1.113883.2.9.4.3.2'</assert>
			<assert test = "count(hl7:legalAuthenticator)= 0 or count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1"
			>ERRORE-28 | ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson DEVE contenere l'elemento 'name'. </assert>
			<assert test = "count(hl7:legalAuthenticator)= 0 or (count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1 and count(hl7:legalAuthenticator/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1)"
			>ERRORE-29 | ClinicalDocument/legalAuthenticator/assignedEntity/assignedPerson/name DEVE riportare gli elementi 'given' e 'family'</assert>

			<!-- controllo su inFulfillmentOf-->
			<let name="prioriry" value="hl7:inFulfillmentOf/hl7:order/hl7:priorityCode/@code"/>
			<assert test ="count(hl7:inFulfillmentOf)>=1" 
			>ERRORE-30 | In ClinicalDocuemnt DEVE essere presente almeno un elemento 'inFulfillmentOf'. </assert>
			<assert test ="count(hl7:inFulfillmentOf/hl7:order/hl7:priorityCode)=0 or ($prioriry='R' or $prioriry='P' or $prioriry='UR' or $prioriry='EM')"
			>ERRORE-31 | ClinicalDocument/infulfillmentOf/order/priorityCode DEVE avere l'attributo code valorizzato con uno dei seguenti valori: 'R'|'P'|'UR'|'EM' </assert>
					
			<!--controllo su documentationOf-->
			<!--report test = "count (hl7:documentationOf/hl7:serviceEvent/hl7:performer)!=0 or 
			(count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:addr)!=1 and 
			count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:telecom)!=1 )"
			>W003 | L'elemento ClinicalDocument/documentationOf/serviceEvent/performer/assignedEntity dovrebbe contenere address e telecom </report-->
			<assert test = "count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson)=0 or 
			count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1"
			>ERRORE-32 | L'elemento ClinicalDocument/documentationOf/serviceEvent/performer/assignedEntity/assignedPerson se presente, deve contenere l'elemento name </assert>
			<assert test = "count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson)=0 or 
			(count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:given)=1 and 
			count (hl7:documentationOf/hl7:serviceEvent/hl7:performer/hl7:assignedEntity/hl7:assignedPerson/hl7:name/hl7:family)=1)"
			>ERRORE-33 |l'elemento ClinicalDocument/documentationOf/serviceEvent/performer/assignedEntity/assignedPerson/name deve contenere gli attributi given e family </assert>
						

			<!--controllo su componentOf-->
			<let name="path_name" value="hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name"/>
			<assert test = "count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or 
			count (hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson/hl7:name)=1 "
			>ERROR-34 | deve essere presente l'elemento ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedentity/assignedPerson/name </assert>
			<assert test = "count(hl7:componentOf/hl7:encompassingEncounter/hl7:responsibleParty/hl7:assignedEntity/hl7:assignedPerson)=0 or 
			(count($path_name/hl7:given)=1 and count($path_name/hl7:family)=1)"
			>ERRORE-35 | L'elemento ClinicalDocument/componentOf/encompassingEncounter/responsibleParty/assignedentity/assignedPerson/name deve contenere gli elementi given e family </assert>
			<assert test = "count(hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization)=0 or 
			count (hl7:componentOf/hl7:encompassingEncounter/hl7:location/hl7:healthCareFacility/hl7:serviceProviderOrganization/hl7:id)=1"
			>ERRORE-36 | L'elemento ClinicalDocument/componentOf/encompassingEncounter/location/healthcareFacility/serviceProviderOrganization deve contenere l'elemento 'id' </assert>
		
		</rule>


	<!-- Body -->
	
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section">
		
			<assert test="count(hl7:code[@code='18717-9'])>= 1 or count(hl7:code[@code='18718-7'])>= 1 or
						count(hl7:code[@code='18719-5'])>= 1 or count(hl7:code[@code='18720-3'])>= 1 or
						count(hl7:code[@code='18721-1'])>= 1 or count(hl7:code[@code='18722-9'])>= 1 or
						count(hl7:code[@code='18723-7'])>= 1 or count(hl7:code[@code='18724-5'])>= 1 or
						count(hl7:code[@code='18725-2'])>= 1 or count(hl7:code[@code='18727-8'])>= 1 or
						count(hl7:code[@code='18729-6'])>= 1 or count(hl7:code[@code='18729-4'])>= 1 or
						count(hl7:code[@code='18767-4'])>= 1 or count(hl7:code[@code='18768-2'])>= 1 or
						count(hl7:code[@code='18769-0'])>= 1 or count(hl7:code[@code='26435-8'])>= 1 or
						count(hl7:code[@code='26436-6'])>= 1 or count(hl7:code[@code='26437-4'])>= 1 or
						count(hl7:code[@code='26438-2'])>= 1 or count(hl7:code[@code='18716-1'])>= 1 or
						count(hl7:code[@code='26439-0'])>= 1 "
						>ERRORE-37| L'elemento code della section DEVE essere valorizzato con uno dei seguenti codici LOINC individuati:
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
						26439-0 PATOLOGIA CHIRURGICA</assert>
						
			<!-- controllo su text --> 
			<assert test="(count(hl7:component/hl7:section)>=1 or count(hl7:text)=1) or (count(hl7:component/hl7:section)>=1 and count (hl7:text)=1)"
			>ERORE-38| L'elemento component/structuredBody/component/section/text DEVE essere presente nel caso in cui non è riportata la sezione foglia. </assert>
			
			<!-- 5 -->			
			<!-- controllo entryRelationship -->
			<assert test = "count(hl7:entry/hl7:act)=0 or (count(hl7:entry/hl7:act/hl7:entryRelationship[@typeCode='SUBJ'])=1 and 
			count(hl7:entry/hl7:act/hl7:entryRelationship[@inversionInd='true'])=1)"
			>ERRORE-39| L'elemento <name/> /entry/act/entryRelationship deve avere gli attributi @typeCode="SUBJ"e @inversionInd="true" </assert>
		
			<assert test = "count(hl7:entry/hl7:act/hl7:entryRelationship)=0 or 
			(count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:code[@code='48767-8'])=1 and 
			count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)"
			>ERROR-40| L'elemento <name/> /entry/act/entryRelationship/act/code deve avere gli attributi @code="48767-8" e @codeSystem="2.16.840.1.113883.6.1" </assert>
			
			<assert test = "count(hl7:entry/hl7:act/hl7:entryRelationship)=0 or 
			(count(hl7:entry/hl7:act/hl7:entryRelationship/hl7:act/hl7:text/hl7:reference)=1)"
			>ERROR-41| L'elemento <name/> /entry/act/entryRelationship/act/text deve contenere l'elemento reference </assert>
		
		</rule>
		
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:entry/hl7:act/hl7:specimen">
			<assert test="count(hl7:specimenRole/hl7:id)>=1"
			>ERRORE-42| Gli elementi entry/act/specimen/specimenRole DEVONO avere un elemento 'id'. </assert>
			<assert test="count(hl7:specimenRole/hl7:specimenPlayingEntity)=1" 
			>ERRORE-43| L'elemento component/struturedBody/component/section/entry/act/specimen deve contenere l'elemento specimenRole/specimenPlayingEntity </assert>
			<assert test="count(hl7:specimenRole/hl7:specimenPlayingEntity/hl7:code)=1" 
			>ERRORE-44| L'elemento entry/act/specimen/specimenRole/specimenPlayingEntity deve contenere l'elemento code</assert>
			
		</rule>
		
		<rule context = "hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:component/hl7:section">
		
			<!-- 5 -->			
			<!-- controllo su section foglia -->
			
			<assert test = "count(hl7:component/hl7:section)=0" 
			>ERRORE-45| La sezione foglia non deve includere ulteriori component</assert>
			
			<let name="stCode" value="hl7:entry/hl7:act/hl7:statusCode/@code"/>
			<assert test = "count(hl7:entry/hl7:act/hl7:statusCode)=1 and ($stCode='completed' or $stCode='active' or $stCode='aborted')"
			>ERRORE-46| L'elemento entry/act/statusCode deve contenere l'attibuto @code = 'completed' or 'active' or 'aborted' </assert>
			
			<report test="not(count(hl7:entry/hl7:act/hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)"
			>W003 | si consiglia di utilizzare il sistema di codifica LOINC per la valorizzazione dell'elemento code di  <name/> /entry.--> </report>

		</rule>
		
		<!-- 5 -->			
			<!-- controllo code Observation -->
		<rule context="hl7:ClinicalDocument/hl7:component/hl7:structuredBody/hl7:component/hl7:section/hl7:component/hl7:section/hl7:entry/hl7:act/hl7:entryRelationship/hl7:observation">
		
		    <report test ="not(count(hl7:code[@codeSystem='2.16.840.1.113883.6.1'])=1)"
			>W004 | si consiglia di utilizzare il sistema di codifica LOINC per la valorizzazione dell'elemento code di observation.--> </report>
			
			<let name="obs_int" value="hl7:interpretationCode/@codeSystem"/>
			<assert test ="count(hl7:interpretationCode)=0 or $obs_int='2.16.840.1.113883.5.83'"
			> ERRORE-47| L'elemento observation/interpretationCode DEVE essere valorizzato secondo il value set HL7 Observation Interpretation (2.16.840.1.113883.5.83)</assert>
			
		</rule>
		
		
		<!-- Controllo Dizionari -->
	
		<!-- verifica che i codici LOINC utilizzati siano corretti -->
		<rule context="//*[@codeSystem='2.16.840.1.113883.6.1']">
			<let name="val_LOINC" value="encode-for-uri(@code)"/> 
			<assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.6.1?code=',$val_LOINC))//result='true'"
			>ERRORE-1_DIZ| Codice LOINC <value-of select="$val_LOINC"/> errato
			</assert>
		</rule>
		 
		<!--Verifica che i codici relativi al value set "ActSite" utilizzati siano corretti-->
		<rule context="//*[@codeSystem='2.16.840.1.113883.5.1052']">
			<let name="sito" value="encode-for-uri(@code)"/> 
			<assert test="doc(concat('http://###PLACEHOLDER_URL###/v1/validate-terminology/2.16.840.1.113883.5.1052?code=',$sito))//result='true'"
			>Errore 4_DIZ| Codice "ActSite" '<value-of select="$sito"/>' errato!
			</assert> 
		</rule>
		 
		
		<!-- 6 -->
		<!-- verifica che gli elementi organizer di tipo battery contengano obbligatoriamente un elemento code -->
		<rule context="//*[@classCode='BATTERY']">
			<assert test="(count(hl7:code)=1)"
			>ERRORE-48| L’elemento organizer di tipo 'BATTERY' (@classCode='BATTERY') DEVE contenere l’elemento organizer/code.
			</assert>
		</rule>
		
		<rule context="//hl7:telecom">
			<assert test="(count(@use)=1)"
			>ERRORE-49| L’elemento 'telecom' DEVE contenere l'attributo @use.
			</assert>
		</rule>
		
		<!-- Controllo formato: -->
		<!--campi Codice Fiscale: 16 cifre [A-Z0-9]{16} -->
		<rule context="//hl7:id[@root='2.16.840.1.113883.2.9.4.3.2']">
			<let name="CF" value="@extension"/>
			<assert test="matches(@extension, '[A-Z0-9]{16}')"
			> ERRORE-50| codice fiscale '<value-of select="$CF"/>' cittadino ed operatore: 16 cifre [A-Z0-9]{16}</assert>
		</rule>
		
		
	</pattern>
</schema>