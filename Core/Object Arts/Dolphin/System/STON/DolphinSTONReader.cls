"Filed out from Dolphin Smalltalk 7"!

STONReader subclass: #DolphinSTONReader
	instanceVariableNames: 'classInstVarMaps'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinSTONReader guid: (GUID fromString: '{a8dab6bc-8e16-483a-adee-741c2aa9f0f7}')!
DolphinSTONReader comment: ''!
!DolphinSTONReader categoriesForClass!Unclassified! !
!DolphinSTONReader methodsFor!

consumeWhitespace
	"Strip whitespaces from the input stream."

	readStream skipSeparators!

indexOfInstVarNamed: aSymbol of: aClass
	^(classInstVarMaps at: aClass
		ifAbsentPut: 
			[| map |
			map := LookupTable new.
			aClass allInstVarNames keysAndValuesDo: [:eachKey :eachValue | map at: eachValue put: eachKey].
			map])
			at: aSymbol asString!

initialize
	super initialize.
	classInstVarMaps := IdentityDictionary new!

lookupClass: aSymbol
	^(Smalltalk bindingFor: aSymbol)
		ifNotNil: [:binding | binding value]
		ifNil: 
			[classes at: aSymbol
				ifAbsentPut: 
					[Object allSubclasses detect: [:class | class stonName == aSymbol]
						ifNone: [NotFoundError signalFor: aSymbol]]]!

parseNamedInstVarsFor: anObject
	self parseMapDo: [ :instVarName :value |
		anObject instVarAt: (self indexOfInstVarNamed: instVarName of: anObject class) put: value ]! !
!DolphinSTONReader categoriesFor: #consumeWhitespace!parsing!private! !
!DolphinSTONReader categoriesFor: #indexOfInstVarNamed:of:!helpers!private! !
!DolphinSTONReader categoriesFor: #initialize!initialize/release!public! !
!DolphinSTONReader categoriesFor: #lookupClass:!helpers!private! !
!DolphinSTONReader categoriesFor: #parseNamedInstVarsFor:!parsing!public! !

