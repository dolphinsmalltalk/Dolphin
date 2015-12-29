"Filed out from Dolphin Smalltalk X6.2"!

WebHttpServlet subclass: #StsServerManagerServlet
	instanceVariableNames: 'importQueueMutex importQueue currentImportProcess'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsServerManagerServlet guid: (GUID fromString: '{1D7CDA96-0769-4ACE-BB43-9F8545178469}')!
StsServerManagerServlet comment: ''!
!StsServerManagerServlet categoriesForClass!Unclassified! !
!StsServerManagerServlet methodsFor!

importChangeSet: description data: objectData 
	| changeSet existingChangeSet coll transaction blessingLevels |
	ItcSystemManager logLineWithTsAndSession: 'Importing Change Set: ' , description.
	
	[changeSet := ODBDeserializer 
				deserializeFromBytes: (ZLibInterface decompress: objectData) asByteArray] 
			on: Error
			do: [:ex | ex exitWith: nil].
	(changeSet isKindOf: StsChangeSet) ifFalse: [^self error: 'Ilegal object received.'].
	"Check existing Change Set."
	transaction := self sourceControl databaseConnection newTransaction.
	coll := transaction root at: self sourceControl changeSetsKey ifAbsentPut: [OrderedCollection new].
	(existingChangeSet := coll detect: 
					[:eachChangeSet | 
					eachChangeSet developer = changeSet developer and: 
							[eachChangeSet timestamp = changeSet timestamp and: 
									[eachChangeSet comment = changeSet comment 
										and: [eachChangeSet browserTitle = changeSet browserTitle]]]]
				ifNone: []) isNil 
		ifFalse: 
			[existingChangeSet blessing == changeSet blessing 
				ifFalse: 
					[existingChangeSet blessing isNil 
						ifTrue: 
							[
							[existingChangeSet
								blessing: changeSet blessing;
								markDirty] 
									evaluateAndCommitIn: transaction]
						ifFalse: 
							[changeSet blessing isNil 
								ifFalse: 
									[blessingLevels := StsEdition possibleBlessingLevels.
									blessingLevels := blessingLevels copyFrom: (blessingLevels indexOf: existingChangeSet blessing)
												to: blessingLevels size.
									(blessingLevels includes: changeSet blessing) 
										ifTrue: 
											[
											[existingChangeSet
												blessing: changeSet blessing;
												markDirty] 
													evaluateAndCommitIn: transaction]]]]]
		ifTrue: 
			[
			[changeSet
				makePersistent;
				markDirty.
			coll add: changeSet] 
					evaluateAndCommitIn: transaction]!

importPackageNamed: packageName version: packageVersion compressedXml: compressedXml 
	| doc packageProxy |
	ItcSystemManager logLineWithTsAndSession: 'Importing package ' , packageName asWebString , ' ' 
				, packageVersion asWebString.
	doc := XMLDOMParser parseDocumentFrom: (ReadStream on: (ZLibInterface decompress: compressedXml)).
	packageProxy := StsXMLPackageProxy new basicImportFrom: doc topElement.
	ItcSystemManager 
		logLineWithTsAndSession: 'Versioning imported package ' , packageName asWebString , ' ' 
				, packageVersion asWebString.
	self sourceControl 
		basicVersionPackage: packageProxy
		versionDescriptor: packageProxy version
		previousEdition: nil
		blessing: packageProxy blessing
		comment: packageProxy comment
		versionComment: packageProxy versionComment
		checkExisting: true
		silentBool: true.
	ItcSystemManager 
		logLineWithTsAndSession: 'Versioning completed for package ' , packageName asWebString , ' ' 
				, packageVersion asWebString!

