"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaPropertyDescriptor
	instanceVariableNames: 'getSelector defaultValue setMessage'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaPropertyDescriptor guid: (GUID fromString: '{49848e62-c4d7-4cba-b9f5-71b0bf864a2a}')!
ScintillaPropertyDescriptor comment: 'ScintillaPropertyDescriptors provide metadata for individually settable scalar properties of a <ScintillaView>, e.g. the background colour of a marker.

Instance Variables:
	getSelector		<symbol>. Accessor message to send to object that represents the composite Scintilla attribute in order to retrieve the property value to send to the control.
	defaultValue		<Object>. Default value of the Scintilla property as initialized by the control.
	setMessage		<SmallInteger> id of the message to send to the control to set the property value, e.g. SCI_SETMARKERSETBACK

'!
!ScintillaPropertyDescriptor categoriesForClass!Kernel-Objects! !
!ScintillaPropertyDescriptor methodsFor!

defaultValue
	^defaultValue!

getSelector
	^getSelector!

getSelector: aSymbol defaultValue: anObject setMessage: anInteger
	getSelector := aSymbol.
	defaultValue := anObject.
	setMessage := anInteger!

setMessage
	^setMessage! !
!ScintillaPropertyDescriptor categoriesFor: #defaultValue!accessing!public! !
!ScintillaPropertyDescriptor categoriesFor: #getSelector!accessing!public! !
!ScintillaPropertyDescriptor categoriesFor: #getSelector:defaultValue:setMessage:!initializing!private! !
!ScintillaPropertyDescriptor categoriesFor: #setMessage!accessing!public! !

!ScintillaPropertyDescriptor class methodsFor!

getSelector: aSymbol defaultValue: anObject setMessage: anInteger
	^self new
		getSelector: aSymbol
		defaultValue: anObject
		setMessage: anInteger!

icon
	^ScintillaView icon! !
!ScintillaPropertyDescriptor class categoriesFor: #getSelector:defaultValue:setMessage:!instance creation!public! !
!ScintillaPropertyDescriptor class categoriesFor: #icon!constants!development!public! !

