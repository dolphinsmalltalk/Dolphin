"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerRequest
	instanceVariableNames: 'queue httpRequest headers body postFields queryFields params'
	classVariableNames: 'MAX_PAYLOAD'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerRequest guid: (GUID fromString: '{14fd8fd4-f15d-4b17-a47d-a6942bc0d04b}')!
HttpServerRequest comment: ''!
!HttpServerRequest categoriesForClass!Unclassified! !
!HttpServerRequest methodsFor!

body
	body ifNil: [body := self receiveBody asString].
	^body!

cancel
	self lib
		httpCancelHttpRequest: self queueHandle
		requestId: self id
		overlapped: nil!

contentLength
	^(self headers headerAt: 'Content-Length' ifAbsent: ['0']) asNumber!

contentType
	^self headers headerAt: 'Content-Type' ifAbsent: ['']!

cookie
	^self headers headerAt: 'Cookie' ifAbsent: []!

fullUrl
	^httpRequest CookedUrl pFullUrl asString!

headerAt: name
	^headers headerAt: name ifAbsent: []!

headerAt: name put: stringValue
	^headers headerAt: name put: stringValue!

headers
	headers ifNil: [self initializeHeaders].
	^headers!

httpVersion
	^Array with: httpRequest Version MajorVersion with: httpRequest Version MinorVersion!

id
	^httpRequest RequestId!

initializeHeaders
	headers := HttpServerHeaders new.
	headers read: httpRequest!

initializeOn: httpApiQueue
	queue := httpApiQueue.
	httpRequest := self lib receiveRequest: queue handle flags: 0!

isDelete
	^self verb = 'DELETE'!

isEncrypted
	^httpRequest pSslInfo notNil!

isFormUrlEncoded
	^self contentType beginsWith: 'application/x-www-form-urlencoded'!

isGet
	^self verb = 'GET'!

isMultipart
	^self contentType beginsWith: 'multipart/form-data'!

isPost
	^self verb = 'POST'!

isPut
	^self verb = 'PUT'!

multipartBoundary
	| header |
	header := self contentType ifNil: [^nil].
	(header beginsWith: 'multipart/form-data') ifFalse:[^nil].
	^(header copyFrom: (header findString: 'boundary=') + 9 to: header size)!

paramAt: name
	^self params at: name ifAbsent: []!

params
	"Answer all params: postFields + queryFields.
	queryFields are given preference over postFields."

	params ifNil: [params := LookupTable withAll: self postFields associations, self queryFields associations].
	^params!

parsePostFields
	| time contents |
	self isFormUrlEncoded ifTrue: [^self class decodeUrlEncoded: self body].
	Transcript show: 'Get body time: ' , (Time millisecondsToRun: [self body]) displayString; cr.
	self isMultipart ifTrue: [
		time := Time millisecondsToRun: [contents := self class decodeMultipart: self body boundary: self multipartBoundary].
		Transcript show: 'Decode time: ' , time displayString.
		^contents].
	^LookupTable new!

parseQueryFields
	^self class decodeUrlEncoded: self queryString!

path
	^httpRequest CookedUrl pAbsPath asString!

peer
	^(httpRequest Address at: 1) displayString!

postFieldAt: name
	^self postFields at: name ifAbsent: []!

postFields
	postFields ifNil: [postFields := self parsePostFields].
	^postFields!

queryFieldAt: name
	^self queryFields at: name ifAbsent: []!

queryFields
	queryFields ifNil: [queryFields := self parseQueryFields].
	^queryFields!

queryString
	| query |
	query := httpRequest CookedUrl pQueryString asString.
	query isEmpty ifTrue: [^query].
	^query first = $? ifTrue: [query allButFirst] ifFalse: [query]!

queueHandle
	^queue handle!

receiveBody
	self contentLength > self class maxPayload
		ifTrue: 
			[HttpServerError payloadTooLarge
				signal: 'The maximum content length allowed is ' , self class maxPayload displayString , ' bytes'].
	^self lib receiveRequestEntityBody: self queueHandle requestId: self id!

verb
	^httpRequest verb! !
!HttpServerRequest categoriesFor: #body!public! !
!HttpServerRequest categoriesFor: #cancel!public! !
!HttpServerRequest categoriesFor: #contentLength!public! !
!HttpServerRequest categoriesFor: #contentType!public! !
!HttpServerRequest categoriesFor: #cookie!public! !
!HttpServerRequest categoriesFor: #fullUrl!public! !
!HttpServerRequest categoriesFor: #headerAt:!public! !
!HttpServerRequest categoriesFor: #headerAt:put:!public! !
!HttpServerRequest categoriesFor: #headers!public! !
!HttpServerRequest categoriesFor: #httpVersion!public! !
!HttpServerRequest categoriesFor: #id!accessing!public! !
!HttpServerRequest categoriesFor: #initializeHeaders!private! !
!HttpServerRequest categoriesFor: #initializeOn:!private! !
!HttpServerRequest categoriesFor: #isDelete!public! !
!HttpServerRequest categoriesFor: #isEncrypted!public! !
!HttpServerRequest categoriesFor: #isFormUrlEncoded!public! !
!HttpServerRequest categoriesFor: #isGet!public! !
!HttpServerRequest categoriesFor: #isMultipart!public! !
!HttpServerRequest categoriesFor: #isPost!public! !
!HttpServerRequest categoriesFor: #isPut!public! !
!HttpServerRequest categoriesFor: #multipartBoundary!private! !
!HttpServerRequest categoriesFor: #paramAt:!public! !
!HttpServerRequest categoriesFor: #params!public! !
!HttpServerRequest categoriesFor: #parsePostFields!private! !
!HttpServerRequest categoriesFor: #parseQueryFields!private! !
!HttpServerRequest categoriesFor: #path!public! !
!HttpServerRequest categoriesFor: #peer!public! !
!HttpServerRequest categoriesFor: #postFieldAt:!public! !
!HttpServerRequest categoriesFor: #postFields!public! !
!HttpServerRequest categoriesFor: #queryFieldAt:!public! !
!HttpServerRequest categoriesFor: #queryFields!public! !
!HttpServerRequest categoriesFor: #queryString!public! !
!HttpServerRequest categoriesFor: #queueHandle!accessing!public! !
!HttpServerRequest categoriesFor: #receiveBody!private! !
!HttpServerRequest categoriesFor: #verb!public! !

