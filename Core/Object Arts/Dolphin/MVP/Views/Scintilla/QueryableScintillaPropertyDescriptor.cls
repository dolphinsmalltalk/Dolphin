"Filed out from Dolphin Smalltalk 7"!

ScintillaPropertyDescriptor subclass: #QueryableScintillaPropertyDescriptor
	instanceVariableNames: 'setSelector getMessage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
QueryableScintillaPropertyDescriptor guid: (GUID fromString: '{79e183f7-c42e-4a53-8327-d3696fc9b52b}')!
QueryableScintillaPropertyDescriptor comment: 'QueryableScintillaPropertyDescriptors provide metadata for individual scalar properties of a <ScintillaView> that can be queries as well as set, e.g. the width of a margin.

Instance Variables:
	setSelector		<symbol>. Mutator message to send to the object that represents the composite Scintilla attribute to which the described property relates in order to store the property value queried from the control.
	getMessage		<SmallInteger> id of the message to send to the control in order to query the property value, e.g. SCI_MARGINGETWIDTH.


'!
!QueryableScintillaPropertyDescriptor categoriesForClass!Kernel-Objects! !
!QueryableScintillaPropertyDescriptor methodsFor!

getMessage
	^getMessage!

setSelector
	^setSelector!

setSelector: aSymbol getMessage: anInteger
	setSelector := aSymbol.
	getMessage := anInteger! !
!QueryableScintillaPropertyDescriptor categoriesFor: #getMessage!accessing!public! !
!QueryableScintillaPropertyDescriptor categoriesFor: #setSelector!accessing!public! !
!QueryableScintillaPropertyDescriptor categoriesFor: #setSelector:getMessage:!initializing!private! !

!QueryableScintillaPropertyDescriptor class methodsFor!

getSelector: getSymbol defaultValue: anObject setMessage: setInteger setSelector: setSymbol getMessage: getInteger
	^(self new)
		getSelector: getSymbol
			defaultValue: anObject
			setMessage: setInteger;
		setSelector: setSymbol getMessage: getInteger! !
!QueryableScintillaPropertyDescriptor class categoriesFor: #getSelector:defaultValue:setMessage:setSelector:getMessage:!instance creation!public! !

