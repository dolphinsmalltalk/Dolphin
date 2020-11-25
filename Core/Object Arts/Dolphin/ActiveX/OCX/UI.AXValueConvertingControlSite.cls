"Filed out from Dolphin Smalltalk 7"!

AXControlSite subclass: #AXValueConvertingControlSite
	instanceVariableNames: 'typeconverter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AXValueConvertingControlSite guid: (GUID fromString: '{3f495368-8c18-4e53-a039-299027f2e032}')!
AXValueConvertingControlSite comment: 'AXValueConvertingControlSite is a kind of <AXControlSite> that also behaves as if it were a <ValueConvertingControlView>, in particular it implements the <valueView> protocol. 

Use this class in preference to the superclass when hosting Active-X controls that have a single, clearly identifiable, "value". In many cases this will be obvious as the control will implement a Value property. In some cases a value property might not exist due to an oversight of the designer, in which case it can be implemented for the control by generating the control''s default interface and implementing #value and #value: appropriately in it.In other cases there may be multiple properties that could be used as the value, and one must decide whether, from a particular viewpoint, treating the control as a value view onto just one of these properties makes sense. A sensible strategy in these cases is to start off with a generic AXControlSite and only consider using this class as the use of the control is better understood.

See <ValueConvertingControlView> for more information on value converting views.

Instance Variables:
	typeconverter	<typeConverter> used to convert between model values and display values.

'!
!AXValueConvertingControlSite categoriesForClass!MVP-Views! !
!AXValueConvertingControlSite methodsFor!

connectModel
	"Connect the receiver to its model by wiring up event handlers, etc."

	self model 
		when: #valueChanged
		send: #onModelChanged
		to: self!

createControl
	"Private - Create the embedded control in its initalized state, and copy across
	the model value into it. Note that this is not called when restoring from a previously
	saved representation."

	super createControl.
	self onModelChanged!

defaultProgId
	"Answer the 'prog id' of the Active-X control to be hosted in the receiver by default (i.e. initially
	and when no other prog id is specified)."

	^'mshtml:<h2>Active-X Value Converting Control Site</h2>
<h4>Copyright © Object Arts Ltd, 2000</h4>'!

defaultTypeConverter
	"Answers a default type converter to use for the receiver"

	| answer |
	answer := self defaultTypeConverterClass new.
	self initializeNewTypeConverter: answer.
	^answer!

defaultTypeConverterClass
	"Private - Answers a default type converter class for use with the receiver"

	^NullConverter!

displayValue
	"Private - Answers the displayed contents of the receiver"

	^self controlDispatch value!

displayValue: anObject
	"Private - Set the displayed contents of the receiver from anObject."

	[self controlDispatch value: anObject] on: HRESULTError
		do: 
			[:e | 
			e hresult = DISP_E_MEMBERNOTFOUND 
				ifTrue: 
					["Suppress the error, the value is read-only and cannot be set"

					]
				ifFalse: [e pass]]!

initializeNewTypeConverter: aTypeConverter
	"Private - Hook to enable subclasses to set up a newly created type converter, e.g. to 
	set the left and right null values appropriately."

	"Do nothing by default"

	!

observePropertyNotifications
	"Private - Answer whether the site should observer property change notifications through
	<IPropertyNotifySink>. In the case of AXValueConvertingControlSite this is required to track
	the current value."

	^true!

propertyChanged: aSymbol
	aSymbol == #Value ifTrue: [self updateModel].
	^super propertyChanged: aSymbol!

refreshContents
	"Re-display the receiver with the model's value"

	self model notNil 
		ifTrue: 
			[self 
				displayValue: (self typeconverter convertFromLeftToRight: self model value)]!

typeconverter
	"Answer the typeconverter that the receiver uses for converting model
	values to displayable values and vice-versa."

	typeconverter isNil ifTrue: [typeconverter := self defaultTypeConverter].
	^typeconverter!

typeconverter: aTypeConverter
	"Set the typeconverter that the receiver uses for converting model
	values to displayable values and vice-versa to aTypeConverter."

	typeconverter := aTypeConverter.
	self value: typeconverter leftNullValue!

