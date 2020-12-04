"Filed out from Dolphin Smalltalk 7"!

OS.NMHDR subclass: #'OS.NMCUSTOMDRAW'
	instanceVariableNames: 'item view canvas font'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwDrawStage' -> 16rC.
		'_OffsetOf_dwItemSpec' -> 16r24.
		'_OffsetOf_hdc' -> 16r10.
		'_OffsetOf_lParam' -> 16r2C.
		'_OffsetOf_rc' -> 16r14.
		'_OffsetOf_uItemState' -> 16r28
	}!
OS.NMCUSTOMDRAW guid: (Core.GUID fromString: '{1123e900-72b4-46d6-81b5-8122b9e2393f}')!
OS.NMCUSTOMDRAW comment: '`NMCUSTOMDRAW` is an `ExternalStructure` class to represent the Win32 structure of the same name.

`NMCUSTOMDRAW` structures are sent as parameter blocks along with certain WM_NOTIFY messages from Windows common controls such as the `ListView` and `TreeView` to request custom draw information for individual items (and optionally sub-items).

All the fields in this structure are read-only. Specialized sub-structures provide fields which can be written to in order to pass custom draw settings back to the control (for example the foreground and background text colours). The DC associated with this structure can also be updated by changing the font, and so forth.

'!
!OS.NMCUSTOMDRAW categoriesForClass!External-Data-Structured-Win32! !
!OS.NMCUSTOMDRAW methodsFor!

applyFont
	"Private - Apply the new font (if changed) to the custom draw DC and answer whether
	a new font was indeed selected."

	^(font notNil and: [font basicHandle ~= self canvas fontHandle])
		ifTrue: 
			[#todo.	"It's definitely not a good idea to delete old font here (the default font will
			 probably get deleted, but we rely on the fact that finalization happens in
			 the background so that the font we supply in place is not deleted until
			 after the drawing cycle is complete. This seems dangerous."
			self canvas font: font.
			CDRF_NEWFONT]
		ifFalse: [CDRF_DODEFAULT]!

backcolor
	"Answer the background <Color>."

	^self canvas backcolor!

backcolor: aColor
	"Sets the background <Color>."

	self canvas backcolor: aColor!

boundingRectangle
	"Answer the <Rectangle> within which the item is being displayed (in the client co-ordinates
	of the view."

	^self rc asRectangle!

canvas
	"Answer the <Canvas> associated with the receiver (useful for custom modifications,
	but private because care is needed to avoid leaks)."

	canvas isNil ifTrue: [canvas := Graphics.Canvas withNonOwnedDC: self hdc].
	^canvas!

dwDrawStage
	"Answer the <Integer> value of the receiver's 'dwDrawStage' field."

	^bytes dwordAtOffset: _OffsetOf_dwDrawStage!

dwItemSpec
	"Answer the <Integer> value of the receiver's 'dwItemSpec' field."

	^bytes dwordAtOffset: _OffsetOf_dwItemSpec!

evaluateDrawBlock: customDrawBlock
	"Private - Evaluate the <monadicValuable>, customDrawBlock, and answer the appropriate instruction
	 for a common control to complete the draw operation (or skip it if total control is taken)."

	^(customDrawBlock value: self) == true ifTrue: [CDRF_SKIPDEFAULT] ifFalse: [self applyFont]!

font
	"Answer the character font."

	^font ifNil: [font := self canvas font]!

font: aFont
	"Set the character font.
	Implementation Note: Don't update the DC with the new font yet."

	font := aFont!

forecolor
	"Answer the foreground text colour."

	^self canvas forecolor!

forecolor: aColor
	"Sets the foreground text <Color>."

	self canvas forecolor: aColor!

hasFocus
	"Answer whether the item being drawn has focus."

	^self uItemState allMask: CDIS_FOCUS!

hdc
	"Answer the <ExternalHandle> value of the receiver's 'hdc' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hdc) asExternalHandle!

isChecked
	"Answer whether the item being draw is 'checked' (i.e. in a list with checkboxes it is ticked)."

	^self uItemState allMask: CDIS_CHECKED!

isDefault
	"Answer whether the item being drawn is the default."

	^self uItemState allMask: CDIS_DEFAULT!

