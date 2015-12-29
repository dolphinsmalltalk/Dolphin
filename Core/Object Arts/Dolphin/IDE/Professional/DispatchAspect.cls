"Filed out from Dolphin Smalltalk X6"!

AXAutomationAspect subclass: #DispatchAspect
	instanceVariableNames: 'dispid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DispatchAspect guid: (GUID fromString: '{DFBF2467-3A73-4B93-8B67-936AF2754EC7}')!
DispatchAspect comment: 'DispatchAspect is a specialised <Aspect> for accessing properties of Automation objects through IDispatch. It is an extension of the PublishedAspectorInspector framework.'!
!DispatchAspect categoriesForClass!Attribute-Definition! !
!DispatchAspect methodsFor!

descriptor: anAXMemberDesc 
	dispid := anAXMemberDesc memid.
	anAXMemberDesc isReadOnly ifTrue: [flags := flags maskClear: WriteableMask | NullableMask].
	^self!

dispid
	^dispid!

readFrom: anObject
	"Private - Answer the attribute of anObject represented by the receiver."

	^[anObject getPropertyId: self dispid] on: Error do: [:ex | ex]!

writeInto: subjectObject value: valueObject 
	"Private - Set the attribute of subjectObject described by the receiver 
	to valueObject."

	[subjectObject setPropertyId: self dispid value: valueObject] on: HRESULTError
		do: 
			[:ex | 
			MessageBox errorMsg: ex description
				caption: ('Error setting property <1p>' expandMacrosWith: self name)]! !
!DispatchAspect categoriesFor: #descriptor:!accessing!public! !
!DispatchAspect categoriesFor: #dispid!accessing!public! !
!DispatchAspect categoriesFor: #readFrom:!indirect accessing!private! !
!DispatchAspect categoriesFor: #writeInto:value:!indirect accessing!private! !

