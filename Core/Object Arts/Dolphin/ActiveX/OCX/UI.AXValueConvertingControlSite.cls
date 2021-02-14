"Filed out from Dolphin Smalltalk 7"!

UI.AXControlSite subclass: #'UI.AXValueConvertingControlSite'
	instanceVariableNames: 'typeconverter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.AXValueConvertingControlSite guid: (Core.GUID fromString: '{3f495368-8c18-4e53-a039-299027f2e032}')!
UI.AXValueConvertingControlSite comment: 'AXValueConvertingControlSite is a kind of <AXControlSite> that also behaves as if it were a <ValueConvertingControlView>, in particular it implements the <valueView> protocol. 

Use this class in preference to the superclass when hosting Active-X controls that have a single, clearly identifiable, "value". In many cases this will be obvious as the control will implement a Value property. In some cases a value property might not exist due to an oversight of the designer, in which case it can be implemented for the control by generating the control''s default interface and implementing #value and #value: appropriately in it.In other cases there may be multiple properties that could be used as the value, and one must decide whether, from a particular viewpoint, treating the control as a value view onto just one of these properties makes sense. A sensible strategy in these cases is to start off with a generic AXControlSite and only consider using this class as the use of the control is better understood.

See <ValueConvertingControlView> for more information on value converting views.

Instance Variables:
	typeconverter	<typeConverter> used to convert between model values and display values.

'!
!UI.AXValueConvertingControlSite categoriesForClass!MVP-Views! !
!UI.AXValueConvertingControlSite methodsFor!

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
!UI.AXValueConvertingControlSite categoriesFor: #connectModel!models!public! !
!UI.AXValueConvertingControlSite categoriesFor: #createControl!private!realizing/unrealizing! !
!UI.AXValueConvertingControlSite categoriesFor: #defaultProgId!constants!public! !
!UI.AXValueConvertingControlSite categoriesFor: #defaultTypeConverter!accessing!public! !
!UI.AXValueConvertingControlSite categoriesFor: #defaultTypeConverterClass!initializing!private! !
!UI.AXValueConvertingControlSite categoriesFor: #displayValue!private!updating! !
!UI.AXValueConvertingControlSite categoriesFor: #displayValue:!private!updating! !
!UI.AXValueConvertingControlSite categoriesFor: #initializeNewTypeConverter:!accessing!private! !
!UI.AXValueConvertingControlSite categoriesFor: #observePropertyNotifications!helpers!private! !
!UI.AXValueConvertingControlSite categoriesFor: #propertyChanged:!event handling!private! !
!UI.AXValueConvertingControlSite categoriesFor: #refreshContents!public!updating! !
!UI.AXValueConvertingControlSite categoriesFor: #typeconverter!accessing!public! !
!UI.AXValueConvertingControlSite categoriesFor: #typeconverter:!accessing!public! !
!UI.AXValueConvertingControlSite categoriesFor: #typeconverterClass!accessing!public! !
!UI.AXValueConvertingControlSite categoriesFor: #typeconverterClass:!accessing!public! !
!UI.AXValueConvertingControlSite categoriesFor: #updateModel!private!updating! !
!UI.AXValueConvertingControlSite categoriesFor: #value!accessing!public! !
!UI.AXValueConvertingControlSite categoriesFor: #value:!accessing!public! !

