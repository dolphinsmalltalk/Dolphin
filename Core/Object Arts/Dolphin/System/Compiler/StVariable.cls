"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StVariable
	instanceVariableNames: 'scope reads writes'
	classVariableNames: 'ReadMask WrittenMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StVariable guid: (GUID fromString: '{c0f71430-b170-427f-a259-f06ca5fc44d7}')!
StVariable addClassConstant: 'ReadMask' value: 1!
StVariable addClassConstant: 'WrittenMask' value: 2!
StVariable comment: ''!
!StVariable categoriesForClass!Kernel-Objects! !
!StVariable methodsFor!

addRead: anStVariableNode
	(reads ifNil: [reads := OrderedCollection new]) addLast: anStVariableNode!

addWrite: anStVariableNode
	(writes ifNil: [writes := OrderedCollection new]) addLast: anStVariableNode!

isArgument
	^false!

isConstant
	^false!

isInstanceVariable
	^false!

isLocalVariable
	^false!

isRead
	^reads notNil!

isStaticVariable
	^false!

isTempVariable
	^false!

isWritten
	^writes notNil!

name
	^self subclassResponsibility!

printOn: aPuttableStream
	self basicPrintOn: aPuttableStream.
	aPuttableStream
		nextPut: $(;
		display: self name;
		nextPut: $)!

reads
	^reads ?? #()!

scope
	^scope!

scope: anStSemanticScope
	scope := anStSemanticScope!

valueClass
	"Answer the class of the variables value, if this is known, or nil if unknown. In Smalltalk
	we only know the type that a variable can assume in the case of constants as variables are
	untyped."

	^nil!

writes
	^writes ?? #()! !
!StVariable categoriesFor: #addRead:!public! !
!StVariable categoriesFor: #addWrite:!public! !
!StVariable categoriesFor: #isArgument!public!testing! !
!StVariable categoriesFor: #isConstant!public!testing! !
!StVariable categoriesFor: #isInstanceVariable!public!testing! !
!StVariable categoriesFor: #isLocalVariable!public!testing! !
!StVariable categoriesFor: #isRead!public!testing! !
!StVariable categoriesFor: #isStaticVariable!public!testing! !
!StVariable categoriesFor: #isTempVariable!public!testing! !
!StVariable categoriesFor: #isWritten!public!testing! !
!StVariable categoriesFor: #name!accessing!public! !
!StVariable categoriesFor: #printOn:!public! !
!StVariable categoriesFor: #reads!accessing!public! !
!StVariable categoriesFor: #scope!accessing!public! !
!StVariable categoriesFor: #scope:!accessing!public! !
!StVariable categoriesFor: #valueClass!accessing!public! !
!StVariable categoriesFor: #writes!accessing!public! !

!StVariable class methodsFor!

initialize
	self addClassConstant: 'ReadMask' value: 1.
	self addClassConstant: 'WrittenMask' value: 2! !
!StVariable class categoriesFor: #initialize!public! !

