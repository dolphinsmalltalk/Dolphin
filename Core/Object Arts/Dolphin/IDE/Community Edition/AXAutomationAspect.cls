"Filed out from Dolphin Smalltalk X6.2"!

Aspect subclass: #AXAutomationAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXAutomationAspect guid: (GUID fromString: '{4FBB641D-1F5C-4DCF-B8F6-DD525A4BBB0F}')!
AXAutomationAspect comment: 'AXAutomationAspect is the abstract superclass of <Aspect>s specialised for accessing properties and fields of Active-X Automation objects. It is an extension of the PublishedAspectorInspector framework.'!
!AXAutomationAspect categoriesForClass!Development! !
!AXAutomationAspect methodsFor!

canReadFrom: anObject
	^self isReadable!

canWriteInto: anObject
	^self isWriteable! !
!AXAutomationAspect categoriesFor: #canReadFrom:!public!testing! !
!AXAutomationAspect categoriesFor: #canWriteInto:!public!testing! !

