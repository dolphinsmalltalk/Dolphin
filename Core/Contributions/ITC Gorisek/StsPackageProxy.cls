"Filed out from Dolphin Smalltalk X6.2"!

StsImportProxy subclass: #StsPackageProxy
	instanceVariableNames: 'stream classes looseMethods resources globals prerequisiteNames imageStripperBytes aboutBlock scripts manualPrerequisites packagePathname versionComment blessing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsPackageProxy guid: (GUID fromString: '{F810498E-9AB5-47D0-BD85-02980ADD9496}')!
StsPackageProxy comment: ''!
!StsPackageProxy categoriesForClass!Unclassified! !
!StsPackageProxy methodsFor!

aboutBlock
	^aboutBlock!

addResource: aDolphinResourceProxy 
	resources isNil ifTrue: [resources := OrderedCollection new].
	resources add: aDolphinResourceProxy!

allResourceIdentifiers
	^resources!

blessing
	^blessing!

blessing: aSymbolOrNil 
	(blessing isNil or: [self possibleBlessingLevels includes: aSymbolOrNil]) 
		ifFalse: [self error: 'Invalid blessing level'].
	blessing := aSymbolOrNil!

classes
	^classes!

classNamed: className 
	^classes detect: [:each | each name = className] ifNone: []!

comment
	^comment!

findOrCreateClassNamed: className 
	| classProxy |
	(classProxy := self classNamed: className) isNil ifFalse: [^classProxy].
	classProxy := StsClassProxy new.
	classProxy
		name: className;
		definition: 'Object subclass: ' , className printString 
					, '
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	classInstanceVariableNames: ''''';
		comment: ''.
	classes add: classProxy.
	^classProxy!

global: globalName put: globalValue 
	self globals at: globalName put: globalValue!

globalNames
	^self globals keys!

globals
	globals isNil ifTrue: [globals := LookupTable new].
	^globals!

imageStripperBytes
	^imageStripperBytes!

imageStripperBytes: aByteArray 
	imageStripperBytes := aByteArray!

isChanged: aBoolean 
	!

load
	self subclassResponsibility!

loadFrom: pathname 
	| result |
	classes := OrderedCollection new.
	looseMethods := OrderedCollection new.
	version := ''.
	comment := ''.
	resources := OrderedCollection new.
	stream := FileStream read: pathname text: true.
	[result := self load] ensure: [stream close].
	^result!

manualPrerequisites
	^manualPrerequisites isNil ifTrue: [#()] ifFalse: [manualPrerequisites]!

methods
	^looseMethods!

packagePathname
	^packagePathname!

packagePathname: aString 
	packagePathname := (aString isNil or: [aString trimBlanks isEmpty]) ifFalse: [aString]!

packageVersion
	^version!

packageVersion: aString 
	version := aString!

prerequisiteNames
	^prerequisiteNames isNil ifTrue: [#()] ifFalse: [prerequisiteNames]!

prerequisiteNames: aCollection 
	prerequisiteNames := aCollection!

removeEndingSpace: aString 
	^(aString size > 1 and: [(aString copyFrom: aString size - 1 to: aString size) = ' ''']) 
		ifFalse: [aString]
		ifTrue: [(aString copyFrom: 1 to: aString size - 2) , '''']!

resources
	^resources!

scriptAt: aSymbol 
	^self scripts at: aSymbol ifAbsent: ['']!

scriptAt: scriptSymbol put: aString 
	self scripts at: scriptSymbol put: aString!

scripts
	scripts isNil ifTrue: [scripts := LookupTable new].
	^scripts!

undoubleMarkers: sourceString 
	| rs result |
	rs := ReadStream on: sourceString.
	result := rs upTo: $!!.
	[rs atEnd or: [(rs peekFor: $!!) not]] whileFalse: [result := result , '!!' , (rs upTo: $!!)].
	^result!

versionComment
	^versionComment!

versionComment: aStringOrNil 
	versionComment := aStringOrNil! !
!StsPackageProxy categoriesFor: #aboutBlock!public! !
!StsPackageProxy categoriesFor: #addResource:!public! !
!StsPackageProxy categoriesFor: #allResourceIdentifiers!public! !
!StsPackageProxy categoriesFor: #blessing!accessing!public! !
!StsPackageProxy categoriesFor: #blessing:!accessing!public! !
!StsPackageProxy categoriesFor: #classes!public! !
!StsPackageProxy categoriesFor: #classNamed:!public! !
!StsPackageProxy categoriesFor: #comment!public! !
!StsPackageProxy categoriesFor: #findOrCreateClassNamed:!public! !
!StsPackageProxy categoriesFor: #global:put:!public! !
!StsPackageProxy categoriesFor: #globalNames!public! !
!StsPackageProxy categoriesFor: #globals!public! !
!StsPackageProxy categoriesFor: #imageStripperBytes!public! !
!StsPackageProxy categoriesFor: #imageStripperBytes:!public! !
!StsPackageProxy categoriesFor: #isChanged:!public! !
!StsPackageProxy categoriesFor: #load!public! !
!StsPackageProxy categoriesFor: #loadFrom:!public! !
!StsPackageProxy categoriesFor: #manualPrerequisites!public! !
!StsPackageProxy categoriesFor: #methods!public! !
!StsPackageProxy categoriesFor: #packagePathname!public! !
!StsPackageProxy categoriesFor: #packagePathname:!public! !
!StsPackageProxy categoriesFor: #packageVersion!public! !
!StsPackageProxy categoriesFor: #packageVersion:!public! !
!StsPackageProxy categoriesFor: #prerequisiteNames!public! !
!StsPackageProxy categoriesFor: #prerequisiteNames:!public! !
!StsPackageProxy categoriesFor: #removeEndingSpace:!public! !
!StsPackageProxy categoriesFor: #resources!public! !
!StsPackageProxy categoriesFor: #scriptAt:!public! !
!StsPackageProxy categoriesFor: #scriptAt:put:!public! !
!StsPackageProxy categoriesFor: #scripts!public! !
!StsPackageProxy categoriesFor: #undoubleMarkers:!public! !
!StsPackageProxy categoriesFor: #versionComment!public! !
!StsPackageProxy categoriesFor: #versionComment:!public! !

