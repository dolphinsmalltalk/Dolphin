"Filed out from Dolphin Smalltalk"!

Tools.AXAutomationAspect
	subclass: #'Tools.AXRecordAspect'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AXRecordAspect guid: (Core.GUID fromString: '{0b80a2c6-1c74-4fe7-9a0e-b28bb197d120}')!
Tools.AXRecordAspect comment: 'AXRecordAspect is a specialised <Aspect> for accessing properties of user-defined Automation structures (as represented by instances of <AXRecord>). It is an extension of the PublishedAspectorInspector framework.'!
!Tools.AXRecordAspect methodsFor!

defaultFlags
	^super defaultFlags maskClear: MutableMask!

readFrom: anObject
	"Private - Answer the attribute of anObject represented by the receiver."

	^[anObject getField: self name] on: Error do: [:ex | ex]!

writeInto: subjectObject value: valueObject
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	[subjectObject setField: self name value: valueObject] on: Error
		do: 
			[:ex |
			MessageBox new
				headline: 'Error setting field <1p>' << self name;
				errorMsg: ex description]! !
!Tools.AXRecordAspect categoriesForMethods!
defaultFlags!initializing!private! !
readFrom:!indirect accessing!public! !
writeInto:value:!indirect accessing!public! !
!