isDisabled
	"Answer whether the item being draw is disabled."

	^self uItemState allMask: CDIS_DISABLED!

isGrayed
	"Answer whether the item being draw is greyed out."

	^self uItemState allMask: CDIS_GRAYED!

isHot
	"Answer whether the item being drawn is hot (i.e. under the cursor 
	when hot tracking is enabled)."

	^self uItemState allMask: CDIS_HOT!

isIndeterminate
	"Answer whether the item being drawn is an indeterminate state."

	^self uItemState allMask: CDIS_INDETERMINATE  !

isMarked
	"Answer whether the item being drawn is marked (whatever that means)."

	^self uItemState allMask: CDIS_MARKED!

isSelected
	"Answer whether the item being draw is selected."

	^self uItemState allMask: CDIS_SELECTED!

item
	"Answer the object from the view's model that is being drawn (the item,
	which is pre-cached)."

	^item!

item: anObject
	"Private - Private -Record the item being drawn."

	item := anObject!

itemHandle
	"Private - Answer the 'handle' of the receiver's node."

	^self dwItemSpec!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

rc
	"Answer the <RECTL> value of the receiver's 'rc' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rc!

uItemState
	"Answer the <Integer> value of the receiver's 'uItemState' field."

	^bytes dwordAtOffset: _OffsetOf_uItemState!

view
	"Answer the sub-instance of <IconListAbstract> for which this is a <customDrawContext>."

	^view!

view: anIconListAbstract
	"Private -"
	view := anIconListAbstract! !
!OS.NMCUSTOMDRAW categoriesFor: #applyFont!operations!private! !
!OS.NMCUSTOMDRAW categoriesFor: #backcolor!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #backcolor:!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #boundingRectangle!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #canvas!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #dwDrawStage!**compiled accessors**!public! !
!OS.NMCUSTOMDRAW categoriesFor: #dwItemSpec!**compiled accessors**!public! !
!OS.NMCUSTOMDRAW categoriesFor: #evaluateDrawBlock:!operations!public! !
!OS.NMCUSTOMDRAW categoriesFor: #font!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #font:!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #forecolor!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #forecolor:!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #hasFocus!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #hdc!**compiled accessors**!public! !
!OS.NMCUSTOMDRAW categoriesFor: #isChecked!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #isDefault!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #isDisabled!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #isGrayed!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #isHot!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #isIndeterminate!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #isMarked!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #isSelected!public!testing! !
!OS.NMCUSTOMDRAW categoriesFor: #item!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #item:!accessing!private! !
!OS.NMCUSTOMDRAW categoriesFor: #itemHandle!accessing!private! !
!OS.NMCUSTOMDRAW categoriesFor: #lParam!**compiled accessors**!public! !
!OS.NMCUSTOMDRAW categoriesFor: #rc!**compiled accessors**!public! !
!OS.NMCUSTOMDRAW categoriesFor: #uItemState!**compiled accessors**!public! !
!OS.NMCUSTOMDRAW categoriesFor: #view!accessing!public! !
!OS.NMCUSTOMDRAW categoriesFor: #view:!accessing!private! !

OS.NMCUSTOMDRAW methodProtocol: #customDrawContext attributes: #(#readOnly) selectors: #(#backcolor #backcolor: #boundingRectangle #canvas #font #font: #forecolor #forecolor: #hasFocus #isChecked #isDefault #isDisabled #isGrayed #isHot #isIndeterminate #isSelected #view)!

!OS.NMCUSTOMDRAW class methodsFor!

defineFields
	"Define the structure template for Win32 NMCUSTOMDRAW structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #dwDrawStage type: DWORDField readOnly;
		defineField: #hdc type: HANDLEField readOnly;
		defineField: #rc type: (StructureField type: RECTL) beReadOnly;
		defineField: #dwItemSpec type: DWORDField readOnly;
		defineField: #uItemState type: DWORDField readOnly;
		defineField: #lParam type: UINT_PTRField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwDrawStage #hdc #rc #dwItemSpec #uItemState #lParam)! !
!OS.NMCUSTOMDRAW class categoriesFor: #defineFields!public!template definition! !
!OS.NMCUSTOMDRAW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

