"Filed out from Dolphin Smalltalk 7"!

StVariable subclass: #StLocalVariable
	instanceVariableNames: 'node'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLocalVariable guid: (GUID fromString: '{0a285b01-fe92-41ca-97c5-99914ab50746}')!
StLocalVariable comment: ''!
!StLocalVariable categoriesForClass!Kernel-Objects! !
!StLocalVariable methodsFor!

isLocalVariable
	^true!

name
	^node name!

node
	^node!

setNode: anStVariableNode
	node := anStVariableNode! !
!StLocalVariable categoriesFor: #isLocalVariable!public!testing! !
!StLocalVariable categoriesFor: #name!accessing!public! !
!StLocalVariable categoriesFor: #node!accessing!public! !
!StLocalVariable categoriesFor: #setNode:!accessing!initializing!private! !

!StLocalVariable class methodsFor!

node: anStTempDecl
	^self new setNode: anStTempDecl! !
!StLocalVariable class categoriesFor: #node:!public! !

