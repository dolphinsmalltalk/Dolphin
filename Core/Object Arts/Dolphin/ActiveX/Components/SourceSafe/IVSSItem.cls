"Filed out from Dolphin Smalltalk 7"!

IVSSItemOld subclass: #IVSSItem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SourceSafeTypeLibConstants'
	classInstanceVariableNames: ''!
IVSSItem guid: (IID fromString: '{2A0DE0E7-2E9F-11D0-9236-00AA00A1EB95}')!
IVSSItem comment: '<IVSSItem> is a wrapper class for the COM interface ''SourceSafeTypeLib.IVSSItem'' generated from type information in the ''Microsoft SourceSafe 6.0 Type Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"SourceSafe item interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!IVSSItem categoriesForClass!COM-Interfaces!SourceSafeTypeLib-Interfaces! !
!IVSSItem methodsFor!

branch: comment iFlags: iFlags 
	"Answer the <IVSSItem> result of invoking the COM Object's Branch() method."

	| answer |
	answer := IVSSItem newPointer.
	self
		Branch: comment
		iFlags: iFlags
		ppIItem: answer.
	^answer asObject
!

Branch: comment iFlags: iFlags ppIItem: ppIItem
	"Private - Invoke the Branch() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Branch(
			[in, optional, defaultvalue()] BSTR Comment,
			[in, optional, defaultvalue(0)] long iFlags,
			[out, retval] IVSSItem** ppIItem);
	"

	<virtual stdcall: hresult 37 bstr sdword IVSSItem**>
	^self invalidCall
!

get_Links: ppIItems
	"Private - Get the value of the 'Links' property of the receiver.

		HRESULT __stdcall Links(
			[out, retval] IVSSItems** ppIItems);
	"

	<virtual stdcall: hresult 36 IVSSItems**>
	^self invalidCall
!

links
	"Answer the <IVSSItems> value of the 'Links' property of the receiver."

	| answer |
	answer := IVSSItems newPointer.
	self
		get_Links: answer.
	^answer asObject
! !
!IVSSItem categoriesFor: #branch:iFlags:!**auto generated**!methods!public! !
!IVSSItem categoriesFor: #Branch:iFlags:ppIItem:!**auto generated**!COM Interfaces-IVSSItem!private! !
!IVSSItem categoriesFor: #get_Links:!COM Interfaces-IVSSItem!private! !
!IVSSItem categoriesFor: #links!**auto generated**!properties!public! !