importProjectEditionNamed: projectName version: projectVersion compressedXml: compressedXml 
	| doc projectEdition oid packageEditionsOIDs |
	ItcSystemManager logLineWithTsAndSession: 'Importing project ' , projectName asWebString , ' ' 
				, projectVersion asWebString.
	doc := XMLDOMParser parseDocumentFrom: (ReadStream on: (ZLibInterface decompress: compressedXml)).
	projectEdition := StsProjectProxy new basicImportHeaderFromDocument: doc.
	projectEdition isNil ifTrue: [^self error: 'Can not read project information from XML'].
	packageEditionsOIDs := OrderedCollection new.
	projectEdition packages do: 
			[:eachPackageEdition | 
			oid := self sourceControl 
						findExistingPackageEdition: eachPackageEdition name
						versionDescriptor: eachPackageEdition packageVersion
						developer: eachPackageEdition developer
						timestamp: eachPackageEdition timestamp.
			oid isNil 
				ifTrue: 
					[^self 
						error: 'Assertion failed, can not find package ' , eachPackageEdition name asWebString , ' version ' 
								, ((eachPackageEdition packageVersion add: eachPackageEdition developer withDelimiter: ' / ') 
										add: eachPackageEdition timestamp asWebString
										withDelimiter: ' / ') asWebString].
			packageEditionsOIDs add: oid].
	ItcSystemManager 
		logLineWithTsAndSession: 'Finalizing project import for ' , projectName asWebString , ' ' 
				, projectVersion asWebString.
	(self sourceControl 
		findExistingProjectEdition: projectEdition name
		versionDescriptor: projectEdition projectVersion
		developer: projectEdition developer
		timestamp: projectEdition timestamp) isNil 
		ifTrue: 
			[self sourceControl 
				basicVersionProject: projectEdition
				versionDescriptor: projectEdition projectVersion
				previousEdition: (self sourceControl 
						findProjectEditionForPreviousVersionData: projectEdition previousVersionsData
						projectName: projectEdition name)
				blessing: projectEdition blessing
				comment: projectEdition comment
				versionComment: projectEdition versionComment
				packageEditionOIDs: packageEditionsOIDs
				progress: nil
				tick: nil
				timestamp: projectEdition timestamp
				developer: projectEdition developer.
			ItcSystemManager 
				logLineWithTsAndSession: 'Done finalizing project import for ' , projectName asWebString , ' ' 
						, projectVersion asWebString]
		ifFalse: 
			[ItcSystemManager 
				logLineWithTsAndSession: 'Project import ignored (ALREADY EXISTS) for ' , projectName asWebString 
						, ' ' , projectVersion asWebString]!

initialize
	super initialize.
	importQueue := OrderedCollection new.
	importQueueMutex := Semaphore forMutualExclusion.
	currentImportProcess := nil!

kickWaitingJobs
	| newProcess |
	importQueueMutex critical: 
			[(currentImportProcess isNil or: [currentImportProcess itcIsTerminated]) 
				ifTrue: 
					[importQueue isEmpty 
						ifFalse: 
							[| scheduledJob |
							scheduledJob := importQueue removeFirst.
							newProcess := currentImportProcess := ItcSystemManager newProcessOn: 
													[scheduledJob first ensure: 
															["start new waiting job after this one terminates"
															ItcSystemManager logLineWithTsAndSession: 'Process ended for: ' , scheduledJob last.
															currentImportProcess := nil.
															self kickWaitingJobs]]
												named: scheduledJob last]]].
	newProcess isNil 
		ifFalse: 
			[ItcSystemManager logLineWithTsAndSession: 'Process started for: ' , newProcess name.
			newProcess
				webSession: self webSession;
				priority: ItcSystemManager batchJobPriority;
				resume]!

process: request on: stream 
	self
		checkOrSetDefaultClientIdCookieAndSessionFor: request on: stream;
		dispatch: request
			on: stream
			withDefault: #processDefault:on:!

processChangeSetUpload: request on: stream 
	"Schedule background job to finalize change set import into repository.
	Answer OK string after file contents is uploaded."

	| changeSetData changeSetDescription |
	self webSession user isNil ifTrue: [^stream fileNotFoundResponse].
	changeSetDescription := request stringAt: 'changeSetDescription'.
	changeSetData := (request getAttachedFile: 'changeSetData') value.
	self scheduleJobFor: [self importChangeSet: changeSetDescription data: changeSetData]
		description: 'Importing Change Set: ' , changeSetDescription.
	stream nextPutAll: 'OK'!

processCompleteProjectEditionUpload: request on: stream 
	"Schedule background job to finalize project edition import into repository.
	Answer OK string after file contents (project edition header) is uploaded."

	| projectName projectVersion compressedXml |
	self webSession user isNil ifTrue: [^stream fileNotFoundResponse].
	projectName := request stringAt: 'projectName'.
	projectVersion := request stringAt: 'projectVersion'.
	compressedXml := (request getAttachedFile: 'projectHeader') value.
	"add project edition header data to the import queue and kick the importing process in the background"
	self scheduleJobFor: 
			[self 
				importProjectEditionNamed: projectName
				version: projectVersion
				compressedXml: compressedXml]
		description: 'Finalizing project edition import for: ' , projectName asWebString , ' ' 
				, projectVersion asWebString.
	stream nextPutAll: 'OK'!

