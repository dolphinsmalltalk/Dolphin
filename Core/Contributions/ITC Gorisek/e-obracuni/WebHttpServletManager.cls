"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebHttpServletManager
	instanceVariableNames: 'servlets fileServlets indexServlets domainNames allowRobots allowIPcoll blockIPcoll'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpServletManager guid: (GUID fromString: '{C09BBF25-828C-444D-B3C3-7790451A16A8}')!
WebHttpServletManager comment: ''!
!WebHttpServletManager categoriesForClass!Unclassified! !
!WebHttpServletManager methodsFor!

addFileScriptServlet: aWebHttpFileServlet for: aWebApplication 
	| coll |
	aWebHttpFileServlet
		rootPath: aWebApplication webFilesPath;
		application: aWebApplication;
		urlPrefix: aWebApplication urlPrefix.
	domainNames add: aWebApplication domainName.
	coll := fileServlets at: aWebApplication domainName
				ifAbsentPut: [SortedCollection sortBlock: [:a :b | a urlPrefix size > b urlPrefix size]].
	^coll add: aWebHttpFileServlet!

addFileServlet: aWebHttpFileServlet for: aWebApplication 
	| coll |
	aWebHttpFileServlet
		rootPath: aWebApplication webFilesPath;
		urlPrefix: aWebApplication urlPrefix;
		application: aWebApplication.
	domainNames add: aWebApplication domainName.
	coll := fileServlets at: aWebApplication domainName
				ifAbsentPut: [SortedCollection sortBlock: [:a :b | a urlPrefix size > b urlPrefix size]].
	^coll add: aWebHttpFileServlet!

addServlet: aWebServlet for: aWebApplication 
	^self 
		addServlet: aWebServlet
		for: aWebApplication
		urlPrefix: aWebApplication urlPrefix!

addServlet: aWebServlet for: aWebApplication urlPrefix: urlPrefix 
	| dict |
	aWebServlet application: aWebApplication.
	domainNames add: aWebApplication domainName.
	dict := servlets at: aWebApplication domainName ifAbsentPut: [LookupTable new].
	^dict at: urlPrefix , '/' , aWebServlet servletName ifAbsentPut: [aWebServlet]!

allowRobots: aBoolean 
	"Set this to <true> if web spiders and robots are allowed.
	Default is to send 'robots.txt' file with denial of all web spiders.

	If you want to allow Googlebot  and others then set this to true."

	allowRobots := aBoolean!

applications
	| set |
	set := Set new.
	servlets do: [:eachDict | set addAll: (eachDict collect: [:each | each application])].
	^set!

getMatchStringCollectionFrom: aString 
	| tokens |
	tokens := (aString asWebString itcSubStrings: $;) select: 
					[:each | 
					(each conform: [:eachCh | eachCh isDigit or: [eachCh = $* or: [eachCh = $? or: [eachCh = $.]]]]) 
						and: [each notEmpty]].
	^tokens isEmpty ifFalse: [tokens]!

