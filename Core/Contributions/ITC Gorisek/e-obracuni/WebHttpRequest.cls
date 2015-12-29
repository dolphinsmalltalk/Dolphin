"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebHttpRequest
	instanceVariableNames: 'header contents formFields charactersMap isoCodesMap socketIP clientIP isHttps'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpRequest guid: (GUID fromString: '{3EC002C3-E29F-44AB-86F0-F3562BDB2F6C}')!
WebHttpRequest comment: ''!
!WebHttpRequest categoriesForClass!Unclassified! !
!WebHttpRequest methodsFor!

action
	"Answer action attribute, if this was a GET request then it is the value of 'action' attribute.
	Else this is the second part of submit button name i.e. BUTTON_<action_name>."

	| action |
	header command = 'POST' 
		ifFalse: [(action := self formFields at: 'action' ifAbsent: []) notNil ifTrue: [^action]]
		ifTrue: 
			["AJAX post action encoded as hidden field in the form posted to iframe"
			(action := self formFields at: '_apa' ifAbsent: []) isNilOrEmpty ifFalse: [^action]].
	self formFieldNames do: 
			[:each | 
			(each size > 7 and: [(each copyFrom: 1 to: 7) = 'BUTTON_']) 
				ifTrue: 
					[(each indexOf: $-) = 0 ifFalse: [^each copyFrom: 8 to: (each indexOf: $-) - 1].
					action := each copyFrom: 8 to: each size.
					^(action size > 2 and: 
							[(action at: action size - 1) = $. 
								and: [(action at: action size) = $x or: [(action at: action size) = $y]]]) 
						ifFalse: [action]
						ifTrue: [action copyFrom: 1 to: action size - 2]]].
	(action := self formFields at: 'action' ifAbsent: []) notNil ifTrue: [^action].
	^nil!

basicButtonValueAt: fieldName 
	(fieldName notNil 
		and: [fieldName size > 7 and: [(fieldName copyFrom: 1 to: 7) = 'BUTTON_']]) 
			ifFalse: [^nil].
	self formFields keysDo: 
			[:key | 
			(key size > 7 and: 
					[(key copyFrom: 1 to: 7) = 'BUTTON_' 
						and: [(key indexOf: $-) > 8 and: [(key copyFrom: 1 to: (key indexOf: $-) - 1) = fieldName]]]) 
				ifTrue: [^key copyFrom: (key indexOf: $-) + 1 to: key size]].
	^nil!

boolAt: fieldName 
	| str |
	str := self stringAt: fieldName.
	^(str = 'true' or: [str = '1']) ifTrue: [1] ifFalse: [0]!

booleanAt: fieldName 
	^(self stringAt: fieldName) = 'true'!

booleanAt: fieldName putTo: anObject 
	anObject at: fieldName put: (self booleanAt: fieldName)!

calculateMoneyFrom: string 
	| session ts dp str str2 sum sum2 n str3 sum3 str4 sum4 |
	session := self webSession.
	ts := session isNil 
				ifFalse: [session thousandsSeparator]
				ifTrue: [Processor activeProcess language = 'Slovene' ifTrue: [ts := $.]].
	dp := session isNil 
				ifFalse: [session decimalPoint]
				ifTrue: [Processor activeProcess language = 'Slovene' ifTrue: [dp := $,]].
	string = '-' ifTrue: [^nil].
	sum := sum2 := 0.0s.
	"Tokens for subtracting."
	(string itcSubStrings: $-) doWithIndex: 
			[:eachToken :index | 
			(str := eachToken trimBlanks) isEmpty 
				ifTrue: [index == 1 ifFalse: [^nil]]
				ifFalse: 
					["Tokens for adding."
					sum2 := 0.0s.
					(str itcSubStrings: $+) do: 
							[:eachToken2 | 
							(str2 := eachToken2 trimBlanks) isEmpty ifTrue: [^nil].
							"Tokens for multiplicating."
							sum3 := 0.0s.
							(str2 itcSubStrings: $*) doWithIndex: 
									[:eachToken3 :index3 | 
									(str3 := eachToken3 trimBlanks) isEmpty ifTrue: [^nil].
									"Tokens for dividing."
									sum4 := 0.0s.
									(str3 itcSubStrings: $/) doWithIndex: 
											[:eachToken4 :index4 | 
											(str4 := eachToken4 trimBlanks) isEmpty ifTrue: [^nil].
											n := ItcConverter 
														getNumberFromString: str4
														scale: 25
														precision: 6
														thousandsSeparator: ts
														decimalPoint: dp.
											n isNil ifTrue: [^nil].
											sum4 := index4 == 1 ifTrue: [n] ifFalse: [sum4 = 0 ifTrue: [^nil] ifFalse: [sum4 / n]]].
									sum3 := index3 == 1 ifTrue: [sum4] ifFalse: [sum3 * sum4]].
							sum2 := sum2 + sum3]].
			sum := index == 1 ifTrue: [sum2] ifFalse: [sum - sum2]].
	^sum!

