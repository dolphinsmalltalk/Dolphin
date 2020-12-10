"Filed out from Dolphin Smalltalk 7"!

Tools.Aspect subclass: #'Tools.AXAutomationAspect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AXAutomationAspect guid: (Core.GUID fromString: '{4fbb641d-1f5c-4dcf-b8f6-dd525a4bbb0f}')!
Tools.AXAutomationAspect comment: 'AXAutomationAspect is the abstract superclass of <Aspect>s specialised for accessing properties and fields of Active-X Automation objects. It is an extension of the PublishedAspectorInspector framework.'!
!Tools.AXAutomationAspect categoriesForClass!Attribute-Definition! !
!Tools.AXAutomationAspect methodsFor!

canReadFrom: anObject
	^self isReadable!

canWriteInto: anObject
	^self isWriteable! !
!Tools.AXAutomationAspect categoriesFor: #canReadFrom:!public!testing! !
!Tools.AXAutomationAspect categoriesFor: #canWriteInto:!public!testing! !