getServletsFor: aWebApplication 
	^(servlets at: aWebApplication domainName ifAbsent: [^#()]) values!

indexServlet: aWebServlet for: application 
	| domainName |
	(domainName := application domainName) isNil ifTrue: [domainName := '...'].
	^self 
		indexServlet: aWebServlet
		for: application
		domainName: domainName!

indexServlet: aWebServlet for: application domainName: domainName 
	"When request for  httt://domainName/  is received, it will be forwarded to default/index servlet aWebServlet."

	indexServlets at: domainName put: aWebServlet.
	domainNames add: domainName!

indexServletFor: application 
	indexServlets do: [:eachServlet | eachServlet application == application ifTrue: [^eachServlet]].
	^nil!

initialize
	servlets := LookupTable new.
	fileServlets := LookupTable new.
	indexServlets := LookupTable new.
	domainNames := Set new!

removeServletsFor: aWebApplication 
	| dict coll |
	dict := servlets at: aWebApplication domainName ifAbsent: [^self].
	(dict keys select: [:eachKey | (dict at: eachKey) application == aWebApplication]) 
		do: [:eachKey | dict removeKey: eachKey].
	coll := fileServlets at: aWebApplication domainName ifAbsent: [^self].
	coll removeAll: (coll select: [:each | each application == aWebApplication])!

service: request on: stream 
	"the rule is: if request domainName is one of predefined then it will be used
	for exactly that application, otherwise string '...' will be used."

	| delimiterIndex servletName servlet domainName coll domainDict clientIP |
	(allowIPcoll isNil and: [blockIPcoll isNil]) 
		ifFalse: 
			[clientIP := request clientIP.
			allowIPcoll isNil 
				ifFalse: 
					[allowIPcoll detect: [:eachIPmask | eachIPmask match: clientIP]
						ifNone: [^stream fileNotFoundResponse]].
			blockIPcoll isNil 
				ifFalse: 
					[blockIPcoll do: [:eachIPmask | (eachIPmask match: clientIP) ifTrue: [^stream fileNotFoundResponse]]]].
	domainName := request requestHost.
	(domainNames includes: domainName) ifFalse: [domainName := '...'].
	servletName := request header url.
	servletName = '/robots.txt' 
		ifTrue: 
			[^allowRobots = true 
				ifTrue: [stream fileNotFoundResponse]
				ifFalse: [stream disallowAllRobotsResponse]].
	(servletName = '/' and: [(indexServlets at: domainName ifAbsent: []) notNil]) 
		ifTrue: 
			[servlet := indexServlets at: domainName.
			"redirect to index servlet URL"
			^stream redirectResponseTo: '/' , servlet application urlPrefix , '/' , servlet servletName].
	(domainDict := servlets at: domainName ifAbsent: []) isNil 
		ifFalse: 
			[(delimiterIndex := servletName indexOf: $-) > 0 
				ifTrue: 
					["URL encoded tasks"
					(servlet := domainDict at: (servletName copyFrom: 2 to: delimiterIndex - 1) ifAbsent: []) isNil 
						ifFalse: [^servlet service: request on: stream]].
			(servlet := domainDict at: ((delimiterIndex := servletName indexOf: $?) > 0 
								ifTrue: [servletName copyFrom: 2 to: delimiterIndex - 1]
								ifFalse: [servletName copyFrom: 2 to: servletName size])
						ifAbsent: []) isNil 
				ifFalse: [^servlet service: request on: stream]].
	((coll := fileServlets at: domainName ifAbsent: []) isNil or: 
			[(servlet := coll detect: [:each | request header url beginsWith: '/' , each urlPrefix] ifNone: []) 
				isNil]) 
		ifFalse: [servlet service: request on: stream]
		ifTrue: 
			[domainName = '...' 
				ifTrue: [stream fileNotFoundResponse]
				ifFalse: 
					[self 
						serviceOnDefaultDomain: request
						servletName: servletName
						on: stream]]!

serviceOnDefaultDomain: request servletName: servletName on: stream 
	"Private - V primeru, da isce resource na specificni domeni in ga ne najde, potem ga isce, ce je dostopen na default domeni."

	| delimiterIndex servlet coll domainDict |
	(domainDict := servlets at: '...' ifAbsent: []) isNil 
		ifFalse: 
			[(delimiterIndex := servletName indexOf: $-) > 0 
				ifTrue: 
					["URL encoded tasks"
					(servlet := domainDict at: (servletName copyFrom: 2 to: delimiterIndex - 1) ifAbsent: []) 
						isNil ifFalse: [^servlet service: request on: stream]].
			(servlet := domainDict at: ((delimiterIndex := servletName indexOf: $?) > 0 
								ifTrue: [servletName copyFrom: 2 to: delimiterIndex - 1]
								ifFalse: [servletName copyFrom: 2 to: servletName size])
						ifAbsent: []) isNil 
				ifFalse: [^servlet service: request on: stream]].
	((coll := fileServlets at: '...' ifAbsent: []) isNil or: 
			[(servlet := coll detect: [:each | request header url beginsWith: '/' , each urlPrefix]
						ifNone: []) isNil]) 
		ifTrue: [stream fileNotFoundResponse]
		ifFalse: [servlet service: request on: stream]!

setAllowedIPString: aString 
	allowIPcoll := self getMatchStringCollectionFrom: aString!

setBlockedIPString: aString 
	blockIPcoll := self getMatchStringCollectionFrom: aString! !
!WebHttpServletManager categoriesFor: #addFileScriptServlet:for:!public! !
!WebHttpServletManager categoriesFor: #addFileServlet:for:!public! !
!WebHttpServletManager categoriesFor: #addServlet:for:!public! !
!WebHttpServletManager categoriesFor: #addServlet:for:urlPrefix:!public! !
!WebHttpServletManager categoriesFor: #allowRobots:!public! !
!WebHttpServletManager categoriesFor: #applications!public! !
!WebHttpServletManager categoriesFor: #getMatchStringCollectionFrom:!private! !
!WebHttpServletManager categoriesFor: #getServletsFor:!public! !
!WebHttpServletManager categoriesFor: #indexServlet:for:!public! !
!WebHttpServletManager categoriesFor: #indexServlet:for:domainName:!public! !
!WebHttpServletManager categoriesFor: #indexServletFor:!public! !
!WebHttpServletManager categoriesFor: #initialize!public! !
!WebHttpServletManager categoriesFor: #removeServletsFor:!public! !
!WebHttpServletManager categoriesFor: #service:on:!public! !
!WebHttpServletManager categoriesFor: #serviceOnDefaultDomain:servletName:on:!private! !
!WebHttpServletManager categoriesFor: #setAllowedIPString:!public! !
!WebHttpServletManager categoriesFor: #setBlockedIPString:!public! !

!WebHttpServletManager class methodsFor!

new

	^super new initialize! !
!WebHttpServletManager class categoriesFor: #new!public! !