processGetAllAvailableChangeSets: request on: stream 
	"Answer a collection of data for change sets in the repository.
	Answer a serialized string as HTTP response."

	| changeSets result textDeveloper textComment listMinBlessing textIncludesClass |
	application allowPublicReadOnlyAccess 
		ifFalse: [self webSession user isNil ifTrue: [^stream fileNotFoundResponse]].
	changeSets := self sourceControl getStoredChangeSets reverse.
	textDeveloper := request stringOrNilAt: 'textDeveloper'.
	textComment := request stringOrNilAt: 'textComment'.
	(listMinBlessing := request symbolAt: 'listMinBlessing') isNil 
		ifFalse: 
			[result := StsEdition possibleBlessingLevels.
			listMinBlessing := result copyFrom: (result indexOf: listMinBlessing
								ifAbsent: [^stream errorResponseWithDescription: 'Ilegal blessing level.'])
						to: result size].
	(textDeveloper isNil and: [textComment isNil and: [listMinBlessing isNil]]) 
		ifFalse: 
			[changeSets := changeSets select: 
							[:each | 
							(textDeveloper isNil or: [textDeveloper match: each developer]) and: 
									[(textComment isNil 
										or: [(textComment match: each comment) or: [textComment match: each browserTitle]]) 
											and: [listMinBlessing isNil or: [listMinBlessing includes: each blessing]]]]].
	(textIncludesClass := request stringOrNilAt: 'textIncludesClass') isNil 
		ifFalse: 
			[changeSets := changeSets select: 
							[:eachChangeSet | 
							(eachChangeSet changeNodes 
								detect: [:eachChange | textIncludesClass match: eachChange anyEditionClassName]
								ifNone: []) notNil]].
	result := OrderedCollection new.
	changeSets do: 
			[:eachChangeSet | 
			result 
				add: ((OrderedCollection new: 6)
						add: eachChangeSet browserTitle;
						add: eachChangeSet comment;
						add: eachChangeSet developer;
						add: eachChangeSet timestamp;
						add: eachChangeSet blessing;
						yourself) asArray].
	stream
		isBytes: true;
		nextPutAll: (ODBSerializer serializeToBytes: result asArray)!

processGetAllProjectEditionsForProjectName: request on: stream 
	"Answer a collection of data for all project editions for the selected project.
	Answer a serialized string as HTTP response."

	| projectName projectEditionsData |
	application allowPublicReadOnlyAccess 
		ifFalse: [self webSession user isNil ifTrue: [^stream fileNotFoundResponse]].
	projectName := request stringAt: 'projectName'.
	projectEditionsData := OrderedCollection new.
	(self sourceControl getProjectEditionsFor: projectName) do: 
			[:each | 
			each isOpenEdition 
				ifFalse: 
					[projectEditionsData 
						add: ((OrderedCollection new: 7)
								add: projectName;
								add: each versionDescriptor;
								add: each developer;
								add: each timestamp;
								add: each blessing;
								add: each comment;
								add: each versionComment;
								yourself) asArray]].
	stream nextPutAll: projectEditionsData asArray webSerializeToString!