typeconverterClass
	"Answer the class of typeconverter for the receiver"

	^typeconverter isNil 
		ifTrue: [self defaultTypeConverterClass]
		ifFalse: [typeconverter class]!

typeconverterClass: aTypeConverterClass 
	"Set the typeconverter for the receiver to a default instance
	of aTypeConverterClass."

	| converter |
	self typeconverter class == aTypeConverterClass ifTrue: [^self].
	converter := aTypeConverterClass new.
	self initializeNewTypeConverter: converter.
	self typeconverter: converter!

updateModel
	"Private - The displayed value of the receiver has changed so set this
	back into the model after first running through the type converter"

	[self model value: (self typeconverter convertFromRightToLeft: self displayValue)] 
		on: InvalidFormat
		do: 
			[:exception | 
			exception beep.
			self value: self typeconverter leftNullValue].
	self invalidateUserInterface!

value
	"Answer the receiver's model value"

	^self model value!

value: anObject
	"Set the receiver's model value to anObject"

	self model value: anObject! !
!AXValueConvertingControlSite categoriesFor: #connectModel!models!public! !
!AXValueConvertingControlSite categoriesFor: #createControl!private!realizing/unrealizing! !
!AXValueConvertingControlSite categoriesFor: #defaultProgId!constants!public! !
!AXValueConvertingControlSite categoriesFor: #defaultTypeConverter!accessing!public! !
!AXValueConvertingControlSite categoriesFor: #defaultTypeConverterClass!initializing!private! !
!AXValueConvertingControlSite categoriesFor: #displayValue!private!updating! !
!AXValueConvertingControlSite categoriesFor: #displayValue:!private!updating! !
!AXValueConvertingControlSite categoriesFor: #initializeNewTypeConverter:!accessing!private! !
!AXValueConvertingControlSite categoriesFor: #observePropertyNotifications!helpers!private! !
!AXValueConvertingControlSite categoriesFor: #propertyChanged:!event handling!private! !
!AXValueConvertingControlSite categoriesFor: #refreshContents!public!updating! !
!AXValueConvertingControlSite categoriesFor: #typeconverter!accessing!public! !
!AXValueConvertingControlSite categoriesFor: #typeconverter:!accessing!public! !
!AXValueConvertingControlSite categoriesFor: #typeconverterClass!accessing!public! !
!AXValueConvertingControlSite categoriesFor: #typeconverterClass:!accessing!public! !
!AXValueConvertingControlSite categoriesFor: #updateModel!private!updating! !
!AXValueConvertingControlSite categoriesFor: #value!accessing!public! !
!AXValueConvertingControlSite categoriesFor: #value:!accessing!public! !

!AXValueConvertingControlSite class methodsFor!

applicableTypeConverterCategories
	"Answers a Set of class categories that contain <typeConverter>s that can 
	be used with the receiver"

	^Set with: (ClassCategory name: 'MVP-Type Converters-General')!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^nil asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^ValueConvertingControlView icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(AXValueConvertingControlSite)  98 26 0 0 98 2 8 1140916224 1 416 721990 2 ##(ValueHolder)  0 32 1376774 ##(PluggableSearchPolicy)  459270 ##(Message)  8 #= 98 0 562 8 #hash 98 0 0 524550 ##(ColorRef)  8 4278190080 0 7 0 0 0 416 0 81920801 8 'mshtml:<h2>Active-X Value Converting Control Site</h2>