clearFormFields
	formFields := LookupTable new!

clientHostname
	^WebHttpServer getHostnameFromIP: self clientIP!

clientIP
	| idx |
	clientIP isNil 
		ifTrue: 
			[(clientIP := header at: 'httpIP' ifAbsent: []) isNil 
				ifTrue: 
					[(clientIP := header at: 'httpsIP' ifAbsent: []) isNil 
						ifTrue: 
							[(clientIP := header at: 'X-Forwarded-For' ifAbsent: []) isNil 
								ifTrue: [clientIP := socketIP]
								ifFalse: 
									[idx := 0.
									1 to: clientIP size do: [:i | (clientIP at: i) asInteger < 46 ifTrue: [idx := i]].
									clientIP := clientIP copyFrom: idx + 1 to: clientIP size]]
						ifFalse: [isHttps := true]]].
	^clientIP!

clientIP: aIpString 
	clientIP := aIpString!

contents
	^contents!

dateAt: fieldName 
	"Answer aDate at field name or nil if there is no such field or date is in invalid format."

	| str session |
	^((str := self formAt: fieldName) notNil and: [(str := str trimBlanks) notEmpty]) 
		ifTrue: 
			[session := self webSession.
			ItcConverter getDateFromString: str
				dateFormat: (session isNil ifTrue: ['DD.MM.YYYY'] ifFalse: [session dateFormat])]!

formAt: aString 
	^self formAt: aString ifAbsent: []!

formAt: aStringOrSymbol ifAbsent: aBlock 
	| rawValue |
	rawValue := self formFields 
				at: (aStringOrSymbol isSymbol ifTrue: [aStringOrSymbol asString] ifFalse: [aStringOrSymbol])
				ifAbsent: [].
	^rawValue isNil 
		ifTrue: [aBlock value]
		ifFalse: [self getUnencodedStringInCurrentCodePageFrom: rawValue]!

formAt: fieldName put: aString 
	formFields isNil ifTrue: [formFields := LookupTable new].
	formFields at: fieldName put: aString!

formFieldNames
	^self formFields keys!

formFields
	formFields isNil ifTrue: [self parseFormFields].
	^formFields!

getAttachedFile: aString 
	| srch assoc |
	srch := 'file_' , aString , '='.
	self formFields keys do: 
			[:each | 
			(each beginsWith: srch) 
				ifTrue: 
					[assoc := Association key: (each copyFrom: srch size + 1 to: each size)
								value: (formFields at: each ifAbsent: []).
					^(assoc key isNilOrEmpty or: [assoc value isNilOrEmpty]) ifFalse: [assoc]]].
	^nil!

