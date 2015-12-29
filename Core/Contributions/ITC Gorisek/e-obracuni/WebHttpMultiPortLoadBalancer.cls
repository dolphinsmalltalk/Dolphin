"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebHttpMultiPortLoadBalancer
	instanceVariableNames: 'alternativeHttpPorts alternativeHttpsPorts lastHttpPortIndex lastHttpsPortIndex httpConnections httpsConnections application mutex lastProposedHttpPortIndex lastProposedHttpsPortIndex counterMutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpMultiPortLoadBalancer guid: (GUID fromString: '{91AC6C95-0362-45A7-8862-A007181E5091}')!
WebHttpMultiPortLoadBalancer comment: ''!
!WebHttpMultiPortLoadBalancer categoriesForClass!Unclassified! !
!WebHttpMultiPortLoadBalancer methodsFor!

alternativeHttpPortsFromString: aString 
	| ports port |
	ports := OrderedCollection new.
	aString isNilOrEmpty 
		ifFalse: 
			[(aString itcSubStrings: $,) do: [:each | (port := each itcAsInteger) > 0 ifTrue: [ports add: port]]].
	alternativeHttpPorts := ports asArray!

alternativeHttpsPortsFromString: aString 
	| ports port |
	ports := OrderedCollection new.
	aString isNilOrEmpty 
		ifFalse: 
			[(aString itcSubStrings: $,) do: [:each | (port := each itcAsInteger) > 0 ifTrue: [ports add: port]]].
	alternativeHttpsPorts := ports asArray!

application
	^application!

application: anObject
	application := anObject!

bufferSize
	^100!

getNewHttpPortFor: request pageTag: pageTag 
	| coll n clientIP port |
	(alternativeHttpPorts includes: request requestPort) 
		ifTrue: 
			["already redirected"
			^nil].
	clientIP := request clientIP.
	n := alternativeHttpPorts size.
	mutex critical: 
			[n timesRepeat: 
					[lastHttpPortIndex := lastHttpPortIndex + 1.
					lastHttpPortIndex > n ifTrue: [lastHttpPortIndex := 1].
					port := alternativeHttpPorts at: lastHttpPortIndex.
					coll := httpConnections at: port ifAbsent: [].
					coll 
						do: [:eachArray | ((eachArray at: 1) = pageTag and: [(eachArray at: 2) = clientIP]) ifTrue: [^port]]]].
	^nil!

getNewHttpsPortFor: request pageTag: pageTag 
	| coll n clientIP port |
	(alternativeHttpsPorts includes: request requestPort) 
		ifTrue: 
			["already redirected"
			^nil].
	clientIP := request clientIP.
	n := alternativeHttpsPorts size.
	mutex critical: 
			[n timesRepeat: 
					[lastHttpsPortIndex := lastHttpsPortIndex + 1.
					lastHttpsPortIndex > n ifTrue: [lastHttpsPortIndex := 1].
					port := alternativeHttpsPorts at: lastHttpsPortIndex.
					coll := httpsConnections at: port ifAbsent: [].
					coll 
						do: [:eachArray | ((eachArray at: 1) = pageTag and: [(eachArray at: 2) = clientIP]) ifTrue: [^port]]]].
	^nil!

getNewPageTag
	^application getNewSessionId , '_' , Timestamp now totalSeconds printString!

getNewPortFor: request 
	| pageTag |
	(pageTag := request stringOrNilAt: 'pageTag') isNilOrEmpty ifTrue: [^nil].
	^request isHttps 
		ifTrue: [self getNewHttpsPortFor: request pageTag: pageTag]
		ifFalse: [self getNewHttpPortFor: request pageTag: pageTag]!

getOpenPortDetectionHtmlFragmentFor: request 
	^self getOpenPortDetectionHtmlFragmentFor: request pageTag: self getNewPageTag!

getOpenPortDetectionHtmlFragmentFor: request pageTag: pageTag 
	| urls ws str |
	(urls := self getOpenPortDetectionUrlsFor: request pageTag: pageTag) isNilOrEmpty ifTrue: [^nil].
	ws := WriteStream on: String new.
	ws
		nextPutAll: '<div id="oPD" style="visibility:hidden;position:absolute;top:0px;left:0px;width:5px;height:5px;overflow:hidden;"></div>';
		nextPutAll: '<input type="hidden" name="pageTag" id="pageTag" value="' 
					, pageTag webHtmlEncodedForForm , '" />';
		nextPutAll: #HtmlContainer itcAsClass javascriptBeginString;
		nextPutAll: 'function oPDsend(){try{';
		nextPutAll: (request isMozilla 
					ifTrue: ['document.getElementById("oPD")']
					ifFalse: ['document.all.oPD']);
		nextPutAll: '.innerHTML='.
	str := ''.
	urls doWithIndex: 
			[:eachUrl :eachIndex | 
			str := str , '<iframe id="oPD' , eachIndex printString , '" src="' , eachUrl 
						, '" style="width:5px;height:5px;"></iframe>'].
	ws
		nextPutAll: str asJavascriptValue;
		nextPutAll: ';}catch(e){}}';
		nextPutAll: 'var oPDpol=window.onload;
