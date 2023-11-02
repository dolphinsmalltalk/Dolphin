"Filed out from Dolphin Smalltalk"!

UI.AXControlSite
	subclass: #'UI.AXValueConvertingControlSite'
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
!UI.AXValueConvertingControlSite categoriesForMethods!
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.AXValueConvertingControlSite} 38 #{Core.Array} 26 nil nil 50 2 8 1140916224 1 32 1094 2 #{UI.ValueHolder} nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 178 #hash 8 #() nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 8 'mshtml:<h2>Active-X Value Converting Control Site</h2>
<h4>Copyright © Object Arts Ltd, 2000</h4>' 1030 #{OS.COM.IDispatch} nil nil 2374 1 #{OS.COM.TKindDispatchAnalyzer} 1094 1 #{OS.COM.ITypeInfo2} nil nil 774 #{OS.COM.TYPEATTR} nil 352 384 nil nil nil 2630 3 #{OS.COM.TypeLibraryAnalyzer} 518 #{OS.COM.ITypeLib2} nil nil 2053 nil 262 #{OS.COM.TLIBATTR} 8 #[197 241 80 48 181 152 207 17 187 130 0 170 0 189 206 11 0 0 0 0 1 0 0 0 4 0 0 0 8 0 110 0] 8 #{Root.MSHTML} nil nil nil 550 #{Core.LookupTable} 0 nil nil 1329 1030 #{OS.COM.TypeLibDocumentation} 8 'DispHTMLDocument' 8 '' 1 8 '' nil nil nil 518 #{UI.IDolphinAxHost} nil nil nil 2761 562 1 -1049 #ReadyState 1030 #{UI.IAxWinAmbientDispatchEx} nil nil nil nil 518 #{OS.COM.IUnknown} nil nil nil nil nil 518 #{UI.NullConverter} nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 914 591 251 32 866 #restoreAmbientProperties 8 #() 32 866 #controlBinaryStoreBytes: 50 1 8 #[118 0 101 0 45 0 88 0 32 0 86 0 97 0 108 0 117 0 101 0 32 0 67 0 111 0 110 0 118 0 101 0 114 0 116 0 105 0 110 0 103 0 32 0 67 0 111 0 110 0 116 0 114 0 111 0 108 0 32 0 83 0 105 0 116 0 101 0 60 0 47 0 104 0 50 0 62 0 13 0 10 0 60 0 104 0 52 0 62 0 67 0 111 0 112 0 121 0 114 0 105 0 103 0 104 0 116 0 32 0 169 0 32 0 79 0 98 0 106 0 101 0 99 0 116 0 32 0 65 0 114 0 116 0 115 0 32 0 76 0 116 0 100 0 44 0 32 0 50 0 48 0 48 0 48 0 60 0 47 0 104 0 52 0 62 0] 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 38 13 0 0 135 0 0 0] 8 #() 914 193 193 nil 27)! !
!UI.AXValueConvertingControlSite class categoriesForMethods!
applicableTypeConverterCategories!constants!must strip!public! !
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

