"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMCUSTOMDRAW
	instanceVariableNames: 'item view canvas font'
	classVariableNames: '_OffsetOf_dwDrawStage _OffsetOf_dwItemSpec _OffsetOf_hdc _OffsetOf_lParam _OffsetOf_rc _OffsetOf_uItemState'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMCUSTOMDRAW guid: (GUID fromString: '{1123e900-72b4-46d6-81b5-8122b9e2393f}')!

NMCUSTOMDRAW addClassConstant: '_OffsetOf_dwDrawStage' value: 16rC!
NMCUSTOMDRAW addClassConstant: '_OffsetOf_dwItemSpec' value: 16r24!
NMCUSTOMDRAW addClassConstant: '_OffsetOf_hdc' value: 16r10!
NMCUSTOMDRAW addClassConstant: '_OffsetOf_lParam' value: 16r2C!
NMCUSTOMDRAW addClassConstant: '_OffsetOf_rc' value: 16r14!
NMCUSTOMDRAW addClassConstant: '_OffsetOf_uItemState' value: 16r28!

NMCUSTOMDRAW comment: '`NMCUSTOMDRAW` is an `ExternalStructure` class to represent the Win32 structure of the same name.

`NMCUSTOMDRAW` structures are sent as parameter blocks along with certain WM_NOTIFY messages from Windows common controls such as the `ListView` and `TreeView` to request custom draw information for individual items (and optionally sub-items).

All the fields in this structure are read-only. Specialized sub-structures provide fields which can be written to in order to pass custom draw settings back to the control (for example the foreground and background text colours). The DC associated with this structure can also be updated by changing the font, and so forth.

'!

!NMCUSTOMDRAW categoriesForClass!External-Data-Structured-Win32! !

!NMCUSTOMDRAW methodsFor!

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

	canvas isNil ifTrue: [canvas := Canvas withNonOwnedDC: self hdc].
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
	"Answer the <RECT> value of the receiver's 'rc' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rc!

uItemState
	"Answer the <Integer> value of the receiver's 'uItemState' field."

	^bytes dwordAtOffset: _OffsetOf_uItemState!

view
	"Answer the sub-instance of <IconListAbstract> for which this is a <customDrawContext>."

	^view!

view: anIconListAbstract
	"Private -"
	view := anIconListAbstract! !

!NMCUSTOMDRAW categoriesForMethods!
applyFont!operations!private! !
backcolor!accessing!public! !
backcolor:!accessing!public! !
boundingRectangle!accessing!public! !
canvas!accessing!public! !
dwDrawStage!**compiled accessors**!public! !
dwItemSpec!**compiled accessors**!public! !
evaluateDrawBlock:!operations!public! !
font!accessing!public! !
font:!accessing!public! !
forecolor!accessing!public! !
forecolor:!accessing!public! !
hasFocus!public!testing! !
hdc!**compiled accessors**!public! !
isChecked!public!testing! !
isDefault!public!testing! !
isDisabled!public!testing! !
isGrayed!public!testing! !
isHot!public!testing! !
isIndeterminate!public!testing! !
isMarked!public!testing! !
isSelected!public!testing! !
item!accessing!public! !
item:!accessing!private! !
itemHandle!accessing!private! !
lParam!**compiled accessors**!public! !
rc!**compiled accessors**!public! !
uItemState!**compiled accessors**!public! !
view!accessing!public! !
view:!accessing!private! !
!

NMCUSTOMDRAW methodProtocol: #customDrawContext attributes: #(#readOnly) selectors: #(#backcolor #backcolor: #boundingRectangle #canvas #font #font: #forecolor #forecolor: #hasFocus #isChecked #isDefault #isDisabled #isGrayed #isHot #isIndeterminate #isSelected #view)!

!NMCUSTOMDRAW class methodsFor!

defineFields
	"Define the structure template for Win32 NMCUSTOMDRAW structure.
		self compileDefinition
	"

	super defineFields.
	self
		defineField: #dwDrawStage type: DWORDField readOnly;
		defineField: #hdc type: HANDLEField readOnly;
		defineField: #rc type: (StructureField type: RECT) beReadOnly;
		defineField: #dwItemSpec type: DWORDField readOnly;
		defineField: #uItemState type: DWORDField readOnly;
		defineField: #lParam type: UINT_PTRField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwDrawStage #hdc #rc #dwItemSpec #uItemState #lParam)! !

!NMCUSTOMDRAW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

