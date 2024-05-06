"Filed out from Dolphin Smalltalk"!

Object variableSubclass: #MethodContext
	instanceVariableNames: 'frame method receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MethodContext guid: (GUID fromString: '{87b4c4a2-026e-11d3-9fd7-00a0cc3e4a32}')!

MethodContext comment: 'MethodContext is present only to assist in the conversion of old view resources. It is no longer used.'!

!MethodContext categoriesForClass!Deprecated! !

!MethodContext methodsFor!

frame
	^frame!

method
	^method!

receiver
	^receiver! !

!MethodContext categoriesForMethods!
frame!accessing!private! !
method!accessing!private! !
receiver!accessing!private! !
!

!MethodContext class methodsFor!

stbConvertFrom: format 
	^
	[:data | 
	| ctxt size |
	size := data size.
	format version < 1 
		ifTrue: 
			[
			"Version 0 was the original Dolphin representation (Smalltalk-80 style blocks)"
			ctxt := self basicNew: size - 3.
			1 to: data size do: [:i | ctxt instVarAt: i put: (data at: i)]]
		ifFalse: 
			[
			"Version 1 was an interim format used during the migration to the BlockClosure VM"
			ctxt := Context basicNew: size - 4.
			1 to: size - 4 do: [:i | ctxt basicAt: i put: (data at: i + 4)].
			ctxt outer: (data at: 1)].
	ctxt]!

stbVersion
	^2
! !

!MethodContext class categoriesForMethods!
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!constants!private! !
!