!UI.AXValueConvertingControlSite class methodsFor!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.AXValueConvertingControlSite) 34 26 nil nil 34 2 8 1140916224 1 416 918598 2 ##(UI.ValueHolder) nil false 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 546 #hash 8 #() nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 nil 537194055 8 'mshtml:<h2>Active-X Value Converting Control Site</h2>
<h4>Copyright © Object Arts Ltd, 2000</h4>' 1049606 ##(OS.COM.IDispatch) nil nil 1837382 1 ##(OS.COM.TKindDispatchAnalyzer) 1114886 ##(OS.COM.ITypeInfo2) nil nil 983814 ##(OS.COM.TYPEATTR) nil 720 752 nil 1706310 2 ##(OS.COM.TypeLibraryAnalyzer) 1049094 ##(OS.COM.ITypeLib2) nil nil 2049 983302 ##(OS.COM.TLIBATTR) 8 #[197 241 80 48 181 152 207 17 187 130 0 170 0 189 206 11 0 0 0 0 1 0 0 0 4 0 0 0 8 0 0 0] nil nil nil nil 170 176 34 6 8 'PROPVARIANT' 1508870 ##(Kernel.BindingReference) 8 'VARIANT' 34 1 992 800 1 1442886 2 ##(Kernel.VariableBinding) #VARIANT ##(OS.COM.VARIANT) ##(OS.COM) 1 5537 8 'GUID' 962 8 'GUID' 34 1 1088 800 1 1026 #GUID ##(Core.GUID) ##(Core) 1 5537 8 'RemotableHandle' 962 8 'ExternalHandle' 34 1 1168 800 1 1638406 ##(Kernel.UndeclaredVariable) 5537 nil nil nil 1329 nil nil nil nil 1114630 ##(UI.IDolphinAxHost) nil nil 1050118 ##(OS.COM.EventSink) 170 176 34 76 8 -2147418100 #onselectstart 8 -2147418099 #onerrorupdate 2073 #oncontrolselect 8 -2147418101 #ondragstart -1217 #onreadystatechange 2047 #oncontextmenu 2099 #onfocusout -1203 #onkeydown 2075 #onselectionchange 8 -2147418098 #ondatasetchanged 2089 #onactivate 8 -2147418097 #ondataavailable -1201 #ondblclick 8 -2147418093 #onpropertychange 8 -2147418105 #onrowenter -1213 #onmouseup 2091 #ondeactivate -1199 #onclick 8 -2147418078 #oncellchange 2053 #onstop -1211 #onmousemove 2067 #onmousewheel 8 -2147418079 #onrowsinserted 8 -2147418102 #onhelp 8 -2147418106 #onrowexit 2055 #onbeforeeditfocus -1209 #onmousedown 2095 #onbeforeactivate 8 -2147418104 #onmouseover 8 -2147418108 #onbeforeupdate 8 -2147418096 #ondatasetcomplete 8 -2147418107 #onafterupdate 8 -2147418103 #onmouseout 2069 #onbeforedeactivate -1207 #onkeyup 2097 #onfocusin 8 -2147418080 #onrowsdelete -1205 #onkeypress 416 1507846 ##(OS.COM.IConnectionPoint) nil nil 1598699457 706 738 nil nil 770 nil 1632 1648 nil 816 nil 589878 ##(Core.GUID) 16 96 242 80 48 181 152 207 17 187 130 0 170 0 189 206 11 1279 nil nil nil 1 2761 170 176 8 #(1005 #activeElement -525 #ReadyState) 1704966 ##(UI.IAxWinAmbientDispatchEx) nil nil nil nil 983558 ##(OS.COM.IUnknown) nil nil nil nil nil 1049094 ##(UI.NullConverter) nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 6143 21 1954 591 251 416 1906 #restoreAmbientProperties 8 #() 416 1906 #controlBinaryStoreBytes: 34 1 8 #[60 0 104 0 50 0 62 0 65 0 99 0 116 0 105 0 118 0 101 0 45 0 88 0 32 0 86 0 97 0 108 0 117 0 101 0 32 0 67 0 111 0 110 0 118 0 101 0 114 0 116 0 105 0 110 0 103 0 32 0 67 0 111 0 110 0 116 0 114 0 111 0 108 0 32 0 83 0 105 0 116 0 101 0 60 0 47 0 104 0 50 0 62 0 13 0 10 0 60 0 104 0 52 0 62 0 67 0 111 0 112 0 121 0 114 0 105 0 103 0 104 0 116 0 32 0 169 0 32 0 79 0 98 0 106 0 101 0 99 0 116 0 32 0 65 0 114 0 116 0 115 0 32 0 76 0 116 0 100 0 44 0 32 0 50 0 48 0 48 0 48 0 60 0 47 0 104 0 52 0 62 0] 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 38 13 0 0 135 0 0 0] 8 #() 1954 193 193 nil 27 )! !
!UI.AXValueConvertingControlSite class categoriesFor: #applicableTypeConverterCategories!constants!must strip!public! !
!UI.AXValueConvertingControlSite class categoriesFor: #defaultModel!models!public! !
!UI.AXValueConvertingControlSite class categoriesFor: #icon!constants!public! !
!UI.AXValueConvertingControlSite class categoriesFor: #resource_Default_view!public!resources-views! !