!HttpServerRequest class methodsFor!

decodeMultipart: aString boundary: boundary
	| fields |
	fields := LookupTable new.
	self
		decodeMultipart: aString readStream
		boundary: boundary
		do: 
			[:headers :params :content |
			params at: 'name'
				ifPresent: 
					[:fieldName |
					| value |
					value := content.
					params at: 'filename'
						ifPresent: 
							[:filename |
							value := HttpServerFile new.
							value fileName: filename.
							value contents: content.
							value contentType: (headers at: 'content-type' ifAbsent: ['text/html'])].
					fields at: fieldName put: value]].
	^fields!

decodeMultipart: aStream boundary: boundary do: aBlock
	| skip headers content disposition index params |
	aStream upToAll: '--' , boundary.
	[aStream atEnd or: [(skip := aStream next: 2) = '--']] whileFalse: 
			[skip = String lineDelimiter ifFalse: [self error: 'Error decoding multipart/form-data fields'].
			headers := LookupTable new.
			(self readPartHeadersFrom: aStream) do: [:hdr | headers add: hdr].
			content := aStream upToAll: String lineDelimiter , '--' , boundary.
			params := LookupTable new.
			disposition := headers at: 'content-disposition' ifAbsent: [''].
			#('name' 'filename') do: 
					[:arg |
					| len val |
					len := arg size + 2.
					index := disposition findString: arg , '='.
					index > 0
						ifTrue: 
							[val := disposition copyFrom: index + len to: (disposition indexOf: $" startingAt: index + len) - 1.
							params at: arg put: val]].
			aBlock
				value: headers
				value: params
				value: content]!

decodeUrlEncoded: aString
	| fields |
	fields := LookupTable new.
	self decodeUrlEncoded: aString
		do: 
			[:key :value |
			fields at: key
				put: ((fields at: key ifAbsent: [])
						ifNil: [value]
						ifNotNil: [:previous | (previous isKindOf: Array) ifTrue: [previous , {value}] ifFalse: [{previous. value}]])].
	^fields!

decodeUrlEncoded: aString do: aBlock
	| args keyval index key value |
	args := aString readStream.
	[args atEnd] whileFalse: 
			[keyval := args upTo: $&.
			(index := keyval indexOf: $=) = 0
				ifTrue: 
					[key := keyval.
					value := '']
				ifFalse: 
					[key := keyval copyFrom: 1 to: index - 1.
					value := keyval copyFrom: index + 1 to: keyval size].
			key := key unescapePercents.
			value := value unescapePercents.
			aBlock value: key value: value]!

maxPayload
	MAX_PAYLOAD ifNil: [MAX_PAYLOAD := 100 * 1024 * 1024 "100MB"].
	^MAX_PAYLOAD!

maxPayload: size
	MAX_PAYLOAD := size!

on: httpApiQueue
	^self new initializeOn: httpApiQueue!

readPartHeadersFrom: aStream
	| headers nextLine existing |
	headers := OrderedCollection new.
	
	[nextLine := aStream nextLine readStream.
	nextLine atEnd] whileFalse: 
				[nextLine peek isSeparator
					ifTrue: 
						["Continuation as per HTTP 1.1 spec"
						existing := headers last.
						existing value: existing value , ' ' , nextLine contents trimBlanks]
					ifFalse: 
						["Regular header"
						headers add: (nextLine upTo: $:) asLowercase -> nextLine upToEnd trimBlanks]].
	^headers! !
!HttpServerRequest class categoriesFor: #decodeMultipart:boundary:!public! !
!HttpServerRequest class categoriesFor: #decodeMultipart:boundary:do:!public! !
!HttpServerRequest class categoriesFor: #decodeUrlEncoded:!public! !
!HttpServerRequest class categoriesFor: #decodeUrlEncoded:do:!public! !
!HttpServerRequest class categoriesFor: #maxPayload!public! !
!HttpServerRequest class categoriesFor: #maxPayload:!public! !
!HttpServerRequest class categoriesFor: #on:!public! !
!HttpServerRequest class categoriesFor: #readPartHeadersFrom:!private! !

