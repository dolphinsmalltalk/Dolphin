﻿"Filed out from Dolphin Smalltalk"!

Tools.AXAutomationAspect
	subclass: #'Tools.DispatchAspect'
	instanceVariableNames: 'dispid'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.DispatchAspect guid: (Core.GUID fromString: '{dfbf2467-3a73-4b93-8b67-936af2754ec7}')!

Tools.DispatchAspect comment: 'DispatchAspect is a specialised <Aspect> for accessing properties of Automation objects through IDispatch. It is an extension of the PublishedAspectorInspector framework.'!

!Tools.DispatchAspect categoriesForClass!Attribute-Definition! !

!Tools.DispatchAspect methodsFor!

dispid
	^dispid!

dispid: anInteger 
	dispid := anInteger!

readFrom: anObject
	"Private - Answer the attribute of anObject represented by the receiver."

	^[anObject getPropertyId: self dispid] on: Error do: [:ex | ex]!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	[subjectObject setPropertyId: self dispid value: valueObject] on: OS.HRESULTError
		do: 
			[:ex |
			MessageBox new
				headline: 'Unable to set property <1p>' << self name;
				errorMsg: ex description]! !

!Tools.DispatchAspect categoriesForMethods!
dispid!accessing!public! !
dispid:!accessing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

