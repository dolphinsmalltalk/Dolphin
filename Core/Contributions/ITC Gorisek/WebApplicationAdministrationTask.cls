"Filed out from Dolphin Smalltalk X6.1"!

WebTask subclass: #WebApplicationAdministrationTask
	instanceVariableNames: 'formFields currentPath commandInProgress commandProcess lastCommandLog lastCommandErrorLog commandLogReadPosition errorLogNodes errorLogParsingProcess errorLogFormArgs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebApplicationAdministrationTask guid: (GUID fromString: '{B6252B36-0700-4E81-9340-86F0DB400A8E}')!
WebApplicationAdministrationTask comment: ''!
!WebApplicationAdministrationTask categoriesForClass!Unclassified! !
!WebApplicationAdministrationTask methodsFor!

ajaxGetExpandErrorLogNode
	| errorId coder errorDescription subNodes |
	errorId := (self webRequest stringAt: 'id') trimOrZeroPadToSize: 6.
	errorDescription := errorLogNodes keys detect: [:each | each beginsWith: errorId]
				ifNone: [^self putAjaxResultsForNoAction].
	subNodes := errorLogNodes at: errorDescription.
	coder := self newCoderForAjaxRequest.
	subNodes doWithIndex: 
			[:eachSubnode :index | 
			coder htmlStream 
				nextPutAll: '<a href="' 
						, (coder urlPrefixForAction: #ajaxGetExpandErrorLogSubnode id: errorId , '_' , index asWebString) 
							, '" onclick="this.style.color=''#ff0000'';">' 
							, ((eachSubnode at: 1) asWebString add: (eachSubnode at: 2) withDelimiter: ' user: ') , '</a><br />'].
	self putAjaxResultsIntoDiv: 'error_' , errorId itcAsInteger asWebString coder: coder!

ajaxGetExpandErrorLogSubnode
	| errorId errorDescription subNodes subNodeId node |
	errorId := (self webRequest stringAt: 'id') itcAsInteger asLeadingZerosStringOfSize: 6.
	subNodeId := ((self webRequest stringAt: 'id') copyFrom: 8) itcAsInteger.
	errorDescription := errorLogNodes keys detect: [:each | each beginsWith: errorId]
				ifNone: [^self putAjaxResultsForNoAction].
	subNodes := errorLogNodes at: errorDescription.
	node := subNodes at: subNodeId.
	self 
		showAjaxPopUpForm: 'Stack trace for: ' 
				, ((node at: 1) asWebString add: (node at: 2) withDelimiter: ' user: ')
		content: 
			[:coder | 
			(coder htmlStream)
				nextPutAll: '<div style="border:1px solid grey;background:#fff0e0;">';
				nextPutAll: (self getErrorLogStackFrameFor: node) webHtmlEncoded , '</div>']
		bottomContent: 
			[:coder | 
			coder writeActionButtonsCentered: (Array 
						with: (HtmlButton label: 'asp.button.CloseWindow' onClick: 'closeTopDialogBox();'))]
		width: session getScreenWidth - 300
		height: 400!

ajaxGetLiveUpdateExpandClass
	| class methods classId coder |
	classId := self webRequest stringAt: 'id'.
	class := ItcSystemManager getLiveUpdatePatchDict keys 
				detect: [:each | (self getLiveUpdateDivNameForClass: each) = classId]
				ifNone: [^self putAjaxResultsForNoAction].
	methods := ItcSystemManager getLiveUpdatePatchDict at: class.
	coder := self newCoderForAjaxRequest.
	methods keys asSortedCollection do: 
			[:eachSelector | 
			"Each value contains of Array of 3 elements:
1. Method source;
2. String of user who made live update,
3. Timestamp when update was made."
			| val |
			val := methods at: eachSelector.
			coder htmlStream 
				nextPutAll: '<a href="' , (coder urlPrefixForAction: #ajaxGetLiveUpdateExpandMethod
								id: classId , '_' , eachSelector asString webEncrypted) 
						, '">#' 
							, (eachSelector asString , '  /by ' 
									, ((val at: 2) asWebString add: val last asWebString withDelimiter: ' @ ')) webHtmlEncoded 
							, '</a><div id="' , classId 
						, '_' , eachSelector asString webEncrypted 
						, '"></div>'].
	self putAjaxResultsIntoDiv: classId coder: coder!

ajaxGetLiveUpdateExpandMethod
	| class methods ws classId methodId selector |
	classId := ((self webRequest stringAt: 'id') itcSubStrings: $_) first.
	methodId := ((self webRequest stringAt: 'id') itcSubStrings: $_) last.
	class := ItcSystemManager getLiveUpdatePatchDict keys 
				detect: [:each | (self getLiveUpdateDivNameForClass: each) = classId]
				ifNone: [^self putAjaxResultsForNoAction].
	methods := ItcSystemManager getLiveUpdatePatchDict at: class.
	selector := methods keys detect: [:each | each asString webEncrypted = methodId]
				ifNone: [^self putAjaxResultsForNoAction].
	ws := WriteStream on: String new.
	ws 
		nextPutAll: '<div style="padding:1px;margin-left:4px;border:1px solid #808080;background:#f0f0f0;">' 
				, (methods at: selector) first webHtmlEncoded , '</div>'.
	self putAjaxResults: 'commonGetElementById("' , classId , '_' , methodId , '").innerHTML=' 
				, ws contents asJavascriptValue!

allMemoryUsageTrackingClassPrefixes
	^#('Web' 'Itc' 'Html' 'Http' 'Or')!

canDoApplicationAdministration
	^true!

errorLogFilename
	^ItcSystemManager isRuntime 
		ifTrue: [ItcSystemManager startUpDirectoryPath , 'ERROR.LOG']
		ifFalse: ['c:\temp\ERROR-eracuni.LOG']!

getCachedMemoryUsageStatistics
	"Answers memory usage statistics.
	If no statistics exists, then starts counting instances."

	| coll |
	coll := WebApplicationAdministrationManager memoryUsageStats.
	coll isNil ifFalse: [^coll].
	WebApplicationAdministrationManager 
		recordMemoryUsageStatistics: [self getCurrentMemoryUsage] itcDeferredValue.
	^false!

getCurrentMemoryUsage
	"Answer a collection of associations where keys are classes and for each class a value represents number of instances of that class."

	| coll prefixes nInstances |
	coll := SortedCollection sortBlock: ((ItcSortBlock with: #value)
						invertAscendingDescending;
						yourself).
	prefixes := self allMemoryUsageTrackingClassPrefixes.
	Object allSubclasses do: 
			[:eachClass | 
			eachClass isMetaclass 
				ifFalse: 
					[(prefixes detect: [:eachPrefix | eachClass name asString beginsWith: eachPrefix] ifNone: []) isNil 
						ifFalse: 
							[nInstances := eachClass basicAllInstances size.
							nInstances > 2 ifTrue: [coll add: (Association key: eachClass value: nInstances)]]]].
	^coll!

getDataSeriesForDbReadStatisticsTheLastHour
	| ts array numberOfRequestsData labels minResponseDuration maxResponseDuration avgResponseDuration |
	array := #OrDBConnectionStatisticsLogger itcAsClass getReadRequestStatisticsForLastNminutes: 60.
	labels := LookupTable new.
	numberOfRequestsData := Array new: 60.
	minResponseDuration := Array new: 60.
	maxResponseDuration := Array new: 60.
	avgResponseDuration := Array new: 60.
	ts := Timestamp now.
	array reverse doWithIndex: 
			[:each :index | 
			numberOfRequestsData at: 61 - index put: (each at: 1).
			minResponseDuration at: 61 - index put: (each at: 2).
			maxResponseDuration at: 61 - index put: (each at: 3).
			avgResponseDuration at: 61 - index
				put: ((each at: 1) = 0 
						ifTrue: [0]
						ifFalse: 
							[(each at: 1) - 1 = 0 
								ifTrue: [(each at: 4) // (each at: 1)]
								ifFalse: 
									["ce je samo en ekstrem se ne uposteva pri racunanju povprecja"
									((each at: 4) - (each at: 3)) // ((each at: 1) - 1)]]).
			ts time minutes \\ 5 = 0 
				ifTrue: 
					[labels at: (ts time hours asLeadingZerosStringOfSize: 2) , ':' 
								, (ts time minutes asLeadingZerosStringOfSize: 2)
						put: 61 - index].
			ts := Timestamp fromSeconds: ts asSeconds - 60].
	1 to: numberOfRequestsData size
		do: [:i | numberOfRequestsData at: i put: (numberOfRequestsData at: i) / 60.0].
	^(IdentityDictionary new)
		at: #labels put: labels;
		at: #numberOfRequestsData put: numberOfRequestsData;
		at: #minResponseDuration put: minResponseDuration;
		at: #maxResponseDuration put: maxResponseDuration;
		at: #avgResponseDuration put: avgResponseDuration;
		yourself!

getDataSeriesForDbWriteStatisticsTheLastHour
	| ts array numberOfRequestsData labels minResponseDuration maxResponseDuration avgResponseDuration |
	array := #OrDBConnectionStatisticsLogger itcAsClass getWriteRequestStatisticsForLastNminutes: 60.
	labels := LookupTable new.
	numberOfRequestsData := Array new: 60.
	minResponseDuration := Array new: 60.
	maxResponseDuration := Array new: 60.
	avgResponseDuration := Array new: 60.
	ts := Timestamp now.
	array reverse doWithIndex: 
			[:each :index | 
			numberOfRequestsData at: 61 - index put: (each at: 1).
			minResponseDuration at: 61 - index put: (each at: 2).
			maxResponseDuration at: 61 - index put: (each at: 3).
			avgResponseDuration at: 61 - index
				put: ((each at: 1) = 0 
						ifTrue: [0]
						ifFalse: 
							[(each at: 1) - 1 = 0 
								ifTrue: [(each at: 4) // (each at: 1)]
								ifFalse: 
									["ce je samo en ekstrem se ne uposteva pri racunanju povprecja"
									((each at: 4) - (each at: 3)) // ((each at: 1) - 1)]]).
			ts time minutes \\ 5 = 0 
				ifTrue: 
					[labels at: (ts time hours asLeadingZerosStringOfSize: 2) , ':' 
								, (ts time minutes asLeadingZerosStringOfSize: 2)
						put: 61 - index].
			ts := Timestamp fromSeconds: ts asSeconds - 60].
	1 to: numberOfRequestsData size
		do: [:i | numberOfRequestsData at: i put: (numberOfRequestsData at: i) / 60.0].
	^(IdentityDictionary new)
		at: #labels put: labels;
		at: #numberOfRequestsData put: numberOfRequestsData;
		at: #minResponseDuration put: minResponseDuration;
		at: #maxResponseDuration put: maxResponseDuration;
		at: #avgResponseDuration put: avgResponseDuration;
		yourself!

getDataSeriesForHttpServerTheLast24Hours
	| ts array newRequestData keepAliveRequestData labels serverUtilization minDuration maxDuration avgDuration peakMemoryUsage |
	array := WebHttpServer current getRequestCounterArrayForLastNminutes: 24 * 60.
	labels := LookupTable new.
	newRequestData := (Array new: 24 * 4)
				atAllPut: 0;
				yourself.
	keepAliveRequestData := (Array new: 24 * 4)
				atAllPut: 0;
				yourself.
	serverUtilization := (Array new: 24 * 4)
				atAllPut: 0;
				yourself.
	minDuration := (Array new: 24 * 4)
				atAllPut: 0;
				yourself.
	maxDuration := (Array new: 24 * 4)
				atAllPut: 0;
				yourself.
	avgDuration := (Array new: 24 * 4)
				atAllPut: 0;
				yourself.
	peakMemoryUsage := (Array new: 24 * 4)
				atAllPut: 0;
				yourself.
	ts := Timestamp now.
	array reverse doWithIndex: 
			[:each :index | 
			| i |
			i := 24 * 4 + 1 - ((index - 1) // 15 + 1).
			keepAliveRequestData at: i add: (each at: 2).
			newRequestData at: i add: (each at: 1).
			serverUtilization at: i add: (each at: 5).
			peakMemoryUsage at: i put: ((peakMemoryUsage at: i) max: (each at: 6)).
			minDuration at: i
				put: ((minDuration at: i) = 0 ifTrue: [each at: 3] ifFalse: [(minDuration at: i) min: (each at: 3)]).
			maxDuration at: i put: ((maxDuration at: i) max: (each at: 4)).
			i even 
				ifTrue: 
					[labels at: (ts time hours asLeadingZerosStringOfSize: 2) , ':' 
								, (ts time minutes asLeadingZerosStringOfSize: 2)
						put: i].
			ts := Timestamp fromSeconds: ts asSeconds - 60].
	1 to: serverUtilization size
		do: 
			[:i | 
			avgDuration at: i
				put: ((keepAliveRequestData at: i) = 0 
						ifTrue: [0]
						ifFalse: [(serverUtilization at: i) // (keepAliveRequestData at: i)]).
			serverUtilization at: i put: (serverUtilization at: i) // 9000.
			keepAliveRequestData at: i put: (keepAliveRequestData at: i) / 15.0 / 60.0.
			newRequestData at: i put: (newRequestData at: i) / 15.0 / 60.0].
	^(IdentityDictionary new)
		at: #labels put: labels;
		at: #newRequestData put: newRequestData;
		at: #keepAliveRequestData put: keepAliveRequestData;
		at: #serverUtilization put: serverUtilization;
		at: #minDuration put: minDuration;
		at: #maxDuration put: maxDuration;
		at: #avgDuration put: avgDuration;
		at: #peakMemoryUsage put: peakMemoryUsage;
		yourself!

getDataSeriesForHttpServerTheLastHour
	| ts array newRequestData keepAliveRequestData labels serverUtilization minDuration maxDuration avgDuration memoryUsage |
	array := WebHttpServer current getRequestCounterArrayForLastNminutes: 60.
	labels := LookupTable new.
	newRequestData := Array new: 60.
	keepAliveRequestData := Array new: 60.
	serverUtilization := Array new: 60.
	minDuration := Array new: 60.
	maxDuration := Array new: 60.
	avgDuration := Array new: 60.
	memoryUsage := Array new: 60.
	ts := Timestamp now.
	array reverse doWithIndex: 
			[:each :index | 
			keepAliveRequestData at: 61 - index put: (each at: 2).
			newRequestData at: 61 - index put: (each at: 1).
			serverUtilization at: 61 - index put: ((each at: 5) - (each at: 4)) // 600.
			memoryUsage at: 61 - index put: (each at: 6).
			minDuration at: 61 - index put: (each at: 3).
			maxDuration at: 61 - index put: (each at: 4).
			avgDuration at: 61 - index
				put: ((each at: 2) = 0 
						ifTrue: [0]
						ifFalse: 
							[(each at: 2) - 1 = 0 
								ifTrue: [(each at: 5) // (each at: 2)]
								ifFalse: 
									["ce je samo en ekstrem se ne uposteva pri racunanju povprecja"
									((each at: 5) - (each at: 4)) // ((each at: 2) - 1)]]).
			ts time minutes \\ 5 = 0 
				ifTrue: 
					[labels at: (ts time hours asLeadingZerosStringOfSize: 2) , ':' 
								, (ts time minutes asLeadingZerosStringOfSize: 2)
						put: 61 - index].
			ts := Timestamp fromSeconds: ts asSeconds - 60].
	1 to: serverUtilization size
		do: 
			[:i | 
			keepAliveRequestData at: i put: (keepAliveRequestData at: i) / 60.0.
			newRequestData at: i put: (newRequestData at: i) / 60.0].
	^(IdentityDictionary new)
		at: #labels put: labels;
		at: #newRequestData put: newRequestData;
		at: #keepAliveRequestData put: keepAliveRequestData;
		at: #serverUtilization put: serverUtilization;
		at: #minDuration put: minDuration;
		at: #maxDuration put: maxDuration;
		at: #avgDuration put: avgDuration;
		at: #memoryUsage put: memoryUsage;
		yourself!

getErrorLogNodeArrayFor: timestamp sessionData: sessionData stackFramePos: stackFramePos readStream: rs 
	^rs isFileStream 
		ifTrue: 
			[Array 
				with: timestamp
				with: sessionData
				with: stackFramePos
				with: rs position]
		ifFalse: 
			["for remote server error log the error has to be kept in the memory since the file can not be accesseds"
			| len |
			len := rs position - stackFramePos.
			rs position: stackFramePos.
			Array 
				with: timestamp
				with: sessionData
				with: (rs next: len)
				with: nil]!

getErrorLogStackFrameFor: errorLogNode 
	| rs str |
	(errorLogNode at: 3) isString ifTrue: [^errorLogNode at: 3].
	rs := FileStream read: self errorLogFilename text: true.
	
	[rs position: (errorLogNode at: 3).
	str := rs next: (((errorLogNode at: 4) + 2048 min: rs size) - (errorLogNode at: 3) min: 102400)] 
			ensure: [rs close].
	^str!

getLiveUpdateDivNameForClass: aClass 
	^aClass printString webEncrypted!

imagesServerUrl
	"Answer URL address of the central server from which images can be downloaded into HTTP root directory."

	^nil!

initialize
	| tabs |
	super initialize.
	errorLogFormArgs := ItcLookupTable new.
	errorLogFormArgs
		at: #errorLogDateFrom put: Date today;
		at: #errorLogTailSize put: 1.
	formFields := LookupTable new.
	formFields
		at: #upgradeAllServersInCluster put: true;
		at: 'serverPort' put: WebHttpServer current serverPort;
		at: 'noAsp' put: false.
	tabs := HtmlSingleTaskNavigationTabs new.
	self parentTopNavigation: tabs.
	tabs
		addTab: 'Uploads'
			task: self
			action: #processDefault:on:;
		addTab: 'Server message'
			task: self
			action: #processServerMessage:on:;
		addTab: 'Sessions'
			task: self
			action: #processShowCurrentSessions:on:;
		addTab: 'Processes'
			task: self
			action: #processShowProcesses:on:;
		addTab: 'Statistics'
			task: self
			action: #processShowServerStatistics:on:;
		addTab: 'Memory'
			task: self
			action: #processShowMemoryUsage:on:;
		addTab: 'ERROR.LOG'
			task: self
			action: #processErrorLog:on:;
		addTab: 'SERVER_LOG'
			task: self
			action: 'downloadServerLog'.
	self canDoApplicationAdministration 
		ifTrue: 
			[ItcSystemManager isRunningOnWindows 
				ifTrue: 
					[tabs 
						addTab: 'CMD prompt'
						task: self
						action: #processCommandLine:on:].
			tabs 
				addTab: 'SQL prompt'
				task: self
				action: #processSqlPrompt:on:].
	tabs 
		addTab: 'Live update'
		task: self
		action: #processLiveUpdate:on:!

newImageFilename
	| path filename postfix |
	path := ItcSystemManager startUpDirectoryPath , ItcSystemManager imageFilename , '_' 
				, Timestamp now asFilenameString.
	postfix := 0.
	filename := path , '.exe'.
	[ItcSystemManager fileExists: filename] whileTrue: 
			[postfix := postfix + 1.
			filename := path , '_' , postfix printString , '.exe'.
			postfix >= 10 ifTrue: [^nil]].
	^filename!

parseErrorLog
	| rs nodes uniquenessDict dateFrom tailSize perServerErrorLogs |
	ItcSystemManager logLineWithTsAndSession: 'Parsing ERROR.LOG'.
	dateFrom := errorLogFormArgs at: #errorLogDateFrom.
	errorLogNodes := nil.
	nodes := LookupTable new.
	uniquenessDict := LookupTable new.
	tailSize := ((errorLogFormArgs at: #errorLogTailSize) ifNil: [2]) * 1024 * 1024.
	application serverClusterManager isNil 
		ifFalse: 
			[perServerErrorLogs := LookupTable new.
			application serverClusterManager forEveryOtherClusterMemberDo: 
					[:eachServerUrl :eachManager | 
					perServerErrorLogs at: eachServerUrl
						put: [eachManager getErrorLogFileContentsForTheLastNBytes: tailSize] itcDeferredValue]].
	"first parse local ERROR.LOG"
	[rs := FileStream read: self errorLogFilename text: true] on: Error do: [:ex | ].
	rs isFileStream 
		ifTrue: 
			[
			[rs position: (rs size - tailSize max: 0).
			self 
				parseErrorLogStream: rs
				dateFrom: dateFrom
				uniquenessDict: uniquenessDict
				addTo: nodes
				forServer: (application serverClusterManager 
						ifNil: ['localhost']
						ifNotNil: [:value | value myServerUrl])] 
					ensure: [rs close]].
	"update list with local nodes"
	errorLogNodes := nodes copy.
	"parse other nodes and update list accordingly"
	perServerErrorLogs isNil 
		ifFalse: 
			[| done errorString counter |
			counter := 0.
			[perServerErrorLogs isEmpty] whileFalse: 
					[done := Set new.
					counter := counter + 1.
					counter > 1 
						ifTrue: 
							[(Delay forSeconds: 1) wait.
							counter > 500 
								ifTrue: [self error: 'Could no parse ERROR.LOG on servers ' , perServerErrorLogs keys asWebString]].
					perServerErrorLogs keysAndValuesDo: 
							[:eachServerUrl :eachValueHolder | 
							eachValueHolder hasValue 
								ifTrue: 
									[done add: eachServerUrl.
									errorString := nil.
									[errorString := eachValueHolder value] on: Error do: [:ex | ].
									errorString isNil 
										ifFalse: 
											[self 
												parseErrorLogStream: (ReadStream on: errorString)
												dateFrom: dateFrom
												uniquenessDict: uniquenessDict
												addTo: nodes
												forServer: eachServerUrl]]].
					done do: [:each | perServerErrorLogs removeKey: each].
					errorLogNodes := nodes copy]].
	errorLogNodes := nodes.
	errorLogParsingProcess := nil!

parseErrorLogStream: rs dateFrom: dateFrom uniquenessDict: uniquenessDict addTo: nodes forServer: serverName 
	| pendingLine pos line |
	pendingLine := nil.
	[rs atEnd and: [pendingLine isNil]] whileFalse: 
			[pendingLine isNil 
				ifTrue: 
					[pos := rs position.
					line := rs nextLine]
				ifFalse: 
					[pos := rs position - pendingLine size - 2.
					line := pendingLine.
					pendingLine := nil].
			(line beginsWith: 'Error at 20') 
				ifTrue: 
					[pendingLine := self 
								parseErrorNodeFrom: rs
								line: line
								pos: pos
								addTo: nodes
								dict: uniquenessDict
								dateFrom: dateFrom
								forServer: serverName]]!

parseErrorNodeFrom: rs line: firstLine pos: pos addTo: nodes dict: uniquenessDict dateFrom: dateFrom forServer: serverName 
	| time date sessionData timestamp line description stackFramePos wasEmpty |
	firstLine size >= 28 ifFalse: [^nil].
	date := ItcConverter getDateYYYYMMDD: (firstLine copyFrom: 10 to: 17).
	time := Time 
				hours: (firstLine copyFrom: 19 to: 20) itcAsInteger
				minutes: (firstLine copyFrom: 21 to: 22) itcAsInteger
				seconds: (firstLine copyFrom: 23 to: 24) itcAsInteger
				milliseconds: (firstLine copyFrom: 26 to: 28) itcAsInteger.
	timestamp := Timestamp date: date time: time.
	rs atEnd ifTrue: [^nil].
	line := rs nextLine.
	(line beginsWith: 'User: ') ifFalse: [^nil].
	sessionData := (line copyFrom: 7) asWebString , '[@' , serverName , ']'.
	rs atEnd ifTrue: [^nil].
	line := rs nextLine.
	(line beginsWith: 'Description: ') ifFalse: [^nil].
	description := line copyFrom: 13.
	rs atEnd ifTrue: [^nil].
	
	[line := rs nextLine.
	line isEmpty] whileFalse: 
				[description := description , ' ' , line.
				rs atEnd ifTrue: [^nil]].
	description := uniquenessDict at: description
				ifAbsentPut: [(uniquenessDict size + 1 asLeadingZerosStringOfSize: 6) , ':' , description].
	stackFramePos := rs position.
	[rs atEnd] whileFalse: 
			[line := rs nextLine.
			(wasEmpty = true and: [line beginsWith: 'Error at 20']) 
				ifTrue: 
					[(dateFrom isNil or: [timestamp date >= dateFrom]) 
						ifTrue: 
							[(nodes at: description ifAbsentPut: [OrderedCollection new: 1]) add: (self 
										getErrorLogNodeArrayFor: timestamp
										sessionData: sessionData
										stackFramePos: stackFramePos
										readStream: rs)].
					^line].
			wasEmpty := line isEmpty].
	(dateFrom isNil or: [timestamp date >= dateFrom]) 
		ifTrue: 
			[(nodes at: description ifAbsentPut: [OrderedCollection new: 1]) add: (self 
						getErrorLogNodeArrayFor: timestamp
						sessionData: sessionData
						stackFramePos: stackFramePos
						readStream: rs)].
	^nil!

parseLiveUpdateSourceString: sourceString errors: errors 
	| rs result coll line tokens className classObject |
	coll := OrderedCollection new.
	rs := ReadStream on: sourceString.
	
	[line := rs nextLine.
	line trimBlanks isEmpty 
		ifFalse: 
			[(line notEmpty and: ['!!* methodsFor*!!' match: line]) 
				ifFalse: 
					[errors at: 'sourceString' put: 'Invalid beginning of chunk. Can not find class name in: ' , line.
					^nil].
			tokens := line itcSubStrings: $ .
			className := tokens first copyFrom: 2.
			tokens size >= 2 
				ifFalse: 
					[errors at: 'sourceString' put: 'Invalid beginning of chunk. Can not find class name in: ' , line.
					^nil].
			(classObject := className asSymbol itcAsClassOrNil) isNil 
				ifTrue: 
					[errors at: 'sourceString' put: 'Class ' , className , ' not found in the server image: ' , line.
					^nil].
			(tokens at: 2) = 'class' ifTrue: [classObject := classObject class].
			result := self parseLiveUpdateSourceStringMethodsFrom: rs errors: errors.
			result isNilOrEmpty 
				ifTrue: 
					[errors at: 'sourceString'
						put: 'No methods for class ' , className , ' found in the uploaded source code'.
					^nil].
			coll add: classObject -> result].
	rs atEnd] 
			whileFalse: [].
	^coll!

parseLiveUpdateSourceStringMethodFrom: rs errors: errors 
	| ws ch |
	ws := WriteStream on: String new.
	[rs atEnd] whileFalse: 
			[ch := rs next.
			ch = $!! ifTrue: [rs peek = $!! ifTrue: [rs next] ifFalse: [^ws contents trimSeparators]].
			ws nextPut: ch].
	^ws contents trimSeparators!

parseLiveUpdateSourceStringMethodsFrom: rs errors: errors 
	"Private - Answer source code of methods in chunked source. Parse until double delimiter is found for ending source methods of a class !! !! or EOF"

	| coll methodSource |
	coll := OrderedCollection new.
	[rs atEnd] whileFalse: 
			[methodSource := self parseLiveUpdateSourceStringMethodFrom: rs errors: errors.
			methodSource isNilOrEmpty ifFalse: [coll add: methodSource] ifTrue: [^coll]].
	^coll!

process: request on: stream 
	parentTopNavigation isNil ifFalse: [parentTopNavigation selectedTask: self action: request action].
	^self 
		dispatch: request
		using: #('default' 'uploadApplication' 'restartApplication' 'startUploadedApplication' 'downloadServerLog' 'restartApplication' #processShowProcessesKillPID:on: #processShowProcesses:on: #processShowProcessesPerformGC:on: #processShowProcessesCheckImageConsistency:on: 'commandLine' 'commandLineRun' #processShowMemoryUsage:on: #processShowMemoryUsageRefresh:on: #processShowMemoryUsagePerformGC:on: #processShowMemoryUsageCheckImageConsistency:on: #processShowCurrentSessions:on: #processShowCurrentSessionsAndPurge:on: #processShowCurrentSessionsAndRestartScavenger:on: #processRemoveSession:on: 'serverMessage' 'serverMessageSet' 'showPartner' 'serverMessageSetAndBlockLogins' 'serverMessageSetAndUnblockLogins' 'backupDatabase' 'backupFiles' 'sqlPrompt' 'sqlPromptExecute' 'sqlPromptRunQuery' #processRestartApplicationAtGivenTime #processUploadDatabaseBackup #processVacuumDatabase #processDatabaseClose:on: #processLiveUpdate:on: #processLiveUpdateUploadPatch:on: #processErrorLogDownload:on: #processErrorLog:on: #processErrorLogReload:on: #processDownloadImagesFromCentralServer #processShowServerStatisticsPerformanceLogDownload:on: #processShowServerStatistics:on: #processShowServerStatisticsForLast24hours:on: #processShowServerStatisticsForDbReadAccessLast60min:on: #processShowServerStatisticsForDbWriteAccessLast60min:on: #processUploadAppFile:on: #processUploadAndBroadcastAppFile:on: #processLiveUpdateDoIt:on: #processReloadNlsFiles:on:)
		on: stream
		withDefault: 'default'!

processBackupDatabase: request on: stream 
	ItcSystemManager logLineWithTsAndSession: 'Starting database backup.'.
	ItcSystemManager startUpSessionManager makePsqlBackupFor: application.
	self processDefault: request on: stream!

processBackupFiles: request on: stream 
	ItcSystemManager logLineWithTsAndSession: 'Starting files backup.'.
	ItcSystemManager startUpSessionManager makeFileBackupFor: application.
	self processDefault: request on: stream!

processCommandLine: request on: stream 
	(self canDoApplicationAdministration and: [ItcSystemManager isRunningOnWindows]) 
		ifFalse: [^self processNoAccess: request on: stream].
	(self newCoder: stream) applicationAdministrationCommandLine: ItcLookupTable new errors: nil!

processCommandLineRun: request on: stream 
	| script output fileStream fileName |
	(self canDoApplicationAdministration and: [ItcSystemManager isRunningOnWindows]) 
		ifFalse: [^self processNoAccess: request on: stream].
	script := request stringAt: 'cmd'.
	fileName := 'WEB_ADMIN_SCRIPT_' , Timestamp now asFilenameString , '.bat'.
	fileStream := FileStream write: fileName mode: #truncate.
	
	[fileStream
		nextPutAll: script;
		cr;
		nextPutAll: 'exit';
		cr] ensure: [fileStream close].
	output := ItcSystemManager isRunningOnWindows 
				ifTrue: [ItcSystemManager startExternalProgram: fileName maxSecondsToRun: 60]
				ifFalse: [ItcSystemManager startExternalProgramScript: script].
	(self newCoder: stream) applicationAdministrationCommandLine: ((ItcLookupTable new)
				at: 'cmd' put: script;
				at: 'result' put: output;
				yourself)
		errors: nil!

processDatabaseClose: request on: stream 
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	ItcSystemManager logLineWithTsAndSession: 'Closing down database connections...'.
	application databaseClose.
	self processDefault: request on: stream!

processDefault: request on: stream 
	self 
		sendPreviewPageOn: stream
		error: nil
		errors: nil!

processDownloadImagesFromCentralServer
	| newDir |
	self imagesServerUrl isNilOrEmpty 
		ifFalse: 
			[ItcSystemManager logLineWithTsAndSession: 'Starting download of images from central server...'.
			newDir := application applicationRootDirectory , 'images-bck' , Timestamp now asSeconds printString.
			(ItcSystemManager directoryCreate: newDir) 
				ifTrue: 
					[ItcSystemManager 
						startExternalProgramScript: 'xcopy ' , application webFilesPath 
								, ItcSystemManager pathSeparatorString , 'images' 
								, ItcSystemManager pathSeparatorString , '*.* ' 
								, newDir , ' /E /Y /R /C'.
					application installerClass new downloadAndSaveImagesFrom: self imagesServerUrl.
					ItcSystemManager 
						logLineWithTsAndSession: 'Done downloading of images from central server. Backup saved to: ' 
								, newDir]
				ifFalse: 
					[ItcSystemManager 
						logLineWithTsAndSession: 'Downloading of images failed, because no backup directory could be created.']].
	self processDefault: self webRequest on: self webStream!

processDownloadServerLog: request on: stream 
	| fileStream filename contents |
	ItcSystemManager logLineWithTsAndSession: 'Downloading SERVER_LOG.TXT'.
	filename := ItcSystemManager serverLogStreamFilename.
	(filename notNil and: [ItcSystemManager fileExists: filename]) 
		ifTrue: 
			[fileStream := FileStream read: filename text: true.
			[contents := fileStream upToEnd] ensure: [fileStream close]].
	stream
		attachmentFilename: 'SERVER_LOG.TXT';
		contentType: 'text/plain'.
	contents isNil 
		ifTrue: [stream nextPutAll: 'No server error log found!!']
		ifFalse: [stream nextPutAll: contents]!

processErrorLog: request on: stream 
	errorLogNodes isNil 
		ifTrue: 
			[ItcSystemManager logLineWithTsAndSession: 'About to parse ERROR.LOG...'.
			self startErrorLogParsingProcess].
	self newCoder 
		applicationAdministrationErrorLogPage: errorLogNodes
		errors: nil
		args: errorLogFormArgs!

processErrorLogDownload: request on: stream 
	| fileStream contents |
	ItcSystemManager logLineWithTsAndSession: 'Downloading ERROR.LOG'.
	[fileStream := FileStream read: self errorLogFilename text: true] on: Error
		do: [:ex | ex exitWith: nil].
	fileStream isFileStream 
		ifTrue: 
			[
			["download up to 2 MB of file"
			fileStream size > 2097152 
				ifTrue: 
					[fileStream
						position: fileStream size - 2097152;
						nextLine].
			contents := fileStream upToEnd] 
					ensure: [fileStream close]].
	stream
		attachmentFilename: 'errorLog' , Timestamp now totalSeconds printString , '.txt';
		contentType: 'text/plain'.
	contents isNil 
		ifTrue: [stream nextPutAll: 'No error log found!!']
		ifFalse: [stream nextPutAll: contents]!

processErrorLogReload: request on: stream 
	errorLogFormArgs
		at: #errorLogDateFrom put: (request dateAt: #errorLogDateFrom);
		at: #errorLogTailSize put: (request integerAt: #errorLogTailSize).
	self startErrorLogParsingProcess.
	errorLogNodes := nil.
	self newCoder 
		applicationAdministrationErrorLogPage: errorLogNodes
		errors: nil
		args: errorLogFormArgs!

processLiveUpdate: request on: stream 
	self newCoder applicationAdministrationLiveUpdatePage: ItcLookupTable new errors: nil!

processLiveUpdateDoIt: request on: stream 
	| sourceString args errors coll classObject liveUpdatesCompleted |
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	sourceString := request stringOrNilAt: 'sourceString'.
	args := ItcLookupTable new.
	errors := ItcLookupTable new.
	args at: 'sourceString' put: sourceString.
	liveUpdatesCompleted := OrderedCollection new.
	sourceString isNilOrEmpty 
		ifFalse: 
			["compile patches here"
			sourceString := '!!' , self class name asString 
						, ' methodsFor: ''live update'' stamp: ''brezveze''!!
liveUpdateJustDoIt

' , sourceString 
						, '!! !!
'.
			(coll := self parseLiveUpdateSourceString: sourceString errors: errors) isNilOrEmpty 
				ifFalse: 
					[errors isNilOrEmpty 
						ifTrue: 
							[self class methodDictionary removeKey: #liveUpdateJustDoIt ifAbsent: [].
							coll do: 
									[:eachAssociation | 
									classObject := eachAssociation key.
									eachAssociation value do: 
											[:eachMethodSource | 
											(ItcSystemManager compileRuntimePatchForClass: classObject methodSource: eachMethodSource) = false 
												ifTrue: 
													[errors at: 'sourceString'
														put: ((errors at: 'sourceString') 
																add: 'Could not compile: ' , classObject printString , '>>' , eachMethodSource lines first
																withDelimiter: '
')]
												ifFalse: [liveUpdatesCompleted add: (Association key: classObject value: eachMethodSource)]]].
							errors isNilOrEmpty 
								ifTrue: 
									[ItcSystemManager logLineWithTsAndSession: 'Live update DO IT evaluating: ' , sourceString.
									args at: 'doItResult' put: self liveUpdateJustDoIt]]]].
	application onLiveUpdatePerformed: liveUpdatesCompleted.
	self newCoder applicationAdministrationLiveUpdatePage: args errors: errors!

processLiveUpdateUploadPatch: request on: stream 
	| sourceString args errors coll classObject liveUpdatesCompleted |
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	sourceString := request stringOrNilAt: 'sourceString'.
	args := ItcLookupTable new.
	errors := ItcLookupTable new.
	args at: 'sourceString' put: sourceString.
	liveUpdatesCompleted := OrderedCollection new.
	sourceString isNilOrEmpty 
		ifFalse: 
			["compile patches here"
			(coll := self parseLiveUpdateSourceString: sourceString errors: errors) isNilOrEmpty 
				ifFalse: 
					[errors isNilOrEmpty 
						ifTrue: 
							[coll do: 
									[:eachAssociation | 
									classObject := eachAssociation key.
									eachAssociation value do: 
											[:eachMethodSource | 
											(ItcSystemManager compileRuntimePatchForClass: classObject methodSource: eachMethodSource) = false 
												ifTrue: 
													[errors at: 'sourceString'
														put: ((errors at: 'sourceString') 
																add: 'Method could not compile: ' , classObject printString , '>>' , eachMethodSource lines first
																withDelimiter: '
')]
												ifFalse: [liveUpdatesCompleted add: (Association key: classObject value: eachMethodSource)]]]]]].
	application onLiveUpdatePerformed: liveUpdatesCompleted.
	self newCoder applicationAdministrationLiveUpdatePage: args errors: errors!

processNoAccess: request on: stream 
	self processDefault: request on: stream!

processReloadNlsFiles: request on: stream 
	ItcSystemManager logLineWithTsAndSession: 'Doing NLS files reload.'.
	application reloadMessages.
	application serverClusterManager isNil ifFalse: [application serverClusterManager onReloadMessages].
	self processDefault: request on: stream!

processRemoveSession: request on: stream 
	| sessionId sessionToRemove |
	sessionId := request stringAt: 'id'.
	sessionToRemove := application sessionAt: sessionId.
	sessionToRemove isNil ifFalse: [application removeSession: sessionToRemove].
	self processShowCurrentSessions: request on: stream!

processRestartApplication: request on: stream 
	ItcSystemManager logLineWithTsAndSession: 'Soft server restart'.
	application
		shutdown;
		startup.
	stream redirectResponseTo: self taskURLPrefix!

processRestartApplicationAtGivenTime
	| port startParameters restartTime errors error |
	self canDoApplicationAdministration 
		ifFalse: [^self processNoAccess: self webRequest on: self webStream].
	errors := LookupTable new.
	(restartTime := self webRequest timeAt: #autoUpgradeTime) isNil 
		ifTrue: [errors at: #autoUpgradeTime put: 'asp.error.MandatoryEntry'].
	self updateUploadFormFields: formFields request: self webRequest.
	error := (WebApplicationAdministrationManager newExecutableFileName isNilOrEmpty or: 
					[(ItcSystemManager fileExists: ItcSystemManager startUpDirectoryPath 
								, WebApplicationAdministrationManager newExecutableFileName) 
						not]) 
				ifTrue: ['Can not schedule server restart. New version file is not set or does not exist.'].
	(error isNilOrEmpty and: [errors isNilOrEmpty]) 
		ifTrue: 
			[(port := formFields at: 'serverPort') isNil ifTrue: [port := application webServer serverPort].
			startParameters := (formFields at: 'noAsp') == true ifTrue: ['-noasp '] ifFalse: [''].
			WebApplicationAdministrationManager 
				scheduleApplicationServerRestartAt: restartTime
				port: port
				startParameters: startParameters
				serverClusterManager: ((formFields at: #upgradeAllServersInCluster) = true 
						ifTrue: [application serverClusterManager])].
	self 
		sendPreviewPageOn: self webStream
		error: error
		errors: errors!

processServerMessage: request on: stream 
	(self newCoder: stream) applicationAdministrationSetServerMessage!

processServerMessageSet: request on: stream 
	ItcSystemManager 
		logLineWithTsAndSession: 'Setting server message to: ' , (request stringAt: 'serverMessage').
	application serverMessage: (request stringOrNilAt: 'serverMessage') distributed: true.
	(self newCoder: stream) applicationAdministrationSetServerMessage!

processServerMessageSetAndBlockLogins: request on: stream 
	ItcSystemManager 
		logLineWithTsAndSession: 'Setting server message and blocking login for non-admins. Server message: ' 
				, (request stringAt: 'serverMessage').
	application serverMessage: (request stringOrNilAt: 'serverMessage').
	application configurationSettingsAt: #serverBlocked put: true.
	(self newCoder: stream) applicationAdministrationSetServerMessage!

processServerMessageSetAndUnblockLogins: request on: stream 
	ItcSystemManager 
		logLineWithTsAndSession: 'Setting server message and unblocking login for non-admins. Server message: ' 
				, (request stringAt: 'serverMessage').
	application serverMessage: (request stringOrNilAt: 'serverMessage').
	application configurationSettingsAt: #serverBlocked put: false.
	(self newCoder: stream) applicationAdministrationSetServerMessage!

processShowCurrentSessions: request on: stream 
	(self newCoder: stream) applicationAdministrationCurrentSessionsPage: (application activeSessions 
				asSortedCollection: [:a :b | b expirationTime < a expirationTime])!

processShowCurrentSessionsAndPurge: request on: stream 
	application purgeExpiredSessions.
	(self newCoder: stream) applicationAdministrationCurrentSessionsPage: (application activeSessions 
				asSortedCollection: [:a :b | b expirationTime < a expirationTime])!

processShowCurrentSessionsAndRestartScavenger: request on: stream 
	application restartScavengerProcess.
	(self newCoder: stream) applicationAdministrationCurrentSessionsPage: (application activeSessions 
				asSortedCollection: [:a :b | b expirationTime < a expirationTime])!

processShowMemoryUsage: request on: stream 
	(self newCoder: stream) 
		applicationAdministrationShowMemoryUsagePage: self getCachedMemoryUsageStatistics!

processShowMemoryUsageCheckImageConsistency: request on: stream 
	ItcSystemManager checkImageConsistency.
	(self newCoder: stream) 
		applicationAdministrationShowMemoryUsagePage: self getCachedMemoryUsageStatistics!

processShowMemoryUsagePerformGC: request on: stream 
	ItcSystemManager globalGarbageCollect.
	(self newCoder: stream) 
		applicationAdministrationShowMemoryUsagePage: self getCachedMemoryUsageStatistics!

processShowMemoryUsageRefresh: request on: stream 
	| stats |
	stats := self getCachedMemoryUsageStatistics.
	stats = false 
		ifFalse: 
			["if it is not in the middle of calculating the statistics, then take another snapshot"
			WebApplicationAdministrationManager 
				recordMemoryUsageStatistics: [self getCurrentMemoryUsage] itcDeferredValue].
	(self newCoder: stream) applicationAdministrationShowMemoryUsagePage: stats!

processShowProcesses: request on: stream 
	(self newCoder: stream) applicationAdministrationShowProcessesPage: (Processor allProcesses 
				asSortedCollection: (ItcSortBlock with: #priority with: #itcProcessId))!

processShowProcessesCheckImageConsistency: request on: stream 
	ItcSystemManager checkImageConsistency.
	(self newCoder: stream) applicationAdministrationShowProcessesPage: (Processor allProcesses 
				asSortedCollection: (ItcSortBlock with: #priority with: #itcProcessId))!

processShowProcessesKillPID: request on: stream 
	self canDoApplicationAdministration 
		ifTrue: 
			[| pid processes |
			pid := request stringAt: 'id'.
			processes := Processor allProcesses select: [:each | each itcProcessId asWebString = pid].
			processes size = 1 ifTrue: [processes first itcSafeTerminate]].
	self processShowProcesses: request on: stream!

processShowProcessesPerformGC: request on: stream 
	ItcSystemManager globalGarbageCollect.
	(self newCoder: stream) applicationAdministrationShowProcessesPage: (Processor allProcesses 
				asSortedCollection: (ItcSortBlock with: #priority with: #itcProcessId))!

processShowServerStatistics: request on: stream 
	(self newCoder: stream) applicationAdministrationShowServerStatisticsForLast60minutes: self 
				getDataSeriesForHttpServerTheLastHour!

processShowServerStatisticsForDbReadAccessLast60min: request on: stream 
	(self newCoder: stream) 
		applicationAdministrationShowServerStatisticsForDbReadAccessLast60minutes: self 
				getDataSeriesForDbReadStatisticsTheLastHour!

processShowServerStatisticsForDbWriteAccessLast60min: request on: stream 
	(self newCoder: stream) 
		applicationAdministrationShowServerStatisticsForDbWriteAccessLast60minutes: self 
				getDataSeriesForDbWriteStatisticsTheLastHour!

processShowServerStatisticsForLast24hours: request on: stream 
	(self newCoder: stream) applicationAdministrationShowServerStatisticsForLast24hours: self 
				getDataSeriesForHttpServerTheLast24Hours!

processShowServerStatisticsPerformanceLogDownload: request on: stream 
	| ts array |
	self 
		setContentTypeFrom: request
		on: stream
		withDefault: 'DelimitedText'
		filename: 'performance_log.txt'.
	stream
		nextPutAll: 'Index	Timestamp	Hour	Minutes	New requests	Requests	Min duration	Max duration	Average duration	Total duration	Utilization';
		cr.
	ts := Timestamp now.
	array := WebHttpServer current getRequestCounterArrayForLastNminutes: 1440.
	array reverse doWithIndex: 
			[:each :index | 
			stream
				nextPutAll: index printString;
				tab;
				nextPutAll: ts asWebString;
				tab;
				nextPutAll: ts time hours printString;
				tab;
				nextPutAll: ts time minutes printString;
				tab;
				nextPutAll: (each at: 1) printString;
				tab;
				nextPutAll: (each at: 2) printString;
				tab;
				nextPutAll: (each at: 3) printString;
				tab;
				nextPutAll: (each at: 4) printString;
				tab;
				nextPutAll: ((each at: 2) = 0 
							ifTrue: ['0']
							ifFalse: [((each at: 5) / (each at: 2) roundTo: 0.01s) asXmlString]);
				tab;
				nextPutAll: (each at: 5) printString;
				tab;
				nextPutAll: ((each at: 5) / 60000 roundTo: 0.01s) asXmlString;
				cr.
			ts := Timestamp fromSeconds: ts asSeconds - 60]!

processSqlPrompt: request on: stream 
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	(self newCoder: stream) 
		applicationAdministrationSQLPrompt: ItcLookupTable new
		errors: nil
		resultTable: nil!

processSqlPromptExecute: request on: stream 
	| script output timeBegin duration |
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	script := request stringAt: 'cmd'.
	output := WriteStream on: String new.
	ItcSystemManager logLineWithTsAndSession: 'Executing SQL script:
---
' , script , '
---'.
	timeBegin := ItcSystemManager absoluteMillisecondsClockValue.
	application db safeExecuteSql: script log: output.
	duration := ItcSystemManager absoluteMillisecondsClockValue - timeBegin.
	ItcSystemManager 
		logLineWithTsAndSession: 'Script executed in ' , duration asWebString , ' msec; result message: ' 
				, output contents asWebString.
	(self newCoder: stream) 
		applicationAdministrationSQLPrompt: ((ItcLookupTable new)
				at: 'cmd' put: script;
				at: 'result' put: output contents;
				at: 'duration' put: duration;
				yourself)
		errors: nil
		resultTable: nil!

processSqlPromptRunQuery: request on: stream 
	| script output timeBegin duration rows limit |
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	limit := request integerAt: 'limit'.
	(limit isNil or: [limit < 1]) ifTrue: [limit := 1000].
	script := request stringAt: 'cmd'.
	((script asUppercase beginsWithUppercase: 'SHOW ') 
		or: [script asUppercase beginsWithUppercase: 'EXPLAIN ']) ifTrue: [limit := nil].
	ItcSystemManager logLineWithTsAndSession: 'Starting SQL query:
---
' , script , '
---'.
	timeBegin := ItcSystemManager absoluteMillisecondsClockValue.
	[rows := application db rowsFromQuery: script limit: limit] on: Error
		do: 
			[:ex | 
			output := ex itcDescription.
			ex exitWith: nil].
	duration := ItcSystemManager absoluteMillisecondsClockValue - timeBegin.
	ItcSystemManager 
		logLineWithTsAndSession: 'Script executed in ' , duration asWebString , ' msec; result message: ' 
				, output asWebString.
	(self newCoder: stream) 
		applicationAdministrationSQLPrompt: ((ItcLookupTable new)
				at: 'cmd' put: script;
				at: 'result' put: output;
				at: 'duration' put: duration;
				yourself)
		errors: nil
		resultTable: rows!

processStartUploadedApplication: request on: stream 
	| result |
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	self updateUploadFormFields: formFields request: request.
	result := WebApplicationAdministrationManager 
				startUploadedApplication: application
				onPort: (formFields at: 'serverPort')
				additionalArguments: ((formFields at: 'noAsp') == true ifTrue: ['-noasp '])
				serverClusterManager: ((formFields at: #upgradeAllServersInCluster) = true 
						ifTrue: [application serverClusterManager]).
	self 
		sendPreviewPageOn: stream
		error: result
		errors: nil!

processUploadAndBroadcastAppFile: request on: stream 
	^self 
		processUploadAppFile: request
		on: stream
		broadcastAfterUpload: true!

processUploadAppFile: request on: stream 
	^self 
		processUploadAppFile: request
		on: stream
		broadcastAfterUpload: false!

processUploadAppFile: request on: stream broadcastAfterUpload: aBoolean 
	| file filename fileStream assoc destination uploadedFiles fileType |
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	destination := request stringAt: #uploadPath.
	assoc := self uploadDirectoriesValues detect: [:each | each key = destination]
				ifNone: [^self processDefault: request on: stream].
	formFields at: #uploadPath put: assoc key.
	destination := assoc value.
	(destination last = $/ or: [destination last = $\]) 
		ifFalse: [destination := destination , ItcSystemManager pathSeparatorString].
	ItcSystemManager directoryCreate: (destination copyFrom: 1 to: destination size - 1).
	uploadedFiles := OrderedCollection new.
	1 to: 6
		do: 
			[:i | 
			(file := request getAttachedFile: 'file' , i printString) isNil 
				ifFalse: 
					[filename := destination 
								, (((ItcSystemManager fileNameFromPath: file key) replaceAll: $\ with: ItcSystemManager pathSeparator) 
										replaceAll: $/
										with: ItcSystemManager pathSeparator).
					ItcSystemManager 
						logLineWithTsAndSession: 'Saving uploaded application file ' , filename asWebString.
					fileStream := FileStream write: filename text: false.
					[fileStream nextPutAll: file value] ensure: [fileStream close].
					uploadedFiles add: filename]].
	aBoolean = true 
		ifTrue: 
			[application serverClusterManager isNil 
				ifFalse: 
					[uploadedFiles do: 
							[:eachFilename | 
							fileType := assoc key = self uploadDirectoriesValues first key 
										ifTrue: [#startupPathFile]
										ifFalse: [#applicationRootFile].
							application serverClusterManager broadcastFileNamed: eachFilename fileType: fileType]]].
	self 
		sendPreviewPageOn: stream
		error: nil
		errors: nil!

processUploadApplication: request on: stream 
	| file filename fileStream platformID |
	self canDoApplicationAdministration ifFalse: [^self processNoAccess: request on: stream].
	platformID := (request symbolAt: #platformId) ifNil: [ItcSystemManager currentPlatformID].
	self updateUploadFormFields: formFields request: request.
	(file := request getAttachedFileAndUnzip: 'fileName') isNil 
		ifTrue: 
			[^self 
				sendPreviewPageOn: stream
				error: 'asp.error.NoFileWasUploaded'
				errors: nil].
	(filename := self newImageFilename) isNil 
		ifTrue: 
			[^self 
				sendPreviewPageOn: stream
				error: 'ApplicationAdministration.error.fileSaveFailed'
				errors: nil].
	ItcSystemManager logLineWithTsAndSession: 'Uploaded new version of server executable.'.
	fileStream := FileStream write: filename text: false.
	[fileStream nextPutAll: file value] ensure: [fileStream close].
	WebApplicationAdministrationManager 
		newExecutableFileName: (ItcSystemManager fileNameFromPath: filename)
		forPlatform: platformID.
	self 
		sendPreviewPageOn: stream
		error: nil
		errors: nil!

processUploadDatabaseBackup
	self canDoApplicationAdministration 
		ifFalse: [^self processNoAccess: self webRequest on: self webStream].
	ItcSystemManager logLineWithTsAndSession: 'Starting FTP upload of database backup.'.
	ItcSystemManager startUpSessionManager uploadLastBackupFor: application.
	self processDefault: self webRequest on: self webStream!

processVacuumDatabase
	| newProcess |
	ItcSystemManager logLineWithTsAndSession: 'Vacuuming database started'.
	newProcess := ItcSystemManager newProcessOn: 
					[(Processor activeProcess)
						language: session language;
						webSession: session.
					ItcSystemManager startUpSessionManager vacuumPsqlWindowsFor: application]
				named: 'User induced database vacuum'.
	newProcess
		priority: ItcSystemManager batchJobPriority;
		resume.
	self processDefault: self webRequest on: self webStream!

sendPreviewPageOn: stream error: error errors: errors 
	(self newCoder: stream) 
		applicationAdministrationPreviewPage: formFields
		error: error
		errors: errors!

startErrorLogParsingProcess
	(errorLogParsingProcess isNil or: [errorLogParsingProcess itcIsTerminated]) 
		ifTrue: 
			[errorLogParsingProcess := ItcSystemManager 
						forkNewProcessOn: [self parseErrorLog]
						named: 'Reading and parsing ERROR.LOG'
						priority: ItcSystemManager batchJobPriority]!

updateUploadFormFields: fields request: request 
	fields
		at: 'serverPort' put: (request integerAt: 'serverPort');
		at: 'noAsp' put: (request booleanAt: 'noAsp').
	(request formFieldNames includes: 'autoUpgradeTime') 
		ifTrue: 
			[fields
				at: #autoUpgradeTime put: (request timeAt: #autoUpgradeTime);
				at: #upgradeAllServersInCluster put: (request booleanAt: #upgradeAllServersInCluster)].
	^fields!

uploadDirectoriesValues
	^(OrderedCollection new)
		add: (Association key: '(startup path)' value: ItcSystemManager startUpDirectoryPath);
		add: (Association key: './' , application applicationPath value: application applicationRootDirectory);
		add: (Association key: './' , application applicationPath , '/http-root'
					value: application webFilesPath);
		add: (Association key: './' , application applicationPath , '/http-root/images'
					value: application webFilesPath , ItcSystemManager pathSeparatorString , 'images');
		add: (Association key: './' , application applicationPath , '/http-root/scripts'
					value: application webFilesPath , ItcSystemManager pathSeparatorString , 'scripts');
		add: (Association key: './' , application applicationPath , '/http-root/css'
					value: application webFilesPath , ItcSystemManager pathSeparatorString , 'css');
		add: (Association key: './' , application applicationPath , '/templates'
					value: application applicationRootDirectory , 'templates');
		add: (Association key: './' , application applicationPath , '/nls'
					value: application applicationRootDirectory , 'nls');
		add: (Association key: './' , application applicationPath , '/upgrades'
					value: application applicationRootDirectory , 'upgrades');
		add: (Association key: './' , application applicationPath , '/temp'
					value: application temporaryDirectoryPath);
		yourself! !
!WebApplicationAdministrationTask categoriesFor: #ajaxGetExpandErrorLogNode!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #ajaxGetExpandErrorLogSubnode!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #ajaxGetLiveUpdateExpandClass!private!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #ajaxGetLiveUpdateExpandMethod!private!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #allMemoryUsageTrackingClassPrefixes!public!tab Memory usage! !
!WebApplicationAdministrationTask categoriesFor: #canDoApplicationAdministration!public!user privileges! !
!WebApplicationAdministrationTask categoriesFor: #errorLogFilename!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #getCachedMemoryUsageStatistics!public!tab Memory usage! !
!WebApplicationAdministrationTask categoriesFor: #getCurrentMemoryUsage!public!tab Memory usage! !
!WebApplicationAdministrationTask categoriesFor: #getDataSeriesForDbReadStatisticsTheLastHour!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #getDataSeriesForDbWriteStatisticsTheLastHour!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #getDataSeriesForHttpServerTheLast24Hours!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #getDataSeriesForHttpServerTheLastHour!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #getErrorLogNodeArrayFor:sessionData:stackFramePos:readStream:!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #getErrorLogStackFrameFor:!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #getLiveUpdateDivNameForClass:!private!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #imagesServerUrl!private!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #initialize!public! !
!WebApplicationAdministrationTask categoriesFor: #newImageFilename!private!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #parseErrorLog!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #parseErrorLogStream:dateFrom:uniquenessDict:addTo:forServer:!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #parseErrorNodeFrom:line:pos:addTo:dict:dateFrom:forServer:!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #parseLiveUpdateSourceString:errors:!private!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #parseLiveUpdateSourceStringMethodFrom:errors:!private!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #parseLiveUpdateSourceStringMethodsFrom:errors:!private!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #process:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processBackupDatabase:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processBackupFiles:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processCommandLine:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processCommandLineRun:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processDatabaseClose:on:!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processDefault:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processDownloadImagesFromCentralServer!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processDownloadServerLog:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processErrorLog:on:!public!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #processErrorLogDownload:on:!public!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #processErrorLogReload:on:!public!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #processLiveUpdate:on:!public!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #processLiveUpdateDoIt:on:!public!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #processLiveUpdateUploadPatch:on:!public!tab Live update! !
!WebApplicationAdministrationTask categoriesFor: #processNoAccess:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processReloadNlsFiles:on:!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processRemoveSession:on:!public!tab Sessions! !
!WebApplicationAdministrationTask categoriesFor: #processRestartApplication:on:!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processRestartApplicationAtGivenTime!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processServerMessage:on:!public!tab Server message! !
!WebApplicationAdministrationTask categoriesFor: #processServerMessageSet:on:!public!tab Server message! !
!WebApplicationAdministrationTask categoriesFor: #processServerMessageSetAndBlockLogins:on:!public!tab Server message! !
!WebApplicationAdministrationTask categoriesFor: #processServerMessageSetAndUnblockLogins:on:!public!tab Server message! !
!WebApplicationAdministrationTask categoriesFor: #processShowCurrentSessions:on:!public!tab Sessions! !
!WebApplicationAdministrationTask categoriesFor: #processShowCurrentSessionsAndPurge:on:!public!tab Sessions! !
!WebApplicationAdministrationTask categoriesFor: #processShowCurrentSessionsAndRestartScavenger:on:!public!tab Sessions! !
!WebApplicationAdministrationTask categoriesFor: #processShowMemoryUsage:on:!public!tab Memory usage! !
!WebApplicationAdministrationTask categoriesFor: #processShowMemoryUsageCheckImageConsistency:on:!public!tab Memory usage! !
!WebApplicationAdministrationTask categoriesFor: #processShowMemoryUsagePerformGC:on:!public!tab Memory usage! !
!WebApplicationAdministrationTask categoriesFor: #processShowMemoryUsageRefresh:on:!public!tab Memory usage! !
!WebApplicationAdministrationTask categoriesFor: #processShowProcesses:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processShowProcessesCheckImageConsistency:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processShowProcessesKillPID:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processShowProcessesPerformGC:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processShowServerStatistics:on:!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #processShowServerStatisticsForDbReadAccessLast60min:on:!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #processShowServerStatisticsForDbWriteAccessLast60min:on:!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #processShowServerStatisticsForLast24hours:on:!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #processShowServerStatisticsPerformanceLogDownload:on:!public!tab Server statistics! !
!WebApplicationAdministrationTask categoriesFor: #processSqlPrompt:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processSqlPromptExecute:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processSqlPromptRunQuery:on:!public! !
!WebApplicationAdministrationTask categoriesFor: #processStartUploadedApplication:on:!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processUploadAndBroadcastAppFile:on:!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processUploadAppFile:on:!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processUploadAppFile:on:broadcastAfterUpload:!private!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processUploadApplication:on:!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processUploadDatabaseBackup!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #processVacuumDatabase!public!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #sendPreviewPageOn:error:errors:!private!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #startErrorLogParsingProcess!private!tab ERROR LOG! !
!WebApplicationAdministrationTask categoriesFor: #updateUploadFormFields:request:!private!tab Uploads! !
!WebApplicationAdministrationTask categoriesFor: #uploadDirectoriesValues!public!tab Uploads! !

