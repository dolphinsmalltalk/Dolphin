"Filed out from Dolphin Smalltalk 2000 release 4.01"!

ValueDialog subclass: #RenameInstVarDialog
	instanceVariableNames: 'oldNamePresenter newNamePresenter instVar numArgs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameInstVarDialog comment: ''!

RenameInstVarDialog guid: (GUID fromString: '{E7610471-16EF-11D5-B80B-000102677BBF}')!

!RenameInstVarDialog categoriesForClass!Unclassified! !
!RenameInstVarDialog methodsFor!

countArgs: aString

	^aString inject: 0 into: [:sum : each | each = $: ifTrue: [sum + 1] ifFalse: [sum]].!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	newNamePresenter := self add: TextPresenter new name: 'newName'.
	oldNamePresenter := self add: TextPresenter new name: 'oldName'.
!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.

	newNamePresenter 
		when: #valueChanged send: #validateName to: self.
!

model: anRBMethod
	"Set the model associated with the receiver." 

	| aspectBuffer |

	super model: anRBMethod. 
	aspectBuffer := self model.
	instVar := anRBMethod selector.
	newNamePresenter model: (anRBMethod aspectValue: #selector). 
	oldNamePresenter model: (anRBMethod aspectValue: #selector). 


!

onViewOpened

	super onViewOpened.
	oldNamePresenter value: instVar.
	numArgs := self countArgs: instVar.!

queryCommand: aCommandQuery

	super queryCommand: aCommandQuery.

	aCommandQuery command == #ok
		ifTrue: [aCommandQuery enabled: self validateName].!

setInitialFocus
	
	newNamePresenter setFocus!

validateName
"rbDmmFix - can't make oldName update as newName is entered"
	| x |

	oldNamePresenter value: newNamePresenter value.
	self invalidateUserInterface.
	x := self countArgs: newNamePresenter value.
	^x = numArgs.
! !
!RenameInstVarDialog categoriesFor: #countArgs:!*-unclassified!public! !
!RenameInstVarDialog categoriesFor: #createComponents!*-unclassified!private! !
!RenameInstVarDialog categoriesFor: #createSchematicWiring!*-unclassified!public! !
!RenameInstVarDialog categoriesFor: #model:!*-unclassified!private! !
!RenameInstVarDialog categoriesFor: #onViewOpened!*-unclassified!public! !
!RenameInstVarDialog categoriesFor: #queryCommand:!*-unclassified!private! !
!RenameInstVarDialog categoriesFor: #setInitialFocus!*-unclassified!private! !
!RenameInstVarDialog categoriesFor: #validateName!*-unclassified!private! !

!RenameInstVarDialog class methodsFor!

defaultView
	"Answer the resource name of the default view for the receiver."

	^'defaultView'! !
!RenameInstVarDialog class categoriesFor: #defaultView!*-unclassified!public! !