window.onload=new Function("if(oPDpol)oPDpol();oPDsend();");';
		nextPutAll: #HtmlContainer itcAsClass javascriptEndString.
	^ws contents!

getOpenPortDetectionUrlsFor: request pageTag: pageTag 
	"Vrne Array z URL naslovi na razlicnih portih, kjer detektira ali se lahko klient poveze preko drugega porta.
	Trenutno vsakic vrne samo en URL po round-robin algoritmu."

	| prefix postfix |
	(prefix := request requestHost) isNilOrEmpty ifTrue: [^nil].
	request isHttps 
		ifTrue: 
			[(alternativeHttpsPorts isEmpty or: [alternativeHttpsPorts includes: request requestPort]) 
				ifTrue: [^nil].
			prefix := 'https://' , prefix , ':'.
			postfix := '/' , application urlPrefix , '/T_O_P-' , pageTag , '.html'.
			counterMutex critical: 
					[(lastProposedHttpsPortIndex := lastProposedHttpsPortIndex + 1) > alternativeHttpsPorts size 
						ifTrue: [lastProposedHttpsPortIndex := 1]].
			^Array with: prefix , (alternativeHttpsPorts at: lastProposedHttpsPortIndex) printString , postfix]
		ifFalse: 
			[(alternativeHttpPorts isEmpty or: [alternativeHttpPorts includes: request requestPort]) 
				ifTrue: [^nil].
			prefix := 'http://' , prefix , ':'.
			postfix := '/' , application urlPrefix , '/T_O_P-' , pageTag , '.html'.
			counterMutex critical: 
					[(lastProposedHttpPortIndex := lastProposedHttpPortIndex + 1) > alternativeHttpPorts size 
						ifTrue: [lastProposedHttpPortIndex := 1]].
			^Array with: prefix , (alternativeHttpPorts at: lastProposedHttpPortIndex) printString , postfix]!

initialize
	lastHttpPortIndex := 0.
	lastHttpsPortIndex := 0.
	httpConnections := IdentityDictionary new.
	httpsConnections := IdentityDictionary new.
	alternativeHttpPorts 
		do: [:eachPort | httpConnections at: eachPort put: (OrderedCollection new: self bufferSize)].
	alternativeHttpsPorts 
		do: [:eachPort | httpsConnections at: eachPort put: (OrderedCollection new: self bufferSize)].
	mutex := Semaphore forMutualExclusion.
	"stevci za predlagane porte"
	lastProposedHttpPortIndex := 0.
	lastProposedHttpsPortIndex := 0.
	counterMutex := Semaphore forMutualExclusion!

rememberOpenPortFor: request 
	| port url coll pageTag |
	port := request requestPort.
	url := request header url reverse.
	pageTag := (url copyFrom: 6 to: (url indexOf: $-) - 1) reverse.
	coll := (request isHttps ifTrue: [httpsConnections] ifFalse: [httpConnections]) at: port
				ifAbsent: [].
	coll isNil 
		ifFalse: 
			[mutex critical: 
					[coll size < self bufferSize ifFalse: [coll removeLast].
					coll addFirst: (Array with: pageTag with: request clientIP)]]! !
!WebHttpMultiPortLoadBalancer categoriesFor: #alternativeHttpPortsFromString:!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #alternativeHttpsPortsFromString:!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #application!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #application:!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #bufferSize!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #getNewHttpPortFor:pageTag:!accessing!private! !
!WebHttpMultiPortLoadBalancer categoriesFor: #getNewHttpsPortFor:pageTag:!accessing!private! !
!WebHttpMultiPortLoadBalancer categoriesFor: #getNewPageTag!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #getNewPortFor:!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #getOpenPortDetectionHtmlFragmentFor:!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #getOpenPortDetectionHtmlFragmentFor:pageTag:!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #getOpenPortDetectionUrlsFor:pageTag:!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #initialize!accessing!public! !
!WebHttpMultiPortLoadBalancer categoriesFor: #rememberOpenPortFor:!accessing!public! !

!WebHttpMultiPortLoadBalancer class methodsFor!

on: aWebApplication 
	^self new application: aWebApplication! !
!WebHttpMultiPortLoadBalancer class categoriesFor: #on:!public! !

