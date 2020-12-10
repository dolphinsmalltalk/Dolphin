"Filed out from Dolphin Smalltalk 7"!

Aspect subclass: #AXAutomationAspect
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXAutomationAspect guid: (GUID fromString: '{4fbb641d-1f5c-4dcf-b8f6-dd525a4bbb0f}')!
AXAutomationAspect comment: 'AXAutomationAspect is the abstract superclass of <Aspect>s specialised for accessing properties and fields of Active-X Automation objects. It is an extension of the PublishedAspectorInspector framework.'!
!AXAutomationAspect categoriesForClass!Attribute-Definition! !
!AXAutomationAspect methodsFor!

canReadFrom: anObject
	^self isReadable!

canWriteInto: anObject
	^self isWriteable! !
!AXAutomationAspect categoriesFor: #canReadFrom:!public!testing! !
!AXAutomationAspect categoriesFor: #canWriteInto:!public!testing! !

