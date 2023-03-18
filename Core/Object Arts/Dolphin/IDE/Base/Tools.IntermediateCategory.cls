"Filed out from Dolphin Smalltalk"!

Core.Category
	subclass: #'Tools.IntermediateCategory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.IntermediateCategory guid: (Core.GUID fromString: '{87b4c501-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.IntermediateCategory comment: ''!
!Tools.IntermediateCategory categoriesForClass!System-Support! !
!Tools.IntermediateCategory methodsFor!

acceptsAdditions
	"Answer whether new members can be added to the receiver.
	Intermediate categories are merely placeholders in the tree, and cannot
	have methods or classes added to them directly."

	^false!

addClass: class
	"Add the <Class>, class, to the collection of classes associated with the receiver."

	^self shouldNotImplement!

addMethod: method
	"Add the <CompiledMethod>, method, to the collection of methods within the receiver.
	As this is a pseudo category witch calculated membership, we just ignore the request."
!

addMethodSilently: method
	"Private - Add the <CompiledMethod>, method, to the collection of methods within the receiver
	without making any fuss.
	As this is a pseudo category with calculated membership, we just ignore the request."!

contents
	Notification deprecated.
	^#()!

includesMethod: method
	"Answer whether the receiver includes the <CompiledMethod>, method.
	Intermediate categories (i.e. non-terminal branches of the category tree)
	never include any methods."

	^false!

isEmpty
	"Answer whether the receiver is an empty category (with no members)"

	^true!

isIntermediate
	"Private - Answer whether the receiver is a temporary category used only as a 
	branch node in a category tree."

	^true!

methodsInBehavior: class
	"Answer all the methods in the <Behavior>, class, which are members of the receiver.
	We aren't able to determine this readily."

	^Set new!

methodsInBehavior: aBehavior do: aMonadicValuable 
!

removeClass: class
	"Remove the <ClassDescription>, class, from the classes 'held' by the receiver."

	^self shouldNotImplement! !
!Tools.IntermediateCategory categoriesForMethods!
acceptsAdditions!public!testing! !
addClass:!adding!public! !
addMethod:!adding!public! !
addMethodSilently:!adding!private! !
contents!enumerating!public! !
includesMethod:!public!testing! !
isEmpty!public!testing! !
isIntermediate!private!testing! !
methodsInBehavior:!enumerating!public! !
methodsInBehavior:do:!enumerating!public! !
removeClass:!development!public!removing! !
!

!Tools.IntermediateCategory class methodsFor!

name: categoryName
	"Answer the subinstance of the receiver with the 
	<readableString> name, categoryName."

	^self newNamed: categoryName!

unclassifiedName
	^self shouldNotImplement! !
!Tools.IntermediateCategory class categoriesForMethods!
name:!instance creation!public! !
unclassifiedName!constants!private! !
!

