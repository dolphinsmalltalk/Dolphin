"Filed out from Dolphin Smalltalk"!

ScintillaDef subclass: #ScintillaEventDef
	instanceVariableNames: 'args'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaEventDef guid: (GUID fromString: '{fdf0c39c-6309-4219-a64c-07355e04671c}')!

ScintillaEventDef comment: ''!

!ScintillaEventDef categoriesForClass!Development! !

!ScintillaEventDef methodsFor!

args: anArrayOfArray 
	args := anArrayOfArray!

constPrefix
	^'SCN_'!

generateHandlerOn: stream 
	stream
		nextPutAll: self selector;
		nextPutAll: ' pSCNotification';
		crtab;
		nextPutAll: '"Private - Default handler for an ';
		display: self constName;
		display: ' event.';
		crtab.
	args isEmpty 
		ifTrue: [stream nextPutAll: 'No fields of the notification structure are set.']
		ifFalse: 
			[stream nextPutAll: 'The following fields of the notification structure are set:'.
			args do: 
					[:each | 
					stream
						crtab: 2;
						nextPutAll: each last]].
	stream
		nextPut: $";
		cr;
		crtab;
		nextPutAll: '^nil'!

id: anInteger name: nameString retType: aString 
	super 
		id: anInteger
		name: nameString
		retType: aString.
	selector := ('scn' , name capitalized , ':') asSymbol!

retType: aString 
	self assert: [aString = 'void']! !

!ScintillaEventDef categoriesForMethods!
args:!private! !
constPrefix!constants!initializing!private! !
generateHandlerOn:!helpers!private! !
id:name:retType:!initializing!private! !
retType:!accessing!private! !
!

!ScintillaEventDef class methodsFor!

tokens: anArray 
	| evt |
	evt := self 
				id: (anArray at: 3)
				name: (anArray at: 2)
				retType: (anArray at: 1).
	evt args: (anArray copyFrom: 4).
	^evt! !

!ScintillaEventDef class categoriesForMethods!
tokens:!instance creation!public! !
!

