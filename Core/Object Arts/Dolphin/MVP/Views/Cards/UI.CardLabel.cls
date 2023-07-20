"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.CardLabel'
	instanceVariableNames: 'text iconBlock helpId'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.CardLabel guid: (Core.GUID fromString: '{50770bcc-1797-4efb-be30-f06da60566cf}')!
UI.CardLabel comment: '<CardLabel>s are used to ''label'' (that is specify the text and image) the tabs in a <CardContainer>. This is achieved by setting the #arrangement of the view for each tab (typically a <ContainerView> or <ReferenceView>) to be an appropriately configured CardLabel instance.

Instance Variables:
	text			<String> to be displayed as the tab label.
	iconBlock	<niladicValuable> that evaluates to the <Icon> to be displayed on the tab.
'!
!UI.CardLabel categoriesForClass!Kernel-Objects! !
!UI.CardLabel methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self text!

helpId
	^helpId!

helpId: anInteger 
	helpId := anInteger!

icon
	^iconBlock isNil ifTrue: [Icon null] ifFalse: [iconBlock value]!

iconBlock
	^iconBlock!

iconBlock: aNiladicValuable 
	iconBlock := aNiladicValuable!

printOn: aStream 
	aStream
		nextPut: $(;
		display: self class name;
		nextPutAll: ' text: ';
		print: self text.
	iconBlock 
		ifNotNil: 
			[aStream
				nextPutAll: ' iconBlock: [';
				print: iconBlock value;
				nextPut: $]].
	aStream nextPut: $)!

text
	^text!

text: aString 
	text := aString! !
!UI.CardLabel categoriesForMethods!
displayOn:!displaying!public! !
helpId!public! !
helpId:!public! !
icon!accessing!public! !
iconBlock!accessing!public! !
iconBlock:!accessing!public! !
printOn:!printing!public! !
text!accessing!public! !
text:!accessing!public! !
!

UI.CardLabel methodProtocol: #whatsThisHelp attributes: #(#readOnly) selectors: #(#helpId)!

!UI.CardLabel class methodsFor!

new
	^self text: 'Label'!

stbConvertFrom: anSTBClassFormat
	"Version 1 adds helpId instance variable."

	anSTBClassFormat version == 0 ifTrue: [^[:data | (data resize: 3) becomeA: CardLabel]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1!

text: aString 
	^self text: aString iconBlock: nil!

text: aString iconBlock: aNiladicValuable 
	^(super new)
		text: aString;
		iconBlock: aNiladicValuable;
		yourself! !
!UI.CardLabel class categoriesForMethods!
new!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
text:!instance creation!public! !
text:iconBlock:!instance creation!public! !
!

