"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkSystemIcon subclass: #'Tools.SmalltalkSystemFolder'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkSystemFolder guid: (Core.GUID fromString: '{87b4c6df-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.SmalltalkSystemFolder comment: ''!
!Tools.SmalltalkSystemFolder categoriesForClass!MVP-Models! !
!Tools.SmalltalkSystemFolder methodsFor!

isFolder
	"Answers true if the receiver can hold contents"

	^true! !
!Tools.SmalltalkSystemFolder categoriesFor: #isFolder!accessing!public! !

!Tools.SmalltalkSystemFolder class methodsFor!

description: aStringDescription
	"Answers an instance of the receiver with a default icon and aStringDescription"
	
	^self icon: self icon description: aStringDescription
	!

description: aStringDescription helpId: helpId 
	"Answers an instance of the receiver with a default icon and aStringDescription"

	^self 
		icon: self icon
		description: aStringDescription
		helpId: helpId!

icon
	"Answers an Icon that can be used to represent this class"

	^Folder icon!

icon: anIcon description: aStringDescription 
	"Answers an instance of the receiver with anIcon and aStringDescription.
	Implementation Note: Use a message to avoid holding onto the problem
	of a block continuing to reference the last pair of arguments."

	^self 
		icon: anIcon
		description: aStringDescription
		helpId: nil!

icon: anIcon description: aStringDescription helpId: helpId 
	"Answers an instance of the receiver with anIcon and aStringDescription.
	Implementation Note: Use a message to avoid holding onto the problem
	of a block continuing to reference the last pair of arguments."

	^super 
		icon: anIcon
		description: aStringDescription
		openBlock: [:presenter :object | presenter expand: object]
		helpId: helpId! !
!Tools.SmalltalkSystemFolder class categoriesFor: #description:!instance creation!public! !
!Tools.SmalltalkSystemFolder class categoriesFor: #description:helpId:!instance creation!public! !
!Tools.SmalltalkSystemFolder class categoriesFor: #icon!constants!public! !
!Tools.SmalltalkSystemFolder class categoriesFor: #icon:description:!instance creation!public! !
!Tools.SmalltalkSystemFolder class categoriesFor: #icon:description:helpId:!instance creation!public! !

