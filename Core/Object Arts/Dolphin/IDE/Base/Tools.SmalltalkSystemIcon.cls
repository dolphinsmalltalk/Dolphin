"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.SmalltalkSystemIcon'
	instanceVariableNames: 'openBlock icon description tool helpId'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SmalltalkSystemIcon guid: (Core.GUID fromString: '{87b4c4ba-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.SmalltalkSystemIcon comment: ''!
!Tools.SmalltalkSystemIcon categoriesForClass!MVP-Models! !
!Tools.SmalltalkSystemIcon methodsFor!

= aSmalltalkSystemIcon
	"Answer true if aSmalltalkSystemIcon is equal to (has the same description as) the receiver."

	^self species == aSmalltalkSystemIcon species and: [
		self description = aSmalltalkSystemIcon description]!

description
	"Answers the <readableString> description for the receiver"

	^description!

hash
	"Answer the SmallInteger hash value for the receiver."

	^description hash!

helpId
	"Answer an integer ID used to associate the receicer with pop-up help"

	^helpId ?? -1!

icon
	"Answers the <Icon> for the receiver"

	^icon ifNil: [tool icon]!

isFolder
	"Answers true if the receiver can hold contents"

	^false!

openBlock
	"Private - Answers the <monadicValuable> open block for the receiver"

	^openBlock ifNil: [[:folder :sysicon | tool show]]!

openIn: aFolderPresenter
	"Opens the receiver within aFolderPresenter"

	^Cursor wait showWhile: [self openBlock value: aFolderPresenter value: self]!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self description;
		nextPut: $)
!

tool
	^tool!

tool: anObject
	tool := anObject!

tool: aToolClass icon: anIcon description: aString openBlock: aMonadicValuable helpId: anIntegerOrNil 
	"Private - Sets the <Icon> for the receiver to anIcon, the <readableString> description
	to aString and the <monadicValuable> open block to aMonadicValuable. The latter is
	evaluated to determine what action to take when an attempt is made to open the receiver
	in a folder presenter. The parameter is the folder presenter displaying the receiver"

	tool := aToolClass.
	icon := anIcon.
	openBlock := aMonadicValuable.
	description := aString.
	helpId := anIntegerOrNil!

whatsThis
	SessionManager current whatsThis: self! !
!Tools.SmalltalkSystemIcon categoriesFor: #=!comparing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #description!accessing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #hash!comparing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #helpId!accessing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #icon!accessing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #isFolder!accessing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #openBlock!accessing!private! !
!Tools.SmalltalkSystemIcon categoriesFor: #openIn:!operations!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #printOn:!printing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #tool!accessing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #tool:!accessing!public! !
!Tools.SmalltalkSystemIcon categoriesFor: #tool:icon:description:openBlock:helpId:!initializing!private! !
!Tools.SmalltalkSystemIcon categoriesFor: #whatsThis!public! !

Tools.SmalltalkSystemIcon methodProtocol: #whatsThisHelp attributes: #(#readOnly) selectors: #(#helpId)!

!Tools.SmalltalkSystemIcon class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Smalltalk developmentSystem icon!

icon: anIcon description: aStringDescription openBlock: aDyadicValuable 
	"Answers an instance of the receiver with anIcon, aStringDescription and the <dyadicValuable> 
	open block set to aDyadicValuable."

	^self 
		icon: anIcon
		description: aStringDescription
		openBlock: aDyadicValuable
		helpId: nil!

icon: anIcon description: aStringDescription openBlock: aDyadicValuable helpId: helpId
	"Answers an instance of the receiver with anIcon, aStringDescription and the <dyadicValuable> 
	open block set to aDyadicValuable."

	^self 
		tool: nil
		icon: anIcon
		description: aStringDescription
		openBlock: aDyadicValuable
		helpId: helpId!

new
	"Private - Use #icon:description:openBlock:."

	^self shouldNotImplement!

show: aToolClass description: aStringDescription 
	"Answers an instance of the receiver for the tool with aToolClass
	and the description in aStringDescription."

	^self 
		tool: aToolClass
		icon: nil
		description: aStringDescription
		openBlock: nil
		helpId: nil!

show: aToolClass description: aStringDescription helpId: helpId
	"Answers an instance of the receiver for the tool with aToolClass
	and the description in aStringDescription."

	^self 
		tool: aToolClass
		icon: nil
		description: aStringDescription
		openBlock: nil
		helpId: helpId!

showModal: aToolClass description: aStringDescription 
	"Answers an instance of the receiver for the modal tool with aToolClass
	and the description in aStringDescription"

	^self 
		tool: aToolClass
		icon: nil
		description: aStringDescription
		openBlock: [:folder :sysicon | aToolClass showModal]
		helpId: nil!

tool: aToolClass icon: anIcon description: aStringDescription openBlock: aDyadicValuable helpId: anIntegerOrNil 
	"Answers an instance of the receiver with anIcon, aStringDescription and the <dyadicValuable> 
	open block set to aDyadicValuable."

	^super new 
		tool: aToolClass
		icon: anIcon
		description: aStringDescription
		openBlock: aDyadicValuable
		helpId: anIntegerOrNil! !
!Tools.SmalltalkSystemIcon class categoriesFor: #icon!constants!public! !
!Tools.SmalltalkSystemIcon class categoriesFor: #icon:description:openBlock:!instance creation!public! !
!Tools.SmalltalkSystemIcon class categoriesFor: #icon:description:openBlock:helpId:!instance creation!public! !
!Tools.SmalltalkSystemIcon class categoriesFor: #new!instance creation!private! !
!Tools.SmalltalkSystemIcon class categoriesFor: #show:description:!instance creation!public! !
!Tools.SmalltalkSystemIcon class categoriesFor: #show:description:helpId:!instance creation!public! !
!Tools.SmalltalkSystemIcon class categoriesFor: #showModal:description:!instance creation!public! !
!Tools.SmalltalkSystemIcon class categoriesFor: #tool:icon:description:openBlock:helpId:!instance creation!public! !

