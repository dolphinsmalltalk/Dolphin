"Filed out from Dolphin Smalltalk"!

AXControlSite subclass: #AXValueConvertingControlSite
	instanceVariableNames: 'typeconverter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!AXValueConvertingControlSite categoriesForMethods!
connectModel!models!public! !
createControl!private!realizing/unrealizing! !
defaultProgId!constants!public! !
defaultTypeConverter!accessing!public! !
defaultTypeConverterClass!initializing!private! !
displayValue!private!updating! !
displayValue:!private!updating! !
initializeNewTypeConverter:!accessing!private! !
observePropertyNotifications!helpers!private! !
propertyChanged:!event handling!private! !
refreshContents!public!updating! !
typeconverter!accessing!public! !
typeconverter:!accessing!public! !
typeconverterClass!accessing!public! !
typeconverterClass:!accessing!public! !
updateModel!private!updating! !
value!accessing!public! !
value:!accessing!public! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.AXValueConvertingControlSite) 34 26 nil nil 34 2 8 1140916224 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 546 #hash 8 #() nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 537202249 8 'mshtml:<h2>Active-X Value Converting Control Site</h2>
<h4>Copyright © Object Arts Ltd, 2000</h4>' 590854 ##(Smalltalk.IDispatch) nil nil 1378630 1 ##(Smalltalk.TKindDispatchAnalyzer) 590598 ##(Smalltalk.ITypeInfo) nil nil 525062 ##(Smalltalk.TYPEATTR) nil 752 720 nil 1378630 2 ##(Smalltalk.AXTypeLibraryAnalyzer) 590342 ##(Smalltalk.ITypeLib2) nil nil 1 524550 ##(Smalltalk.TLIBATTR) 8 #[197 241 80 48 181 152 207 17 187 130 0 170 0 189 206 11 0 0 0 0 1 0 0 0 4 0 0 0 8 0 65 0] nil nil nil nil 170 176 34 2 8 'GUID' #GUID nil nil nil 835 nil nil nil nil 918022 ##(Smalltalk.IDolphinAxHost) nil nil 722438 ##(Smalltalk.AXEventSink) 170 176 34 76 8 -2147418100 #onselectstart 8 -2147418099 #onerrorupdate 2073 #oncontrolselect 8 -2147418101 #ondragstart -1217 #onreadystatechange 2047 #oncontextmenu 2099 #onfocusout -1203 #onkeydown 2075 #onselectionchange 8 -2147418098 #ondatasetchanged 2089 #onactivate 8 -2147418097 #ondataavailable -1201 #ondblclick 8 -2147418093 #onpropertychange 8 -2147418105 #onrowenter -1213 #onmouseup 2091 #ondeactivate -1199 #onclick 8 -2147418078 #oncellchange 2053 #onstop -1211 #onmousemove 2067 #onmousewheel 8 -2147418079 #onrowsinserted 8 -2147418102 #onhelp 8 -2147418106 #onrowexit 2055 #onbeforeeditfocus -1209 #onmousedown 2095 #onbeforeactivate 8 -2147418104 #onmouseover 8 -2147418108 #onbeforeupdate 8 -2147418096 #ondatasetcomplete 8 -2147418107 #onafterupdate 8 -2147418103 #onmouseout 2069 #onbeforedeactivate -1207 #onkeyup 2097 #onfocusin 8 -2147418080 #onrowsdelete -1205 #onkeypress 416 1049094 ##(Smalltalk.IConnectionPoint) nil nil 455205345 706 656134 ##(Smalltalk.ITypeInfo2) nil nil 770 nil 1360 1392 nil 802 834 nil nil 2049 866 8 #[197 241 80 48 181 152 207 17 187 130 0 170 0 189 206 11 0 0 0 0 1 0 0 0 4 0 0 0 8 0 0 0] nil nil nil nil 170 176 34 6 8 'PROPVARIANT' #VARIANT 8 'GUID' #GUID 8 'RemotableHandle' #ExternalHandle nil nil 262198 ##(Smalltalk.GUID) 16 96 242 80 48 181 152 207 17 187 130 0 170 0 189 206 11 1279 nil nil nil 1 2761 170 176 8 #(-525 #ReadyState) 1508358 ##(Smalltalk.IAxWinAmbientDispatchEx) nil nil nil nil 524806 ##(Smalltalk.IUnknown) nil nil nil nil nil 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[5 0 0 0 5 0 0 0 44 1 0 0 130 0 0 0] 193 448 8 '' 416 1794 #restoreAmbientProperties 8 #() 416 1794 #controlBinaryStoreBytes: 34 1 8 #[60 33 68 79 67 84 89 80 69 32 72 84 77 76 32 80 85 66 76 73 67 32 34 45 47 47 87 51 67 47 47 68 84 68 32 72 84 77 76 32 52 46 48 32 84 114 97 110 115 105 116 105 111 110 97 108 47 47 69 78 34 62 13 10 60 72 84 77 76 62 60 72 69 65 68 62 60 47 72 69 65 68 62 13 10 60 66 79 68 89 62 13 10 60 72 50 62 65 99 116 105 118 101 45 88 32 86 97 108 117 101 32 67 111 110 118 101 114 116 105 110 103 32 67 111 110 116 114 111 108 32 83 105 116 101 60 47 72 50 62 13 10 60 72 52 62 67 111 112 121 114 105 103 104 116 32 169 32 79 98 106 101 99 116 32 65 114 116 115 32 76 116 100 44 32 50 48 48 48 60 47 72 52 62 60 47 66 79 68 89 62 60 47 72 84 77 76 62 13 10] 416 1 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )! !

!AXValueConvertingControlSite class categoriesForMethods!
applicableTypeConverterCategories!constants!must strip!public! !
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