getAttachedFileAndUnzip: aString 
	| file stream tempFilesPath tempFileName unzippedFiles unzippedContent |
	file := self getAttachedFile: aString.
	file isNil ifTrue: [^nil].
	(ItcSystemManager fileExtensionFromPath: file key) = 'ZIP' ifFalse: [^file].
	Processor activeProcess webApplication isNil ifTrue: [^file].
	(tempFilesPath := Processor activeProcess webApplication temporaryDirectoryPath) isNilOrEmpty 
		ifTrue: [^file].
	tempFilesPath := tempFilesPath , 'Unzip' , ItcSystemManager generateShortRandomString.
	
	[ItcSystemManager directoryCreate: tempFilesPath.
	tempFileName := tempFilesPath , ItcSystemManager pathSeparatorString , 'TEMP.ZIP'.
	stream := FileStream write: tempFileName text: false.
	[stream nextPutAll: file value] ensure: [stream close].
	ItcSystemManager unzipArchive: tempFileName into: tempFilesPath.
	unzippedFiles := (ItcSystemManager getAllFilenamesInDirectory: tempFilesPath) 
				reject: [:each | each asUppercase = (ItcSystemManager fileNameFromPath: tempFileName) asUppercase].
	unzippedFiles isEmpty ifTrue: [^nil].
	stream := FileStream 
				read: tempFilesPath , ItcSystemManager pathSeparatorString , unzippedFiles first
				text: false.
	"don't load files larger than 128 MB"
	stream size > 134217728 ifTrue: [^nil].
	[unzippedContent := stream contents] ensure: [stream close]] 
			ensure: 
				["remove all temporary files in the temp directory and the directory itself"
				(ItcSystemManager getAllFilenamesInDirectory: tempFilesPath) 
					do: [:each | FileStream delete: tempFilesPath , ItcSystemManager pathSeparatorString , each].
				[FileStream delete: tempFileName] on: Error do: [:ex | ].
				[ItcSystemManager directoryRemove: tempFilesPath] on: Error do: [:ex | ]].
	^Association key: unzippedFiles first value: unzippedContent!

getIntegerId
	"To se uporablja tako pogosto, da si zasluzi svojo metodo."

	^self integerAt: 'id'!

getMultipleValuesAt: fieldName 
	"Answer a collection of all values sent with the same field name. This can be used by multi select SELECT field.
	If only one value in multiselect then check for basic field and wrap it's value as collection.
	Answer <nil> if the field is not present in the request."

	| coll |
	coll := self formFields 
				at: (fieldName isSymbol ifTrue: [fieldName asString] ifFalse: [fieldName]) , '__multiple_values__'
				ifAbsent: [].
	^coll isNil 
		ifTrue: 
			[| val |
			(val := self stringAt: fieldName) isEmpty ifFalse: [OrderedCollection with: val]]
		ifFalse: [coll collect: [:each | self getUnencodedStringInCurrentCodePageFrom: each]]!

getUnencodedStringInCurrentCodePageFrom: encodedString 
	| readStream writeStream ch ch2 code |
	isoCodesMap isNil ifTrue: [self initializeUnicodeTo8bitCodePageConversion].
	readStream := ReadStream on: encodedString.
	writeStream := WriteStream on: (String new: encodedString size + 20).
	[readStream atEnd] whileFalse: 
			[ch := readStream next.
			(ch = $& and: [readStream atEnd not]) 
				ifFalse: 
					["ISO encoding => Windows encoding"
					writeStream 
						nextPut: (charactersMap isNil ifFalse: [charactersMap at: ch ifAbsent: [ch]] ifTrue: [ch])]
				ifTrue: 
					[code := ''.
					
					[ch := readStream next.
					ch ~= $; and: [ch ~= $&]] whileTrue: 
								[code := code , ch asString.
								readStream atEnd ifTrue: [^writeStream contents , '&' , code]].
					(ch = $; and: [(ch2 := isoCodesMap isNil ifFalse: [isoCodesMap at: code ifAbsent: []]) notNil]) 
						ifTrue: [ch2 isString ifTrue: [writeStream nextPutAll: ch2] ifFalse: [writeStream nextPut: ch2]]
						ifFalse: 
							[writeStream
								nextPutAll: '&';
								nextPutAll: code.
							readStream position: readStream position - 1]]].
	^writeStream contents!

getUrlProtocolAndHostnamePrefix
	| hostname |
	(hostname := self requestHost) isNilOrEmpty ifTrue: [^nil].
	^self isHttps ifTrue: ['https://' , hostname] ifFalse: ['http://' , hostname]!

header
	^header!

initialize
	header := WebHttpRequestHeader new initialize!

