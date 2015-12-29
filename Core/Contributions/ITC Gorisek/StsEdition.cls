"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #StsEdition
	instanceVariableNames: 'timestamp developer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsEdition guid: (GUID fromString: '{914F381C-11D6-11D4-B091-000000000000}')!
StsEdition comment: ''!
!StsEdition categoriesForClass!Unclassified! !
!StsEdition methodsFor!

blessingString
	^self blessing asString!

className
	^''!

classNameForVisualWorks: aString 
	| className |
	className := (aString subStrings: $ ) first.
	(#('Object' 'Class') includes: className) ifTrue: [^'Core.' , aString].
	^aString!

convertToSqueakPackageName: aString 
	| ws rs ch |
	ws := WriteStream on: String new.
	rs := ReadStream on: aString.
	[rs atEnd] whileFalse: 
			[ch := rs next.
			ch = $  ifFalse: [ws nextPut: ch]].
	^ws contents!

developer
	^developer!

developer: aString 
	developer := aString!

developerForSmalltalkX
	^self developer reject: [:each | each = $ ]!

fullClassNameForVisualWorks: aString 
	| className |
	className := (aString subStrings: $ ) first.
	(#('Object' 'Class') includes: className) ifTrue: [^'Root.Smalltalk.Core.' , className].
	^'Root.Smalltalk.' , className!

logError: aString 
	Transcript
		nextPutAll: 'Error: ' , aString;
		cr!

logMethodOverride: aCompiledMethod 
	| package |
	package := aCompiledMethod owningPackage.
	self 
		logWarning: 'Method ' , aCompiledMethod printString , ' from package ' 
				, (package isNil ifTrue: ['* uncommitted *'] ifFalse: [package name]) , ' has been overridden'!

logWarning: aString 
	Transcript
		nextPutAll: 'Warning: ' , aString;
		cr!

possibleBlessingLevels
	"Answer a collection of blessing level symbols ordered from the lowest blessing level to the highest."

	^self class possibleBlessingLevels!

putSmalltalkXDeveloperAndTimestampOn: aStream 
	aStream
		nextPutAll: '''---- timestamp ';
		nextPutAll: self developerForSmalltalkX;
		nextPut: $ ;
		nextPutAll: self timestampForSmalltalkX;
		nextPutAll: ' ----''!!
'!

replaceBlanksWithDash: aString 
	^aString trimBlanks copyReplacing: $  withObject: $-!

resolveProxies
	self odbResolve!

sourceControl
	^StsManager current!

sourceManager
	"Answer the receiver's source manager."

	^self class sourceManager!

timestamp
	^timestamp!

timestamp: aTimeStamp 
	timestamp := aTimeStamp!

timestampForSmalltalkX
	| date time stream names h |
	names := #('jan' 'feb' 'mar' 'apr' 'may' 'jun' 'jul' 'aug' 'sep' 'oct' 'nov' 'dec').
	date := self timestamp date.
	time := self timestamp time.
	stream := WriteStream on: String new.
	stream
		nextPutAll: date dayOfMonth printString;
		nextPut: $-;
		nextPutAll: (names at: date monthIndex);
		nextPut: $-;
		nextPutAll: date year printString;
		nextPut: $ .
	h := time hours > 12 ifTrue: [24 - time hours] ifFalse: [time hours].
	h = 0 ifTrue: [h := 12].
	h < 10 ifTrue: [h := '0' , h printString] ifFalse: [h := h printString].
	stream
		nextPutAll: h;
		nextPut: $:.
	time minutes < 10 
		ifTrue: [h := '0' , time minutes printString]
		ifFalse: [h := time minutes printString].
	stream
		nextPutAll: h;
		nextPut: $:.
	time seconds < 10 
		ifTrue: [h := '0' , time seconds printString]
		ifFalse: [h := time seconds printString].
	stream
		nextPutAll: h;
		nextPut: $ .
	h := 'am'.
	(time hours >= 12 and: [time hours < 24]) ifTrue: [h := 'pm'].
	stream nextPutAll: h.
	^stream contents!

timestampValue
	^timestamp isNil ifTrue: ['0'] ifFalse: [timestamp asSeconds printString]!

versionInfo
	^StsMethodVersionNotification new edition: self! !
!StsEdition categoriesFor: #blessingString!public! !
!StsEdition categoriesFor: #className!accessing!public! !
!StsEdition categoriesFor: #classNameForVisualWorks:!public! !
!StsEdition categoriesFor: #convertToSqueakPackageName:!public! !
!StsEdition categoriesFor: #developer!public! !
!StsEdition categoriesFor: #developer:!public! !
!StsEdition categoriesFor: #developerForSmalltalkX!public! !
!StsEdition categoriesFor: #fullClassNameForVisualWorks:!public! !
!StsEdition categoriesFor: #logError:!public! !
!StsEdition categoriesFor: #logMethodOverride:!public! !
!StsEdition categoriesFor: #logWarning:!public! !
!StsEdition categoriesFor: #possibleBlessingLevels!public! !
!StsEdition categoriesFor: #putSmalltalkXDeveloperAndTimestampOn:!public! !
!StsEdition categoriesFor: #replaceBlanksWithDash:!public! !
!StsEdition categoriesFor: #resolveProxies!OmniBase!public! !
!StsEdition categoriesFor: #sourceControl!constants!development!public! !
!StsEdition categoriesFor: #sourceManager!public! !
!StsEdition categoriesFor: #timestamp!public! !
!StsEdition categoriesFor: #timestamp:!public! !
!StsEdition categoriesFor: #timestampForSmalltalkX!public! !
!StsEdition categoriesFor: #timestampValue!public! !
!StsEdition categoriesFor: #versionInfo!accessing!public! !

!StsEdition class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

iconImageForVersion: aString
	^self icon imageIndex!

new
	^super new initialize!

possibleBlessingLevels
	"Answer a collection of blessing level symbols ordered from the lowest blessing level to the highest."

	^#(#obsolete #broken #workInProgress #development #patch #integrationReady #integrated #merged #tested #internalRelease #released)! !
!StsEdition class categoriesFor: #icon!constants!public! !
!StsEdition class categoriesFor: #iconImageForVersion:!public! !
!StsEdition class categoriesFor: #new!public! !
!StsEdition class categoriesFor: #possibleBlessingLevels!public! !