<h4>Copyright © Object Arts Ltd, 2000</h4>' 590854 ##(IDispatch)  0 0 1378630 1 ##(TKindDispatchAnalyzer)  590598 ##(ITypeInfo)  0 0 525062 ##(TYPEATTR)  0 816 784 0 1378630 2 ##(AXTypeLibraryAnalyzer)  590342 ##(ITypeLib2)  0 0 1 524550 ##(TLIBATTR)  8 #[197 241 80 48 181 152 207 17 187 130 0 170 0 189 206 11 0 0 0 0 1 0 0 0 4 0 0 0 8 0 65 0] 0 0 0 0 234 240 98 2 8 'GUID' 8 #GUID 0 0 0 835 0 0 0 0 918022 ##(IDolphinAxHost)  0 0 722438 ##(AXEventSink)  234 240 98 76 8 -2147418096 8 #ondatasetcomplete 2075 8 #onselectionchange 2073 8 #oncontrolselect 2097 8 #onfocusin 2099 8 #onfocusout 2089 8 #onactivate 2091 8 #ondeactivate 2095 8 #onbeforeactivate 2047 8 #oncontextmenu 2053 8 #onstop 2055 8 #onbeforeeditfocus 2067 8 #onmousewheel -1217 8 #onreadystatechange 2069 8 #onbeforedeactivate -1213 8 #onmouseup -1211 8 #onmousemove -1209 8 #onmousedown -1207 8 #onkeyup -1205 8 #onkeypress -1203 8 #onkeydown 8 -2147418102 8 #onhelp -1199 8 #onclick -1201 8 #ondblclick 8 -2147418103 8 #onmouseout 8 -2147418104 8 #onmouseover 8 -2147418108 8 #onbeforeupdate 8 -2147418107 8 #onafterupdate 8 -2147418106 8 #onrowexit 8 -2147418105 8 #onrowenter 8 -2147418101 8 #ondragstart 8 -2147418100 8 #onselectstart 8 -2147418099 8 #onerrorupdate 8 -2147418080 8 #onrowsdelete 8 -2147418079 8 #onrowsinserted 8 -2147418078 8 #oncellchange 8 -2147418093 8 #onpropertychange 8 -2147418098 8 #ondatasetchanged 8 -2147418097 8 #ondataavailable 416 1049094 ##(IConnectionPoint)  0 0 385781601 770 802 0 0 834 0 2064 2048 0 866 898 0 0 2049 930 8 #[197 241 80 48 181 152 207 17 187 130 0 170 0 189 206 11 0 0 0 0 1 0 0 0 4 0 0 0 8 0 0 0] 0 0 0 0 234 240 98 2 8 'GUID' 1024 0 0 262198 ##(GUID)  16 96 242 80 48 181 152 207 17 187 130 0 170 0 189 206 11 825 0 0 0 1 2761 234 240 98 0 1508358 ##(IAxWinAmbientDispatchEx)  0 0 0 0 524806 ##(IUnknown)  0 0 0 0 0 852486 ##(NullConverter)  0 0 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 2498 591 251 416 2434 8 #restoreAmbientProperties 2256 416 2434 8 #controlBinaryStoreBytes: 98 1 8 #[32 105 51 37 249 3 207 17 143 208 0 170 0 104 111 19 60 33 68 79 67 84 89 80 69 32 72 84 77 76 32 80 85 66 76 73 67 32 34 45 47 47 87 51 67 47 47 68 84 68 32 72 84 77 76 32 52 46 48 32 84 114 97 110 115 105 116 105 111 110 97 108 47 47 69 78 34 62 13 10 60 72 84 77 76 62 60 72 69 65 68 62 60 47 72 69 65 68 62 13 10 60 66 79 68 89 62 13 10 60 72 50 62 65 99 116 105 118 101 45 88 32 86 97 108 117 101 32 67 111 110 118 101 114 116 105 110 103 32 67 111 110 116 114 111 108 32 83 105 116 101 60 47 72 50 62 13 10 60 72 52 62 67 111 112 121 114 105 103 104 116 32 169 32 79 98 106 101 99 116 32 65 114 116 115 32 76 116 100 44 32 50 48 48 48 60 47 72 52 62 60 47 66 79 68 89 62 60 47 72 84 77 76 62 13 10] 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 44 1 0 0 130 0 0 0] 98 0 2498 193 193 0 27 )! !
!AXValueConvertingControlSite class categoriesFor: #applicableTypeConverterCategories!constants!must strip!public! !
!AXValueConvertingControlSite class categoriesFor: #defaultModel!models!public! !
!AXValueConvertingControlSite class categoriesFor: #icon!constants!public! !
!AXValueConvertingControlSite class categoriesFor: #resource_Default_view!public!resources-views! !