initializeFrom: stream 
	| contentLength |
	header := WebHttpRequestHeader new initializeFrom: stream.
	(contentLength := header contentLength) > 0 
		ifTrue: 
			[contentLength > 16777216 
				ifTrue: [self error: 'Maximum of 16 MB message contents per request limit exceeded.'].
			"set maximum time to read request contents at a minimum transfer 
			speed of 2048 bytes per second + contingency of 30 seconds"
			Processor activeProcess 
				webHttpRequestDeadline: ItcSystemManager absoluteSecondsClockValue + (contentLength // 2048) + 30.
			contents := stream next: contentLength]
		ifFalse: [contents := ''].
	socketIP := stream socket peerAddressString!

initializeOnUrl: url 
	contents := ''.
	formFields := nil.
	header initializeOnUrl: url!

initializeUnicodeTo8bitCodePageConversion
	| codePage |
	codePage := Processor activeProcess webRequestCodePage.
	isoCodesMap := WebTranslationService getUnicodeTo8bitCodePageMapsForCodePage: codePage.
	charactersMap := WebTranslationService getCharactersMapForCodePage: codePage!

integerAt: aStringOrSymbol 
	"Always answer an instance of Integer at form field aString or <nil> if absent."

	| str fieldName |
	fieldName := aStringOrSymbol isSymbol 
				ifTrue: [aStringOrSymbol asString]
				ifFalse: [aStringOrSymbol].
	(str := self formFields at: fieldName ifAbsent: []) isNil 
		ifTrue: [str := self basicButtonValueAt: fieldName].
	^(str notNil and: 
			[(str := str trimBlanks) notEmpty 
				and: [str conform: [:each | each isDigit or: [each = $-]]]]) 
		ifTrue: [str itcAsInteger]!

isAjaxCapableBrowser
	"Vrne <true>, ce brskalnik podpira AJAX funkcionalnost."

	#itcTodo.
	"Some mobile browsers have AJAX functionality."
	self isMobileBrowser ifTrue: [^false].
	self isMozilla ifTrue: [^true].
	self isInternetExplorer55AndUp ifTrue: [^true].
	self isOpera ifTrue: [^true].
	^false!

isAppleSafari
	^(self userAgent indexOfSubCollection: 'Safari') > 0 and: [self isGoogleChrome not]!

isChecked: fieldName 
	^self formFields includesKey: fieldName!

isGoogleChrome
	^(self userAgent indexOfSubCollection: 'Chrome') > 0!

isHttps
	^isHttps == true!

isIndexingRobotOrWebSpider
	"Answer <true> if the request was sent by Google or Yahoo or any other web search indexing provider."

	| userAgent |
	userAgent := self userAgent.
	#('msnbot/* (+http://search.msn.com/msnbot.htm)' 'Mozilla/* (compatible; Yahoo!! Slurp/*' 'Mozilla/* (compatible; Googlebot/*' 'Mozilla/* (compatible; Najdi.si/*)' 'Mosad/2.0' 'Mozilla/* (compatible; Pogodak.co.yu/*)') 
		do: [:eachMatch | (eachMatch match: userAgent) ifTrue: [^true]].
	^false!

isIndexingRobotOrWebSpiderForSerbia
	"Answer <true> if the request was sent by Google or Yahoo or any other web search indexing provider."

	| userAgent |
	userAgent := self userAgent.
	#('Mozilla/* (compatible; Pogodak.co.yu/*)') 
		do: [:eachMatch | (eachMatch match: userAgent) ifTrue: [^true]].
	^false!

isIndexingRobotOrWebSpiderForSlovenia
	"Answer <true> if the request was sent by Google or Yahoo or any other web search indexing provider."

	| userAgent |
	userAgent := self userAgent.
	#('Mozilla/* (compatible; Najdi.si/*)') 
		do: [:eachMatch | (eachMatch match: userAgent) ifTrue: [^true]].
	^false!

isInternetExplorer
	^'*MSIE*' match: self userAgent!

isInternetExplorer55AndUp
	"DG: Na Win 98 naj bi z IE 5.5 ne koledarcek ne deloval zato sem spremenil, da javi <true> sele takrat, ko je IE 6.0"

	| str index |
	str := self userAgent.
	str isNilOrEmpty ifTrue: [^false].
	index := str indexOfSubCollection: 'MSIE ' startingAt: 1.
	index = 0 ifTrue: [^false].
	str := str copyFrom: index + 5 to: str size.
	str size < 3 ifTrue: [^false].
	(str at: 1) >= $6 ifTrue: [^true].
	^false!

isInternetExplorer6OrBelow
	"V IE 6.0 se vcasih stylesheet-i in DIV-i drugace obnasajo, kot v Mozilli in IE 7.0 zato se to kontrolira"

	| str index |
	str := self userAgent.
	str isNilOrEmpty ifTrue: [^false].
	index := str indexOfSubCollection: 'MSIE ' startingAt: 1.
	index = 0 ifTrue: [^false].
	str := str copyFrom: index + 5 to: str size.
	str size < 3 ifTrue: [^false].
	(str at: 1) <= $6 ifTrue: [^true].
	^false!

isInternetExplorerOnPocketPC
	| str |
	str := self userAgent.
	^('*MSIE*Windows CE*PPC*' match: str) or: ['*MSIE*Windows CE*IEMobile*' match: str]!

isMobileBrowser
	"See also:

		http://www.zytrax.com/tech/web/mobile_ids.htm
	"

	| ua |
	(self isOperaMobile or: [self isInternetExplorerOnPocketPC]) ifTrue: [^true].
	ua := self userAgent.
	('*NetFront*' match: ua) 
		ifTrue: 
			["on SonyEricsson phones"
			^true].
	('*iPhone*WebKit*' match: ua) 
		ifTrue: 
			["iPhone"
			^true].
	('*BlackBerry*' match: ua) ifTrue: [^true].
	('*Opera Mini*' match: ua) ifTrue: [^true].
	('*SymbianOS*' match: ua) ifTrue: [^true].
	('*Nokia*MIDP*' match: ua) ifTrue: [^true].
	('* UP.Link*' match: ua) ifTrue: [^true].
	(ua beginsWith: 'SonyEricsson') ifTrue: [^true].
	^false!

isMozilla
	^(self userAgent indexOfSubCollection: 'Gecko') > 0!

isMozillaFirefox
	^self isMozilla and: [self isGoogleChrome not]!

isOpera
	^'*Opera*' match: self userAgent!

isOperaFull
	^('*Opera*' match: self userAgent) and: [self isOperaMobile not]!

isOperaMobile
	| str |
	str := self userAgent.
	^('*Windows CE*PPC*Opera*' match: str) or: ['*Opera Mobile*' match: str]!

moneyAt: fieldName 
	"Always answer an instance of a decimal number at form field aString."

	| string value |
	(string := self formAt: fieldName) isNil ifTrue: [^0.0s].
	(string := string trimBlanks) isEmpty ifTrue: [^0.0s].
	^(value := self calculateMoneyFrom: string) isNil ifTrue: [0.0s] ifFalse: [value]!

moneyOrNilAt: fieldName 
	"Answer an instance of a decimal number at form field aString or nil if empty or absent."

	| string |
	^((string := self formAt: fieldName) isNil or: [(string := string trimBlanks) isEmpty]) 
		ifFalse: [self calculateMoneyFrom: string]!

numberAt: fieldName 
	^(self stringAt: fieldName) itcAsInteger!

objectAt: fieldName 
	"Answer deserialized object at <fieldName>. Answer nil if none or bad contents."

	^(self stringAt: fieldName) webDeserializeFromString!

parseFormData: aString 
	| stream key value existingValue |
	stream := ReadStream on: aString.
	[stream atEnd or: [(key := stream upTo: $=) isNil or: [key isEmpty]]] whileFalse: 
			[key := key webHttpUrlDecodeQueryComponent.
			value := stream upTo: $&.
			value := value webHttpUrlDecodeQueryComponent.
			(existingValue := formFields at: key ifAbsent: []) isNil 
				ifFalse: 
					["multiple values are available for this filedName, in this case create another key which will store an OrderedCollection of all values for this field name"
					(formFields at: key , '__multiple_values__'
						ifAbsentPut: 
							[(OrderedCollection new)
								add: existingValue;
								yourself]) 
							add: value].
			formFields at: key put: value]!

parseFormFields
	| index url |
	formFields := LookupTable new.
	"always parse URL attributes (even if it is a POST request)"
	(index := (url := header url) indexOf: $?) > 0 
		ifTrue: [self parseFormData: (url copyFrom: index + 1 to: url size)].
	header contentType notNil 
		ifTrue: 
			[('application/x-www-form-urlencoded' sameAs: header contentType) 
				ifTrue: [self parseFormData: contents]
				ifFalse: 
					[(header contentType indexOfSubCollection: 'multipart/form-data' startingAt: 1) > 0 
						ifTrue: [self parseMultiPartRequest]]]!

parseFormFieldsFromUrlWithoutRequestContent
	"Use this method when you want to get only value encoded in the request URL without touching the request contents."

	| index url |
	formFields := LookupTable new.
	(index := (url := header url) indexOf: $?) > 0 
		ifTrue: [self parseFormData: (url copyFrom: index + 1 to: url size)]!

parseMultiPartRequest
	| boundary idx idx2 idx3 idx4 items dataname datavalue |
	idx := header contentType 
				indexOfSubCollection: 'boundary='
				startingAt: 1
				ifAbsent: [^nil].
	boundary := '--' , (header contentType copyFrom: idx + 9 to: header contentType size).
	items := self splitString: contents delimiterString: boundary , '
'.
	items at: items size
		put: (items last copyFrom: 1
				to: (items last indexOfSubCollection: boundary , '-' startingAt: 1) - 1).
	items removeAtIndex: 1.
	items do: 
			[:each | 
			idx := each indexOfSubCollection: 'name="' startingAt: 1.
			idx2 := each indexOf: $" startingAt: idx + 7.
			dataname := each copyFrom: idx + 6 to: idx2 - 1.
			idx := each indexOfSubCollection: '

' startingAt: idx2.
			idx > (idx2 + 10) 
				ifTrue: 
					[idx3 := each indexOfSubCollection: 'filename="' startingAt: idx2 + 1.
					idx3 > 0 
						ifTrue: 
							[idx4 := each indexOf: $" startingAt: idx3 + 11.
							idx4 > (idx3 + 11) 
								ifTrue: [dataname := 'file_' , dataname , '=' , (each copyFrom: idx3 + 10 to: idx4 - 1)]]].
			datavalue := each copyFrom: idx + 4 to: each size - 2.
			formFields at: dataname put: datavalue]!

printOn: aStream 
	aStream nextPutAll: 'WebHttpRequest:action='.
	self action printOn: aStream.
	aStream nextPut: $ .
	header printOn: aStream!

redirectionMessageContents
	| stream |
	stream := WriteStream on: (String new: 2048).
	header 
		generateRedirectionHeaderFor: socketIP
		secure: isHttps
		on: stream.
	^stream
		nextPutAll: contents;
		contents!

referer
	^header at: 'Referer' ifAbsent: ['']!

requestHost
	"Answer hostname of the server on which this request was received (virtual hosting, name taken from HTTP header)."

	| hostname idx |
	^(hostname := self header host) isNilOrEmpty 
		ifFalse: 
			[(idx := hostname indexOf: $:) > 0 
				ifTrue: [hostname copyFrom: 1 to: idx - 1]
				ifFalse: [hostname]]!

requestPort
	"Answer port on which this request was received."

	| host |
	(host := self header host) isNilOrEmpty 
		ifFalse: [(host includes: $:) ifTrue: [^(host itcSubStrings: $:) last itcAsInteger]].
	^self isHttps ifTrue: [WebHttpsServer defaultPort] ifFalse: [WebHttpServer defaultPort]!

setIsHttps
	isHttps := true!

splitString: aString delimiterString: delimiter 
	| coll str index |
	coll := OrderedCollection new.
	str := aString.
	[(index := str indexOfSubCollection: delimiter) > 0] whileTrue: 
			[index > 1 ifTrue: [coll add: (str copyFrom: 1 to: index - 1)] ifFalse: [coll add: ''].
			str := index + delimiter size > str size 
						ifTrue: ['']
						ifFalse: [str copyFrom: index + delimiter size to: str size]].
	coll add: str.
	^coll!

stringAt: aString 
	"Always answer an instance of String at form field aString."

	| str |
	^((str := self formAt: aString) notNil and: [str isString]) 
		ifTrue: [str trimBlanks]
		ifFalse: ['']!

stringOrNilAt: aString 
	"Aswer an instance of String at form field aString or <nil> if empty or none."

	| str |
	str := (self formAt: aString ifAbsent: [^nil]) trimBlanks.
	^str isEmpty ifFalse: [str]!

stringsAt: fieldName count: count 
	"Answer a collection of strings for field name which starts with 'name_' + integer count"

	| coll |
	coll := Array new: count.
	1 to: count do: [:i | coll at: i put: (self stringAt: fieldName , i printString)].
	^coll!

symbolAt: aString 
	| str |
	^((str := self stringOrNilAt: aString) isNilOrEmpty or: [str size > 150]) ifFalse: [str asSymbol]!

timeAmountInHoursAt: fieldName 
	"Answer amount of hous which can be entered either as a decimal number or as hours and minutes in using hh:mm syntax."

	| str hours minutes timeAmount |
	((str := self stringAt: fieldName) occurrencesOf: $:) = 1 
		ifTrue: 
			[hours := (str itcSubStrings: $:) first.
			minutes := (str itcSubStrings: $:) last.
			hours := hours itcAsInteger.
			minutes := minutes itcAsInteger.
			timeAmount := hours + (minutes / 60 roundTo: 0.01s)].
	^timeAmount isNil ifTrue: [self moneyOrNilAt: fieldName] ifFalse: [timeAmount]!

timeAt: fieldName 
	"Answer aTime at field name or nil if there is no such field or time is in invalid format."

	| str |
	^((str := self formAt: fieldName) notNil and: [(str := str trimBlanks) notEmpty]) 
		ifTrue: [ItcConverter getTimeFromString: str]!

timestampAt: fieldName 
	| str arr session |
	session := self webSession.
	^((str := self formAt: fieldName) notNil 
		and: [(str := str trimBlanks) notEmpty and: [(arr := str subStrings: ' ') size = 2]]) 
			ifTrue: 
				[Timestamp date: (ItcConverter getDateFromString: arr first
							dateFormat: (session isNil ifTrue: ['DD.MM.YYYY'] ifFalse: [session dateFormat]))
					time: (ItcConverter getTimeFromString: arr last)]!

userAgent
	^header userAgent! !
!WebHttpRequest categoriesFor: #action!public! !
!WebHttpRequest categoriesFor: #basicButtonValueAt:!private! !
!WebHttpRequest categoriesFor: #boolAt:!public! !
!WebHttpRequest categoriesFor: #booleanAt:!public! !
!WebHttpRequest categoriesFor: #booleanAt:putTo:!public! !
!WebHttpRequest categoriesFor: #calculateMoneyFrom:!private! !
!WebHttpRequest categoriesFor: #clearFormFields!public! !
!WebHttpRequest categoriesFor: #clientHostname!public! !
!WebHttpRequest categoriesFor: #clientIP!public! !
!WebHttpRequest categoriesFor: #clientIP:!public! !
!WebHttpRequest categoriesFor: #contents!public! !
!WebHttpRequest categoriesFor: #dateAt:!public! !
!WebHttpRequest categoriesFor: #formAt:!public! !
!WebHttpRequest categoriesFor: #formAt:ifAbsent:!public! !
!WebHttpRequest categoriesFor: #formAt:put:!public! !
!WebHttpRequest categoriesFor: #formFieldNames!public! !
!WebHttpRequest categoriesFor: #formFields!public! !
!WebHttpRequest categoriesFor: #getAttachedFile:!public! !
!WebHttpRequest categoriesFor: #getAttachedFileAndUnzip:!public! !
!WebHttpRequest categoriesFor: #getIntegerId!public! !
!WebHttpRequest categoriesFor: #getMultipleValuesAt:!public! !
!WebHttpRequest categoriesFor: #getUnencodedStringInCurrentCodePageFrom:!private! !
!WebHttpRequest categoriesFor: #getUrlProtocolAndHostnamePrefix!public! !
!WebHttpRequest categoriesFor: #header!public! !
!WebHttpRequest categoriesFor: #initialize!initialization!public! !
!WebHttpRequest categoriesFor: #initializeFrom:!initialization!public! !
!WebHttpRequest categoriesFor: #initializeOnUrl:!initialization!public! !
!WebHttpRequest categoriesFor: #initializeUnicodeTo8bitCodePageConversion!initialization!private! !
!WebHttpRequest categoriesFor: #integerAt:!public! !
!WebHttpRequest categoriesFor: #isAjaxCapableBrowser!public! !
!WebHttpRequest categoriesFor: #isAppleSafari!public! !
!WebHttpRequest categoriesFor: #isChecked:!public! !
!WebHttpRequest categoriesFor: #isGoogleChrome!public! !
!WebHttpRequest categoriesFor: #isHttps!public! !
!WebHttpRequest categoriesFor: #isIndexingRobotOrWebSpider!public! !
!WebHttpRequest categoriesFor: #isIndexingRobotOrWebSpiderForSerbia!public! !
!WebHttpRequest categoriesFor: #isIndexingRobotOrWebSpiderForSlovenia!public! !
!WebHttpRequest categoriesFor: #isInternetExplorer!public! !
!WebHttpRequest categoriesFor: #isInternetExplorer55AndUp!public! !
!WebHttpRequest categoriesFor: #isInternetExplorer6OrBelow!public! !
!WebHttpRequest categoriesFor: #isInternetExplorerOnPocketPC!public! !
!WebHttpRequest categoriesFor: #isMobileBrowser!public! !
!WebHttpRequest categoriesFor: #isMozilla!public! !
!WebHttpRequest categoriesFor: #isMozillaFirefox!public! !
!WebHttpRequest categoriesFor: #isOpera!public! !
!WebHttpRequest categoriesFor: #isOperaFull!public! !
!WebHttpRequest categoriesFor: #isOperaMobile!public! !
!WebHttpRequest categoriesFor: #moneyAt:!public! !
!WebHttpRequest categoriesFor: #moneyOrNilAt:!public! !
!WebHttpRequest categoriesFor: #numberAt:!public! !
!WebHttpRequest categoriesFor: #objectAt:!public! !
!WebHttpRequest categoriesFor: #parseFormData:!private! !
!WebHttpRequest categoriesFor: #parseFormFields!public! !
!WebHttpRequest categoriesFor: #parseFormFieldsFromUrlWithoutRequestContent!public! !
!WebHttpRequest categoriesFor: #parseMultiPartRequest!public! !
!WebHttpRequest categoriesFor: #printOn:!public! !
!WebHttpRequest categoriesFor: #redirectionMessageContents!public! !
!WebHttpRequest categoriesFor: #referer!public! !
!WebHttpRequest categoriesFor: #requestHost!public! !
!WebHttpRequest categoriesFor: #requestPort!public! !
!WebHttpRequest categoriesFor: #setIsHttps!public! !
!WebHttpRequest categoriesFor: #splitString:delimiterString:!public! !
!WebHttpRequest categoriesFor: #stringAt:!public! !
!WebHttpRequest categoriesFor: #stringOrNilAt:!public! !
!WebHttpRequest categoriesFor: #stringsAt:count:!public! !
!WebHttpRequest categoriesFor: #symbolAt:!public! !
!WebHttpRequest categoriesFor: #timeAmountInHoursAt:!public! !
!WebHttpRequest categoriesFor: #timeAt:!public! !
!WebHttpRequest categoriesFor: #timestampAt:!public! !
!WebHttpRequest categoriesFor: #userAgent!public! !

!WebHttpRequest class methodsFor!

new
	^super new initialize!

newGenericRequest
	"Answer a generic request object which can be used as a request parameter in methods which require web request object."

	^(self new)
		clientIP: '127.0.0.1';
		yourself! !
!WebHttpRequest class categoriesFor: #new!public! !
!WebHttpRequest class categoriesFor: #newGenericRequest!public! !

