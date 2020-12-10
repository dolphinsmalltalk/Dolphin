"Filed out from Dolphin Smalltalk 7"!

Tools.Scintilla.InterfaceDefinition subclass: #'Tools.Scintilla.EventDefinition'
	instanceVariableNames: 'args'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Scintilla.EventDefinition guid: (Core.GUID fromString: '{fdf0c39c-6309-4219-a64c-07355e04671c}')!
Tools.Scintilla.EventDefinition comment: ''!
!Tools.Scintilla.EventDefinition categoriesForClass!Development! !
!Tools.Scintilla.EventDefinition methodsFor!

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
!Tools.Scintilla.EventDefinition categoriesFor: #args:!private! !
!Tools.Scintilla.EventDefinition categoriesFor: #constPrefix!constants!initializing!private! !
!Tools.Scintilla.EventDefinition categoriesFor: #generateHandlerOn:!helpers!private! !
!Tools.Scintilla.EventDefinition categoriesFor: #id:name:retType:!initializing!private! !
!Tools.Scintilla.EventDefinition categoriesFor: #retType:!accessing!private! !

!Tools.Scintilla.EventDefinition class methodsFor!

tokens: anArray 
	| evt |
	evt := self 
				id: (anArray at: 3)
				name: (anArray at: 2)
				retType: (anArray at: 1).
	evt args: (anArray copyFrom: 4).
	^evt! !
!Tools.Scintilla.EventDefinition class categoriesFor: #tokens:!instance creation!public! !