processGetAllProjectNamesAndEditionsForDefault: request on: stream 
	"Answer a collection of all project names. To save another roundtrip, also answer a collection of data for all project editions for selected project (or for the first one in the list if none selected).
	Answer a serialized string as HTTP response."

	| defaultProjectName allProjectNames projectEditionsData |
	application allowPublicReadOnlyAccess 
		ifFalse: [self webSession user isNil ifTrue: [^stream fileNotFoundResponse]].
	allProjectNames := self sourceControl getAllProjectNames.
	defaultProjectName := request stringAt: 'defaultProject'.
	allProjectNames isEmpty 
		ifTrue: 
			[defaultProjectName := nil.
			projectEditionsData := #()]
		ifFalse: 
			[(allProjectNames includes: defaultProjectName) 
				ifFalse: [defaultProjectName := allProjectNames first].
			projectEditionsData := OrderedCollection new.
			(self sourceControl getProjectEditionsFor: defaultProjectName) do: 
					[:each | 
					each isOpenEdition 
						ifFalse: 
							[projectEditionsData 
								add: ((OrderedCollection new: 7)
										add: defaultProjectName;
										add: each versionDescriptor;
										add: each developer;
										add: each timestamp;
										add: each blessing;
										add: each comment;
										add: each versionComment;
										yourself) asArray]]].
	stream 
		nextPutAll: (Array 
				with: allProjectNames
				with: defaultProjectName
				with: projectEditionsData) webSerializeToString!

processGetChangeSetByDescription: request on: stream 
	"Answer a change set as serialized string as HTTP response."

	| changeSet browserTitle comment developer timestamp |
	application allowPublicReadOnlyAccess 
		ifFalse: [self webSession user isNil ifTrue: [^stream fileNotFoundResponse]].
	browserTitle := request stringOrNilAt: 'browserTitle'.
	comment := request stringOrNilAt: 'comment'.
	developer := request stringOrNilAt: 'developer'.
	timestamp := request timestampAt: 'timestamp'.
	(changeSet := self sourceControl getStoredChangeSets detect: 
					[:each | 
					each browserTitle = browserTitle and: 
							[each comment = comment and: 
									[each developer = developer and: 
											[timestamp notNil 
												and: [each timestamp date = timestamp date and: [each timestamp time = timestamp time]]]]]]
				ifNone: []) isNil 
		ifTrue: [^stream errorResponseWithDescription: 'Object not found'].
	stream
		isBytes: true;
		nextPutAll: (ODBSerializer serializeToBytes: (changeSet
							resolveProxies;
							yourself))!

processGetPackageEdition: request on: stream 
	"Answer and export package in XML format for the requested package edition."

	| packageEdition packageProxy oid |
	application allowPublicReadOnlyAccess 
		ifFalse: [self webSession user isNil ifTrue: [^stream fileNotFoundResponse]].
	packageProxy := request objectAt: 'packageEdition'.
	packageProxy isNil ifTrue: [stream errorResponseWithDescription: 'Invalid request parameter'].
	oid := self sourceControl 
				findExistingPackageEdition: packageProxy name
				versionDescriptor: packageProxy packageVersion
				developer: packageProxy developer
				timestamp: packageProxy timestamp.
	oid isNil ifTrue: [stream errorResponseWithDescription: 'Could not find requested project edition'].
	packageEdition := application newReadOnlyTransaction objectAt: oid.
	packageEdition exportAsXmlOn: stream!

processGetProjectEditionHeader: request on: stream 
	"Answer and export XML header for requested project edition."

	| projectEdition shadowEdition oid |
	application allowPublicReadOnlyAccess 
		ifFalse: [self webSession user isNil ifTrue: [^stream fileNotFoundResponse]].
	shadowEdition := request objectAt: 'projectEdition'.
	shadowEdition isNil ifTrue: [stream errorResponseWithDescription: 'Invalid request parameter'].
	oid := self sourceControl 
				findExistingProjectEdition: shadowEdition name
				versionDescriptor: shadowEdition versionDescriptor
				developer: shadowEdition developer
				timestamp: shadowEdition timestamp.
	oid isNil ifTrue: [stream errorResponseWithDescription: 'Could not find requested project edition'].
	projectEdition := application newReadOnlyTransaction objectAt: oid.
	projectEdition exportHeaderAsXmlOn: stream!

processGetServerInfo: request on: stream 
	"Answer STS server version."

	stream
		contentType: 'text/plain';
		nextPutAll: 'STS server 4.0' , (application allowPublicReadOnlyAccess 
							ifTrue: [' / PUBLIC repository']
							ifFalse: [' / PRIVATE repository'])!

processLogin: request on: stream 
	| username password result |
	username := request stringAt: 'username'.
	password := request stringAt: 'password'.
	(result := application 
				loginForSession: self webSession
				username: username
				password: password) = true 
		ifTrue: [stream nextPutAll: 'OK']
		ifFalse: [stream nextPutAll: result]!

processQueryMissingPackageEditionsForProjectEditionUpload: request on: stream 
	"Find out which package versions already exist in server repository and then answer back a collection of all package names for contained package editions that have to be uploaded.
	The resulting collection is answered as serialized string."

	| compressedHeader headerXml doc project editionsToImport oid |
	self webSession user isNil ifTrue: [^stream fileNotFoundResponse].
	(compressedHeader := request getAttachedFile: 'projectHeader') isNil 
		ifTrue: [^stream fileNotFoundResponse].
	headerXml := ZLibInterface decompress: compressedHeader value.
	"find out which project and package editions already exist and answer this back to the client"
	doc := XMLDOMParser parseDocumentFrom: (ReadStream on: headerXml).
	project := StsProjectProxy new basicImportHeaderFromDocument: doc.
	project isNil 
		ifTrue: [^stream errorResponseWithDescription: 'Can not read project information from request'].
	editionsToImport := OrderedCollection new.
	project packages do: 
			[:eachPackageEdition | 
			oid := self sourceControl 
						findExistingPackageEdition: eachPackageEdition name
						versionDescriptor: eachPackageEdition packageVersion
						developer: eachPackageEdition developer
						timestamp: eachPackageEdition timestamp.
			oid isNil 
				ifTrue: 
					["this edition should be uploaded"
					editionsToImport add: eachPackageEdition name]].
	stream nextPutAll: editionsToImport webSerializeToString!

processUploadPackageEdition: request on: stream 
	"Schedule background job to import package edition into repository.
	Answer OK string after file contents is uploaded."

	| packageName packageVersion compressedXml |
	self webSession user isNil ifTrue: [^stream fileNotFoundResponse].
	packageName := request stringAt: 'packageName'.
	packageVersion := request stringAt: 'packageVersion'.
	compressedXml := (request getAttachedFile: 'packageExport') value.
	"add package data to the import queue and kick the importing process in the background"
	self scheduleJobFor: 
			[self 
				importPackageNamed: packageName
				version: packageVersion
				compressedXml: compressedXml]
		description: 'Package edition import for: ' , packageName asWebString , ' ' 
				, packageVersion asWebString.
	stream nextPutAll: 'OK'!

scheduleJobFor: aBlock description: aString 
	ItcSystemManager logLineWithTsAndSession: 'Scheduling job: ' , aString asWebString.
	importQueueMutex critical: [importQueue add: (Array with: aBlock with: aString)].
	self kickWaitingJobs!

sourceControl
	^Package manager sourceControl! !
!StsServerManagerServlet categoriesFor: #importChangeSet:data:!private!uploading! !
!StsServerManagerServlet categoriesFor: #importPackageNamed:version:compressedXml:!private!uploading! !
!StsServerManagerServlet categoriesFor: #importProjectEditionNamed:version:compressedXml:!private!uploading! !
!StsServerManagerServlet categoriesFor: #initialize!private! !
!StsServerManagerServlet categoriesFor: #kickWaitingJobs!private!uploading! !
!StsServerManagerServlet categoriesFor: #process:on:!public! !
!StsServerManagerServlet categoriesFor: #processChangeSetUpload:on:!public!uploading! !
!StsServerManagerServlet categoriesFor: #processCompleteProjectEditionUpload:on:!public!uploading! !
!StsServerManagerServlet categoriesFor: #processGetAllAvailableChangeSets:on:!public!uploading! !
!StsServerManagerServlet categoriesFor: #processGetAllProjectEditionsForProjectName:on:!public!uploading! !
!StsServerManagerServlet categoriesFor: #processGetAllProjectNamesAndEditionsForDefault:on:!public!uploading! !
!StsServerManagerServlet categoriesFor: #processGetChangeSetByDescription:on:!public!uploading! !
!StsServerManagerServlet categoriesFor: #processGetPackageEdition:on:!public! !
!StsServerManagerServlet categoriesFor: #processGetProjectEditionHeader:on:!public! !
!StsServerManagerServlet categoriesFor: #processGetServerInfo:on:!public! !
!StsServerManagerServlet categoriesFor: #processLogin:on:!public! !
!StsServerManagerServlet categoriesFor: #processQueryMissingPackageEditionsForProjectEditionUpload:on:!public!uploading! !
!StsServerManagerServlet categoriesFor: #processUploadPackageEdition:on:!public!uploading! !
!StsServerManagerServlet categoriesFor: #scheduleJobFor:description:!private!uploading! !
!StsServerManagerServlet categoriesFor: #sourceControl!private! !

!StsServerManagerServlet class methodsFor!

servletName
	^'StsManager'! !
!StsServerManagerServlet class categoriesFor: #servletName!public! !

